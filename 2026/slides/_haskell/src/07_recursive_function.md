# 第 07 章：递归函数

### 01 递归函数

在前文中已经看到，可以基于已有的函数定义新的函数：

```haskell
fac :: Int -> Int
fac n  =  product [1..n]
```

在很多情况下，一个函数可以通过自身对自身进行定义：

```haskell
fac :: Int -> Int
fac 0 = 1
fac n = n * fac (n-1)
```

这类函数称为 **递归函数** (Recursive Function)。


### 02 为什么需要递归函数？

- 一些函数，其递归定义方式更为简洁

- 一些函数，其定义本身就天然存在递归

- 在一些情况下，递归定义的函数，其数学性质更易于证明


### 03 List 上的递归函数

递归不仅适用于整数类型，也适用于 List 以及其他类型。

#### 示例：List 中元素的乘积

```haskell
product :: Num a => [a] -> a
product []  =  1
product (n:ns)  =  n * product ns
```

#### 示例：List 的长度

```haskell
length :: [a] -> Int
length []  =  0
length (_:xs)  =  1 + length xs
```

#### 示例：List 逆序

```haskell
reverse :: [a] -> [a]
reverse []  =  []
reverse (x:xs)  =  reverse xs ++ [x]
```

#### 示例：插入排序

```haskell
isort :: Ord a => [a] -> [a]
isort []  =  []
isort (x:xs)  =  insert x (isort xs)

insert :: Ord a => a -> [a] -> [a]
insert x []  =  [x]
insert x (y:ys) | x <= y    = x:y:ys
                | otherwise = y:(insert x ys)
```

### 04 多参数递归

具有多个参数的函数，也可以进行递归定义。

#### 示例：zip 函数

```haskell
zip :: [a] -> [b] -> [(a,b)]
zip []     _      = []
zip _      []     = []
zip (x:xs) (y:ys) = (x, y) : zip xs ys
```

#### 示例：drop 函数

```haskell
drop :: Int -> [a] -> [a]
drop 0 xs      =  xs
drop _ []      =  []
drop n (_:xs)  =  drop (n-1) xs
```

#### 示例：序列拼接函数

```haskell
(++) :: [a] -> [a] -> [a]
[]     ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)
```

### 05 多重递归 (Multiple Recursion)

所谓 **多重递归**，指的是：在定义一个函数时，对函数自身进行了多次递归调用。

```haskell
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n - 2) + fib (n - 1)
```

```haskell
qsort :: Ord a => [a] -> [a]
qsort []  =  []
qsort (x:xs)  =  qsort smaller ++ [x] ++ qsort larger
  where
    smaller = [a | a <- xs, a <= x]
    larger  = [b | b <- xs, b >  x]
```

```shell
    qsort [3, 2, 4, 1, 5]
=== qsort [2,1]                  ++  [3]  ++  qsort [4,5]
=== qsort [1] ++ [2] ++ qsort [] ++  [3]  ++  qsort [] ++ [4] ++ qsort [5]
===       [1] ++ [2] ++       [] ++  [3]  ++        [] ++ [4] ++       [5]
```

### 06 互递归 (Mutual Recursion)

所谓 **互递归**，指的是：在定义两或多个函数时，这些函数通过相互调用对方进行定义。

```haskell
even :: Int -> Bool
even 0 = True
even n = odd (n-1)

odd :: Int -> Bool
odd 0 = False
odd n = even (n-1)
```

## 本章作业

> <div class="warning">
>
> **作业 01**
>
> 在不查看 Prelude 源码的情况下，使用递归定义如下函数：
>
> 1. 判断 `[Bool]` 类型的一个值中的所有元素是否都为 `True`
>    ```haskell
>    and :: [Bool] -> Bool
>    ```
> 2. 将类型 `[[a]]` 的一个值中包含的所有 list 拼接为一个 list
>    ```haskell
>    concat :: [[a]] -> [a]
>    ```
> 3. 获得一个 list 中编号为 `n` 的元素 (从 `0` 开始编号)
>    ```haskell
>    (!!) :: [a] -> Int -> a
>    ```
> 4. 生成一个包含 `n` 个重复元素的 list
>    ```haskell
>    replicate :: Int -> a -> [a]
>    ```
> 5. 判断一个元素是否包含在一个 list 中
>    ```haskell
>    elem :: Eq a => a -> [a] -> Bool
>    ```
> </div>

> <div class="warning">
>
> **作业 02**
>
> 采用递归的方式定义如下函数：
>    ```haskell
>    merge :: Ord a => [a] -> [a] -> [a]
>    ```
> 该函数接收两个已经处于从小到大排序状态的 list，然后把其中包含的所有元素归并成一个保持排序状态的 list。
>
> 例如：
> ```shell
> ghci> merge [2,5,6] [1,3,4]
> [1,2,3,4,5,6]
> ```
> </div>


> <div class="warning">
>
> **作业 03**
>
> 采用递归的方式定义归并排序函数：
>    ```haskell
>    msort :: Ord a => [a] -> [a]
>    ```
> 它的递归定义包含两条规则：
> 1. 长度小于 2 的 list 已经处于排序状态
> 2. 对于长度大于 1 的 list，将其从中间断开，形成两个更短的 list，然后：
>    1. 对这两个更短的 list 分别进行归并排序
>    2. 将排序后形成的两个 list 进行归并
> </div>
