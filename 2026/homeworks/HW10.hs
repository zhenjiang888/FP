module HW10 where

import Prelude hiding (Maybe (..))

-- **=========[ Ch.14 ]=========**

-- Problem #1: Maybe, Foldable and Traversable
data Maybe a = Nothing | Just a
  deriving (Show, Eq, Ord)

instance Functor Maybe where
  fmap = _

instance Foldable Maybe where
  foldMap = _
  foldr = _
  foldl = _

instance Traversable Maybe where
  traverse = _

-- End Problem #1

-- Problem #2: Tree, Foldable and Traversable
data Tree a = Leaf | Node (Tree a) a (Tree a)
  deriving (Show)

instance Functor Tree where
  fmap = _

instance Foldable Tree where
  foldMap = _
  foldr = _
  foldl = _

instance Traversable Tree where
  traverse = _

-- End Problem #2

-- **=========[ Ch.15 ]=========**

-- Problem #1: fibonacci using zip/tail/list-comprehension
fibs :: [Integer]
fibs = _

-- End Problem #1

-- Problem #2: Newton's square root with lazy lists
sqroot :: Double -> Double
sqroot = _

-- End Problem #2
