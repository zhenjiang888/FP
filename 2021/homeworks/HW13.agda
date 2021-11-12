module HW13 where

module problem-1 where

  open import Data.Nat using (ℕ; suc; zero)
  open import Data.Bool using (Bool; true; false)

  _<_ : ?
  _<_ = ?

module problem-2 where

  open import Data.List using (List; []; _∷_)
  open import Data.Bool using (Bool; true; false)

  filter : ?
  filter = ?

module problem-3 where

  open import Data.Nat using (ℕ; suc; zero)
  open import Data.Vec using (Vec; []; _∷_)

  Matrix : Set → ℕ → ℕ → Set
  Matrix A n m = Vec (Vec A n) m

  transpose
    : {A : Set}
      {n m : ℕ}
    → Matrix A n m
      ------------
    → Matrix A m n
  transpose [] = ?
  transpose (v ∷ mat) = ?
