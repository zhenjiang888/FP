module HW6 where

import Data.Char (chr)

-- Ch.08

-- Problem #1: desugar list comprehension using map and filter
theExpr :: (a -> Bool) -> (a -> b) -> [a] -> [b]
-- theExpr p f xs = [f x | x <- xs, p x]
theExpr p f xs = _
-- End Problem #1

-- Problem #2: redefine map/filter with foldr
filter_ :: (a -> Bool) -> [a] -> [a]
filter_ p = foldr _ _

map_ :: (a -> b) -> [a] -> [b]
map_ f = foldr _ _
-- End Problem #2

-- Problem #3: error checking for binary string transmitter
type Bit = Int

bin2int :: [Bit] -> Int
bin2int = foldr (\x y -> x + 2 * y) 0

decode :: [Bit] -> String
-- modify this line to add error checking
decode = map (chr . bin2int) . chop

chop :: [Bit] -> [[Bit]]
chop = _ -- hint: not 'chop8' any more
-- you can check: decode [1,0,0,0,0,1,1,0,1] == "a"

-- End Problem #3
