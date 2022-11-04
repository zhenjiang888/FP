module HW13 where

open import Data.Nat using (ℕ; zero; suc; _+_; _*_)
open import Data.Bool using (Bool; true; false; _∨_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; cong; cong-app; trans)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; step-≡˘; _∎)

-- problem 1.1: commutativity of _*_
*-comm : (x y : ℕ) → x * y ≡ y * x
*-comm = ?

-- problem 1.2: associativity of _*_
*-assoc : (x y z : ℕ) → (x * y) * z ≡ x * (y * z)
*-assoc = ?

-- problem 2: prove the theorems.
-- remark: the standard library provides the following comparison based on decidability
--   _<?_ : (x y : ℕ) → Dec (x < y)
-- where `Dec` is the type for decidability;
-- and also the following comparison as inductive relation
--   _<_ : (x y : ℕ) → Set
-- so neither is the one we want.
-- note: read more on decidability here:
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

-- problem 2.1
n≮n : (n : ℕ) → n < n ≡ false
n≮n = ?

-- problem 2.2
<-antisym : (x y : ℕ) → x < y ≡ true → y < x ≡ false
<-antisym = ?

-- problem 2.3
<-trichotomy : (x y : ℕ) → x < y ∨ x ≟ y ∨ y < x ≡ true
<-trichotomy = ?
