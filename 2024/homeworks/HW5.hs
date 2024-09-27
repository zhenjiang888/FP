module HW5 where

import Prelude hiding (and, concat, replicate, (!!), elem, filter, map)
import Data.Char (chr, isLower, ord)

-- **=========[ Ch.05 ]=========**

-- Problem #1: define safetail
-- Part #1.1: use a conditional expression
safetail1 :: [a] -> [a]
safetail1 = _
-- End Part #1.1

-- Part #1.2: use guarded equations
safetail2 :: [a] -> [a]
safetail2 = _
-- End Part #1.2

-- Part #1.3: use pattern matching
safetail3 :: [a] -> [a]
safetail3 = _
-- End Part #1.3
-- End Problem #1

-- Problem #2: Luhn algorithm
luhn :: Int -> Int -> Int -> Int -> Bool
luhn = _
-- End Problem #2

-- **=========[ Ch.06 ]=========**

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
