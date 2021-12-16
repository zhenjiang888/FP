module HW16 where

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; _≢_; refl; trans; sym; cong; cong-app; subst)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; _∎)

open import Function using (_∘_)

module MSS (
    extensionality : ∀ {A : Set} {B : A → Set}
        {f g : (x : A) → B x}
      → ((x : A) → f x ≡ g x)
        ---------------------
      → f ≡ g
  ) where

  open import Data.List using (List; []; _∷_; [_]; _++_; foldl; foldr; map; scanl; scanr)
  open import Data.Nat using (ℕ; _+_; zero; suc; _⊔_)

  inits : ∀ {A : Set} → List A → List (List A)
  inits = scanl _++_ [] ∘ map [_]

  tails : ∀ {A : Set} → List A → List (List A)
  tails = scanr _++_ [] ∘ map [_]

  concat : ∀ {A : Set} → List (List A) → List A
  concat = foldr _++_ []

  segs : ∀ {A : Set} → List A → List (List A)
  segs = concat ∘ map tails ∘ inits

  sum : List ℕ → ℕ
  sum = foldr _+_ 0

  maximum : List ℕ → ℕ
  maximum = foldr _⊔_ 0

  mss : List ℕ → ℕ
  mss = maximum ∘ map sum ∘ segs

  module monoid where
    record IsMonoid {A : Set} (e : A) (_⊕_ : A → A → A) : Set where
      field
        assoc : ∀ x y z → (x ⊕ y) ⊕ z ≡ x ⊕ (y ⊕ z)
        identityˡ : ∀ x → e ⊕ x ≡ x
        identityʳ : ∀ x → x ⊕ e ≡ x

    open IsMonoid public

    open import Data.Nat.Properties using (+-assoc; +-identityˡ; +-identityʳ)
    ℕ-add-is-monoid : IsMonoid 0 _+_
    ℕ-add-is-monoid .assoc = +-assoc
    ℕ-add-is-monoid .identityˡ = +-identityˡ
    ℕ-add-is-monoid .identityʳ = +-identityʳ

    open import Data.Nat.Properties using (⊔-assoc; ⊔-identityˡ; ⊔-identityʳ)
    ℕ-⊔-is-monoid : IsMonoid 0 _⊔_
    ℕ-⊔-is-monoid .assoc = ⊔-assoc
    ℕ-⊔-is-monoid .identityˡ = ⊔-identityˡ
    ℕ-⊔-is-monoid .identityʳ = ⊔-identityʳ

    open import Data.List.Properties using (++-assoc; ++-identityˡ; ++-identityʳ)
    List-++-is-monoid : ∀ {A : Set} → IsMonoid {List A} [] _++_
    List-++-is-monoid .assoc = ++-assoc
    List-++-is-monoid .identityˡ = ++-identityˡ
    List-++-is-monoid .identityʳ = ++-identityʳ

  open monoid

  -- Did you know there are plenty of useful theorems in the standard library?
  open import Data.Nat.Properties using (+-distribˡ-⊔; +-distribʳ-⊔)
  -- +-distribˡ-⊔ : ∀ x y z → x + (y ⊔ z) ≡ (x + y) ⊔ (x + z)
  -- +-distribˡ-⊔ : ∀ x y z → (x ⊔ y) + z ≡ (x + z) ⊔ (y + z)

  mss-fast : List ℕ → ℕ
  mss-fast = ?

  derivation : mss ≡ mss-fast
  derivation =
    begin
      mss
    ≡⟨ ? ⟩
      mss-fast
    ∎

  -- note: it is possible to avoid extensionality and instead prove the following
  --
  -- derivation-alt : ∀ xs → mss xs ≡ mss-fast xs
  -- derivation-alt = ?
  --
  -- in fact, this version should be slightly easier to write, since it (generally)
  -- produces better error messages. If you want to follow this route, go ahead and
  -- prove the above 'derivation-alt', and uncomment the following:
  --
  -- derivation : mss ≡ mss-fast
  -- derivation = extensionality derivation-alt

  -- bonus(hard): try to prove the correctness of 'mss' and 'mss-fast'
  --
  -- We have this "segment" relation (you may come up with better definitions):
  --   open import Data.List using (take; drop)
  --   infix 4 _⊆_
  --   data _⊆_ {A : Set} (xs : List A) (ys : List A) : Set where
  --     segment : ∀ m n → take m (drop n ys) ≡ xs → xs ⊆ ys
  -- We also have the "less than" relation:
  --   open import Data.Nat using (_≤_)
  -- which is defined as follows in the standard library:
  --   infix 4 _≤_
  --   data _≤_ : ℕ → ℕ → Set where
  --     z≤n : ∀ {n}                 → zero  ≤ n
  --     s≤s : ∀ {m n} (m≤n : m ≤ n) → suc m ≤ suc n
  -- 'mss' is proven to be correct if we can prove the following two theorems:
  --   open import Data.Product using (_×_; ∃-syntax)
  --   mss-is-max : ∀ {xs ys} → ys ⊆ xs → sum ys ≤ mss xs
  --   mss-is-max = ?
  --   mss-exists : ∀ {xs} → ∃[ ys ] ys ⊆ xs × sum ys ≡ mss xs
  --   mss-exists = ?

module BMF2-1 where

  open import Data.Product using (_×_; _,_; Σ-syntax; proj₁)
  open import Data.List using (List; []; _∷_; [_]; _++_)
  import Data.List using (map)

  -- this reduce works on non-empty lists
  -- remark: 'Σ[ xs ∈ List A ] xs ≢ []' means
  --   those 'xs ∈ List A' such that 'xs ≢ []'
  reduce : ∀ {A : Set}
    → (_⊕_ : A → A → A)
    → Σ[ xs ∈ List A ] xs ≢ []
      ------------------------
    → A
  reduce {A} _⊕_ = λ (xs , N) → helper xs N
    module Reduce where
    helper : (xs : List A) → xs ≢ [] → A
    helper [] N with () ← N refl
    helper (x ∷ []) _ = x
    helper (x ∷ xs@(_ ∷ _)) _ = x ⊕ helper xs (λ())

  -- this map works on non-empty lists
  -- and it produces non-empty lists
  map : ∀ {A B : Set}
    → (f : A → B)
    → Σ[ xs ∈ List A ] xs ≢ []
      ------------------------
    → Σ[ ys ∈ List B ] ys ≢ []
  map f ([] , N) with () ← N refl
  map f (x ∷ xs , _) = f x ∷ Data.List.map f xs , λ()

  -- 1. prove 'split' is a homomorphism
  split : ∀ {A : Set} → Σ[ xs ∈ List A ] xs ≢ [] → List A × A
  split = reduce ? ∘ map ?

  -- to verify your 'split' is correct. after defining 'split', proving the following
  -- should be as easy as filling in 'refl'.
  split-is-correct : split (1 ∷ 2 ∷ 3 ∷ 4 ∷ [] , λ()) ≡ (1 ∷ 2 ∷ 3 ∷ [] , 4)
  split-is-correct = ?

  -- bonus: find a proper way to prove your split is indeed correct:
  -- split-is-indeed-correct : ∀ {A} xs
  --   → let (ys , z) = split {A} xs
  --     in proj₁ xs ≡ ys ++ [ z ]

  -- 2. prove 'init' is not a homomorphism
  init : ∀ {A : Set} → Σ[ xs ∈ List A ] xs ≢ [] → List A
  init = proj₁ ∘ split

  -- This part might be too hard for you to prove in Agda, so you can choose
  -- to write this part in natural language. If so, comment out (or remove)
  -- the following code, and write your proof in the comments.
  --
  -- Anyway, below are some key points if you want to try to prove in Agda:
  -- (1) inequality 'x ≢ y' is negation of equality: '¬ (x ≡ y)'
  -- (2) negation '¬ x' is implication to falsity: 'x → ⊥'
  -- (3) falsity '⊥' is an empty data type, it has no constructors ...
  -- (4) ... which means we can pattern match with absurd pattern '()'

  init-is-not-homomorphism : ∀ {A} {f g} → init {A} ≢ reduce f ∘ map g
  init-is-not-homomorphism = ?

  -- Hint: you might want to follow this guideline below if you get stuck.
  --
  -- Step 1: interpret the theorem
  --   init {A} ≢ reduce f ∘ map g
  -- is just another way of saying
  --   init {A} ≡ reduce f ∘ map g → ⊥
  -- (proof by contradiction)
  --
  -- Step 2: get your premise
  -- You want to derive contradiction from the premise, so the first thing
  -- to do is get the premise (add it as an argument):
  --   init-is-not-homomorphism E = ?
  -- Now 'E' is our premise, with the type 'init {A} ≡ reduce f ∘ map g'
  --
  -- Step 3: derive absurd results
  -- Pass in some example to your premise 'E', and try to get some absurd
  -- results such as 'H : 0 ≡ 42'.
  --
  -- Step 4: make use of that absurd result
  -- Use the result 'H' from Step 3, apply it to '(λ())':
  --   (λ()) H
  -- Just use this expression as the return value. This should do the trick,
  -- because "ex falso quodlibet", or "From falsehood, anything follows."
