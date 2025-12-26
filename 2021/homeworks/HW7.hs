module HW7 where

-- Problem #1: multiplies for natural numbers
data Nat = Zero | Succ Nat
  deriving (Show)

add :: Nat -> Nat -> Nat
add Zero     n = n
add (Succ m) n = Succ (add m n)

multiplies :: Nat -> Nat -> Nat
multiplies = _
-- End Problem #1

-- Problem #2: folde for Exprs
data Expr
  = Val Int
  | Add Expr Expr
  | Mul Expr Expr
  deriving (Show)

-- try to figure out the suitable type yourself
folde :: a
folde = _
-- End Problem #2

-- Problem #3: recursive tree type
data Tree a = FillInTheBlankHere
-- End Problem #3
