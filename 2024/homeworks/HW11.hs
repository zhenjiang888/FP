module HW11 where

import           Prelude hiding (Maybe (..))

-- Problem #1: Extend the expression parser
newtype Parser a = P { parse :: String -> [(a,String)] }

eval :: String -> Int
eval = fst . head . parse expr

expr :: Parser Int
expr = _
-- End Problem #1
