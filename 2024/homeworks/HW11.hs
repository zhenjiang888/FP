module HW11 where
import GHC.Base
import Data.Char

-- Problem #1: Extend the expression parser
newtype Parser a = P { parse :: String -> [(a,String)] }
instance Functor Parser where
  fmap f p = P $ \inp -> case parse p inp of
                           [] -> []
                           [(v,out)] -> [(f v, out)]
instance Applicative Parser where
    pure v = P $ \inp -> [(v,inp)]
    pf <*> px = P $ \inp -> case parse pf inp of
                                [] -> []
                                [(f,out)] -> parse (fmap f px) out
instance Monad Parser where
  return = pure
  p >>= f = P $ \inp -> case parse p inp of
                          [] -> []
                          [(v,out)] -> parse (f v) out
instance Alternative Parser where
  empty = P $ \_ -> []
  p <|> q = P $ \inp -> case parse p inp of
                          [] -> parse q inp
                          [(v,out)] -> [(v,out)]
  many v  = some v <|> pure []
  some v  = pure (:) <*> v <*> many v

-- some functions that might be useful
item :: Parser Char
item = P $ \inp -> case inp of
                     [] -> []
                     (x:xs) -> [(x,xs)]
sat  :: (Char -> Bool) -> Parser Char 
sat p = do x <- item 
           if p x then return x else empty

char  :: Char -> Parser Char 
char x = sat (x ==)

string :: String -> Parser String 
string [] = return [] 
string (x:xs) = do  char x 
                    string xs 
                    return (x:xs)

space :: Parser String
space = many (sat isSpace)

nat :: Parser Int
nat = do xs <- some (sat isDigit)
         return (read xs)

token :: Parser a -> Parser a 
token p = do  space 
              v <- p 
              space 
              return v

symbol :: String -> Parser String 
symbol xs = token $ string xs

natural :: Parser Int
natural = token nat

-- The following is the parser for the expression that you need to extend
expr :: Parser Int 
expr = do t <- term 
          do  symbol "+" 
              e <- expr 
              return (t + e) 
           <|> return t
term :: Parser Int 
term  = do f <- factor 
           do   symbol "*" 
                t <- term 
                return (f * t) 
            <|> return f
factor :: Parser Int 
factor  = do  symbol "(" 
              e <- expr 
              symbol ")" 
              return e 
           <|> natural

eval :: String -> Int
eval = fst . head . parse expr

-- End Problem #1

-- Problem #2: fibonacci using zip/tail/list-comprehension
fibs :: [Integer]
fibs = _

-- End Problem #2

-- Problem #3: Newton's square root
sqroot :: Double -> Double
sqroot = _

-- End Problem #3
