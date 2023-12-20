module HW19 where

-- How to type those Unicode characters:
-- →   \->
-- ≡   \==
-- ≢   \==n
-- ⟨   \<
-- ⟩   \>
-- ∎   \qed
-- ∘   \o
-- ∷   \::
-- ℕ   \bN
-- ⊕   \oplus
-- ˡ   \^l       (4th candidate, use your right arrow key to select)
-- ʳ   \^r       (4th candidate, use your right arrow key to select)
-- ₁   \_1
-- ×   \x
-- ∀   \all
-- Σ   \Sigma
-- ∃   \ex
-- ⊆   \subseteq
-- ≤   \le
-- ⊔   \sqcup
-- ¬   \neg
-- ⊥   \bot
-- ∈   \in

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; _≢_; refl; trans; sym; cong; cong-app; subst)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; _∎)

open import Function using (id; _∘_)

module problem-1 where

  open import Data.List using (List; []; _∷_; _++_)

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

  open import Data.List using (List; []; _∷_; _++_; foldr)

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

  open import Data.List using (List; []; _∷_; _++_)

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

module semigroup where
  record IsSemigroup {A : Set} (_⊕_ : A → A → A) : Set where
    field assoc : ∀ x y z → (x ⊕ y) ⊕ z ≡ x ⊕ (y ⊕ z)

  open IsSemigroup public

  open import Data.Nat using (_+_)
  open import Data.Nat.Properties using (+-assoc)
  ℕ-add-is-semigroup : IsSemigroup _+_
  ℕ-add-is-semigroup .assoc = +-assoc

  open import Data.Nat using (_⊔_)
  open import Data.Nat.Properties using (⊔-assoc)
  ℕ-⊔-is-semigroup : IsSemigroup _⊔_
  ℕ-⊔-is-semigroup .assoc = ⊔-assoc

  open import Data.List using (List; _++_; [])
  open import Data.List.Properties using (++-assoc)
  List-++-is-semigroup : ∀ {A : Set} → IsSemigroup {List A} _++_
  List-++-is-semigroup .assoc = ++-assoc

open semigroup

module monoid where
  record IsMonoid {A : Set} (e : A) (_⊕_ : A → A → A) : Set where
    field
      is-semigroup : IsSemigroup _⊕_
      identityˡ : ∀ x → e ⊕ x ≡ x
      identityʳ : ∀ x → x ⊕ e ≡ x

  open IsMonoid public

  open import Data.Nat using (_+_)
  open import Data.Nat.Properties using (+-identityˡ; +-identityʳ)
  ℕ-add-is-monoid : IsMonoid 0 _+_
  ℕ-add-is-monoid .is-semigroup = ℕ-add-is-semigroup
  ℕ-add-is-monoid .identityˡ = +-identityˡ
  ℕ-add-is-monoid .identityʳ = +-identityʳ

  open import Data.Nat using (_⊔_)
  open import Data.Nat.Properties using (⊔-identityˡ; ⊔-identityʳ)
  ℕ-⊔-is-monoid : IsMonoid 0 _⊔_
  ℕ-⊔-is-monoid .is-semigroup = ℕ-⊔-is-semigroup
  ℕ-⊔-is-monoid .identityˡ = ⊔-identityˡ
  ℕ-⊔-is-monoid .identityʳ = ⊔-identityʳ

  open import Data.List using (List; _++_; [])
  open import Data.List.Properties using (++-identityˡ; ++-identityʳ)
  List-++-is-monoid : ∀ {A : Set} → IsMonoid {List A} [] _++_
  List-++-is-monoid .is-semigroup = List-++-is-semigroup
  List-++-is-monoid .identityˡ = ++-identityˡ
  List-++-is-monoid .identityʳ = ++-identityʳ

open monoid

module MSS (
    extensionality : ∀ {A : Set} {B : A → Set}
        {f g : (x : A) → B x}
      → ((x : A) → f x ≡ g x)
        ---------------------
      → f ≡ g
  ) where

  open import Data.Nat using (ℕ; _+_; zero; suc; _⊔_)
  open import Data.List using (List; []; _∷_; [_]; _++_; foldl; foldr; map; scanl; scanr)

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

  -- Did you know there are plenty of useful theorems in the standard library?
  open import Data.Nat.Properties using (+-distribˡ-⊔; +-distribʳ-⊔)
  -- +-distribˡ-⊔ : ∀ x y z → x + (y ⊔ z) ≡ (x + y) ⊔ (x + z)
  -- +-distribʳ-⊔ : ∀ z x y → (x ⊔ y) + z ≡ (x + z) ⊔ (y + z)

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
  -- In fact, this version should be slightly easier to write, since it (generally)
  -- produces better error messages. If you want to follow this route, go ahead and
  -- prove the above 'derivation-alt', and uncomment the following:
  --
  -- derivation : mss ≡ mss-fast
  -- derivation = extensionality derivation-alt

  -- bonus(hard): try to prove the same result for integers (instead of naturals)
  --
  -- Our effort is futile if every element in the list is non-negative, because
  -- the MSS will always be the sum of all elements. However, it is not trivial
  -- to prove the same result for integers, because 'maximum []' is usually defined
  -- as negative infinity (-∞), which is not an integer.
  --
  -- However, we can extend integers (ℤ) to ℤ∞ as follows:
  --
  --   data ℤ∞ : Set where
  --     fin : ℤ → ℤ∞
  --     -∞ : ℤ∞
  --
  -- and replace 0 with -∞ in 'maximum'. Now you should be able to prove the result.
  -- You will need to define operations like '_+_' and '_⊔_', and prove lemmas like
  -- '+-distribʳ-⊔' all by yourself, which, if you ask me, is not the most pleasant
  -- way to spend your afternoon.

  -- bonus(hard): try to prove the correctness of 'mss' and 'mss-fast'
  --
  -- We have this "segment" relation (you may come up with better definitions):
  --
  --   open import Data.List using (take; drop)
  --   infix 4 _⊆_
  --   data _⊆_ {A : Set} (xs : List A) (ys : List A) : Set where
  --     segment : ∀ m n → take m (drop n ys) ≡ xs → xs ⊆ ys
  --
  -- We also have the "less than" relation:
  --
  --   open import Data.Nat using (_≤_)
  --
  -- which is defined as follows in the standard library:
  --
  --   infix 4 _≤_
  --   data _≤_ : ℕ → ℕ → Set where
  --     z≤n : ∀ {n}                 → zero  ≤ n
  --     s≤s : ∀ {m n} (m≤n : m ≤ n) → suc m ≤ suc n
  --
  -- 'mss' is proven to be correct if we can prove the following two theorems:
  --
  --   open import Data.Product using (_×_; ∃-syntax)
  --   mss-is-max : ∀ {xs ys} → ys ⊆ xs → sum ys ≤ mss xs
  --   mss-exists : ∀ {xs} → ∃[ ys ] ys ⊆ xs × sum ys ≡ mss xs

module BMF2-1 where

  open import Data.Product using (_×_; _,_; Σ-syntax; proj₁)
  open import Data.Nat using (ℕ; _+_; zero; suc)
  open import Data.List using (List; []; _∷_; [_]; _++_)
  open import Relation.Nullary using (¬_)

  infixr 5 _∷′_
  data NList (A : Set) : Set where
    [_]′ : (x : A) → NList A
    _∷′_ : (x : A) → (xs : NList A) → NList A

  infixr 5 _++′_
  _++′_ : ∀ {A : Set} → NList A → NList A → NList A
  [ x ]′ ++′ ys = x ∷′ ys
  (x ∷′ xs) ++′ ys = x ∷′ xs ++′ ys

  ++′-assoc : ∀ {A : Set} (xs ys zs : NList A) → (xs ++′ ys) ++′ zs ≡ xs ++′ ys ++′ zs
  ++′-assoc [ x ]′    ys zs = refl
  ++′-assoc (x ∷′ xs) ys zs = cong (x ∷′_) (++′-assoc xs ys zs)

  NList-++′-is-semigroup : ∀ {A : Set} → IsSemigroup {NList A} _++′_
  NList-++′-is-semigroup .assoc = ++′-assoc

  -- this reduce works on non-empty lists
  reduce : ∀ {A : Set} → (_⊕_ : A → A → A) → NList A → A
  reduce {A} _⊕_ [ x ]′ = x
  reduce {A} _⊕_ (x ∷′ xs) = x ⊕ reduce _⊕_ xs

  -- this map works on non-empty lists
  -- and it produces non-empty lists
  map : ∀ {A B : Set} → (f : A → B) → NList A → NList B
  map f [ x ]′ = [ f x ]′
  map f (x ∷′ xs) = f x ∷′ map f xs

  record IsHomomorphism
    {A : Set} {_⊕_ : A → A → A} (m₁ : IsSemigroup _⊕_)
    {B : Set} {_⊗_ : B → B → B} (m₂ : IsSemigroup _⊗_)
    (f : A → B) : Set where
    field
      distrib : (x y : A) → f (x ⊕ y) ≡ f x ⊗ f y

  open IsHomomorphism

  -- 1. prove 'split' is a homomorphism
  split : ∀ {A : Set} → NList A → List A × A
  split = reduce ? ∘ map ?

  -- bonus: you may also want to prove the following theorems:
  --
  --   _⊗_ : ∀ {A : Set} → List A × A → List A × A → List A × A
  --   R-is-semigroup : ∀ {A : Set} → IsSemigroup {List A × A} _⊗_
  --   split-is-homomorphism : ∀ {A : Set} → IsHomomorphism NList-++′-is-semigroup R-is-semigroup (split {A})
  --
  -- Alternatively, you may find it much more desirable (satisfactory) to prove the general case:
  --
  --   reduce-map-is-homomorphism : ∀ {A B : Set}
  --     → (f : A → B)
  --     → (_⊗_ : B → B → B)
  --     → (B-⊗-is-semigroup : IsSemigroup _⊗_)
  --       ---------------------------------------------------------------------------
  --     → IsHomomorphism NList-++′-is-semigroup B-⊗-is-semigroup (reduce _⊗_ ∘ map f)

  -- to verify your 'split' is correct. after defining 'split', proving the following
  -- should be as easy as filling in 'refl'.
  split-is-correct : split (1 ∷′ 2 ∷′ 3 ∷′ [ 4 ]′) ≡ (1 ∷ 2 ∷ 3 ∷ [] , 4)
  split-is-correct = ?

  -- bonus: find a proper way to prove your split is indeed correct:
  --
  --   split-is-indeed-correct : ∀ {A} xs
  --     → let (ys , z) = split {A} xs
  --       in xs ≡ ys ++ [ z ]

  -- 2. prove 'init' is not a homomorphism
  init : ∀ {A : Set} → NList A → List A
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

  init-is-not-homomorphism : ∀ {_⊗_} (m : IsSemigroup _⊗_)
    → ¬ IsHomomorphism NList-++′-is-semigroup m (init {ℕ})
  init-is-not-homomorphism {_⊗_} m H = ?

  -- Hint: you might want to follow this guideline below if you get stuck.
  --
  -- Step 1: interpret the theorem
  --   ¬ IsHomomorphism NList-++′-is-semigroup m (init {ℕ})
  -- is just another way of saying
  --   IsHomomorphism NList-++′-is-semigroup m (init {ℕ}) → ⊥
  -- (proof by contradiction)
  --
  -- Step 2: get your premise
  -- You want to derive contradiction from the premise, so the first thing
  -- to do is get the premise (add it as an argument):
  --   init-is-not-homomorphism {_⊗_} m H = ?
  -- Now we have the following premises:
  --   m : IsSemigroup _⊗_
  --   H : IsHomomorphism NList-++′-is-semigroup m (init {ℕ})
  --
  -- Step 3: derive absurd results
  -- Pass in some example to your premises, and try to get some absurd
  -- results such as 'K : [ 0 ] ≡ [ 42 ]'.
  --
  -- Step 4: show the absurdity by proving the negation
  -- e.g. for 'K : [ 0 ] ≡ [ 42 ]', write the following:
  --   ¬K : [ 0 ] ≢ [ 42 ]
  --   ¬K ()
  --
  -- Step 5: make use of that absurd result
  -- Use the result 'K' from Step 3, apply it to '¬K':
  --   ¬K K
  -- Just use this expression as the return value.
  -- Alternatively, there is a library function at our disposal:
  --   open import Relation.Nullary using (contradiction)
  --   contradiction K ¬K
