module HW15 where

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; trans; sym; cong; cong-app; subst)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; _∎)

open import Data.List using (List; []; _∷_; _++_; foldr)

module problem-1 where

  ++-assoc : ∀ {A : Set}
      (xs ys zs : List A)
      -----------------------------------
    → (xs ++ ys) ++ zs ≡ xs ++ (ys ++ zs)
  ++-assoc = ?

  -- tips: to input the superscript l (ˡ), type \^l and use your
  --       arrow keys to select it (should be the fourth candidate).
  ++-identityˡ : ∀ {A : Set}
      (xs : List A)
      -------------
    → [] ++ xs ≡ xs
  ++-identityˡ = ?

  -- you might have already guessed it: type \^r for superscript r (ʳ)
  -- again, use your arrow keys to select it (the fourth candidate). 
  ++-identityʳ : ∀ {A : Set}
      (xs : List A)
    → xs ++ [] ≡ xs
  ++-identityʳ = ?

module problem-2 where

  -- tips: to input ⊗, type \otimes
  foldr-++ : ∀ {A : Set}
      (_⊗_ : A → A → A)
      (e : A)
      (xs ys : List A)
      -----------------------------
    → foldr _⊗_ e (xs ++ ys)
    ≡ foldr _⊗_ (foldr _⊗_ e ys) xs
  foldr-++ = ?

module problem-3 (
    extensionality : ∀ {A : Set} {B : A → Set}
        {f g : (x : A) → B x}
      → ((x : A) → f x ≡ g x)
        ---------------------
      → f ≡ g
  ) where

  open import Function using (id; _∘_)

  reverse : ∀ {A : Set} → List A → List A
  reverse []       = []
  reverse (x ∷ xs) = reverse xs ++ (x ∷ [])

  -- hint: you might want to introduce an extra lemma to prove this.
  reverse-involutive : ∀ {A : Set} → reverse {A} ∘ reverse {A} ≡ id
  reverse-involutive = ?

  -- bonus: fast-reverse-involutive
  -- this is only for practice, not part of the homework this week

  -- fast-reverse : ∀ {A : Set} → List A → List A
  -- fast-reverse = helper []
  --   module FastReverse where
  --   helper : ∀ {A : Set} → List A → List A → List A
  --   helper res []       = res
  --   helper res (x ∷ xs) = helper (x ∷ res) xs

  -- fast-reverse-involutive : ∀ {A : Set}
  --   → fast-reverse {A} ∘ fast-reverse {A} ≡ id
  -- fast-reverse-involutive = ?
