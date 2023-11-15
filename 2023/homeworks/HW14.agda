module HW14 where

open import Data.Bool using (Bool; true; false; if_then_else_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open Eq.≡-Reasoning using (begin_; step-≡; step-≡˘; _≡⟨⟩_; _∎)

-- problem 17.1
data day : Set where
  -- fill in your answers here

-- problem 17.2
nextday : day → day
nextday = ?

-- problem 17.3
ite-arg : ∀ {ℓ ℓ′} {A : Set ℓ} {B : Set ℓ′}
  → (f : A → B)
  → (b : Bool)
  → (x y : A)
    ----------------------
  → f (if b then x else y)
  ≡ (if b then f x else f y)
ite-arg = ?
