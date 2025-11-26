module HW16 where

open import Data.Nat using (ℕ; zero; suc; _+_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; sym; trans; cong; cong-app)
open Eq.≡-Reasoning using (begin_; step-≡-⟩; step-≡-⟨; step-≡-∣; _∎)

