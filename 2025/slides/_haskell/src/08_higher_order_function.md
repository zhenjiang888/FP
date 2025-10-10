# 第 08 章：高阶函数

> “高阶函数” 的英文为： Higher-order Function

### 01 高阶函数

所谓 “高阶函数”，指的是：这个函数的某个参数或返回值是一个函数。

```haskell
twice :: (a -> a) -> a -> a
twice f x  =  f (f x)
```
上面这个 `twice` 是一个高阶函数，原因如下：

1. 这个函数接收的第一个参数是一个函数 (类型为 `a -> a`)；或者

2. 这个函数接收第一个参数后返回一个函数 (类型为 `a -> a`)

### 02 为什么需要高阶函数

1. 一些常用的程序设计模式 (Common Programming Idiom) 可以表示为高阶函数

2. 领域特定语言 (Domain Specific Language) 的很多成分，也可以表示为高阶函数

3. 高阶函数具有的代数性质，可用于程序性质证明

### 03 map 函数

Prelude 模块中的 `map` 是一个经典的高阶函数，其功能是把一个函数作用到一个 list 中的每个元素上。

```haskell
map :: (a -> b) -> [a] -> [b]
```

```shell
ghci> map (+1) [1, 2, 3, 4, 5]
[2, 3, 4, 5, 6]
```
<br>

`map` 函数可以使用 List Comprehension 进行简洁的定义：

```haskell
map :: (a -> b) -> [a] -> [b]
map f xs = [f x | x <- xs]
```

<br>

`map` 函数也可以使用递归方式进行定义：

```haskell
map :: (a -> b) -> [a] -> [b]
map _ []  =  []
map f (x:xs)  =  f x : map f xs
```

### 04 filter 函数

Prelude 模块中的 `filter` 是一个经典的高阶函数，其功能是把 list 中不满足指定条件的元素删除。

```haskell
filter :: (a -> Bool) -> [a] -> [a]
```

```shell
ghci> filter even [1..10]
[2,4,6,8,10]
```
<br>

`filter` 函数可以使用 List Comprehension 进行定义：

```haskell
filter :: (a -> Bool) -> [a] -> [a]
filter pred xs  =  [x | x <- xs, pred x]
```

<br>

`filter` 函数也可以使用递归方式进行定义：

```haskell
filter :: (a -> Bool) -> [a] -> [a]
filter _ []  =  []
filter pred (x:xs)
    | pred x    = x : filter pred xs
    | otherwise = filter pred xs
```

### 05 List 上的 foldr 函数

一些定义在 list 上的函数，可以使用如下的递归模式进行定义：

```haskell
f []       = v
f (x:xs) = x ⊕ f xs
```
其含义是：
1. 函数 `f` 将一个空 list `[]` 映射到值 `v`

2. 函数 `f` 将一个非空 list `(x:xs)` 映射为一个函数 `(⊕)` 作用到 `x` 和 `f xs` 上

请看下面的三个示例：

```haskell
sum []  =  0
sum (x:xs)  =  x + sum xs

sum = foldr (+) 0
```

```haskell
product []  =  1
product (x:xs)  =  x * product xs

product = foldr (*) 1
```

```haskell
and []     = True
and (x:xs) = x && and xs

and = foldr (&&) True
```

<br>

在 Haskell 中，`foldr` 是 type class `Foldable` 中的一个函数：

```haskell
class Foldable t where
  foldr :: (a -> b -> b) -> b -> t a -> b
  ...
```
- 在一般意义上，`foldr` 是定义在一种结构 (structure) 上的满足右结合律的折叠 (fold) 操作，且具有惰性求值的特点
  - “结构”：理解为为 “类型” 即可；每一种类型都可以视为一种结构
  - “惰性求值”：大致可以理解为，当前用不到的计算结果，绝对不会去计算

- 在 List 这种结构上的 `foldr`，具有如下行为：
  ```haskell
      foldr f z [x1, x2, ..., xn]
  === x1 `f` (x2 `f` ... (xn `f` z) ...)    -- 因为 `f` 满足右结合律，所以
  === x1 `f`  x2 `f` ...  xn `f` z
  === f x1 (f x2 (... (f xn z) ...))
  ```
- 在对上面 `===` 右侧的表达式进行求值时，按照惰性求值的策略，首先对最外层函数应用进行求值
  - 因此，如果函数 `f` 对其第二个参数也具有惰性求值的行为，那么，即使 `foldr` 的三个参数是一个 infinite list，`foldr`函数也有可能终止

<br>

List 上的 `foldr` 可以采用递归方式进行定义：

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f v []     = v
foldr f v (x:xs) = f x (foldr f v xs)
```

在宏观上，可以将 List 上的 `foldr` 理解为：将一个 list 中的 `[]` 替换为一个指定的值；同时，将所有的 `(:)` 替换为一个指定的函数


**若干示例：**

```haskell
sum  =  foldr (+) 0
```

```haskell
    sum [1, 2, 3]
=== foldr (+) 0 [1, 2, 3]
=== foldr (+) 0 (1 : (2 : (3 : [])))
===              1 + (2 + (3 + 0 ))
=== 6
```
<br>

```haskell
product  =  foldr (*) 1
```

```haskell
    product [1, 2, 3]
=== foldr (*) 1 [1, 2, 3]
=== foldr (*) 1 (1 : (2 : (3 : [])))
===              1 * (2 * (3 * 1 ))
=== 6
```

<br>

```haskell
length :: [a] -> Int
length []  =  0
length (_:xs)  =  1 + length xs
```

```haskell
    length [1, 2, 3]
=== length (1 : (2 : (3 : [])))
===         1 + (1 + (1 + 0 ))
=== 3
```

```haskell
length :: [a] -> Int
length =  foldr (⊕) 0 where
    _ ⊕ n = 1 + n
```

```haskell
    length [1, 2, 3]
=== foldr (⊕) 0 (1 : (2 : (3 : [])))
===              1 ⊕ (2 ⊕ (3 ⊕ 0 ))
===              1 + (1 + (1 + 0 ))
=== 3
```

<br>

```haskell
reverse :: [a] -> [a]
reverse []  =  []
reverse (x:xs)  =  reverse xs ++ [x]
```

```haskell
    reverse [1, 2, 3]
=== reverse (1 : (2 : (3 : [])))
=== (([] ++ [3]) ++ [2]) ++ [1]
=== [3, 2, 1]
```

```haskell
reverse :: [a] -> [a]
reverse  =  foldr (⊕) [] where
    x ⊕ xs  =  xs ++ [x]
```

```haskell
    reverse [1, 2, 3]
=== foldr (⊕) [] (1 : (2 : (3 : [])))
===               1 ⊕ (2 ⊕ (3 ⊕ []))
=== (([] ++ [3]) ++ [2]) ++ [1]
=== [3, 2, 1]
```

<br>

最后，可以看到，函数 `(++)` 采用 `foldr` 进行定义非常简洁：

```haskell
(++) :: [a] -> [a] -> [a]
(++ ys) = foldr (:) ys
```

遗憾的是，Haskell 目前并不支持这种定义方式。

以下是两种可以通过编译的定义方式：

```haskell
(++) :: [a] -> [a] -> [a]
(++) xs ys = foldr (:) ys xs
```

```haskell
(++) :: [a] -> [a] -> [a]
(++) = flip $ foldr (:)

-- flip 是 Prelude 中的一个函数，其定义如下：
flip  ::  (a -> b -> c) -> b -> a -> c
flip f x y  =  f y x
```

```haskell
    (++) xs ys
=== (flip $ foldr (:) ) xs ys
=== (flip  (foldr (:))) xs ys
===  flip  (foldr (:))  xs ys
===        (foldr (:))  ys xs
===         foldr (:)   ys xs
```

#### 为什么需要 foldr

- 一些函数，使用 `foldr` 定义，非常简洁

- `foldr` 具有的代数性质，可以用于程序性质证明

- 使用 `foldr` 定义的函数便于进行性能优化


### 06 List 上的 foldl 函数

在 List 上的一些函数，也可以采用左结合的方式进行递归定义。共性模式如下：

```haskell
f v []     = v
f v (x:xs) = f (v ⊕ x) xs
```

List 上的 `foldl` 函数可以采用递归方式定义：

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f v []     = v
foldl f v (x:xs) = foldl f (f v x) xs
```

<br>

与 `foldl` 类似，在 Haskell 中，`foldr` 是 type class Foldable 中的一个函数：

```haskell
class Foldable t where
  foldr :: (a -> b -> b) -> b -> t a -> b
  foldl :: (b -> a -> b) -> b -> t a -> b
  ...
```
- 在一般意义上，`foldl` 是定义在一种结构 (structure) 上的满足左结合律的折叠 (fold) 操作，且具有惰性求值的特点

- 在 List 这种结构上的 `foldl`，具有如下行为：

  ```haskell
      foldl f z [x1, x2, ..., xn]
  === (((z `f` x1) `f` x2)...) `f` xn  -- 因为 `f` 满足左结合律，所以
  ===    z `f` x1  `f` x2 ...  `f` xn
  === f (... (f (f z x1) x2) ...) xn
  ````
- 在对上面 === 右侧的表达式进行求值时，按照惰性求值的策略，首先对最外层函数应用进行求值
  - 因此，如果 `foldl` 的三个参数是一个 infinite list，则 `foldl` 函数 **不会终止**

- 如果想要一个传统高效的 `foldl`，可以使用 `foldl'` 函数

### 07 Prelude 中的若干高阶函数

#### 函数组合

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
(.) f g = \x -> f $ g x
```
- 其中，`\x -> f $ g x` 是 Haskell 中声明匿名函数的语法

- 使用示例：

  ```haskell
  odd :: Int -> Bool
  odd = not . even
  ```

#### all 函数

`all` 函数计算一个结构中的所有元素是否都满足一个指定的条件 (谓词)

```haskell
all :: Foldable t => (a -> Bool) -> t a -> Bool
```
在 List 上，`all` 函数的定义如下：

```haskell
all :: (a -> Bool) -> [a] -> Bool
all p xs = and [p x | x <- xs]
```

#### any 函数

`any` 函数计算一个结构中的所有元素中是否存在至少一个满足指定条件的元素

```haskell
any :: Foldable t => (a -> Bool) -> t a -> Bool
```
在 List 上，`any` 函数的定义如下：

```haskell
any :: (a -> Bool) -> [a] -> Bool
any p xs = or [p x | x <- xs]
```

#### takeWhile 函数

`takeWhile` 函数持续取出一个 list 中的元素，直到遇到第一个不满足指定条件的元素

```haskell
takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile _ []  =  []
takeWhile p (x:xs)
    | p x       = x : takeWhile p xs
    | otherwise = []
```

```shell
ghci> takeWhile (/= ' ') "abc def"
"abc"
```

#### dropWhile 函数

与 `takeWhile` 相反，`dropWhile` 函数持续地忽略一个 list 中的元素，直到遇到第一个不满足指定条件的元素

```haskell
dropWhile :: (a -> Bool) -> [a] -> [a]
dropWhile _ []  =  []
dropWhile p xs@(x:xs')
    | p x       =  dropWhile p xs'
    | otherwise = xs
```
> 其中出现了一种新的语法 `xs@(x:xs')`。你猜猜这种语法的效果是什么？


### 08 应用 01：Binary String Transmitter

#### 2 进制数 转换到 10 进制数

效果：
```shell
ghci> bin2int [1, 0, 1, 1]
13
```
- 待转换的二进制数放置在 list 中，且：低位在左，高位在右

<br>

定义方式一：

```haskell
type Bit = Int
-- 将 Bit 作为类型 Int 的别名

bin2int :: [Bit] -> Int
bin2int bits  =  sum [ w * b | (w, b) <- zip weights bits ]
   where weights = iterate (* 2) 1

-- iterate is defined in Prelude
iterate :: (a -> a) -> a -> [a]
iterate f x  =  x : iterate f (f x)
```

<br>

定义方式二：

```haskell
type Bit = Int

bin2int :: [Bit] -> Int
bin2int  =  foldr (\x y -> x + 2 * y) 0
```

<br>

#### 10 进制数 转换到 8 位 2 进制数

效果：
```shell
ghci> int2bin8 13
[1, 0, 1, 1, 0, 0, 0, 0]
```

定义：
```haskell
int2bin :: Int -> [Bit]
int2bin 0  =  []
int2bin n  =  mod n 2 : int2bin (div n 2)

make8 :: [Bit] -> [Bit]
make8 bits  =  take 8 $ bits ++ repeat 0

-- repeat is defined in Prelude
repeat :: a -> [a]
repeat x = xs where xs = x : xs

int2bin8 :: Int -> [Bit]
int2bin8  =  make8 . int2bin
```

<br>

#### 文字序列编码

效果：
```shell
ghci> encode "abc"
[1,0,0,0,0,1,1,0,0,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0]
```

定义：
```haskell
encode :: String -> [Bit]
encode = concat . map (make8 . int2bin . ord)
```

<br>

#### 2 进制序列解码

效果：
```shell
ghci> decode [1,0,0,0,0,1,1,0,0,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0]
"abc"
```

定义：
```haskell
decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

chop8 :: [Bit] -> [[Bit]]
chop8 []   = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)
```

### 09 应用 02.01：投票算法 之 First Past the Post

在这种投票系统中，每一个投票者仅可以投一个候选项。获得票数最多的候选项，成为获胜者。

以下给出投票结果的一个示例：

```haskell
votes :: [String]
votes =  ["Red", "Blue", "Green", "Blue", "Blue", "Red"]
```

<br>

编写两个函数 `result` 和 `winner`，实现如下效果：

```shell
ghci> result votes
[(1,”Green"),(2,"Red"),(3,"Blue")]

ghci> :type result
result :: Ord a => [a] -> [(Int, a)]

ghci> winner votes
"Blue"

ghci> :type winner
winner :: Ord a => [a] -> a
```

<br>

**定义：**

```haskell
result :: Ord a => [a] -> [(Int, a)]
result vs  =  sort [ (count v vs, v) | v <- rmdups vs ]
-- The sort function is defined in Data.List

rmdups :: Eq a => [a] -> [a]
rmdups []  =  []
rmdups (x:xs)  =  x : filter (/= x) (rmdups xs)

count :: Eq a => a -> [a] -> Int
count x = length . filter (== x)

winner :: Ord a => [a] -> a
winner = snd . last . result
```

### 09 应用 02.02：投票算法 之 Alternative Vote

在这种投票系统中，每一个投票者：

- 可以给任意多个候选项进行投票

- 但是需要给所投的候选项排序，从而表明自己对所投候选项的偏好
  - 排序在第 1 位的候选项，为第 1 选择；排序在第 2 位的候选项，为第 2 选择；以此类推

下面给出了记录所有投票者投票结果的示例 (包含 5 个投票者的投票结果)：

```haskell
ballots :: [[String]]
ballots  =  [["Red", "Green"],
             ["Blue"],
             ["Green", "Red", "Blue"],
             ["Blue", "Green", "Red"],
             ["Green"]]
```

编写一个 `winner` 函数，实现如下效果：

```shell
ghci> winner ballots
"Green"

ghci> :type winner
winner :: Ord a => [[a]] -> a
```

<br>

**获胜者的确定规则：**

1. 如果某个投票者的投票结果为空，则将其从全部投票结果中删除

2. 在所有投票者的第一选择中，确定得票数最少的候选项，然后将该候选项从全部投票结果中删除

3. 重复执行上述步骤 1 和 2，直到仅存在一个候选项；该候选项即为最终获胜者

下面，我们以 `ballots` 为例，展示整个计算过程：

```haskell
ballots :: [[String]]
ballots  =  [["Red", "Green"],
             ["Blue"],
             ["Green", "Red", "Blue"],
             ["Blue", "Green", "Red"],
             ["Green"]]
```

- 执行步骤 1：
  - 因为不存在为空的投票结果，所以 `ballots` 没有发生变化

- 执行步骤 2：
  - 在所有第 1 选择中，得票最少的是 `"Red"`；所以，将所有 `"Red"` 从 `ballots` 中删除

  ```haskell
  ballots :: [[String]]
  ballots  =  [["Green"],
               ["Blue"],
               ["Green", "Blue"],
               ["Blue", "Green"],
               ["Green"]]
  ```

- 执行步骤 1：
  - 因为不存在为空的投票结果，所以 `ballots` 没有发生变化

- 执行步骤 2：
  - 在所有第 1 选择中，得票最少的是 `"Blue"`；所以，将所有 `"Blue"` 从 `ballots` 中删除

  ```haskell
  ballots :: [[String]]
  ballots  =  [["Green"],
               [],
               ["Green"],
               ["Green"],
               ["Green"]]
  ```

- 执行步骤 1：
  - 删除所有为空的投票

  ```haskell
  ballots :: [[String]]
  ballots  =  [["Green"],
               ["Green"],
               ["Green"],
               ["Green"]]
  ```

- 只剩下一个候选项 `"Green"`；产生获胜者

<br>

**定义：**

```haskell
winner :: Ord a => [[a]] -> a
winner bs = case rank $ filter (/= []) bs of
    [c] -> c
    (c:cs) -> winner $ map (filter (/= c)) bs

rank :: Ord a => [[a]] -> [a]
rank = map snd . result . map head
```

## 本章作业

> <div class="warning">
>
> **作业 01**
>
> 对 `[f x | x <- xs, p x]` 使用函数 `map` 和 `filter` 进行表达
>
> </div>


> <div class="warning">
>
> **作业 02**
>
> 使用 `foldr` 对 `map f` 和 `filter p` 进行定义
>
> </div>


> <div class="warning">
>
> **作业 03**
>
> 对 binary string transmitter 示例进行改写，实现 “检测传输错误” 的功能。
>
> 具体而言，采用 “奇偶校验位” 对传输错误进行检测：
> - 在编码时，每 8 个二进制位添加 1 个奇偶校验位
>   - 当这 8 个二进制位 包含奇数个 `1` 时，将校验位设为 `1`；否则，设置为 `0`
> - 在解码时，对每 9 个二进制位进行校验
>   - 若奇偶校验位正确，则将校验位抛弃；否则，输出错误，并终止程序
>
> 提示：
> - 库函数 `error :: String -> a` 具有 “输出错误信息并终止程序” 的效果
> - 该函数的返回值类型是一个类型参数，所以它可以在任何函数中使用，而不会产生类型错误
>
> </div>
