module HW4 where

-- Problem #1: 补全下列值的类型签名
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

-- Problem #2: 补全下列函数的类型签名
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
-- Part #1: Int/Integer的区别
--   请把你的答案填写在这里（可以考虑直接复制命令行窗口的内容）
-- 示例：
--   Int和Integer的区别是……
--
--   Prelude> 你输入的表达式
--   GHCi返回的结果
-- End Part #1

-- Part #2: show/read的用法
--   请把你的答案填写在这里（可以考虑直接复制命令行窗口的内容）
-- 示例：
--   Prelude> 你输入的表达式
--   GHCi返回的结果
-- End Part #2
-- End Problem #3

-- Problem #4: Integral/Fractional
-- Part #1: Integral
--   请把你的答案填写在这里（可以考虑直接复制命令行窗口的内容）
-- 示例：
--   Prelude> 你输入的表达式
--   GHCi返回的结果
-- End Part #1

-- Part #2: Fractional
--   请把你的答案填写在这里（可以考虑直接复制命令行窗口的内容）
-- 示例：
--   Prelude> 你输入的表达式
--   GHCi返回的结果
-- End Part #2
-- End Problem #3
