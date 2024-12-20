module HW6 where

import Prelude hiding (and, concat, replicate, (!!), elem, filter, map)
import Data.Char (chr)

-- Ch.07

-- Problem #1: desugar list comprehension using map and filter
theExpr :: (a -> Bool) -> (a -> b) -> [a] -> [b]
-- theExpr p f xs = [f x | x <- xs, p x]
theExpr p f xs = _
-- End Problem #1

-- Problem #2: redefine map/filter with foldr
filter :: (a -> Bool) -> [a] -> [a]
filter p = foldr _ _

map :: (a -> b) -> [a] -> [b]
map f = foldr _ _
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
-- End Problem #3
