module HW16 where

open import Data.Nat using (ℕ; zero; suc; _+_)

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; sym; trans; cong; cong-app)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; step-≡˘; _∎)

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
+-identityʳ m = ?

+-suc : (m n : ℕ) → m + suc n ≡ suc (m + n)
+-suc m n = ?
