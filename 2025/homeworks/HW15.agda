module HW15 where

-- How to input the Unicode characters
-- ===================================
-- ℕ    \bN
-- →    \->
-- ∷    \::
-- ≡    \==
-- ⟨    \<
-- ⟩    \>
-- ˘    \u{}

open import Data.Nat using (ℕ; zero; suc; _+_; _*_)
open import Data.Bool using (Bool; true; false; _∨_; if_then_else_)
open import Data.List using (List; []; _∷_)
open import Data.Vec using (Vec; []; _∷_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; sym; trans; cong; cong-app)
open Eq.≡-Reasoning using (begin_; step-≡-⟩; step-≡-⟨; step-≡-∣; _∎)

-- Chap. 20

-- problem 20.1
_by_matrix : (n m : ℕ) → Set
n by m matrix = {!   !}

-- problem 20.2
-- 20.2(a) zero matrix: all zeros
zero-matrix : (n m : ℕ) → n by m matrix
zero-matrix n m = {!   !}

-- 20.2(b) matrix indexing
module Problem-20-2-b where
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
  matrix-elt {n} {m} mat = {!   !}

-- 20.2(c): diagonal matrix, with the same element along the main diagonal
diagonal-matrix : (n : ℕ) → (d : ℕ) → n by n matrix
diagonal-matrix n d = {!   !}

identity-matrix : (n : ℕ) → n by n matrix
identity-matrix n = {!   !}

-- 20.2(d): transpose
transpose : {n m : ℕ} → n by m matrix → m by n matrix
transpose = {!   !}

-- 20.2(e): dot product
_∙_ : {n : ℕ} → (x y : Vec ℕ n) → ℕ
x ∙ y = {!   !}

-- Chap. 21
-- Bonus: rewrite rules
-- 如果 _+_ 是在第二个参数上递归定义的，那么下面这两个性质就是自动得到的了。
-- 因此，也常常说下面两个性质是 _+_ 在第二个参数上的计算规则。
--
-- 有一种办法可以在 Agda 中根据已经证明的等式添加新的计算规则：使用重写规则。
-- 在证明下面两个定理后，试试加上如下规则：
--
--     {-# REWRITE +-identityʳ +-suc #-}
--
-- 然后重新尝试证明加法交换律：
--
--     +-comm : (m n : ℕ) → m + n ≡ n + m
--     +-comm zero    n = ?
--     +-comm (suc m) n = ?
--
-- 注意把光标放进两个 goal 中分别检查目标的类型，并和不用 REWRITE 之前的比较。
-- 使用 REWRITE 能让我们的证明简化，那么它有什么缺点呢？
--
-- 参看官方的文档：
-- https://agda.readthedocs.io/en/v2.6.2.2.20221106/language/rewriting.html

+-identityʳ : (m : ℕ) → m + 0 ≡ m
+-identityʳ m = {!   !}

+-suc : (m n : ℕ) → m + suc n ≡ suc (m + n)
+-suc m n = {!   !}
