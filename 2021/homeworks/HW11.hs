module HW11 where

import Prelude hiding (Maybe(..))

-- Problem #1: Maybe, Foldable and Traversable
data Maybe a = Nothing | Just a
  deriving (Show, Eq, Ord)

instance Functor Maybe where
  fmap = _

instance Foldable Maybe where
  foldMap = _
  foldl = _
  foldr = _

foldMaybe :: Monoid a => Maybe a -> a
foldMaybe = _

instance Traversable Maybe where
  traverse = _
-- End Problem #1

-- Problem #2: Tree, Foldable and Traversable
data Tree a = Leaf | Node (Tree a) a (Tree a)
  deriving Show

instance Functor Tree where
  fmap = _

instance Foldable Tree where
  foldMap = _
  foldl = _
  foldr = _

foldTree :: Monoid a => Tree a -> a
foldTree = _

instance Traversable Tree where
  traverse = _
-- End Problem #2

-- Problem #3: fibonacci using zip/tail/list-comprehension
fibs :: [Integer]
fibs = _
-- End Problem #3

-- Problem #4: Newton's square root
sqroot :: Double -> Double
sqroot = _
-- End Problem #4
