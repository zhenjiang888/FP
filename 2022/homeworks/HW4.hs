module HW4 where

-- Problem #1: What are the types of the following values?
val1 :: _
val1 = ['a', 'b', 'c']

val2 :: _
val2 = ('a', 'b', 'c')

val3 :: _
val3 = [(False, '0'), (True, '1')]

val4 :: _
val4 = ([False, True], ['0', '1'])

val5 :: _
val5 = [tail, init, reverse]
-- End Problem #1

-- Problem #2: What are the types of the following functions?
second :: _
second xs = head (tail xs)

swap :: _
swap (x, y) = (y, x)

pair :: _
pair x y = (x, y)

double :: _
double x = x * 2

palindrome :: _
palindrome xs = reverse xs == xs

twice :: _
twice f x = f (f x)
-- End Problem #2

-- Problem #3: Int/Integer，show/read
--   阅读教科书，用例子（在ghci上运行）
-- Part #3.1: 展示Int/Integer的区别
{- Manual #3.1

    请把你的答案填写在这里（可以考虑直接复制命令行窗口的内容）
  示例：
    Int和Integer的区别是……

    Prelude> 你输入的表达式
    GHCi返回的结果
-}
-- End Part #3.1

-- Part #3.2: show/read的用法
{- Manual #3.2

    请把你的答案填写在这里（可以考虑直接复制命令行窗口的内容）
  示例：
    Prelude> 你输入的表达式
    GHCi返回的结果

-}
-- End Part #3.2
-- End Problem #3

-- Problem #4: Integral/Fractional
--   阅读教科书以及Prelude模块的相关文档，理解 Integral 和 Fractional
-- 两个 Type Class 中定义的函数和运算符，用例子（在 GHCi 上运行）展示每
-- 一个函数/运算符的用法。

-- Part #4.1: Integral
{- Manual #4.1

    请把你的答案填写在这里（可以考虑直接复制命令行窗口的内容）
  示例：
    Prelude> 你输入的表达式
    GHCi返回的结果

-}
-- End Part #4.1

-- Part #4.2: Fractional
{- Manual #4.2

    请把你的答案填写在这里（可以考虑直接复制命令行窗口的内容）
  示例：
    Prelude> 你输入的表达式
    GHCi返回的结果

-}
-- End Part #4.2
-- End Problem #4
