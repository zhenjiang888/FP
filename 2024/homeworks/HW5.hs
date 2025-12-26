module HW5 where

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
encode :: Int -> String -> String 
encode n xs = [ shift n x | x <- xs ] 

shift :: Int -> Char -> Char 
shift n c | isLower c  =  int2let $ mod (let2int c + n) 26
          | otherwise  =  c 

let2int :: Char -> Int 
let2int c = ord c - ord 'a' 
int2let :: Int -> Char 
int2let n = chr $ ord 'a' + n
        
table :: [Float] 
table = [ 8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0, 
          0.2, 0.8, 4.0, 2.4,  6.7, 7.5, 1.9, 0.1, 6.0, 
          6.3, 9.0, 2.8, 1.0,  2.4, 0.2, 2.0, 0.1 ] 

crack :: String -> String
crack xs  =  encode (-factor) xs 
    where   
        factor = position (minimum chitab) chitab      
        chitab = [ chisqr (rotate n table') table | n <- [0..25] ]
        table' = freqs xs
-- you can check : crack "aaaaab" = "eeeeef"

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
