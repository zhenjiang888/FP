module HW14 where

module problem-1 where

  open import Data.List using (List; []; _∷_)

  -- we have 'infix 5 _∷_' in 'Data.List'
  -- therefore we make _⊆_ slightly less associative
  infix 4 _⊆_
  data _⊆_ {A : Set} : List A → List A → Set where
    stop : [] ⊆ []
    drop : ∀ {xs y ys} → xs ⊆ ys → xs ⊆ y ∷ ys
    keep : ∀ {x xs ys} → xs ⊆ ys → x ∷ xs ⊆ x ∷ ys

  ⊆-refl : ∀ {A} {xs : List A} → xs ⊆ xs
  ⊆-refl = ?

  ⊆-trans : ∀ {A} {xs ys zs : List A} → xs ⊆ ys → ys ⊆ zs → xs ⊆ zs
  ⊆-trans = ?

module problem-2 where

  open import Data.Nat using (ℕ; zero; suc; _+_)

  import Relation.Binary.PropositionalEquality as Eq
  open Eq using (_≡_; refl; trans; sym; cong; cong-app; subst)
  open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; _∎)

  +-identity : ∀ (m : ℕ) → m + zero ≡ m
  +-identity = ?

  +-suc : ∀ (m n : ℕ) → m + suc n ≡ suc (m + n)
  +-suc = ?
