module HW7 where

-- **=========[ Ch.09 ]=========**

-- Problem #1: multiplies for natural numbers
data Nat = Zero | Succ Nat
  deriving (Show)

add :: Nat -> Nat -> Nat
add Zero     n = n
add (Succ m) n = Succ (add m n)

multiplies :: Nat -> Nat -> Nat
multiplies = _
-- End Problem #1

-- Problem #2: folde for Exprs
-- Names are appended ' to be distinguished from Ch. 10
data Expr'
  = Val' Int
  | Add' Expr' Expr'
  | Mul' Expr' Expr'
  deriving (Show)

-- try to figure out the suitable type yourself
folde :: _
folde = _

-- Give at least 2 use cases of folde below (other than size and eval)

-- End Problem #2

-- Problem #3: recursive tree type
data Tree a = _
-- End Problem #3

-- **=========[ Ch.10 ]=========**

-- ! 搜索效率可能不高，只建议在非常小的数据上尝试。
-- ! 忽略任何 Int 越界，可认为运算均在 Int 上而非数学意义的整数上执行，请避免在此事上花时间。
-- ! 所有功能均允许改进 valid 函数剪除等价表达式，允许融合表达式的生成与评估，也允许自行引入讲义之外的优化。如果你的优化有理由支撑但可能影响结果（如剪除更多等价表达式），可以用注释简单描述优化的内容和理由。

data Op
  = Add
  | Sub
  | Mul
  | Div
  | Pow -- 添加的指数运算
  deriving Eq

data Expr
  = Val Int
  | App Op Expr Expr
  deriving Eq

-- 一些辅助函数
apply :: Op -> Int -> Int -> Int
apply Add x y = x + y
apply Sub x y = x - y
apply Mul x y = x * y
apply Div x y = x `div` y
apply Pow x y = x ^ y

valid :: Op -> Int -> Int -> Bool
valid = _

eval :: Expr -> [Int]
eval (Val n) = [n | n > 0]
eval (App o l r) = [apply o x y | x <- eval l, y <- eval r, valid o x y]

subs :: [a] -> [[a]]
subs [] = [[]]
subs (x:xs) = subs xs ++ map (x:) (subs xs)

interleave :: a -> [a] -> [[a]]
interleave x [] = [[x]]
interleave x (y:ys) = (x:y:ys) : map (y:) (interleave x ys)

perms :: [a] -> [[a]]
perms [] = [[]]
perms (x:xs) = concatMap (interleave x) (perms xs)

choices :: [a] -> [[a]]
choices = concatMap perms . subs

split :: [a] -> [([a], [a])]
split [] = []
split [_] = []
split (x:xs) = ([x], xs) : [(x:ls, rs) | (ls, rs) <- split xs]

-- 你需要完成下面的 solutions 函数
-- 你可能还需要自定义一些辅助函数或类型
-- 注意你需要实现3个功能：
-- 1. 补全指数运算（Pow）相关功能
-- 2. 如果找不到精确解，则生成所有距离精确解最近的解
-- 3. 为 solutions 制定你喜欢的排序方式
-- 示例如下：
-- solutions [1, 3, 7] 23 应当返回所有值为 22 或 24 的表达式
-- solutions [3, 7] 343 应当返回 7^3
-- 所有功能允许剪除等价表达式。
solutions :: [Int] -> Int -> [Expr]
solutions = _

-- 下面是我们为 Expr 和 Op 提供的一个 Show 的实现
-- 这并不是本次作业必需的，但是在调试过程中可能会让表达式更易读
-- 这个实现使用了 showsPrec，有关它的细节你可以参考相关文档：
-- https://hackage.haskell.org/package/base-4.15.0.0/docs/Text-Show.html#t:Show
-- 以及 Haskell 2010 Report 的 11.4 节：
-- https://www.haskell.org/onlinereport/haskell2010/haskellch11.html

instance Show Op where
  show Add = "+"
  show Sub = "-"
  show Mul = "*"
  show Div = "/"
  show Pow = "^"

instance Show Expr where
  showsPrec _ (Val n) = shows n
  showsPrec p (App op x y)
    = showParen (p > q)
    $ showsPrec q x . showChar ' ' . shows op
    . showChar ' ' . showsPrec (succ q) y
    where q = case op of
            Add -> 6; Sub -> 6
            Mul -> 7; Div -> 7
            Pow -> 8
