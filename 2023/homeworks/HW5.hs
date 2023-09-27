module HW5 where

import Prelude hiding (and, concat, replicate, (!!), elem, filter, map)
import Data.Char (chr, isLower, ord)

-- Ch.05

-- Problem #1: Caesar crack
crack :: String -> String
crack = _

freqs :: String -> [Float]
freqs = _

chisqr :: [Float] -> [Float] -> Float
chisqr = _
-- End Problem #1

-- Problem #2: Pythagorean triples
pyths :: Int -> [(Int, Int, Int)]
pyths = _
-- End Problem #2

-- Problem #3: perfect integers
perfects :: Int -> [Int]
perfects = _
-- End Problem #3

-- Problem #4: scalar product
scalarProduct :: Num a => [a] -> [a] -> a
scalarProduct = _
-- End Problem #4

-- Ch.06

-- Problem #5: define prelude functions using recursions
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
-- End Problem #5

-- Problem #6: merge ascending lists
merge :: Ord a => [a] -> [a] -> [a]
merge = _
-- End Problem #6

-- Problem #7: merge sort
msort :: Ord a => [a] -> [a]
msort = _
-- End Problem #7
