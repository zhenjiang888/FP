module HW16 where

-- README
-- ======
--
-- There are two bonus questions in this template.
-- They are completely optional and won't be graded.
-- Feel free to uncomment or copy the code and fill in your solution.
-- Happy coding and learning Agda!


-- How to input the Unicode characters
-- ===================================
--
-- ℕ    \bN
-- ∷    \::
-- ∙    \.
-- ≡    \==
-- ⟨    \<
-- ⟩    \>
-- ˘    \u{}
-- ≤    \le

open import Data.Nat using (ℕ; zero; suc)
open import Data.Vec using (Vec; []; _∷_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; sym; trans; cong; cong-app; subst)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; step-≡˘; _∎)

-- problem 20.1
_by_matrix : (n m : ℕ) → Set
n by m matrix = ?

-- problem 20.2
-- 20.2(a) zero matrix: all zeros
zero-matrix : (n m : ℕ) → n by m matrix
zero-matrix n m = ?

-- 20.2(b) matrix indexing
module Problem-20-2-b where
  open import Data.Bool using (Bool; true; false)

  _<_ : (n m : ℕ) → Bool
  zero  < zero  = false
  zero  < suc _ = true
  suc _ < zero  = false
  suc x < suc y = x < y

  matrix-elt : {n m : ℕ}
    → n by m matrix
    → (i j : ℕ)
    → i < n ≡ true
    → j < m ≡ true
    → ℕ
  matrix-elt {n} {m} mat = ?


-- Bonus: inductive relations
-- ==========================
--
-- We have already see some downsides of `Bool`-based relations:
-- * `n < m ≡ true` tells us it _is_ true, but not _why_ it is true;
-- * `suc n < suc m ≡ true` is indistinguishable with `n < m ≡ true`;
-- * _<_ is not injective, so Agda's type checker often fails to infer things;
--
-- But we don't need to live with all these! Introducing _inductive relations_:
--
--     data _<_ : ℕ → ℕ → Set where
--       z<s : (n : ℕ) → zero < suc n
--       s<s : {n m : ℕ} → n < m → suc n < suc m
--
-- The inductive relation _<_ is defined as a data type, with these benefits:
-- * values of `n < m` tells us why `n` is less than `m`;
-- * type constructor _<_ is known to be injective, so we have better type inference;
-- * `suc n < suc m` and `n < m` are distinct types;
--
-- Let's see some examples:
--
--     0<1 : 0 < 1
--     0<1 = z<s 0
--
-- We have other ways to define _<_, and here is an example:
--
--     data _<_ : ℕ → ℕ → Set where
--       n<suc[n] : (n : ℕ) → n < suc n
--       n<m⇒n<suc[m] : {n m : ℕ} → n < m → n < suc m
--
-- It is also possible to define _<_ in terms of _≤_:
--
--     data _≤_ (n : ℕ) : ℕ → Set where
--       ≤-refl : n ≤ n
--       ≤-suc : {m : ℕ} → n ≤ m → n ≤ suc m
--
--     _<_ : (n m : ℕ) → Set
--     n < m = suc n ≤ m
--
-- Try the three definitions (and other ones if you wish):
--
--     matrix-elt′ : {n m : ℕ}
--       → n by m matrix
--       → (i j : ℕ)
--       → i < n
--       → j < m
--       → ℕ
--     matrix-elt′ {n} {m} mat i j = ?
--
-- Feel free to uncomment the definition above (or copy it below) and give your solution!
-- Pause and ponder: which definition of _<_ is easier to use in this case? Why?


-- Bonus: bounded natural numbers
-- ==============================
--
-- What? Pass an `i` and prove it is in bound separately? We have better options!
-- Let's define a type for bounded natural numbers [0, n):
--
--     data Fin : ℕ → Set where
--       zero : Fin (suc n)
--       suc : (i : Fin n) → Fin (suc n)
--
-- Values of type `Fin n` is statically known to be smaller than `n`.
-- And guess what? The standard library already have it defined for us, so ...
--
--     open import Data.Fin using (Fin) renaming (zero to fzero; suc to fsuc)
--
-- Let's rewrite `matrix-elt` using `Fin`:
--
--     matrix-elt″ : {n m : ℕ}
--       → n by m matrix
--       → (i : Fin n)
--       → (j : Fin m)
--       → ℕ
--     matrix-elt″ {n} {m} mat i j = ?
--
-- Feel free to uncomment the definition above (or copy it below) and give your solution!

-- 20.2(c): diagonal matrix, with the same element along the main diagonal
diagonal-matrix : (n : ℕ) → (d : ℕ) → n by n matrix
diagonal-matrix n d = ?

identity-matrix : (n : ℕ) → n by n matrix
identity-matrix n = ?

-- 20.2(d): transpose
transpose : {n m : ℕ} → n by m matrix → m by n matrix
transpose = ?

-- 20.2(e): dot product
_∙_ : {n : ℕ} → (x y : Vec ℕ n) → ℕ
x ∙ y = ?
