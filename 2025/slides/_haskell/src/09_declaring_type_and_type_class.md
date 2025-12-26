# 第 09 章：声明类型和类簇

### 01 类型别名的声明

在 Haskell 中，可以通过 `type` 关键字为一个已经存在的类型声明一个 **别名**。

```haskell
type String = [Char]
```
其中：
- `[Char]` 是一个已经存在的类型，而 `String` 仅仅是它的一个别名

- 所谓 “别名”，就是另一个名称，或者称为 **同义词**

引入别名的主要目的：为一个已经存在的类型赋予更明确的含义：

```haskell
type Position = (Int, Int)
```
- 原本的类型 `(Int, Int)` 本身并没有 “位置” 这种专有含义

- 通过将其命名为 `Position`，可以更直接地明确 “用二元组表示二维位置” 的含义

  ```haskell
  origin :: Position
  origin = (0, 0)

  left :: Position -> Position
  left (x, y) = (x - 1, y)
  ```

  <br>

  别名声明，也可以具有参数。

  ```haskell
  type Pair a = (a, a)

  mult :: Pair Int -> Int
  mult (m, n)  =  m * n

  copy :: a -> Pair a
  copy x  =  (x, x)
  ```

  <br>

  在声明一个别名时，在等号 `=` 的右侧可以出现已经定义的其他别名

  ```haskell
  type Position = (Int, Int)
  type Trans = Position -> Position
  ```

  <br>

  但是，别名不支持递归定义。因此，下述定义会产生编译错误：

  ```haskell
  type Tree = (Int, [Tree])
  ```
  - 即便这种定义成立，类型为 `Tree` 的元素似乎也有些无聊

### 02 类型的声明

在 Haskell 中，可以通过 `data` 关键字声明新的类型。

```haskell
data Bool = False | True
```
- `Bool` 一个新定义的类型，它具有两个值：`False` `True`

  - `Bool` 是一个平凡 (trivial) 的 **Type Constructor**

  - `False` 和 `True` 是两个平凡 (trivial) 的 **Data Constructor**

  - 这里的 **平凡** (trivial)，指的是没有参数
    - 马上就会看到带有参数的 Type/Data Constructor

- 在 Haskell 中，Type/Data Constructor 的标识符的首字符必须是大写字母

> 使用 “初见函数式思维” 一章中引入的那种语言，上述 `Bool` 类型定义为
> ```python
> def Bool : Type = {
>     ctor False : Self
>     ctor True  : Self
> }
> ```
> 注意：
> - 关键字 `ctor` 是英文单词 constructor 的缩写

<br>

自定义的类型和值，其使用方式与标准库中定义的类型和值 **完全相同**

```haskell
data Answer  =  Yes | No | Unknown

answers :: [Answer]
answers  =  [Yes, No, Unknown]

flip :: Answer -> Answer
flip Yes     = No
flip No      = Yes
flip Unknown = Unknown
```

<br>

Data Constructor 可以具有参数。

```haskell
data Shape = Circle Float | Rect Float Float

square :: Float -> Shape
square n  =  Rect n n

area :: Shape -> Float
area (Circle r)  =  pi * r * r
area (Rect x y)  =  x * y
```

> 使用 “初见函数式思维” 一章中引入的那种语言，上述 `Shape` 类型定义为
> ```python
> def Shape : Type = {
>     ctor Circle : Float -> Self
>     ctor Rect   : Float -> Float -> Self
> }
> ```
> 更为神奇的是，在 Haskell 中：
>
> - 你确实可以把 `Circle` 视为一个类型为 `Float -> Shape` 的函数
>
> - 你确实可以把 `Rect` 视为一个类型为 `Float -> Float -> Shape` 的函数
>
> 如果你不相信，可以写程序测试一下。

有参数的 Data Constructor 才是一种 非平凡 (non-trivial) 的 Data Constructor。

<br>

Type Constructor 也可以具有参数。

```haskell
data Maybe a = Nothing | Just a

safediv :: Int -> Int -> Maybe Int
safediv _ 0 = Nothing
safediv m n = Just $ div m n

safehead :: [a] -> Maybe a
safehead [] = Nothing
safehead xs = Just $ head xs
```

> 使用 “初见函数式思维” 一章中引入的那种语言，上述 `Maybe` 定义为
> ```python
> def Maybe : Type -> Type = [T] {
>     ctor Nothing : Self
>     ctor Just    : T -> Self
> }
> ```

有参数的 Type Constructor 才是一种 非平凡 (non-trivial) 的 Type Constructor。


### 03 递归类型

在 Haskell 中，新的类型可以通过自身进行递归定义。例如：

```haskell
data Nat = Zero | Succ Nat
```
- `Nat` 是一个新的类型，它具有两个 Data Constructor:
  ```haskell
  Zero :: Nat
  ```
  ```haskell
  Succ :: Nat -> Nat
  ```
- 也即，类型 `Nat` 的值，或者是 `Zero`，或者具有形式 `Succ n` (其中, `n :: Nat`)

- 也即，`Nat` 具有如下无穷多个值
  - `Zero`, `Succ Zero`, `Succ (Succ Zero)`, `Succ (Succ (Succ Zero))`, ...

- 我们可以将 `Nat` 视为 **自然数**；其中

  - `Zero` 表示 `0`

  - `Succ` 表示函数 `(1 + )`

- 例如：

  - `Succ $ Succ $ Succ Zero` 表示自然数 `(1+) $ (1+) $ (1+) Zero === 3`

  > **小和尚：**
  > - 这不就是 “结绳计数” 吗？
  >
  > **唐僧：**
  > - 确实如此
  >
  > - 不过，我们研究的是自然数的本质，而不是自然数的表现形式
  >
  >   - 我们熟悉的自然数，其实是自然数的一种表现形式：即，十进制表现形式
  >
  >   - 这种表现形式 (十进制) 过于复杂：与本质相比，有点喧宾夺主的感觉


```haskell
data Nat = Zero | Succ Nat
```
- 使用递归，可以方便地实现 `Nat` 与 `Int` 两者之间的相互转换

  ```haskell
  nat2int :: Nat -> Int
  nat2int Zero     = 0
  nat2int (Succ n) = 1 + nat2int n

  int2nat :: Int -> Nat
  int2nat 0 = Zero
  int2nat n = Succ $ int2nat $ n - 1
  -- 注意：当把 int2nat 做用到一个负数上，就出大问题了
  ```

- 自然数的加法：定义一 (以 `Int` 为媒介)

  ```haskell
  add :: Nat -> Nat -> Nat
  add m n = int2nat $ nat2int m + nat2int n
  ```

- 自然数的加法：定义一 (直接定义)

  ```haskell
  add :: Nat -> Nat -> Nat
  add Zero     n = n
  add (Succ m) n = Succ $ add m n
  ```

  或者

  ```haskell
  add :: Nat -> Nat -> Nat
  add m Zero     = m
  add m (Succ n) = Succ $ add m n
  ```

### 04 示例：用于表示算术运算表达式的类型

考虑一种简单的算术运算表达式：由整数、加法、乘法形成的算术表达式。

<p><center>
    <img src="image/arith_expr.png"
         width="30%"/>
</center></p>

我们可以定义一种类型，用于表示这种算法运算表达式；也即：

- 这种类型的一个值，一定表示了一个算术运算表达式

- 这样的一个表达式，可以表示为这种类型的一个值

<br>

```haskell
data Expr = Val Int | Add Expr Expr | Mul Expr Expr
```
- 注意：这个类型具有三个 Data Constructor

  - `Val :: Int -> Expr`

  - `Add :: Expr -> Expr -> Expr`

  - `Mul :: Expr -> Expr -> Expr`

- 例如：`1 + (2 * 3)` 被表示为 `Add (Val 1) (Mul (Val 2) (Val 3))`

  > 如果你再给出如下定义：
  >
  > ```haskell
  > (⊕) :: Expr -> Expr -> Expr
  > (⊕) = Add
  >
  > (⊗) :: Expr -> Expr -> Expr
  > (⊗) = Mul
  > ```
  > 那么：`1 + (2 * 3)` 可以表示为 `Val 1 ⊕ (Val 2 ⊗ Val 3)`
  >
  > 如前所述：`Add` 和 `Mul` 这两个 Data Constructor 确实是函数

<br>

利用递归，我们可以定义作用在 `Expr` 上的各种函数：

```haskell
data Expr = Val Int | Add Expr Expr | Mul Expr Expr

size :: Expr -> Int
size (Val n)   = 1
size (Add x y) = size x + size y
size (Mul x y) = size x + size y

eval :: Expr -> Int
eval (Val n)   = n
eval (Add x y) = eval x + eval y
eval (Mul x y) = eval x * eval y
```

<br>

对于类型 `Expr`，是否存在一个相应的 `fold` 函数呢？

- 如果你对 `Natural` 和 `List` 上的 `fold` 函数有深刻理解，那么，这是一件相对简单的事情

  - 即，把这三个 Data Constructor 替换为恰当的函数

<br>

不妨将 `Expr` 上的 `fold` 函数命名为 `folde`。可知，其类型如下：

```haskell
folde :: (Int -> a) -> (a -> a -> a) -> (a -> a -> a) -> Expr -> a
```
> 如何定义该函数，是本章的一个作业题

<br>

基于 `folde`，可以对刚才定义的两个函数 `size` 和 `eval` 进行重新定义：

<table><tbody>

<tr>

<td>

```haskell
size :: Expr -> Int
size (Val n)   = 1
size (Add x y) = size x + size y
size (Mul x y) = size x + size y
```

</td>

<td>

```haskell
size :: Expr -> Int
size = folde (\x -> 1) (+) (+)
```

</td>

</tr>

<tr>

<td>

```haskell
eval :: Expr -> Int
eval (Val n)   = n
eval (Add x y) = eval x + eval y
eval (Mul x y) = eval x * eval y
```

</td>

<td>

```haskell
eval :: Expr -> Int
eval = folde id (+) (*)
```

</td>

</tr>

</tbody></table>


### 05 newtype 声明

如果：一个类型仅具有一个 Data Constructor，且 这个 Data Constructor 仅具有一个参数，

那么：可以使用 newtype 对这种类型进行声明。

例如：

```haskell
newtype Nat = N Int
```

相比较另外两种定义方式，上述定义既具有更高的运行效率，还具有更好的类型安全性：

- `data Nat = N Int`：运行效率低

  - Int 值总是被包裹在 `N` 这样一个盒子里；每次想要获得 Int 值，必须首先打开盒子

  - 反之，`newtype Nat = N Int` 中的 `N` 会被编译器优化掉，因此不存在运行时成本

- `type Nat = Int`：类型安全性差

  - 可能会把一个负数误用为自然数

  - 反之，`N Int` 这种语法，强制要求程序员写出 `N`，从而提醒他/她后面千万不能放负数

> 这是一种实现上的细节。你需要在理解了 Haskell 的类型在内存中的 Representation 和 Layout 后，可能才会明白 `newtype` 的效果。


### 06 类簇及其实例的声明

声明一个类簇：

```haskell
class Eq a where
    (==), (/=) :: a -> a -> Bool
    x /= y = not (x == y)
    x == y = not (x /= y)
    {-# MINIMAL (==) | (/=) #-}
    -- 请自己课后确认一下：上面这一行代码，仅仅是注释，还是一种特殊的声明语句
```
这种声明的含义：

- 如果类型 `a` 想要成为类簇 `Eq` 实例，那么，它必须支持 `Eq` 中声明的两个运算符 `==` `/=`

声明类型是类簇的实例：

```haskell
instance Eq Bool where
  False == False =  True
  True  == True  =  True
  _     == _     =  False
```
- 只有通过 `data` 和 `newtype` 声明的类型，才能够成为类簇的实例

- 类簇中声明的缺省实现，可以在实例声明时被覆盖

类簇之间可以存在扩展关系：即，一个类簇在另一个类簇的基础上进行扩展

```haskell
class  (Eq a) => Ord a  where
    compare              :: a -> a -> Ordering
    (<), (<=), (>), (>=) :: a -> a -> Bool
    max, min             :: a -> a -> a

    compare x y = if x == y then EQ
                  -- NB: must be '<=' not '<' to validate the
                  -- claim about the minimal things that
                  -- can be defined for an instance of Ord:
                  else if x <= y then LT
                  else GT

    x <= y = case compare x y of { GT -> False; _ -> True }
    x >= y = y <= x
    x > y = not (x <= y)
    x < y = not (y <= x)

    -- These two default methods use '<=' rather than 'compare'
    -- because the latter is often more expensive
    max x y = if x <= y then y else x
    min x y = if x <= y then x else y
    {-# MINIMAL compare | (<=) #-}
```
```haskell
data Ordering = LT | EQ | GT
```

```haskell
instance Ord Bool where
   False <= _    = True
   True  <= True = True
   _     <= _    = False
```

<br>

#### 声明自动成为内置类簇的实例

在定义一个新的类型时，可以通过 `deriving` 声明，将该类型自动成为指定内置类簇的实例。

```haskell
data Bool = False | True deriving (Eq, Ord, Show, Read)
```

```shell
ghci> False < True
True

ghci> False == True
False
```

> **小和尚：**
> - 这样太帅了吧！
>
> **唐僧：**
>
> - 注意到 `deriving` 声明的限制：它只适用于标准库内置的类簇，不适用于自定义的类簇
>
> - 编译器在背后帮我们生成了所需的代码

### 07 示例：重言检查器 / Tautology Checker

> **目标问题：**
>
> - 设计一个算法，检查一个 **命题公式** (Propositional Formula) 是否总是为真。

以下是 4 个命题公式的示例：

1. `A ∧ ¬A`

2. `(A ∧ B) => A`

3. `A => (A ∧ B)`

4. `(A ∧ (A => B)) => B`

> **求解方法：** 查看命题公式的真值表，判断是否所有结果都为真

以下是三个操作 (`not`, `and`, `imply`) 对应的真值表：

<table><tbody>

<tr>

<td>

|  A  |  ¬A |
|-----|-----|
|  F  |  T  |
|  T  |  F  |

</td>

<td>

|  A  |  B  | A ∧ B |
|-----|-----|-------|
|  F  |  F  |   F   |
|  F  |  T  |   F   |
|  T  |  F  |   F   |
|  T  |  T  |   T   |

</td>

<td>

|  A  |  B  | A => B|
|-----|-----|-------|
|  F  |  F  |   T   |
|  F  |  T  |   T   |
|  T  |  F  |   F   |
|  T  |  T  |   T   |

</td>

</tr>

</tbody></table>

下面，我们依次列出上面四个命题公式对应的真值表：

|  A  |  ¬A | A ∧ ¬A|
|-----|-----|-------|
|  F  |  T  |   F   |
|  T  |  F  |   F   |

<br>

|  A  |  B  | (A ∧ B) => A|
|-----|-----|-------|
|  F  |  F  |   T   |
|  F  |  T  |   T   |
|  T  |  F  |   T   |
|  T  |  T  |   T   |

<br>

|  A  |  B  | A => (A ∧ B) |
|-----|-----|-------|
|  F  |  F  |   T   |
|  F  |  T  |   T   |
|  T  |  F  |   F   |
|  T  |  T  |   T   |

<br>

|  A  |  B  | (A ∧ (A => B)) => B |
|-----|-----|-------|
|  F  |  F  |   T   |
|  F  |  T  |   T   |
|  T  |  F  |   T   |
|  T  |  T  |   T   |

可以看到，在上面四个命题公式中，有两个重言式：`(A ∧ B) => A`，`(A ∧ (A => B)) => B`

<br>

下面，我们给出重言式检查算法的设计过程：

<br>

**第一步：** 定义一个用于表示命题公式的类型

```haskell
data Prop = Cst   Bool
          | Var   Char
          | Not   Prop
          | And   Prop Prop
          | Imply Prop Prop

```

则，上述四个命题公式可以表示为：

```haskell
-- 1.  A ∧ ¬A
p1 = And (Var 'A') (Not (Var 'A'))

-- 2.  (A ∧ B) => A
p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')

-- 3.  A => (A ∧ B)
p3 = Imply (Var 'A') (And (Var 'A') (Var 'B'))

-- 4.  (A ∧ (A => B)) => B
p4 = Imply (And (Var 'A') (Imply (Var 'A') (Var 'B'))) (Var 'B')
```

<br>

**第二步：** 定义函数 `vars :: Prop -> [Char]`，计算一个命题公式中的变量

```haskell
vars :: Prop -> [Char]
vars (Cst _)     = []
vars (Var x)     = [x]
vars (Not p)     = vars p
vars (And p q)   = vars p ++ vars q
vars (Imply p q) = vars p ++ vars q
```
```shell
ghci> var p4
"AABB"
```

<br>

**第三步：** 定义一个类型，用于表达命题变量 与 真-假值 之间的 绑定/置换 关系

```haskell
type Assoc k v = [(k, v)]
type Subst = Assoc Char Bool

-- example
subst :: Subset
subst = [ ('A' ,True),  ('B', False) ]
```

<br>

**第四步：** 定义函数 `bools :: Int -> [[Bool]]`，用于生成 `n` 个 `Bool` 值所有可能的排列

```haskell
bools :: Int -> [[Bool]]
bools 0 = [[]]
bools n = map (False :) bss ++ map (True :) bss
    where bss = bools $ n - 1
```
```shell
ghci> bools 2
[[False,False],[False,True],[True,False],[True,True]]
```

<br>

**第五步：** 定义函数 `varSubsts :: [Char] -> [Subst]`；
- 该函数接收一组命题变量，生成对这些变量所有可能的赋值/置换方式

```haskell
varSubsts :: [Char] -> [Subst]
varSubsts vs = map (zip vs) (bools $ length vs)
```

```shell
ghci> varSubsts "AB"
[ [('A',False),('B',False)],
  [('A',False),('B',True)],
  [('A',True),('B',False)],
  [('A',True),('B',True)] ]
```

**第六步：** 定义函数 eval :: Subst -> Prop -> Bool
- 该函数接收一个置换表和一个命题公式，评估这个命题公式的值

```haskell
eval :: Subst -> Prop -> Bool
eval _ (Cst b)     = b
eval s (Var x)     = find x s
eval s (Not p)     = not (eval s p)
eval s (And p q)   = eval s p  &&  eval s q
eval s (Imply p q) = eval s p  <=  eval s q
                            -- ^^ 注意：这里出现了一件很有趣的事情
```

**第七步：** 定义函数 isTaut :: Prop -> Bool，判断一个命题公式是否是一个重言式

```haskell
isTaut :: Prop -> Bool
isTaut p = and [eval s p | s <- varSubsts vs]
     where  vs = rmdups (vars p)
```

```shell
ghci> isTaut p1
False

ghci> isTaut p2
True

ghci> isTaut p3
False

ghci> isTaut p4
True
```

### 08 示例：抽象机器 / Abstract Machine

我们可以定义一个表示 “算术运算表达式” 的类型，然后定义一个评估函数，对一个表达式进行求值：

```haskell
data Expr = Val Int | Add Expr Expr

value :: Expr -> Int
value (Val n)    = n
value (Add x y)  = value x + value y
```

<br>

例如，对于表达式 `(2 + 3) + 4`，其求值过程如下：

```haskell
    value (Add (Add (Val 2) (Val 3)) (Val 4))
=== { applying value }
    value (Add (Val 2) (Val 3))  +  value (Val 4)
=== { applying the first value }
    (value (Val 2)  +  value (Val 3))  +  value (Val 4)
=== { applying the first value}
    (2  +  value (Val 3))  +  value (Val 4)
=== { applying the first value}
    (2  +  3)  +  value (Val 4)
=== { applying the first + }
    5  +  value (Val 4)
=== { applying value }
    5  +  4
=== { applying + }
    9
```

注意：

- 在类型声明中，我们并未指定表达式求值的详细步骤

- Haskell 编译器在背后帮我们做了很多的事情

<br>

**一个问题：** 可以自定义表达式的求值步骤吗？

下面是一个解决方案：

```haskell
data Expr = Val Int | Add Expr Expr

value :: Expr -> Int
value e = eval e []

data Op   = EVAL Expr | ADD Int  -- 两种操作
type Cont = [Op]                 -- 操作序列

eval :: Expr -> Cont -> Int
eval (Add x y) c = eval x $ EVAL y : c
  -- 把对表达式 Add x y 的评估拆成两个部分: eval x 和 EVAL y。后者放入操作序列的头部
eval (Val n  ) c = exec c n

exec :: Cont -> Int -> Int
exec []           n = n
exec (EVAL y : c) n = eval y $ ADD n : c
exec (ADD  n : c) m = exec c $ n + m
```
<br>

对于表达式 (2 + 3) + 4，其求值过程如下：

```haskell
    value (Add (Add (Val 2)       (Val 3))       (Val 4))
=== eval  (Add (Add (Val 2)       (Val 3))       (Val 4)) []
=== eval       (Add (Val 2)       (Val 3)) [EVAL (Val 4)]
=== eval            (Val 2) [EVAL (Val 3),  EVAL (Val 4)]
=== exec                    [EVAL (Val 3),  EVAL (Val 4)] 2
=== eval (Val 3) [ADD 2, EVAL (Val 4)]
=== exec         [ADD 2, EVAL (Val 4)] 3
=== exec                [EVAL (Val 4)]     (2 + 3)
=== eval                      (Val 4) [ADD (2 + 3)]
=== exec                              [ADD (2 + 3)]  4
=== exec []                                (2 + 3) + 4
=== (2 + 3) + 4
```

## 本章作业

> <div class="warning">
>
> **作业 01**
>
> 使用递归和函数 `add :: Nat -> Nat -> Nat`，定义自然数 `Nat` 上的乘法运算
>
> </div>

> <div class="warning">
>
> **作业 02**
>
> 给出函数 `folde` 的完整定义，并给出该函数的若干使用案例
>
> </div>

> <div class="warning">
>
> **作业 03**
>
> 定一个二叉树类型 `Tree a`，其中：
>
> - 叶节点的 Constructor 名为`Leaf`，它构造出只包含一个`a`类型值的二叉树
>
> - 非叶节点的 Constructor 名为`Node`，它构造出一个包含两个二叉树的二叉树
>
> </div>
