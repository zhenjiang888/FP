module HW12 where

-- How to input the Unicode characters
-- ===================================
-- ℕ    \bN
-- →    \->
-- ∷    \::
-- ≡    \==
-- ⟨    \<
-- ⟩    \>
-- ∨    \or
-- ≟    \?=
-- ≮    \<n

open import Data.Nat using (ℕ; zero; suc; _+_; _*_)
open import Data.Bool using (Bool; true; false; _∨_; if_then_else_)
open import Data.List using (List; []; _∷_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; sym; trans; cong; cong-app)
open Eq.≡-Reasoning using (begin_; step-≡-⟩; step-≡-⟨; step-≡-∣; _∎)

-- Chap. 18

-- Problem 1.1: commutativity of _*_
*-comm : (x y : ℕ) → x * y ≡ y * x
*-comm = {!   !}

-- Problem 1.2: associativity of _*_
*-assoc : (x y z : ℕ) → (x * y) * z ≡ x * (y * z)
*-assoc = {!   !}

-- Problem 2: prove the theorems.
-- Remark: the standard library provides the following comparison based on decidability
--   _<?_ : (x y : ℕ) → Dec (x < y)
-- where `Dec` is the type for decidability;
-- and also the following comparison as inductive relation
--   _<_ : (x y : ℕ) → Set
-- so neither is the one we want.
-- Note: read more on decidability here:
--  * stdlib: https://agda.github.io/agda-stdlib/Relation.Nullary.Decidable.Core.html#1476
--  * PLFA: https://plfa.github.io/Decidable/
-- so we just provide the same definition as given in the slides:
-- (note that stdlib use (Bool; true; false) instead of (𝔹; tt; ff))
infix 9 _≟_
_≟_ : (x y : ℕ) → Bool
zero  ≟ zero  = true
zero  ≟ suc _ = false
suc _ ≟ zero  = false
suc x ≟ suc y = x ≟ y

infix 9 _<_
_<_ : (x y : ℕ) → Bool
zero < zero  = false
zero < suc _ = true
suc _ < zero  = false
suc x < suc y = x < y

-- Problem 2.1
n≮n : (n : ℕ) → n < n ≡ false
n≮n = {!   !}

-- Problem 2.2
<-antisym : (x y : ℕ) → x < y ≡ true → y < x ≡ false
<-antisym = {!   !}

-- Problem 2.3
<-trichotomy : (x y : ℕ) → x < y ∨ x ≟ y ∨ y < x ≡ true
<-trichotomy = {!   !}


-- Chap. 19

-- This is equivalent to adding a `(A : Set)` to every type with a free variable `A`.
-- For example, `ℕ → A → List A` actually becomes `(A : Set) → ℕ → A → List A`.
variable
  A : Set

takeWhile : (p : A → Bool) → List A → List A
takeWhile = {!   !}

-- This function is usually named `replicate` instead of `repeat`.
replicate : ℕ → A → List A
replicate = {!   !}

prop : (a : A) (n : ℕ)
  → (p : A → Bool)
  → p a ≡ true
    -------------------------------------
  → takeWhile p (replicate n a) ≡ replicate n a
prop = {!   !}

