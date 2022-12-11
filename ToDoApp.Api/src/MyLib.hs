module MyLib (someFunc) where

someFunc :: IO ()
someFunc = putStrLn $ show add

add :: Int -> Int -> Int
add x y = x + y
