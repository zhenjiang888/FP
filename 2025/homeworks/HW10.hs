module HW10 where

import Prelude hiding (Applicative (..), Functor (..), Monad (..))

infixl 4 <$
infixl 1 >>, >>=
infixl 4 <*>

class Functor f where
  fmap        :: (a -> b) -> f a -> f b
  (<$)        :: a -> f b -> f a
  (<$)        =  fmap . const

class Functor f => Applicative f where
  pure :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b

class Applicative m => Monad m where
  return :: a -> m a
  return = pure
  (>>=) :: m a -> (a -> m b) -> m b
  (>>) :: m a -> m b -> m b
  m >> k = m >>= \_ -> k

-- Problem #1: Monad ((->) a)
instance Functor ((->) a) where
  fmap = _

instance Applicative ((->) a) where
  pure = _
  (<*>) = _

instance Monad ((->) r) where
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
