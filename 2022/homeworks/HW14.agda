module HW14 where

-- How to input the Unicode characters
-- ===================================
-- ℕ    \bN
-- →    \->
-- ∷    \::
-- ≡    \==
-- ⟨    \<
-- ⟩    \>
-- ˘    \u{}

open import Data.Bool using (Bool; true; false; if_then_else_)
open import Data.Nat using (ℕ; zero; suc)
open import Data.List using (List; []; _∷_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; sym; trans; cong; cong-app)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; step-≡˘; _∎)

-- I am feeling lazy today, so let's just introduce the variables here.
-- This is equivalent to adding a `(A : Set)` to every type with a free variable `A`
variable
  A : Set

takeWhile : (p : A → Bool) → List A → List A
takeWhile = ?

-- this function is usually named `replicate` instead of `repeat`
replicate : ℕ → A → List A
replicate = ?

prop : (a : A) (n : ℕ)
  → (p : A → Bool)
  → p a ≡ true
    -------------------------------------
  → takeWhile p (replicate n a) ≡ replicate n a
prop = ?
