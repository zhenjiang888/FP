module HW9 where

import Control.Applicative (Alternative(..))
import Data.Char (isSpace, isDigit)
import Data.Maybe (fromJust)

-- **=========[ Ch.12 ]=========**

-- Problem #1: Monad ((->) a)

-- 标准库已经定义了 Monad ((->) a) instance。
-- 为了避免和标准库重复，本题提供了模拟标准库 Functor'、Applicative' 和 Monad'，
-- 其方法名也加撇号（如 fmap'），运算符名做了一些修改（详见程序）。
-- 请在本题中为 ((->) a) 提供 Functor'、Applicative' 和 Monad' 的 instance。
-- 请给出真正的实现，避免像 fmap' = fmap 这样直接引用标准库。

infixl 4 <$$
infixl 1 >>>, >>-
infixl 4 <@>

class Functor' f where
  fmap'        :: (a -> b) -> f a -> f b

  -- | 代替 <$
  (<$$)        :: a -> f b -> f a
  (<$$)        =  fmap' . const

class Functor' f => Applicative' f where
  pure' :: a -> f a

  -- | 代替 <*>
  (<@>) :: f (a -> b) -> f a -> f b

class Applicative' m => Monad' m where
  return' :: a -> m a
  return' = pure'

  -- | 代替 >>=
  (>>-) :: m a -> (a -> m b) -> m b

  -- | 代替 >>
  (>>>) :: m a -> m b -> m b
  m >>> k = m >>- \_ -> k

instance Functor' ((->) a) where
  fmap' = _

instance Applicative' ((->) a) where
  pure' = _
  (<@>) = _

instance Monad' ((->) r) where
  (>>-) = _
-- End Problem #1

-- Problem #2: Functor, Applicative, Monad

-- 从本题起，仍然用标准库的 type class 及其方法。

data Expr a
  = Var a
  | Val Int
  | Add (Expr a) (Expr a)
  deriving (Show)

instance Functor Expr where
  fmap = _

instance Applicative Expr where
  pure = _
  (<*>) = _

instance Monad Expr where
  (>>=) = _

-- End Problem #2

-- **=========[ Ch.13 ]=========**

-- Problem #1: Extend the expression parser

-- 由于我们只考虑最多一种解析方式，与讲义相比，我们用 Maybe 替代 []。

newtype Parser a = P { parse :: String -> Maybe (a, String) }
instance Functor Parser where
  fmap f p = P $ \inp -> case parse p inp of
                           Nothing -> Nothing
                           Just (v, out) -> Just (f v, out)
instance Applicative Parser where
    pure v = P $ \inp -> Just (v, inp)
    pf <*> px = P $ \inp -> case parse pf inp of
                                Nothing -> Nothing
                                Just (f, out) -> parse (fmap f px) out
instance Monad Parser where
  return = pure
  p >>= f = P $ \inp -> case parse p inp of
                          Nothing -> Nothing
                          Just (v, out) -> parse (f v) out
instance Alternative Parser where
  empty = P $ \_ -> Nothing
  p <|> q = P $ \inp -> case parse p inp of
                          Nothing -> parse q inp
                          Just (v, out) -> Just (v, out)
  many v  = some v <|> pure []
  some v  = pure (:) <*> v <*> many v

-- some functions that might be useful
item :: Parser Char
item = P $ \inp -> case inp of
                     [] -> Nothing
                     (x:xs) -> Just (x, xs)
sat  :: (Char -> Bool) -> Parser Char 
sat p = do
  x <- item 
  if p x then return x else empty

char  :: Char -> Parser Char 
char x = sat (x ==)

string :: String -> Parser String 
string [] = return [] 
string (x:xs) = do
  char x 
  string xs 
  return (x:xs)

space :: Parser String
space = many (sat isSpace)

nat :: Parser Int
nat = do
  xs <- some (sat isDigit)
  return (read xs)

token :: Parser a -> Parser a 
token p = do
  space 
  v <- p 
  space 
  return v

symbol :: String -> Parser String 
symbol xs = token $ string xs

natural :: Parser Int
natural = token nat

-- 请将文法如下扩展，支持 - 和 /：
-- expr ::= term ('+' expr | '-' expr | ε)
-- term ::= factor ('*' term | '/' term | ε)

-- 注意上述文法会如下解析 2 - 3 + 4：
--    -
--   / \
--  2   +
--     / \
--    3   4
-- 如果你直接按照解析树求值，会得到 -5 而不是 3。除号也有类似问题。

-- 在本题中，你可以选择如上直接按照文法给出的解析树求值，也就是 2 - 3 + 4 算出 -5。这样对本次作业已经足够。
-- 如果你有兴趣，你也可以选择尝试让它算出 3，当然也算作正确。
-- 提示：
-- 1. 你只需要解析一个自行设计的等价文法，使其能包含同样的算数表达式。不必须构造出相同的解析树。
-- 2. 可以利用 many，一次解析整个 expr 或 term。
-- 3. 避免左递归（如 expr ::= expr '+' term | ...）。这样直接写成程序会造成无穷递归。

-- 请按需修改如下定义。

expr :: Parser Int 
expr = do t <- term 
          (do symbol "+" 
              e <- expr 
              return (t + e))
            <|> return t
term :: Parser Int 
term = do f <- factor 
          (do symbol "*" 
              t <- term 
              return (f * t))
            <|> return f
factor :: Parser Int 
factor = (do symbol "(" 
             e <- expr 
             symbol ")" 
             return e)
           <|> natural

eval :: String -> Int
eval = fst . fromJust . parse expr

-- End Problem #1
