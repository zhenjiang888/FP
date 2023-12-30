module HW21 where

unfold :: (b -> Bool) -> (b -> a) -> (b -> b) -> b -> [a]
unfold p f g x = if p x then [] else f x : unfold p f g (g x)

-- Ch26: BMF4-1
merge :: (Ord a) => [a] -> [a] -> [a]
merge xs ys = unfold _ _ _ _

-- Ch26: BMF4-2
-- Change the following definition of fib to generate all Fibonacci
-- numbers that are less than 1000,000.
fib :: (Int, Int) -> [Int]
fib = unfold (const False) fst (\(x, y) -> (y, x + y))
 where
  const x y = x
