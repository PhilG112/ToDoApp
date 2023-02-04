module Main where

import Criterion
import Criterion.Main

fib = fastFib 1 1

fastFib _ _ 0 = 0
fastFib _ _ 1 = 1
fastFib _ _ 2 = 1
fastFib a b 3 = a + b
fastFib a b c = fastFib (a + b) a (c - 1)

slowFib m
    | m < 0 = error "negative"
    | otherwise = go m
    where
        go 0 = 0
        go 1 = 1
        go n = go (n-1) + go (n-2)

main :: IO ()
main = defaultMain [
    bgroup "fastFibB" [ bench "20" $ whnf fib 1],
    bgroup "slowFib" [ bench "20" $ whnf slowFib 1 ]
    ]
