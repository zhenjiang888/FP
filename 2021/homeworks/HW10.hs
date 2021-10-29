module HW10 where

-- Problem #1: Reader Monad
-- 因为 ((->) a) 在标准库中已经实现了 Monad，所以我们使用下面这个新定义的类型代替
newtype Reader r a = Reader { runReader :: r -> a }

instance Functor (Reader r) where
  fmap f (Reader g) = _

instance Applicative (Reader r) where
  pure = _
  (<*>) = _

instance Monad (Reader r) where
  (>>=) = _
-- End Problem #1

-- Problem #2: Functor, Applicative, Monad
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

-- Problem #3: Why does factorising the expression grammar make the resulting parser more efficient?
-- 请把答案写在这里（注释里面）
-- End Problem #3

-- Problem #4: Extend the expression parser
newtype Parser a = P { parse :: String -> [(a,String)] }

eval :: String -> Int
eval = fst . head . parse expr

expr :: Parser Int
expr = _
-- End Problem #4
