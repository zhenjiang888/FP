module HW15 where

-- How to input the Unicode characters
-- ===================================
-- ℕ    \bN
-- →    \->
-- ∷    \::
-- ≡    \==
-- ⟨    \<
-- ⟩    \>
-- ˘    \u{}

open import Data.Nat using (ℕ; zero; suc; _+_; _*_)
open import Data.Bool using (Bool; true; false; _∨_; if_then_else_)
open import Data.List using (List; []; _∷_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; sym; trans; cong; cong-app)
open Eq.≡-Reasoning using (begin_; step-≡-⟩; step-≡-⟨; step-≡-∣; _∎)

-- Chap. 20

-- problem 20.1
_by_matrix : (n m : ℕ) → Set
n by m matrix = ?

-- problem 20.2
-- 20.2(a) zero matrix: all zeros
zero-matrix : (n m : ℕ) → n by m matrix
zero-matrix n m = ?

-- 20.2(b) matrix indexing
module Problem-20-2-b where
  _<_ : (n m : ℕ) → Bool
  zero  < zero  = false
  zero  < suc _ = true
  suc _ < zero  = false
  suc x < suc y = x < y

  matrix-elt : {n m : ℕ}
    → n by m matrix
    → (i j : ℕ)
    → i < n ≡ true
    → j < m ≡ true
    → ℕ
  matrix-elt {n} {m} mat = ?

-- 20.2(c): diagonal matrix, with the same element along the main diagonal
diagonal-matrix : (n : ℕ) → (d : ℕ) → n by n matrix
diagonal-matrix n d = ?

identity-matrix : (n : ℕ) → n by n matrix
identity-matrix n = ?

-- 20.2(d): transpose
transpose : {n m : ℕ} → n by m matrix → m by n matrix
transpose = ?

-- 20.2(e): dot product
_∙_ : {n : ℕ} → (x y : Vec ℕ n) → ℕ
x ∙ y = ?