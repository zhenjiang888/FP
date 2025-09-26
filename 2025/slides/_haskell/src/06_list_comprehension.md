# 第 06 章：List Comprehension

> 主要知识点：
> - Generator / Guard / String Comprehension

### 01 List Comprehension

在集合论中，我们通常使用 Set Comprehension 实现 “从已有集合出发构造新的集合” 的效果：

```shell
{ x² | x ∈ { 1, 2, 3, 4, 5 } }
```

在 Haskell 中，一种类似的 List Comprehension 语法，可以实现 “从已有 list 出发构造新的 list” 的效果：

```haskell
{ x^2 | x <- [1..5] }
```
上面这个表达式，从一个已有的 list `[1, 2, 3, 4, 5]` 出发，构造出了一个新的 list `[1, 4, 9, 16, 25]`。

### 02 Generator

在上面的示例中，`x <- [1..5]` 称为一个 generator。
- 因为：它能够 **生成** (generate) 一些值

<br>

在一个 List Comprehension 中，可以存在多个 generators：

```haskell
[ (x, y) | x <- [1, 2, 3], y <- [4, 5] ]
```
这个表达式构造的 list 是：
- `[ (1, 4), (1, 5), (2, 4), (2, 5), (3, 4), (3, 5) ]`

<br>

改变多个 generators 的顺序，会导致形成的 list 中的元素的顺序发生变化：

```haskell
[ (x, y) | y <- [4, 5], x <- [1, 2, 3] ]
```
这个表达式构造的 list 是：
- `[ (1, 4), (2, 4), (3, 4), (1, 5), (2, 5), (3, 5) ]`

#### Dependant Generator

后面的 generator 可以依赖于前面的 generator 生成的值：

```haskell
[ (x, y) | x <- [1..3], y <- [x..3] ]
```
这个表达式构造的 list 是：
- `[ (1, 1), (1, 2), (1, 3), (2, 2), (2, 3), (3, 3) ]`

利用 Dependant Generator，可以给出 Prelude 模块中 `concat` 函数的定义：

```haskell
concat :: [[a]] -> [a]
concat xss = [ x | xs <- xss, x <- xs ]
```

```shell
ghci> concat [ [1, 2, 3], [4, 5], [6] ]
[1,2,3,4,5,6]
```

### 03 Guard

可用使用 Guard 对 generator 生成的值进行过滤：

```haskell
[ x | x <- [1..10], even x ]
```
这个表达式构造的 list 是：
- `[ 2, 4, 6, 8, 10 ]`

<br>

**示例：** 使用 Guard，可以定义 “计算一个正整数的所有因子” 的函数：

```haskell
factors :: Int -> [Int]
factors n  =  [ x | x <- [1..n], mod n x == 0 ]
```

```shell
ghci> factors 1000
[1,2,4 5,8,10,20,25,40,50,100,125,200,250,500,1000]
```

<br>

在此基础上，可以定义 “判断一个正整数是否是素数” 的函数：

```haskell
prime :: Int -> Bool
prime n  =  factors n == [1,n]
```

```shell
ghci> prime 1
False

ghci> prime 72
False

ghci> prime 73
True
```

<br>

在此基础上，可以定义 “计算前 n 个素数” 的函数：

```haskell
primes :: Int -> [Int]
primes n  =  [x | x <- [2..n], prime x]
```

```shell
ghci> primes 70
[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67]
```

### 04 `zip` 函数

Prelude 模块中存在一个函数 `zip`，其定义如下：

```haskell
zip :: [a] -> [b] -> [(a,b)]
zip [] _   =  []
zip _  []  =  []
zip (a:as) (b:bs)  =  (a,b) : zip as bs
```

```shell
ghci> zip ['a', 'b', 'c'] [1, 2, 3, 4]
[('a',`),('b',2),('c',3)]
```

你应该能够理解 `zip` 函数的效果：即，把两个 list 向拉链一样合并到一起

<br>

**示例：** 使用 `zip` 函数，可以定义 “计算一个 list 中所有相邻元素对” 的函数

```haskell
pairs :: [a] -> [(a,a)]
pairs xs = zip xs (tail xs)
```

```shell
ghci> pairs [1..10]
[(1,2),(2,3),(3,4),(4,5),(5,6),(6,7),(7,8),(8,9),(9,10)]
```

<br>

**示例：** 使用 `zip` 函数，可以定义 “判断一个 list 是否处于有序 (从小到大) 状态” 的函数

```haskell
sorted :: Ord a => [a] -> Bool
sorted xs  =  and [ x <= y | (x, y) <- pairs xs ]
```

```shell
ghci> sorted [1..10]
True

ghci> sorted [1,3,2,4]
False
```

<br>

**示例：** 使用 `zip` 函数，可以定义 “计算一个值在一个 list 中所有出现的位置” 的函数

```haskell
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [ i | (x',i) <- zip xs [0..], x == x' ]
```

### 05 String Comprehension

在 Haskell 中，一个 字符串字面量 (String Literal) 是一个由一对双引号包围的字符序列。

```haskell
"abcd" :: String
```

其中，类型 `String` 是类型 `[Char]` 的别名。因此，上述声明等价于：

```haskell
['a', 'b', 'c', 'd'] :: [Char]
```

<br>

因为 `String` 是一种特殊的 List 类型，所以任何定义在 List 类型上的多态函数也适用于 `String` 类型。

```haskell
ghci> length "abcde"
5

ghci> take 3 "abcde"
"abc"

ghci> zip "abcd" [1, 2, 3, 4]
[('a',1),('b',2),('c',3),('d',4)]
```

<br>

类似地，List Comprehension 也可用于定义作用在 `String` 上的函数。例如，下面给出了 “计算字符在字符串中出现次数” 的函数定义：

```haskell
count :: Char -> String -> Int
count x xs = length [ x' | x' <- xs, x == x' ]
```

```shell
ghci> count 'g' "googlegod"
3
```

### 06 问题示例：凯撒加密

为了对字符串文本进行加密，凯撒发明了如下的加密方式：

- 把一个英文字母替换为它在字母表中后面的第 3 个字母

- 如果到达了字母表的末尾 (即：字母 `z`)，则回转到第一个字母 `a`
  - 也即，字母 `z` 的后继字母是 `a`

下面，我们按照这种方式，分别定义 加密 和 解密 两个函数。

```haskell
ghci> :type encode
encode :: Int -> String -> String

ghci> encode 3 "haskell is fun"
"kdvnhoo lv ixq"

ghci> encode (-3) "kdvnhoo lv ixq"
"haskell is fun"

ghci> :type crack
crack :: String -> String

ghci> crack "kdvnhoo lv ixq"
"haskell is fun"
```

#### 加密 / encode

```haskell
import Data.Char(ord, chr, isLower)
-- ord :: Char -> Int        // 将字符转换为编码值
-- chr :: Int -> Char        // 将编码值转换为字符
-- isLower :: Char -> Bool  // 判断字符是否为小写字母

encode :: Int -> String -> String
encode n xs = [ shift n x | x <- xs ]

shift :: Int -> Char -> Char
shift n c | isLower c  =  int2let $ mod (let2int c + n) 26
          | otherwise  =  c

let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr $ ord 'a' + n
```

#### 解密 / crack

对凯撒加密后的字符串进行解密的关键：
- 在英文语料中，不同字母出现的频率是不同的

下面定义 `table` 依次记录了 26 个英文字母的出现百分比：

```haskell
table :: [Float]
table = [ 8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
          0.2, 0.8, 4.0, 2.4,  6.7, 7.5, 1.9, 0.1, 6.0,
          6.3, 9.0, 2.8, 1.0,  2.4, 0.2, 2.0, 0.1 ]

```

**chi-square statistic**：一种对一组 期望频率 (expected frequencies) 和 一组 观察频率 (observed frequencies) 进行比较的标准方法。

假设存在两个长度为 `n` 的频率序列: 1.期望频率序列 `es`；2.观察频率序列 `os`。则两者的 chi-square statistic 定义如下：

\\[ \sum_{i=0}^{n - 1} \frac{(os[i] - es[i])^2}{es[i]}\\]

```rust
import Data.Char(ord, chr, isLower)

crack :: String -> String
crack xs = encode (- factor) xs where
    factor = position (minimum chitab) chitab
    -- minimum: a function exported by Prelude

    -- 计算每种加密偏移量下的chisqr
    chitab = [ chisqr (rotate n table') table | n <- [0..25] ]

    -- 计算密文中字母的出现频率
    table' = freqs xs

table :: [Float]
table = [ 8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
          0.2, 0.8, 4.0, 2.4,  6.7, 7.5, 1.9, 0.1, 6.0,
          6.3, 9.0, 2.8, 1.0,  2.4, 0.2, 2.0, 0.1 ]

position :: Eq a => a -> [a] -> Int

rotate :: Int -> [a] -> [a]

freqs :: String -> [Float]

chisqr :: [Float] -> [Float] -> Float
```

## 本章作业

> <div class="warning">
>
> **作业 01**
>
> 请给出凯撒解密函数的完整定义：即，把上述定义中缺失的函数补充完整
>
> 说明：
> - 仅考虑 “明文中仅包含小写字母和空格” 的情况
>
> - 自行学习如何使用 Prelude 中的如下函数实现从整数类型到浮点数类型的转换
>   - `fromIntegral :: (Integral a, Num b) => a -> b`
> </div>

> <div class="warning">
>
> **作业 02**
>
> 称一个三元组 `(x, y, z)` 为 毕达哥拉斯 (Pythagorean) 三元组，如果其满足如下条件：
> - `x² + y² === z²`
>
> 使用 List Comprehension，定义一个函数：
> ```shell
> pyths :: Int -> [(Int, Int, Int)]
> ```
> 该函数接收一个正整数 `n`，返回区间 `[1..n]` 中所有的毕达哥拉斯三元组 (返回的三元组序列按照从小到大的顺序排列)
>
> 例如：
> ```shell
> ghci> pyths 5
> [(3,4,5),(4,3,5)]
> ```
>
> </div>

> <div class="warning">
>
> **作业 03**
>
> 称一个正整数为完美 (perfect) 数，如果它等于自身所有因子 (不含自身) 的和
>
> 使用 List Comprehension，定义一个函数：
> ```shell
> perfects :: Int -> [Int]
> ```
> 该函数接收一个正整数 `n`，返回区间 `[1..n]` 中的所有完美数 (返回的序列按照从小到大的顺序排列)
>
> 例如：
> ```shell
> ghci> perfects 500
> [6, 28, 496]
> ```
>
> </div>

> <div class="warning">
>
> **作业 04**
>
> 对于两个长度为 `n` 的整数序列 `xs` `ys`，两者的的点积 (Scalar Product) 定义如下：
>
> \\[ \sum_{i=0}^{n-1} (xs[i] * ys[i])\\]
>
> 使用 List Comprehension，定义一个 “计算两个整数序列的点积” 的函数：
> </div>
