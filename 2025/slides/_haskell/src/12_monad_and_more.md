# 第 12 章：Monad and More

> 主要知识点：`Functor` | `Applicative` | `Monad`

### 01 提升代码抽象层次的两种方式

**方式一：** 对类型进行抽象 => 多态函数 (Polymorphic Function)

例如：

```haskell
length1 :: [a] -> Int
```
- `a` 是一个类型变量

<br>

**方式二：** 对 Type Constructor 进行抽象 => 范型函数 (Generic Function)

例如：

```haskell
length2 :: t a -> Int
```
- `t` 是一个表示 Type Constructor 的变量

### 02 Functor (函子)

#### 计算的抽象

<table><tbody>
<tr>
<td>

```haskell
inc :: [Int] -> [Int]
inc []     = []
inc (n:ns) = n + 1 : inc ns
```

</td>

<td>

```haskell
sqr :: [Int] -> [Int]
sqr []      = []
sqr (n:ns) = n^2 : sqr ns
```

</td>
</tr>
</tbody></table>

上述两个函数中的共性成分可以被表示为一个高阶函数：

```haskell
map :: (a -> b) -> [a] -> [b]
map f []      = []
map f (x:xs) = f x : map f xs
```
在此基础上，上述两个函数可以被改写为：

<table><tbody>
<tr>
<td>

```haskell
inc :: [Int] -> [Int]
inc = map ( + 1)
```

</td>

<td>

```haskell
sqr :: [Int] -> [Int]
sqr = fmap ( ^ 2)
```

</td>
</tr>
</tbody></table>

注意到：

- 在 Haskell 中，类型 `[a]` 也可以被写为 `[] a`。

- 也即：`[]` 是一个 Type Constructor

  - 它接收一个类型作为参数，返回/构造一个新的类型

  > 可以将 `[]` 的类型 “理解为” `Type -> Type`
  >
  > - 注意：`Type` 不是 Haskell 中的一个类型；因此，仅仅是 “理解为”
  >
  > 更严格而言，应该用如下方式理解 `[]`
  > - `ctor [] :: Type -> Type`
  > <br><br>

<br>

Functor 的目的：

- 把适用于 `[]` 的 `map` 函数推广到任何一个与 `[]` 具有相同类型的 Type Constructor

#### Functor 的定义

```haskell
-- Exported by Prelude
class Functor f where

   fmap :: (a -> b) -> f a -> f b

   (<$) :: b -> f a -> f b
   (<$)  =  fmap . const

const :: b -> a -> b
const x _  =  x
```
- `f`：一个表示 Type Constructor 的变量

  - 不是所有的 Type Constructor 都可以被 `f` 抽象

  - 只有类型为 `Type -> Type` 的 Type Constructor 才可以被 `f` 抽象

  - “`f` 只能具有一个参数” 的限制，在 `fmap` 的类型中可以被观察到

- 如果你看不懂 `<$` 的定义，我们再捋一捋

  ```haskell
      x <$ y
  === (fmap . const) x y
  === fmap (const x) y
  === fmap (\_ -> x) y
  ```

#### 把 Type Constructor 声明为 Functor 的实例

```haskell
-- Exported by Prelude
instance Functor [] where
   fmap :: (a -> b) -> [a] -> [b]
   fmap = map
```

```haskell
ghci> fmap (+1) [1, 2, 3]
[2, 3, 4]

ghci> fmap (^2) [1, 2, 3]
[1, 4, 9]
```

<br>

```haskell
data Maybe a  =  Nothing | Just a

instance Functor Maybe where
    fmap :: (a -> b) -> Maybe a -> Maybe b
    fmap _ Nothing  =  Nothing
    fmap g (Just x) =  Just $ g x
```

```haskell
ghci> fmap (+1) (Just 3)
Just 4

ghci> fmap (+1) Nothing
Nothing

ghci> fmap not (Just False)
Just True
```

<br>

```haskell
data Tree a = Leaf a | Node (Tree a) (Tree a) deriving (Show)

instance Functor Tree where
    fmap :: (a -> b) -> Tree a -> Tree b
    fmap g (Leaf x)   = Leaf $ g x
    fmap g (Node l r) = Node (fmap g l) (fmap g r)
```

```haskell
ghci> fmap length $ Leaf "abc"
Leaf 3

ghci> fmap even $ Node (Leaf 1) (Leaf 2)
Node (Leaf False) (Leaf True)
```

<br>

```haskell
instance Functor IO where
    fmap :: (a -> b) -> IO a -> IO b
    fmap g mx = do
        x <- mx
        return $ g x
```
```haskell
ghci> fmap show $ return True
"True"
```

#### 定义 Generic Function

```haskell
inc :: Functor f => f Int -> f Int
inc = fmap (+1)
```

```haskell
ghci> inc $ Just 1
Just 2

ghci> inc [1,2,3,4,5]
[2,3,4,5,6]

ghci> inc $ Node (Leaf 1) (Leaf 2)
Node (Leaf 2) (Leaf 3)
```

#### Functor Laws

任何一个 Functor 的实例，都必须满足如下两个性质：

1. `fmap id` === `id`

2. `fmap (f . g)` === `fmap f . fmap g`

> 在 Haskell 中，任何一个类型为 `Type -> Type` 的 Type Constructor，最多只有一个满足上述性质 `fmap` 函数
> - 也即，如果一个 Type Constructor 能够成为 Functor 的实例，那么，只有唯一一种实现方式

> **唐僧：**
>
> - 如果你想要知道 “为什么要求上述命题成立”，那么，我只能忽悠你去学习 “范畴论”
>
>   - 如果你面临物质上的压力，那最好还是放弃；因为，目前看来，不是热点，赚不到钱

> 暂时不要尝试去理解 Functor Laws 的本质
>
> - 在没有学习过 “范畴论” 的情况下，所有的理解大概都可以归类为 “盲人摸象”

#### fmap 对应的运算符

```haskell
-- Exported by Prelude
(<$>) :: Functor f => (a -> b) -> f a -> f b
(<$>) = fmap
```
- 运算符 `<$>` 可以类比到运算符 `$`
  ```haskell
  ($)   ::              (a -> b) ->   a ->   b
  (<$>) :: Functor f => (a -> b) -> f a -> f b
  ```

### 03 Applicative Functor (简称为 Applicative)

#### 如何定义一个一般性的 fmap

```haskell
fmap0 :: a -> f a
```
```haskell
fmap1 :: (a -> b) -> f a -> f b
```
```haskell
fmap2 :: (a -> b -> c) -> f a -> f b -> f c
```
```haskell
fmap3 :: (a -> b -> c -> d) -> f a -> f b -> f c -> f d
```
```haskell
...
```

#### 两个基本函数

```haskell
pure :: a -> f a
```

```haskell
(<*>) :: f (a -> b) -> f a -> f b
```

在这两个函数的基础上，就可以定义任何一个一般性的 fmap

```haskell
fmap0 :: a -> f a
fmap0  =  pure

fmap1 :: (a -> b) -> f a -> f b
fmap1 g x  =  pure g <*> x
-- 或者
fmap1 g x  =  fmap g x  =  g <$> x

fmap2 :: (a -> b -> c) -> f a -> f b -> f c
fmap2 g x y  =  pure g <*> x <*> y  =  g <$> x <*> y

fmap3 :: (a -> b -> c -> d) -> f a -> f b -> fc -> f d
fmap3 g x y z = pure g <*> x <*> y <*> z = g <$> x <*> y <*> z
```

#### Applicative 的定义 (一个简化版本)

```haskell
class Functor f => Applicative f where
    -- Lift a value
    pure :: a -> f a

    -- Sequential application.
    (<*>) :: f (a -> b) -> f a -> f b
```

#### 把 Type Constructor 声明为 Applicative 的实例

```haskell
instance Applicative Maybe where
    pure :: a -> Maybe a
    pure = Just

    (<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
    Nothing  <*> _   = Nothing
    (Just g) <*> mx  = g <$> mx
```

```haskell
ghci> pure (+1) <*> Just 1
Just 2

ghci> pure (+) <*> Just 1 <*> Just 2
Just 3

ghci> pure (+) <*> Nothing <*> Just 2
Nothing

ghci> Nothing <*> Just 1
Nothing
```

<br>

```haskell
instance Applicative [] where
    pure :: a -> [a]
    pure x = [x]

    (<*>) :: [a -> b] -> [a] -> [b]
    gs <*> xs = [g x | g <- gs, x <- xs]
```

```haskell
ghci> pure (+1) <*> [1,2,3]
[2,3,4]

ghci> pure (+) <*> [1] <*> [2]
[3]

ghci> pure (*) <*> [1,2] <*> [3,4]
[3,4,6,8]
```

<br>

```haskell
instance Applicative IO where
    pure :: a -> IO a
    pure = return

    (<*>) :: IO (a -> b) -> IO a -> IO b
    mg <*> mx = do { g <- mg; x <- mx; return (g x) }
```

```haskell
getChars :: Int -> IO String
getChars 0 = return []
getChars n = pure (:) <*> getChar <*> getChars (n-1)
```
<br>

#### 定义 Generic Function

```haskell
sequenceA :: Applicative f => [f a] -> f [a]
sequenceA []     =  pure []
sequenceA (x:xs) =  pure (:) <*> x <*> sequenceA xs
```

```shell
ghci> sequenceA [Just 1, Just 2, Just 3]
Just [1,2,3]
```
```haskell
    sequenceA [Just 1, Just 2, Just 3]
=== sequenceA ((Just 1):[Just 2, Just 3])
=== pure (:) <*> Just 1 <*> sequenceA [Just 2, Just 3]
=== Just (:) <*> Just 1 <*> sequenceA [Just 2, Just 3]
=== Just (1:) <*> sequenceA [Just 2, Just 3]
=== Just (1:) <*> sequenceA ((Just 2):[Just 3])
=== Just (1:) <*> (pure (:) <*> Just 2 <*> sequenceA [Just 3])
=== Just (1:) <*> (Just (2:) <*> sequenceA ((Just 3):[]))
=== Just (1:) <*> (Just (2:) <*> (pure (:) <*> Just 3 <*> sequenceA [])
=== Just (1:) <*> (Just (2:) <*> (Just (3:) <*> sequenceA [])
=== Just (1:) <*> (Just (2:) <*> (Just (3:) <*> pure [])
=== Just (1:) <*> (Just (2:) <*> (Just (3:) <*> Just [])
=== Just (1:) <*> (Just (2:) <*> (Just (3:[]))
=== Just (1:) <*> (Just (2:3:[]))
=== Just (1:2:3:[])
=== Just [1, 2, 3]
```

```shell
ghci> sequenceA [Just 1, Nothing, Just 3]
Nothing
```
```haskell
    sequenceA [Just 1, Nothing, Just 3]
=== sequenceA (Just 1):[Nothing, Just 3]
=== pure (:) <*> Just 1 <*> sequenceA [Nothing, Just 3]
=== pure (1:)           <*> sequenceA (Nothing:[Just 3])
=== pure (1:)           <*> (pure (:) <*> Nothing <*> sequenceA [Just 3])
=== pure (1:)           <*> (Just (:) <*> Nothing <*> sequenceA [Just 3])
=== pure (1:)           <*> (     (:) <$> Nothing <*> sequenceA [Just 3])
=== pure (1:)           <*> (             Nothing <*> sequenceA [Just 3])
=== pure (1:)           <*> (             Nothing)
=== Just (1:)           <*>               Nothing
===      (1:)           <$>               Nothing
=== Nothing
```

> **唐僧：**
> - 当 `sequenceA :: Applicative f => [f a] -> f [a]` 中的 `f` 是 `Maybe` 时，
> - 你能观察到 `sequenceA` 的效果吗？
>
> **小和尚：**
> - 观察不到；愿闻其详
>
> **唐僧：**
> - 把 `Maybe` 视为一种可能存在失败的计算活动
>
>   - 当失败时，返回 `Nothing`；当成功时，返回 `Just _`
>
> - 把 `sequenceA [x, y, z]` 视为顺序执行一组可能存在失败的计算活动 `x, y, z`
>
>   - 若在执行一个计算活动时发生失败，则终止后续的计算活动，直接返回 `Nothing`
>
>   - 否则，将所有计算结果存储为序列 `rsts = [r1, r2, r3]`，并返回 `Just rsts`
>
> **小和尚：**
> - 这种效果是刻意设计出来的吗？
>
> **唐僧：**
> - 感觉不是
>
> - 更像是背后的数学结构天然具有的性质
>
>   - 如同我们所生活的物理空间天然存在的物理规律一样
>
>   - 我们只是观察者，而不是设计者

<br>

```shell
ghci> sequenceA [[1,2,3], [4,5,6], [7,8,9]]
[[1,4,7],[1,4,8],[1,4,9],[1,5,7],[1,5,8],[1,5,9],[1,6,7],[1,6,8],[1,6,9],
 [2,4,7],[2,4,8],[2,4,9],[2,5,7],[2,5,8],[2,5,9],[2,6,7],[2,6,8],[2,6,9],
 [3,4,7],[3,4,8],[3,4,9],[3,5,7],[3,5,8],[3,5,9],[3,6,7],[3,6,8],[3,6,9]]
```

> **唐僧：**
> - 当 `sequenceA :: Applicative f => [f a] -> f [a]` 中的 `f` 是 `[]` 时，
> - 你能观察到 `sequenceA` 的效果吗？
>
> **小和尚：**
> - 我观察到了；非常感谢 🤝

#### Applicative Laws

任何一个 Applicative Functor 的实例，都必须满足如下性质：

> 如上所述，暂时不要去理解这些 Laws 的本质
> - 但不妨碍我们做一点简单的类型分析

1. `pure id <*> x` === `x`

    - 若 `id :: a -> a`，则 `x :: f a`

      > 记当前的 Applicative 实例为 `f` (下同)

2. `pure (g x)` === `pure g <*> pure x`

   - 若 `x :: a`，则 `g :: a -> b`，`pure (g x) :: f b`

3. `x <*> pure y` === `pure (\g -> g y) <*> x`

   - 若 `y :: a`，则 `x :: f (a -> b)`，`pure (\g -> g y) :: f ((a -> b) -> b)`

4. `x <*> (y <*> z)` === `(pure (.) <*> x <*> y) <*> z`

   - 若 `z :: f a`，则 `y :: f (a -> b)`，`x :: f (b -> c)`，

   - 且 `pure (.) <*> x <*> y :: f (a -> c)`


### 04 Monad

#### 一个小问题：异常处理

```haskell
data Expr = Val Int | Div Expr Expr

eval :: Expr -> Int
eval (Val n)   = n
eval (Div x y) = eval x `div` eval y
```
```shell
ghci> eval $ Div (Val 1) (Val 0)
** Exception: divide by zero
```

#### 解决方法一 (稍显繁琐)

```haskell
safediv :: Int -> Int -> Maybe Int
safediv _ 0 = Nothing
safediv n m = Just (n `div` m)

eval :: Expr -> Maybe Int
eval (Val n)   = Just n
eval (Div x y) = case eval x of
    Nothing -> Nothing
    Just n  -> case eval y of
        Nothing -> Nothing
        Just m  -> safediv n m
```

#### 解决方法二 (仍然不够简洁)

先给出一个存在类型错误的版本：
```haskell
eval :: Expr -> Maybe Int
eval (Val n)   = pure n
eval (Div x y) = pure safediv <*> eval x <*> eval y
--               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--                  类型错误：Maybe (Maybe Int)
```

改正上面的类型错误：
```haskell
eval :: Expr -> Maybe Int
eval (Val n)   = pure n
eval (Div x y) = case pure safediv <*> eval x <*> eval y of
    Just r  -> r
    Nothing -> Nothing
```

#### 解决方法三 (引入一个新的操作 bind)

```haskell
(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
mx >>= f = case mx of
    Nothing -> Nothing
    Just x  -> f x
```

```haskell
eval :: Expr -> Maybe Int      --   Maybe Int
eval (Val n)   = Just n        --   ∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨
eval (Div x y) = eval x >>= (\n -> (eval y >>= (\m -> safediv n m)))
--               ^^^^^^       ^     ^^^^^^       ^    ^^^^^^^^^^^
--               Maybe Int    Int   Maybe Int    Int  Maybe Int
```

可以看到：
- 上面程序的最后一行中的圆括号全部都可以去除 (不会引起歧义)
```haskell
eval :: Expr -> Maybe Int
eval (Val n)   = Just n
eval (Div x y) = eval x >>= \n -> eval y >>= \m -> safediv n m
```

#### do 到底是什么？

下面，我们通过两步变换，向同学们展示一个非常肤浅的世纪大骗局！

```shell
第一步：先耍一些朝三暮四的小把戏
```
```haskell
eval :: Expr -> Maybe Int
eval (Val n)   = Just n
eval (Div x y) = eval x >>= \n ->
                 eval y >>= \m ->
                 safediv n m
```

<br>

```shell
第二步：再撒一点扑朔迷离的语法糖
```
```haskell
eval :: Expr -> Maybe Int
eval (Val n)   = Just n
eval (Div x y) = do n <- eval x
                    m <- eval y
                    safediv n m
```

> **唐僧：**
>
> - 是的，这就是我们在前面看到的神神秘秘、犹抱琵琶半遮面的 `do` 语法的本质
>
> **小和尚：**
>
> - 这种无聊的形式上的变换，真的适合在大学课堂上讲授吗？
>
> **唐僧：**
>
> - 千万不能有这种 “看似深刻、其实肤浅” 的想法哟！
>
> - 数学上的任何一个定理，何尝又非如此呢！
>   - 定理的结论，仅仅是前提中信息的一种等价变换，并没有增加任何新的信息

#### Prelude 中 Monad 的定义

```haskell
{- The "Monad" class defines the basic operations over a "monad",
   a concept from a branch of mathematics known as "category theory".
   From the perspective of a Haskell programmer, however,
   it is best to think of a monad as an "abstract datatype of actions".
   Haskell's "do" provide a convenient syntax for writing monadic expressions.
-}
class Applicative m => Monad m where
    -- Sequentially compose two actions, passing any value produced
    -- by the first as an argument to the second.
    (>>=) :: m a -> (a -> m b) -> m b

    -- 表达式 ma >>= mb 等价于如下 do 表达式：
    --   do a <- ma
    --      mb a

    -- Sequentially compose two actions, discarding any value produced
    -- by the first, like sequencing operators (such as the semicolon)
    -- in imperative languages.
    (>>) :: m a -> m b -> m b
    m >> k = m >>= \_ -> k

    -- 表达式 ma >> mb 等价于如下 do 表达式：
    --   do ma
    --      mb

    -- Inject a value into the monadic type.
    -- This function should not be different from its default implementation
    -- as 'pure'. The justification for the existence of this function is
    -- merely historic.
    return :: a -> m a
    return = pure
```

把注释删除后，Monad 的定义很简单：

```haskell
class Applicative m => Monad m where
    (>>=) :: m a -> (a -> m b) -> m b

    (>>) :: m a -> m b -> m b
    m >> k = m >>= \_ -> k

    return :: a -> m a
    return = pure
```
- Monad 要求实现的三个方法中，两个已经有缺省实现

- 因此，要把一个 Type Constructor 声明为 Monad 的实例，仅需实现方法 `(>>=)`

#### 把 Type Constructor 声明为 Monad 的实例

```haskell
instance Monad Maybe where
    -- (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
    Nothing  >>= _ = Nothing
    (Just x) >>= f = f x
```

```haskell
instance Monad [] where
    -- (>>=) :: [a] -> (a -> [b]) -> [b]
    xs >>= f = [y | x <- xs, y <- f x]
```

### 05 案例：The State Monad

#### 目标问题：如何用函数描述状态的变化

我们可以将待表达的状态建模为一个 **类型**。

例如，假如这个状态可以建模为类型 `Int`，那么，可以将状态表示为如下形式：

```haskell
type State = Int
```
> 注意：
> - 你可以根据实际需求，将任何一种类型作为 `State`
>
> - 这里将 `Int` 作为 `State`，仅仅是一种举例

<br>

然后，状态的变化可以表示为如下类型：

```haskell
type StateTrans = State -> State
```

<br>

发生状态变化时，有可能会附带一个计算结果。OK，我们把计算结果也表示出来：

```haskell
type StateTrans a = State -> (a, State)
```
- 称 `StateTrans` 为 “状态变换器”

<br>

如前所述，Haskell 不支持将类型别名 (即，用关键字 `type` 声明的类型) 声明为类簇的实例。

OK, 我们来主动适应你：用 `newtype` 重新定义 `StateTrans`。

```haskell
newtype StateTrans a = ST (State -> (a, State))
```
注意：

- `StateTrans` 是一个 Type Constructor，其类型可以理解为 `Type -> Type`

  - 因此，有可能将 `StateTrans` 声明为 `Functor` `Applicative` `Monad` 的实例

- `ST` 是一个 Data Constructor，其类型为 `(State -> (a, State)) -> StateTrans a`

<br>

然后，我们可以定义一个函数 `app`：将一个状态变换器应用到一个状态上。

```haskell
app :: StateTrans a -> State -> (a, State)
app (ST f) s = f s
```
或者更简洁：
```haskell
app :: StateTrans a -> State -> (a, State)
app (ST f) = f
```
> 看起来，把 `app` 命名为 `unwrap` 也挺好的

<br>

#### 将 StateTrans 声明为 Functor 的实例

```haskell
instance Functor StateTrans where
 -- fmap :: (a -> b) -> StateTrans a -> StateTrans b
    fmap g st = ST $ \s -> let (x, s') = app st s in (g x, s')
```

```shell
       ┌──────────────────────────────────────────────┐
       │         fmap g st :: StateTrans b            │
       │   ┌────────────────────┐           ┌─────┐   │
       │   │                    │==> x ====>│  g  │==>│==> g x
       │   │ st :: StateTrans a │           └─────┘   │
  s ==>│==>│                    │==> s' =============>│==> s'
       │   └────────────────────┘                     │
       └──────────────────────────────────────────────┘
```

<br>

#### 将 StateTrans 声明为 Applicative 的实例

```haskell
instance Applicative ST where
 -- pure :: a -> StateTrans a
    pure x = ST $ \s -> (x, s)

    -- (<*>) :: StateTrans (a -> b) -> StateTrans a -> StateTrans b
    stf <*> stx = ST $ \s -> let (f, s' ) = app stf s
                                 (x, s'') = app stx s'
                             in (f x, s'')

```

```shell
       ┌──────────────────────────┐
       │                          │==> x
       │  pure x :: StateTrans a  │
  s ==>│                          │==> s
       └──────────────────────────┘
```

```shell
       ┌────────────────────────────────────────────────────┐
       │             stf <*> stx :: StateTrans b            │
       │   ┌───────┐                              ┌─────┐   │
       │   │       │==> f =======================>│     │==>│==> f x
       │   │       │          ┌───────┐           │  $  │   │
       │   │       │          │       │==> x ====>│     │   │
       │   │       │          │       │           └─────┘   │
  s ==>│==>│  stf  │==> s' ==>│  stx  │==> s'' ============>│==> s''
       │   └───────┘          └───────┘                     │
       └────────────────────────────────────────────────────┘
```

<br>

#### 将 StateTrans 声明为 Monad 的实例

```haskell
instance Monad ST where
    -- (>>=) :: StateTrans a -> (a -> StateTrans b) -> StateTrans b
    st >>= f = ST $ \s -> let (x, s') = app st s
                          in app (f x) s'
```

```shell
       ┌────────────────────────────────────────┐
       │        st >>= f :: StateTrans b        │
       │   ┌──────┐         ┌───────┐           │
       │   │      │==> x ==>│   f   ╞═══╗       │
       │   │      │         └───────┘   ⇓       │
       │   │      │                 ┌───╨───┐   │
       │   │      │                 │       │==>│==> _ :: b
       │   │      │                 │  f x  │   │
  s ==>│==>│  st  │==> s' =========>│       │==>│==> _ :: State
       │   └──────┘                 └───────┘   │
       └────────────────────────────────────────┘
```

<br>

<p><center>
    <img src="image/the_state_monad.png"/>
</center></p>

### 06 The State Monad 应用示例：树的重新标注

#### 目标问题

给定如下表示二叉树的一种类型：

```haskell
data Tree a = Leaf a | Node (Tree a) (Tree a) deriving Show

tree :: Tree Char
tree = Node (Node (Leaf 'a') (Leaf 'b')) (Leaf 'c')
```

定义一个函数 `relabel :: Tree a -> Tree Int`：
- 将树中叶子节点中包含的元素映射为一个唯一的整数编号。例如：

  ```haskell
  ghci> relabel tree
  Node (Node (Leaf 0) (Leaf 1)) (Leaf 2)
  ```

#### 解决方法一：直观朴素法

```haskell
rlabel :: Tree a -> Int -> (Tree Int, Int)
rlabel (Leaf _  ) n = (Leaf n, n+1)
rlabel (Node l r) n = (Node l' r', n'') where
    (l', n' ) = rlabel l n
    (r', n'') = rlabel r n'

relabel :: Tree a -> Tree Int
relabel t = fst (rlabel t 0)
```
缺点：
- `rlabel` 的定义中，需要显式维护中间状态


#### 解决方法二：Applicative

```haskell
fresh :: StateTrans Int
fresh = ST $ \n -> (n, n + 1)  -- 将状态从 n 变换为 n + 1, 同时返回计算结果 n

alabel :: Tree a -> StateTrans (Tree Int)

                 -- :: Int -> Tree Int
                 -- ↓↓↓↓
alabel (Leaf _)   = Leaf <$> fresh
                 --          ↑↑↑↑↑
                 --          :: StateTrans Int

                 -- :: Tree Int -> Tree Int -> Tree Int
                 -- ┊┊┊┊     :: StateTrans (Tree Int)
                 -- ┊┊┊┊     ┊┊┊┊┊┊┊┊     :: StateTrans (Tree Int)
                 -- ↓↓↓↓     ↓↓↓↓↓↓↓↓     ↓↓↓↓↓↓↓↓
alabel (Node l r) = Node <$> alabel l <*> alabel r
                 -- ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                 -- :: StateTrans (Tree Int -> Tree Int)

relabel' :: Tree a -> Tree Int
relabel' t = fst $ app (alabel t) 0
```

> **唐僧：**
>
> - 我时常在想，这些东西是永恒的吗？
>
> - 如果是，那么，它们栖身何处，以至可以被人类发现并表达？


#### 解决方法三：Monad

```haskell
mlabel :: Tree a -> StateTrans (Tree Int)

                 -- :: StateTrans Int
                 -- ┊┊┊┊┊           :: StateTrans (Tree Int)
                 -- ↓↓↓↓↓           ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
mlabel (Leaf _)   = fresh >>= \n -> return $ Leaf n
                 --           ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                 --           :: Int -> StateTrans (Tree Int)

mlabel (Node l r) = mlabel l >>= \l' ->
                    mlabel r >>= \r' -> return $ Node l' r'
                 -- ↑↑↑↑↑↑↑↑     ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                 -- ┊┊┊┊┊┊┊┊     :: Tree Int -> StateTrans (Tree Int)
                 -- :: StateTrans (Tree Int)
                 -- ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                 -- :: StateTrans (Tree Int)

relabel'' :: Tree a -> Tree Int
relabel''  t = fst $ app (mlabel t) 0
```

可以使用 `do` 语法对 `mlabel` 进行改写：

```haskell
mlabel (Leaf _  ) = do n <- fresh
                       return $ Leaf n
mlabel (Node l r) = do l' <- mlabel l
                       r' <- mlabel r
                       return $ Node l' r'
```

### 07 Monad Laws

> ```haskell
> class Applicative m => Monad m where
>     (>>=) :: m a -> (a -> m b) -> m b
>
>     (>>) :: m a -> m b -> m b
>     m >> k = m >>= \_ -> k
>
>     return :: a -> m a
>     return = pure
> ```

任何一个 Monad 的实例，都必须满足如下性质：

1. Left identity (左单位律)

   ```haskell
   -- :: m a       :: a -> m b
   -- ↓↓↓↓↓↓↓↓     ↓
      return x >>= h  ===  h x
   --                      ↑↑↑
   --                      :: m b
   ```


2. Right identity (右单位律)

   ```haskell
   -- :: m a :: a -> m a
   -- ↓↓     ↓↓↓↓↓↓
      mx >>= return  ===  mx
   --                     ↑↑
   --                     :: m a
   ```

3. Associativity (结合律)

   ```haskell
   --  :: m a
   --  ┊┊     :: a -> m b
   --  ┊┊     ┊      :: b -> m c      :: a :: m c
   --  ↓↓     ↓      ↓                ↓    ↓↓↓↓↓↓↓↓↓
      (mx >>= g) >>= h  ===  mx >>= (\x -> g x >>= h)
   --  ↑↑↑↑↑↑↑↑                      ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
   --  :: m b                        :: a -> m c
   ```

   > **小和尚：**
   >
   > - 这里的三个性质，怎么与通常的 `单位律` 和 `结合律` 不太一样呢？
   >
   > - 例如，对于加运算，它的性质可以描述如下：
   >
   >   - 左单位律：`0 + x === x`
   >
   >   - 右单位律：`x + 0 === x`
   >
   >   - 结合律：`(x + y) + z === x + (y + z)`
   >
   > **唐僧：**
   >
   > - 你的直觉是对的
   >
   > - 下面，我们用一些朝三暮四的小把戏，把 Monad Laws 变换到更规整的形式上

   <br>

   在 `Control.Monad` 模块中，定义了一个运算符 `>=>`：

   ```haskell
   -- The monad-composition operator
   -- defined in Control.Monad
   (>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)

   --          :: a :: m b  :: b -> m c
   --          ↓    ↓↓↓     ↓
   f >=> g  = \x -> f x >>= g
   --               ↑↑↑↑↑↑↑↑↑
   --               :: m c
   ```

   - 官方称其为 “the monad-composition operator”

   - 因其形状像一条小鱼，所以也被称为 “the fish operator”

<br>

#### Left identity

```haskell
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
f >=> g  = \x -> f x >>= g
```

```haskell
              return x >>= h      ===  h x
<==>         (return x >>= h)     ===  h x
<==>  (\y -> (return y >>= h)) x  ===  h x
<==>  (       return   >=> h ) x  ===  h x
<==>  (       return   >=> h )    ===  h
<==>          return   >=> h      ===  h
```

> `return` 是 `>=>` 运算的左单位元

<br>

#### Right identity

```haskell
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
f >=> g  = \x -> f x >>= g
```

```haskell
            mx  >>= return     ===  mx
<==>        f x >>= return     ===  f x
<==> (\y -> f y >>= return) x  ===  f x
<==> (      f   >>= return) x  ===  f x
<==> (      f   >>= return)    ===  f
<==>        f   >>= return     ===  f
```

> `return` 是 `>=>` 运算的右单位元

<br>

#### Associativity

```haskell
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
f >=> g  = \x -> f x >>= g
```

```haskell
            (      my  >>= g)   >>= h    ===        my  >>= (\y -> g y >>= h)
<==>        (      f x >>= g)   >>= h    ===        f x >>= (\y -> g y >>= h)
<==>        (      f x >>= g)   >>= h    ===        f x >>= (      g   >=> h)
<==>        (\u -> f u >>= g) x >>= h    ===        f x >>= (      g   >=> h)
<==>        (      f   >=> g) x >>= h    ===        f x >>= (      g   >=> h)
<==> (\u -> (      f   >=> g) u >>= h) x === (\u -> f u >>= (      g   >=> h)) x
<==> (\u -> (      f   >=> g) u >>= h)   === (\u -> f u >>= (      g   >=> h))
<==> (      (      f   >=> g)   >=> h)   === (      f   >=> (      g   >=> h))
```

> `>=>` 运算满足交换律

> **唐僧：**
> - 我时常再想，“朝三暮四” 是一个贬义词吗？

### 08 Monad Laws 在实践中的价值

```haskell
    do { x' <- return x; f x' }
===  return x >>= \x' -> f x'
===  return x >>=        f  -- 根据 left identity law, 可知:
===  f x
=== do { f x }
```

<br>

```haskell
    do {     x <- mx; return x }
===      mx >>= \x -> return x
===      mx >>=       return x -- 根据 right identity law, 可知:
===      mx
=== do { mx }
```

<br>

```haskell
    do { y <- do { x <- mx;  f x };          g y }
===           do { x <- mx;  f x } >>= \y -> g y
===           (mx >>=  \x -> f x ) >>= \y -> g y
===           (mx >>=        f   ) >>=       g  -- 根据 associativity law, 可知:
===            mx >>= (\x -> f x   >>=       g)
=== do { x <- mx;  do { y <- f x;            g y} }
=== do { x <- mx;       y <- f x;            g y  }
```

<br>

```haskell
skip_and_get = do unused <- getLine
                  line   <- getLine
                  return line
```
根据 right identity law，可知：

```haskell
skip_and_get = do unused <- getLine
                  getLine
```

<br>

```haskell
main = do answer <- skip_and_get
          putStrLn answer
```
把 skip_and_get 的定义代入：

```haskell
main = do answer <- do { unused <- getLine;
                         getLine }
          putStrLn answer
```
根据 associativity law，可知：

```haskell
main = do unused <- getLine
          answer <- getLine
          putStrLn answer
```
<br>

> **这些 law 根本不是什么约束，而是天然就应该存在的**

### 09 Monad as Computation

给定 monad `M`，可将类型 `M a` 的一个值 “理解为” 一种计算，且计算结果是若干类型为 `a` 的值

<br>

对于类型为 `a` 任何一个值 `x`，存在一种 “do nothing” 的计算，它只是简单地返回 `x`：

```haskell
return :: (Monad m) => a -> m a
```

<br>

对于任何一对计算 `mx :: m a` 和 `my :: m b`，存在对两者的一种顺序组合：

```haskell
(>>) :: (Monad m) => m a -> m b -> m b
```
- 在这种顺序组合中，第一步的计算结果会被抛弃

<br>

存在一种 “根据第一步的计算结果决定第二步的计算” 的组合计算：

```haskell
(>>=) :: (Monad m) => m a -> (a -> m b) -> m b
```
- `mx >>= f :: m b`

  - 在这个组合计算中，首先计算 `mx`，然后根据计算结果 `x` 确定下一步计算 `f x`

例如：

```haskell
main :: IO ()
main = getLine >>= putStrLn
```
```haskell
main :: IO ()
main = putStrLn "Enter a line of text:"
         >> getLine >>= \x -> putStrLn (reverse x)
```

<br>

在更一般的场景中，通过 `>>` 和 `>>=`，可能会形成非常长的计算链条。

为了让这种长计算链条在形式上更简洁，Haskell 提供了 `do` 语法。

例如，上面的程序可以改写为如下形式：

```haskell
main :: IO ()
main = do
    putStrLn "Enter a line of text:"
    x <- getLine
    putStrLn (reverse x)
```

> **`do` 与 `>>` `>>=` 的相互变换**
>
> ```haskell
> do { x } === x
> ````
>
> ```haskell
>     do { x ;  <stmts> }
> === x >> do { <stmts> }
> ```
>
> ```haskell
>     do { v <- x ;    <stmts> }
> === x >>= \v -> do { <stmts> }
> ```
>
> ```haskell
>     do { let <decls> ;  <stmts> }
> === let <delcs> in do { <stmts> }
> ```

<br>

#### `>>` 与 `>>=` 不仅仅是顺序组合

- 上面的解释，将 `>>` 与 `>>=` 描述为计算的顺序组合

- 但真实情况并非如此：

  - `>>` 与 `>>=` 的真实组合行为由具体的 monad 实例确定

  - 在不同的 monad 实例上，`>>` 与 `>>=` 可能会表现出截然不同的组合行为

<br>

#### Control.Monad 中的若干示例

```haskell
sequence :: (Monad m) => [m a] -> m [a]
sequence []     = return []
sequence (x:xs) = do
    v  <- x
    vs <- sequence xs
    return (v:vs)

main = sequence [getLine, getLine] >>= print
```

<br>

```haskell
forM :: (Monad m) => [a] -> (a -> m b) -> m [b]
forM xs f = sequence $ map f xs

main = forM [1..10] $ \x -> do
    putStr "Looping: "
    print x
```

<br>

```haskell
when :: (Monad m) => Bool -> m () -> m ()
when p mx = if p then mx else return ()
```

### 10 课堂练习

#### 练习 01

给定如下的树结构 (数据存放在非叶子节点中)：

```haskell
data Tree a = Leaf | Node (Tree a) a (Tree a) deriving (Show)
```
将它声明为 `Functor` 的一个实例：

```haskell
instance Functor Tree where
 -- fmap :: (a -> b) -> Tree a -> Tree b

    fmap g Leaf = Leaf
    fmap g (Node l x r) = Node (fmap g l) (g x) (fmap g r)
```

#### 练习 02

在 Haskell 中，给定两个类型 `X` `Y`，运算符 `->` 可以构造出一个新的类型 `X -> Y`。因此：

```haskell
ctor (->) : Type -> Type -> Type
```

而且，在 Haskell 中，`X -> Y` 确实可以被等价地写为 `(->) X Y`

> 显然可知：`(->)` 不可能成为 `Functor` 的实例。
>
> 但是：`(->) a` 有可能成为 `Functor` 的实例；因为 `ctor (->) a :: Type -> Type`

请将 `(->) a` 声明为 `Functor` 的实例：

```haskell
instance Functor ((->) a) where
 -- fmap :: (a -> b) -> f a -> f b  // 这里的 a 与 上面的 a 重名了；因此，改名
 -- fmap :: (b -> c) -> f b -> f c
 -- fmap :: (b -> c) -> (->) a b -> (->) a c
 -- fmap :: (b -> c) -> (a -> b) -> (a -> c)

    fmap = (.)
```

#### 练习 03

请将 `(->) a` 声明为 `Applicative` 的实例：

```haskell
instance Applicative ((->) a) where
 -- pure :: a -> f a
 -- pure :: b -> f b
 -- pure :: b -> a -> b
    pure = const

 -- (<*>) :: f (a -> b) -> f a -> f b
 -- (<*>) :: f (b -> c) -> f b -> f c
 -- (<*>) :: (a -> b -> c) -> (a -> b) -> (a -> c)
  g <*> h = \x -> g x $ h x
```

## 本章作业

> <div class="warning">
>
> **作业 01**
>
> 请将 `(->) a` 声明为 `Monad` 的实例：
>
> </div>

> <div class="warning">
>
> **作业 02**
>
> 给定如下类型定义：
>
> ```haskell
> data Expr a = Var a | Val Int | Add (Expr a) (Expr a)
>               deriving Show
> ```
>
> 1. 请将 `Expr` 声明为 `Functor` `Applicative` `Monad` 的实例
>
> 2. 通过一个示例，解释 `Expr` 上的操作 `>>=` 的行为
>
> </div>
