# 第 10 章：案例 Countdown 问题


### 01 什么是 Countdown 问题

Countdown 问题是一个始于 1982 年的英国电视节目，其中包含了一个关于数字的游戏。

> Countdown 问题的一个示例:
>
> 请使用如下数字：
> - `1` `3` `7` `10` `25` `50`
>
> 以及如下四个运算：
> - `+` `-` `×` `÷`
>
> 构造出一个算术运算表达式，满足表达式的值为 `765`

Countdown 问题需要满足两条规则：

1. 所有的候选数字以及表达式求值过程的中间结果，都必须是正整数

2. 所有的候选数字在构造出的表达式中，最多只能出现一次

> 对于上面的这个示例问题：`1` `3` `7` `10` `25` `50`  =>  `765`
>
> - 一个解是：`(25 - 10) * (50 + 1)` === `765`
>
> - 这个问题一共有 780 个解
>
> 如果将这个问题的目标数字修改为 831，则该问题无解

### 02 求解 Countdown 问题

定义一个类型 `Op`，表示四种运算：

```haskell
data Op  =  Add | Sub | Mul | Div  deriving (Show)
```

<br>

定义函数 `apply`：该函数将一个运算应用到两个正整数上，返回运算结果：
```haskell
apply :: Op -> Int -> Int -> Int
apply Add x y = x + y
apply Sub x y = x - y
apply Mul x y = x * y
apply Div x y = x `div` y
```

<br>

定义函数 `valid`，判断 “将一个操作作用到两个正整数上，其结果是否仍然是一个正整数”：

```haskell
valid :: Op -> Int -> Int -> Bool
valid Add _ _ = True
valid Sub x y = x > y
valid Mul _ _ = True
valid Div x y = x `mod` y == 0
```

<br>

定义一个类型 `Expr`，用于表示算术运算表达式：

```haskell
data Expr  =  Val Int | App Op Expr Expr  deriving (Show)
```

<br>

定义函数 `eval`，用于评估表达式的值：

```haskell
eval :: Expr -> [Int]
eval (Val n    ) = [ n | n > 0 ]
eval (App o l r) = [ apply o x y | x <- eval l, y <- eval r, valid o x y]
```
该函数的返回值有如下特点：

- 若表达式的值为一个正整数，则返回一个仅包含该正整数的 list

- 否则，返回一个 empty list

<br>

#### 定义若干组合函数：

计算一个 list 的所有 sub-list:

```haskell
subs :: [a] -> [[a]]
subs []     = [[]]
subs (x:xs) = let yss = subs xs in yss ++ map (x:) yss
```

```shell
ghci> subs [1, 2, 3]
[ [], [3], [2], [2, 3], [1], [1, 3], [1, 2], [1, 2, 3] ]
```
- 注意：这里的 sub-list 不会改变元素之间的相对位置

```shell
=== subs (3:[])
=== subs [] ++ map (3:) (subs [])
=== [[]] ++ map (3:) [[]]
=== [[]] ++ [[3]]
=== [[],[3]]

    subs (2:3:[])
=== subs (3:[]) ++ map (2:) (subs (3: []))
=== [[],[3]]    ++ map (2:) [[],[3]]
=== [[],[3]]    ++ [[2], [2,3]]
=== [[],[3],[2],[2,3]]

    subs [1, 2, 3]
=== subs (1:2:3:[])
=== subs (2:3:[])      ++ map (1:) (subs (2:3:[]))
=== [[],[3],[2],[2,3]] ++ map (1:) [[],[3],[2],[2,3]]
=== [[],[3],[2],[2,3]] ++ [[1],[1,3],[1,2],[1,2,3]]
=== [[],[3],[2],[2,3],[1],[1,3],[1,2],[1,2,3]]
```

<br>

计算将一个元素插入一个 list 中的所有可能方式：

```haskell
interleave :: a -> [a] -> [[a]]
interleave x []     = [[x]]
interleave x (y:ys) = (x:y:ys) : map (y:) (interleave x ys)
```
```shell
ghci> interleave 1 [2, 3, 4]
[ [1,2,3,4], [2,1,3,4], [2,3,1,4], [2,3,4,1] ]
```

<br>

计算一个 list 中全部元素的所有可能排列 (Permutation)：

```haskell
perms :: [a] -> [[a]]
perms []     = [[]]
perms (x:xs) = concat $ map (interleave x) (perms xs)
```
```shell
ghci> perms [1, 2, 3]
[ [1,2,3], [2,1,3], [2,3,1], [1,3,2], [3,1,2], [3,2,1] ]
```

<br>

计算对一个 list 中的零或多个元素的所有可能选择方式：

```haskell
choices :: [a] -> [[a]]
choices = concat . map perms . subs
```
```shell
ghci> choices [1, 2, 3]
[ [], [3], [2], [2,3], [3,2], [1], [1,3], [3,1], [1,2], [2,1],
  [1,2,3], [2,1,3], [2,3,1], [1,3,2], [3,1,2], [3,2,1] ]
```

### 03 形式化 Countdown 问题

计算一个表达式中出现的所有值：

```haskell
values :: Expr -> [Int]
values (Val n    ) = [n]
values (App _ l r) = values l ++ values r
```

<br>

判断一个表达式是否是一个 Countdown 问题的解：

```haskell
solution :: Expr -> [Int] -> Int -> Bool
solution e ns n = (values e) `elem` (choices ns) && eval e == [n]
```

### 04 暴力搜索方法

计算将一个 list 分裂为两个非空 list 的所有可能方式：

```haskell
split :: [a] -> [([a],[a])]
split []     = []
split [_]    = []
split (x:xs) = ([x],xs) : [ (x:ls, rs) | (ls,rs) <- split xs ]
```

```shell
ghci> split [1, 2, 3, 4]
[ ([1], [2,3,4]), ([1,2], [3,4]), ([1,2,3], [4]) ]
```

<br>

计算所有满足如下条件的表达式：
- 该表达式中包含的值恰好是一个给定的 `[Int]`

```haskell
exprs :: [Int] -> [Expr]
exprs []  = []        -- 给定的 [Int] 为空
exprs [n] = [Val n]   -- 给定的 [Int] 只包含一个整数值
exprs ns  = [e | (ls,rs) <- split ns
                 ,     l <- exprs ls
                 ,     r <- exprs rs
                 ,     e <- combine l r]

combine :: Expr -> Expr -> [Expr]
combine l r = [ App o l r | o <- [Add, Sub, Mul, Div] ]
```

<br>

计算一个 Countdown 问题的所有解：

```haskell
solutions :: [Int] -> Int -> [Expr]
solutions ns n = [ e | ns' <- choices ns
                       , e <- exprs ns'
                       , eval e == [n] ]
```

#### 这种方法的效率

<table><tbody>
<tr>
<td> Hardware </td> <td> 2.8GHz Core 2 Duo, 4GB RAM </td>
</tr>

<tr>
<td> Compiler </td> <td> GHC version 7.10.2 </td>
</tr>

<tr>
<td> Example </td> <td> solutions [1,3,7,10,25,50] 765 </td>
</tr>

<tr>
<td> One solution </td> <td> 0.108 seconds </td>
</tr>

<tr>
<td> All solutions </td> <td> 12.224 seconds </td>
</tr>

</tbody></table>

#### 继续改进

大部分我们考察的表达式都是不合法的 (对这些不合法的表达式进行评估，总是返回一个 empty list)：

- 上面的这个 Countdown 问题，总计约 3300 万个表达式，但只有约 500 万个表达式合法

<br>

因此，将表达式的生成和评估融合在一起，会尽早发现并拒绝不合法的表达式，从而提高效率。


### 05 融合表达式的生成与评估

定义一个类型 `Result`，用于记录合法的表达式以及评估结果：
```haskell
type Result = (Expr, Int)
```

<br>

定义一个函数 `results`，计算包含给定值序列的合法表达式及其评估结果：

- 生成与评估相互独立的 `results` 函数：

  ```haskell
  results :: [Int] -> [Result]
  results ns = [ (e,n) | e <- exprs ns, n <- eval e ]
  ```

- 生成与评估相融合的 `results` 函数

  ```haskell
  results :: [Int] -> [Result]
  results []  = []
  results [n] = [(Val n, n) | n > 0]
  results ns  = [ res | (ls,rs) <- split    ns
                         ,   lx <- results  ls
                         ,   ry <- results  rs
                         ,  res <- combine' lx ry ]

  combine' :: Result -> Result -> [Result]
  combine' (l,x) (r,y) = [ (App o l r, apply o x y)
                               | o <- [Add,Sub,Mul,Div]
                               , valid o x y]
  ```
<br>

一个更好的计算方法：

```haskell
solutions' :: [Int] -> Int -> [Expr]
solutions' ns n = [ e | ns' <- choices ns, (e,m) <- results ns', m == n ]
```

#### 这种方法的效率

<table><tbody>
<tr>
<td> Hardware </td> <td colspan="3"> 2.8GHz Core 2 Duo, 4GB RAM </td>
</tr>

<tr>
<td> Compiler </td> <td colspan="3"> GHC version 7.10.2 </td>
</tr>

<tr>
<td> Example </td> <td colspan="3"> solutions [1,3,7,10,25,50] 765 </td>
</tr>

<tr>
<td> One solution </td> <td> 0.108 s </td> <td> 0.014 s </td> <td>  </td>
</tr>

<tr>
<td> All solutions </td> <td> 12.224 s </td> <td> 1.312 s </td> <td>  </td>
</tr>

<tr>
<td> </td> <td> 暴力搜索 </td> <td> 融合生成与评估 </td> <td>  </td>
</tr>

</tbody></table>

#### 继续改进

很多表达式实际上是相互等价的，例如：
- `x * y` == `y * x`
- `x * 1` == `x`

减少对这些等价表达式的搜索，可以进一步提交效率

### 06 改进 valid 函数

```haskell
valid :: Op -> Int -> Int -> Bool
valid Add x y  =  x <= y
valid Sub x y  =  x > y
valid Mul x y  =  x <= y && x /= 1 && y /= 1
valid Div x y  =  x `mod` y == 0  && y /= 1

-- 原来的版本
valid :: Op -> Int -> Int -> Bool
valid Add x y  =  True
valid Sub x y  =  x > y
valid Mul x y  =  True
valid Div x y  =  x `mod` y == 0
```

#### 这种方法的效率

<table><tbody>
<tr>
<td> Hardware </td> <td colspan="3"> 2.8GHz Core 2 Duo, 4GB RAM </td>
</tr>

<tr>
<td> Compiler </td> <td colspan="3"> GHC version 7.10.2 </td>
</tr>

<tr>
<td> Example </td> <td colspan="3"> solutions [1,3,7,10,25,50] 765 </td>
</tr>

<tr>
<td> One solution </td> <td> 0.108 s </td> <td> 0.014 s </td> <td> 0.007 s </td>
</tr>

<tr>
<td> All solutions </td> <td> 12.224 s </td> <td> 1.312 s </td> <td> 0.119 s </td>
</tr>

<tr>
<td> </td> <td> 暴力搜索 </td> <td> 融合生成与评估 </td> <td> 改进的 valid </td>
</tr>

</tbody></table>


## 本章作业

> <div class="warning">
>
> **作业 01**
>
> 修改最终版本的 Countdown 问题计算方法，实现如下功能增强：
>
> 1. 允许在表达式中存在指数运算
>
> 2. 如果找不到精确解，则生成所有距离精确解最近的解 (Nearest Solutions)
>
> 3. 确定一种对解的简洁性进行评估的指标，然后对生成的解按照这个指标进行排序
>
> </div>
