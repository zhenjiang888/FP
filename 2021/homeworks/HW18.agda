module HW18 where

-- how to input '≗': type \=o
-- Tips: 'f ≗ g' is the same as '∀ xs → f x ≡ g x'

open import Function using (_∘_)
open import Data.List using ([]; _∷_; foldr; map)
open import Data.List.Properties using (foldr-fusion)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; _≗_; refl; trans; sym; cong; cong-app; subst)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; _∎)

foldr-map-fusion : ∀ {A : Set} {B : Set} {C : Set}
  → (f : A → B)
  → (_⊕_ : B → C → C)
  → (e : C)
  → foldr _⊕_ e ∘ map f ≗ foldr (λ a r → f a ⊕ r) e
foldr-map-fusion f _⊕_ e xs = ?

map-composition : ∀ {A : Set} {B : Set} {C : Set}
  → (f : B → C)
  → (g : A → B)
  → map f ∘ map g ≗ map (f ∘ g)
map-composition f g xs = ?
