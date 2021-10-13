module HW5 where

import Prelude hiding (and, concat)

-- Problem #1: define prelude functions using recursions
and :: [Bool] -> Bool
and = _

concat :: [[a]] -> [a]
concat = _

replicate :: Int -> a -> [a]
replicate = _

(!!) :: [a] -> Int -> a
(!!) = _

elem :: Eq a => a -> [a] -> Bool
elem = _
-- End Problem #1

-- Problem #2: merge ascending lists
merge :: Ord a => [a] -> [a] -> [a]
merge = _
-- End Problem #2

-- Problem #3: merge sort
msort :: Ord a => [a] -> [a]
msort = _
-- End Problem #3

-- Problem #4: desugar list comprehension using map and filter
theExpr :: (a -> Bool) -> (a -> b) -> [a] -> [b]
-- theExpr p f xs = [f x | x <- xs, p x]
theExpr p f xs = _
-- End Problem #4

-- Problem #5: redefine map/filter with foldr
filter :: (a -> Bool) -> [a] -> [a]
filter p = foldr _ _

map :: (a -> b) -> [a] -> [b]
map f = foldr _ _
-- End Problem #5

-- Problem #6: error checking for binary string transmitter
type Bit = Int

bin2int :: [Bit] -> Int
bin2int = foldr (\x y -> x + 2 * y) 0

decode :: [Bit] -> String
-- modify this line to add error checking
decode = map (chr . bin2int) . chop

chop :: [Bit] -> [[Bit]]
chop = _ -- hint: not 'chop8' any more
-- End Problem #6
