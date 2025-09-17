# 第 02 章：初见函数式思维

### 01 两句很有哲理的话

- 工欲善其事，必先利其器。

- To a man with a hammer, everything looks like a nail.

> - 思维方式是一种工具；不能被思维方式束缚

### 02 “函数式思维” 是一种什么样的思维方式

- 使用 “数学中的函数” 作为 求解信息处理问题的基本成分。

- “使用方式” 包括：

  - 从零开始，定义一些基本函数

  - 把已有的函数组装起来，形成新的函数

### 03 简要回顾：数学中的函数

> **定义：** 函数 / Function
>
> 对任何两个集合`X`和`Y`，称两者之间的关系`f ⊆ X ✗ Y`是一个函数，当且仅当如下条件成立：
>
> - `∀ x ∈ X, ∃ (u, v) ∈ f, x = u`
> - `∀ (x, y) ∈ f, ∀ (u, v) ∈ f, x = u => y == v`
>
> > 也即：对`X`中的任何元素`x`，存在且仅存唯一一个元素`y ∈ Y`，满足`(x, y) ∈ f`

#### 函数相关的表示符号：

对任何两个集合`X`和`Y`，

- `X ✗ Y`
  - 一个集合，其定义为：`{ (x, y) | x ∈ X, y ∈ Y }`

  - 也称为集合 `X` 和 `Y` 的 **笛卡尔积**

- `X -> Y`
  - 一个集合，包含且仅包含所有从`X`到`Y`的函数

- `f : X -> Y`
  - 声明`f`是一个从`X`到`Y`的函数。也称：`f`是一个类型为`X -> Y`的函数

  - 称：`X`为`f`的**定义域** (Domain)；`Y`为`f`的**值域** (Codomain)

- `f(x)`

  - 函数`f`的定义域中元素`x`映射到的值域中的那个元素，

  - 显然可知：
    - `f(x) : Y`，也即：`f(x)`的类型为`Y`

    - `(x, f(x)) ∈ f`

#### 常用的集合及其表示符号：

> 在 Haskell 中，“类型” 和 “集合” 是同义词

- `ℕ`：自然数集合/类型

- `ℤ`：整数集合/类型

- `ℚ`：有理数集合/类型

- `ℝ`：实数集合/类型

- `𝔹 = { true, flse }`：布尔集合/类型。其中，

  - `true` 表示 “真”；`flse` 表示 “假”

  - 稍后给出 `𝔹` 的一种更为形式化的定义

> **定义：** 函数的组合 / Function Composition
>
> 对任何两个函数 `f : X -> Y`、`g : Y -> Z`，两者的组合，记为 `g * f`，是一个函数。
>
> 该函数的定义如下：
>
> ```haskell
> [ X Y Z : Set, f : X -> Y, g : Y -> Z ]
> def g * f : X -> Z = [x : X] g(f(x))
> ```
> 说明：
>
> - 上述定义不是采用 Haskell 语言书写的程序
>
> - 本章中出现的所有程序 (除了最后一个)，都不是 Haskell 程序
>   - 这些程序所采用的语法，来源于我们正在设计中的一种用于数学证明的语言

### 04 为什么在函数的基础上，可以形成一种思维方式

- 函数可以建模 **“变换”** 和 **“因果关系”**

  - 信息处理问题，本质上是一种信息的变换问题

  - 在面向特定领域问题的软件应用中，大量涉及对物理世界中因果关系的仿真

### 05 几个简单的函数

- **逻辑非**函数

  ```haskell
  def not : 𝔹 -> 𝔹 = [b] match b {
      true => flse,
      flse => true,
  }
  ```

- **逻辑与**函数

  ```haskell
  def and : (𝔹 ✗ 𝔹) -> 𝔹 = [p] match p {
      (true, true) => true,
      _            => flse,
  }
  ```

  另一种定义方式:

  ```haskell
  def and : 𝔹 -> 𝔹 -> 𝔹 = [l] [r] match (l, r) {
      (true, true) => true,
      _            => flse,
  }
  ```

- 为了定义关于自然数`ℕ`的函数，我们首先需要给出`ℕ`的定义

  ```haskell
  def ℕ : Type = {
      ctor zero : Self
      ctor succ : Self -> Self
  }
  ```

  这是一种递归定义，其含义如下：

  - `zero` 是 `ℕ` 中的一个元素

  - 如果 `n` 是 `ℕ` 中的一个元素，那么，`succ n` 也是`ℕ` 中的一个元素

  - `ctor` 是一个关键字 (Key Word)，其英文单词 “constructor” 的缩写

    - `ctor` 后面的那个元素是一个公理 (无需给出元素的定义)

      - 所谓公理，就是一个神秘存在

  > 为什么可以这样定义自然数呢？
  >
  > 因为在这种定义下，我们可以做出如下设定：
  > - `0 === zero`
  > - `1 === succ(zero)`
  > - `2 === succ(succ(zero))`
  > - `3 === succ(succ(succ(zero)))`
  > <br> <br>

  > **小和尚：**
  > - 这不就是上古传说中的 **“结绳记数”** 吗！
  >
  > **唐僧：**
  > - 思维真敏捷；真是一个值得教育的好孩子！
  >
  > **小和尚：**
  > - 但是，这么 low 的自然数定义，真的适合在北京大学的课堂上讲吗？
  >
  > **唐僧：**
  > - 我猜测，也许你的思维被你的高中数学老师囚禁在数学宇宙的一片荒漠中了
  >
  > - 采用类似的方式，我们也可以对`𝔹`给出形式化的定义
  >   ```haskell
  >   def 𝔹 : Type = {
  >       ctor flse : Self,
  >       ctor true : Self,
  >   }
  >   ```



- 自然数的**加法运算**

  ```haskell
  def plus : ℕ -> (ℕ -> ℕ) = [a] [b] match (a, b) {
      (m, zero)    => m,
      (m, succ(n)) => succ(plus(m)(n))
  }
  ```

  加法运算示例：

  ```haskell
      plus(3)(4)  -- 因为实在受不了“结绳记数”的自然数，所以局部回归人类世俗文明😅
  === plus(3)(succ(3))
  === succ(plus(3)(3))
  === succ(plus(3)(succ(2)))
  === succ(succ(plus(3)(2)))
  === succ(succ(plus(3)(succ 1)))
  === succ(succ(succ(plus(3)(1))))
  === succ(succ(succ(plus(3)(succ 0))))
  === succ(succ(succ(succ(plus(3)(0)))))
  === succ(succ(succ(succ(3))))
  === (succ * succ * succ * succ)(3)
  ```

  > 不要被上面这种看似复杂的定义所困扰。
  >
  > 它只不过用递归的方式定义了一件很简单的事情：
  >
  > ```haskell
  >   plus(m)(n) === (succ * succ * succ * ... * succ)(m)
  >                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  >                     "the composition of n succ"
  > ```

- 自然数的**乘法运算**

  ```haskell
  def mult : ℕ -> (ℕ -> ℕ) = [a] [b] match (a, b) {
      (m, zero)    => zero,
      (m, succ(n)) => plus(m)(mult(m)(n))
  }
  ```

  乘法运算示例：

  ```haskell
      mult(3)(4)
  === mult(3)(succ 3)
  === plus(3)(mult(3)(3))
  === plus(3)(mult(3)(succ 2))
  === plus(3)(plus(3)(mult(3)(2)))
  === plus(3)(plus(3)(mult(3)(succ 1)))
  === plus(3)(plus(3)(plus(3)(mult(3)(1))))
  === plus(3)(plus(3)(plus(3)(mult(3)(succ 0))))
  === plus(3)(plus(3)(plus(3)(plus(3)(mult(3)(0)))))
  === plus(3)(plus(3)(plus(3)(plus(3)(0))))
  === (plus(3) * plus(3) * plus(3) * plus(3))(0)
  ```

  > 不要被上面这种看似复杂的定义所困扰。
  >
  > 它只不过用递归的方式定义了一件很简单的事情：
  >
  > ```haskell
  >   mult(m)(n) === (plus(m) * plus(m) * ... * plus(m))(zero)
  >                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  >                    "the composition of n plus(m)"
  > ```

- 自然数的**指数运算**

  ```haskell
  def expn : ℕ -> (ℕ -> ℕ) = [a] [b] match (a, b) {
      (m, zero)    => succ(zero),
      (m, succ(n)) => mult(m)(expn(m)(n))
  }
  ```

  指数运算示例：

  ```haskell
      expn(3)(4)
  === expn(3)(succ 3)
  === mult(3)(expn(3)(3))
  === mult(3)(expn(3)(succ 2))
  === mult(3)(mult(3)(expn(3)(2)))
  === mult(3)(mult(3)(expn(3)(succ 1)))
  === mult(3)(mult(3)(mult(3)(expn(3)(1))))
  === mult(3)(mult(3)(mult(3)(expn(3)(succ 0))))
  === mult(3)(mult(3)(mult(3)(mult(3)(expn(3)(0)))))
  === mult(3)(mult(3)(mult(3)(mult(3)(1))))
  === (mult(3) * mult(3) * mult(3) * mult(3))(1)
  ```

  > 不要被上面这种看似复杂的定义所困扰。
  >
  > 它只不过用递归的方式定义了一件很简单的事情：
  >
  > ```haskell
  >   expn(m)(n) === (mult(m) * mult(m) * ... * mult(m))(succ(zero))
  >                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  >                    "the composition of n mult(m)"
  > ```

  > **小和尚：**
  > - 总是n个相同函数的组合；能不能有些新东西呢？
  >
  > **唐僧：**
  > - 何必让自己这么累；这样划水不挺好嘛！
  > <br> <br>

- **阶乘运算**

  ```haskell
  def fact : ℕ -> ℕ = [m] match m {
      zero    => succ(zero),
      succ(n) => mult(succ(n))(fact(n)),
  }
  ```

  > 不要被上面这种看似复杂的定义所困扰
  >
  > 它只不过用递归的方式定义了一件很简单的事情：
  >
  > ```haskell
  > fact(m) === (mult(m) * mult(m - 1) * ... * mult(1))(1)
  >             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  >                  "the composition of n mult(_)"
  > ```

  > **唐僧：** 看，是不是有那么一点点新东西了 😅

- **斐波那契函数**

  ```haskell
  def fib : ℕ -> ℕ = [m] match m {
      zero          => zero,
      succ(zero)    => succ(zero),
      succ(succ(n)) => plus(fib(n))(fib(succ n)),
  }
  ```

  斐波那契函数运算示例：
  ```haskell
      fib(5)
  === plus(fib(3))(fib(4))
  === plus(plus(fib(1))(fib(2)))(plus(fib(2))(fib(3)))
  === plus(plus(1)(plus(fib(0))(fib(1))))(plus(plus(fib(0))(fib(1)))(plus(fib(1))(fib(2))))
  === plus(plus(1)(plus(0)(1)))(plus(plus(0)(1))(plus(1)(plus(fib(0))(fib(1)))))
  === plus(plus(1)(plus(0)(1)))(plus(plus(0)(1))(plus(1)(plus(0)(1))))
  ```

  > **小和尚：** 这下好了，没有规律了。看你怎么圆过来 😜

### 06 自然数上的 fold 函数

- `plus` `mult` `expn` 这三个函数之间存在共性

- 这种共性可以被封装在一个函数中

  ```haskell
  [T : Type]
  def fold
  : (T -> T) -> (T -> (ℕ -> T))
  = [h : T -> T] [c : T] [m : ℕ] match m {
      zero   => c,
      succ n => h(fold(h)(c)(n))
    }
    ------ 引入一点语法糖 ------
  = [h : T -> T, c : T, m : ℕ] match m {
      zero   => c,
      succ n => h(fold(h)(c)(n))
    }
  ```

- 给定 `h : T -> T`, `c : T`，令 `f === fold(h)(c)`，则可知：
  - `f(zero) === c`

  - `f(succ n) === h(f(n))`

- 如果不理解这个定义的含义，请看如下解释：

  >
  > 给定一个自然数 `n`，可知：
  >
  > ```haskell
  >    n === (succ * succ * succ * ... * succ)(zero)
  >          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  >             "the composition of n succ"
  > ```

  > 已知 `f === fold(h)(c)`，则可知：
  >
  > ```haskell
  > f(n) === ( h   *   h   *  h  *  ... *  h )(c)
  >          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  >             "the composition of n h"
  > ```

  > 也即：
  > - `f(n)` 把 `n` 中的 `zero` 替换为 `c`，把每一个 `succ` 替换为 `h`
  >
  > - `n` 和 `f(n)` 是同构的，即：两者具有相同的结构
  >

- 使用 `fold` 函数，可以对 `plus` `mult` `expn` 这三个函数进行更深刻的定义

  ```haskell
  def plus : ℕ -> (ℕ -> ℕ) = [m] fold(succ)(m)

  def mult : ℕ -> (ℕ -> ℕ) = [m] fold(plus(m))(zero)

  def expn : ℕ -> (ℕ -> ℕ) = [m] fold(mult(m))(succ(zero))
  ```

  示例：
  ```haskell
                 ----the composition of n succ -----
    n        === (succ    * succ    * ... * succ   )(zero)
    |              |         |         |     |
  plus(m)(n) === (succ    * succ    * ... * succ   )(m)
    |              |         |         |     |
  mult(m)(n) === (plus(m) * plus(m) * ... * plus(m))(zero)
    |              |         |         |     |
  expn(m)(n) === (mult(m) * mult(m) * ... * mult(m))(succ(zero))

  ```

- 使用`fold`函数，也可以对 `fact` `fib` 这两个函数进行更深刻的定义

  首先引入两个辅助函数：

  ```haskell
  [A B : Type]
  def fst : A ✗ B -> A = [(a, b)] a

  [A B : Type]
  def snd : A ✗ B -> B = [(a, b)] b
  ```

  `fact`函数的定义：

  ```haskell
  def fact : ℕ -> ℕ = {
      def f
      : ℕ ✗ ℕ -> ℕ ✗ ℕ
      = [(m, n)] (m + 1, (m + 1) * n);

      ret snd * (fold(f)(0, 1));
  }
  ```

  ```haskell
                   ----the composition of n succ ----
    n     ===      ( succ  *  succ  *  ...  *  succ )(0)
    |                 |        |        |       |     |
  fact(n) === snd( (  f    *   f    *  ...  *   f   )(0, 1) )
  ```

  `fib`函数的定义：

  ```haskell
  def fib : ℕ -> ℕ = {
      def g
      : ℕ ✗ ℕ -> ℕ ✗ ℕ
      = [(m, n)] (n, m + n);

      ret fst * (fold(g)(0, 1));
  }
  ```

  ```haskell
                   ----the composition of n succ ----
    n     ===      ( succ  *  succ  *  ...  *  succ )(0)
    |                 |        |        |       |     |
  fib(n)  === fst( (  g    *   g    *  ...  *   g   )(0, 1) )
  ```

### 07 List 类型

- 在信息处理问题中，经常涉及一组按照某种顺序排列的数据；

  我们将这类数据用 List 类型进行表示。

  - 例如：对于排序问题

    - 待排序的数据通常采用 List 的方式进行输入

    - 排序的结果自然也以 List 的方式返回

- List 类型的定义

  ```haskell
  def List : Type -> Type = [A] {
      ctor nil  : Self,
      ctor (+>) : A -> Self -> Self,
  }
  ```

- List 类型的示例

   - `List(ℕ)`：自然数序列类型

   - `nil`：一个不包含任何元素的空序列

   - `1 +> nil`：仅包含 1 个元素 `1` 的自然数序列

   - `1 +> (2 +> (3 +> (4 +> nil)))`：包含 4 个元素 `1` `2` `3` `4` 的自然数序列

- List 类型相关的函数

  添加元素函数：

  ```haskell
  [T : Type]
  def cons
  : T -> (List(T) -> List(T))
  = [x, xs] x +> xs

  -- 这个函数就是把运算符 +> 进行了函数化
  ```

  长度函数：

  ```haskell
  [T : Type]
  def len
  : List(T) -> ℕ
  = [xs] match xs {
      nil     => 0,
      a +> yx => 1 + len(yx)
  }
  ```

  逆序函数：

  ```haskell
  [T : Type]
  def rev
  : List(T) -> List(T)
  = {
      def rev-memo
      : List(T) -> (List(T) -> List(T))
      = [xs, ys] match ys {
          nil     => xs,
          m +> ms => rev-memo(m +> xs)(ms),
      };

      ret rev-memo(nil);
  }
  ```

  序列拼接函数：

  ```haskell
  [T : Type]
  def concat
  : List(T) -> (List(T) -> List(T))
  = [xs, ys] match xs {
      nil     => ys,
      m +> ms => m +> (concat(ms)(ys)),
  }
  ```

  过滤函数：

  ```haskell
  [T : Type]
  def filter
  : (T -> 𝔹) -> (List(T) -> List(T))
  = [f, xs] match xs {
      nil     => nil,
      m +> ms => match f(m) {
          true => m +> filter(f)(ms),
          flse =>      filter(f)(ms),
      }
  }
  ```

### 08 List 上的 fold 函数

- 如果我的理解没有错误，在任何类型上都存在 fold 函数

  <div class="warning">

      这个观点待确认。
      数学上的事情，只要没有给出证明，都不能随意相信。
  </div>

- 无论如何，`List` 类型上存在 fold 函数，而且存在两个。

  我们将这两个函数分别命名为 `foldl` 和 `foldr`。
  - 其中的后缀 `l` 和 `r` 分别表示 `left` 和 `right`

- `foldr` 函数

  ```haskell
  [A B : Type]
  def foldr
  : (A -> (B -> B)) -> (B -> (List(A) -> B))
  = [h : A -> (B -> B), b : B, xs : List(A)] match xs {
      nil     => b,
      a +> ys => h(a)(foldr(h)(b)(ys))
  }
  ```

  > 如果不理解这个定义，请看如下解释：
  >
  > - 给定 `xs : List(A)`，不失一般性，令：
  >
  >   ```haskell
  >   xs    === xn  +>  xn-1  +>  ...  +>  x1  +>  nil
  >   ```
  >
  >   则可知：
  >
  >   ```haskell
  >   xs    === ( cons(xn) * cons(xn-1) * ... * cons(x1) )(nil)
  >   ```
  >
  > - 已知 `f === foldr(h)(b)`，则可知：
  >
  >   ```haskell
  >   f(xs) === (    h(xn) *    h(xn-1) * ... *    h(x1) )(b)
  >   ```
  > - 也即：
  >   - `f(xs)`把`xs`中的`nil`替换为`b`，把`xs`中的每一个`cons`替换为`h`
  >
  >   - `xs` 和 `f(xs)` 是同构的，即：两者具有相同的结构

- `foldl` 函数

  ```haskell
  [A B : Type]
  def foldl
  : (B -> (A -> B)) -> (B -> (List(A) -> B))
  = [h : B -> (A -> B), b : B, xs : List(A)] match xs {
      nil     => b,
      a +> ys => foldl(h)(h(b)(a))(ys),
  }
  ```

  > 如果不理解这个定义，请看如下解释：
  >
  > - 引入一个工具函数
  >
  >   ```haskell
  >   [A B C : Type]
  >   def flip
  >   : (A -> (B -> C)) -> (B -> (A -> C))
  >   = [f, b, a] f a b
  >   ```
  >
  > - 给定 `xs : List(A)`，不失一般性，令：
  >
  >   ```haskell
  >   xs    === xn  +>  xn-1  +>  ...  +>  x1  +>  nil
  >   ```
  >
  >   则可知：
  >
  >   ```haskell
  >   xs    === ( cons(xn) * cons(xn-1) * ... * cons(x1) )(nil)
  >   ```
  >
  > - 已知 `f === foldr(h)(b)`，令 `h' = flip(h)`，则可知：
  >
  >   ```haskell
  >   f(xs) === (   h'(x1) *   h'(x2)   * ... *   h'(xn) )(b)
  >   ```
  > - 也即：
  >   - `f(xs)`把`xs`中的`nil`替换为`b`，把`xs`中的每一个`cons`替换为`h'`
  >
  >   - 同时，还顺带逆序了一下
  >
  > - 但实际上，**并不存在一个显式的逆序环节**；更真实的计算过程如下
  >
  >   ```haskell
  >   f(xs) === b ≺ xn ≺ xn-1 ≺ ... ≺ x1 ≺ nil
  >   ```
  >   其中：运算符 `≺` 具有左结合性，且 `b ≺ a === h(b)(a)`

### 09 使用fold函数，重定义List相关的函数

- `len` 函数

  ```haskell
  [A : Type]
  def len
  : List(A) -> ℕ
  = {
      def h
      : A -> ℕ -> ℕ
      = [_, n] n + 1;

      ret foldr(h)(0)
  }
  ```

  > ```haskell
  >     xs  === ( cons(xn) * cons(xn-1) * ... * cons(x1) )(nil)
  > len(xs) === (    h(xn) *    h(xn-1) * ... *    h(x1) )(0)
  > ```

- `rev` 函数

  ```haskell
  [A : Type]
  def rev
  : List(A) -> List(A)
  = foldl(flip(cons))(nil)
  ```

- `concat` 函数

  ```haskell
  [A : Type]
  def concat
  : List(A) -> (List(A) -> List(A))
  = [xs, ys] foldr(cons)(ys)(xs)
  ```

- `filter` 函数

  ```haskell
  [A : Type]
  def filter
  : (A -> 𝔹) -> (List(A) -> List(A))
  = [f] {
      def h
      : (A -> 𝔹) -> (A -> (List(A) -> List(A)))
      = [f, a, xs] match f(a) {
          true => a +> xs,
          flse => xs,
      }

      ret foldr(h(f))(nil);
  }
  ```

  > ```haskell
  >           xs  === ( cons(xn) * cons(xn-1) * ... * cons(x1) )(nil)
  > filter(f)(xs) === ( h(f)(xn) * h(f)(xn-1) * ... * h(f)(x1) )(nil)
  > ```

### 10 一种排序算法

- 快速排序算法

  ```haskell
  def qsort
  : List(ℕ) -> List(ℕ)
  = [xs] match {
      nil     => nil,
      n +> ns => {
         def left = qsort(filter([m] m <  n)(ns));
         def rigt = qsort(filter([m] m >= n)(ns));

         ret concat(left)(n +> rigt);
      }
  }
  ```

  > **小和尚：**
  >
  > - 这段代码看起来还不错 👍
  >
  > **唐僧：**
  >
  > - 你的审美能力看起来也不错 👏
  >
  > - 可以让你看一下去年的形式：
  >   ```haskell
  >   qsort : List(ℕ) -> List(ℕ)
  >   qsort(nil) = nil
  >   qsort(n +> ns) = concat(concat(qsort(filter(lt(n))(ns)))([n]))(qsort(filter(ge(n))(ns)))
  >   where
  >       lt : ℕ -> (ℕ -> 𝔹)
  >       lt(n)(m) = if m < n then true else flse
  >
  >       ge : ℕ -> (ℕ -> 𝔹)
  >       ge(n)(m) = not(lt(n)(m))
  >   ```
  > **小和尚：**
  >
  > - 如果这就是用 FP 书写的算法，此生绝不学 FP！
  >
  > **唐僧：**
  >
  > - 好孩子，如果给你三生三世的财富，学否？
  >
  > **小和尚：**
  >
  > - 佛学工作者可是不能撒谎的哦！！！
  > <br> <br>

- **内容** 与 **形式**

  - 这是一个关于 “内容” 与 “形式” 两者之间关系的问题

    - 内容：对自然数序列进行排序的一种方法

    - 形式：表现这种排序方法的形式

  - 进一步而言，去年的程序存在的问题可以表述为：

    - “形式” 小于 “内容”: 内容是很好的，但形式实在是太糟糕了

  - 如果你能体会到这一点，你会发现：这个问题的严重程度并不像表面上看起来的那样

  - 为什么这么说呢？因为，本质（内容）毕竟还是很好的

- **重走长征路**

  - 在某种意义上，我们正在“重走长征路”

  - 在很多年以前，科研工作者们就已经意识到了这个问题
    - 即：函数式思维的 “形式” 小于 “内容”

  - 在这个问题的驱使下，他/她们设计了各种各样的函数式程序设计语言

  - 我们即将介绍的Haskell语言，就是这些函数式程序设计语言的集大成者

  - 不过，目前看来，Haskell 语言正在老去：**一鲸落，万物生！**

    - 例如，本章中程序的语法，就是在 Haskell 语言的基础上改良形成的


### 11 剧透：采用 Haskell 语言编写的 qsort 算法

```haskell
qsort :: Ord a => [a] -> [a]
qsort []     	= []
qsort (p:xs)	= qsort lt ++ [p] ++ qsort ge
  where
    lt = filter (<  p) xs
    ge = filter (>= p) xs
```

### 本章作业

> <div class="warning">
>
>   本章没有作业。
>
>   但是，你需要想清楚：这门课是否适合你。
> </div>
