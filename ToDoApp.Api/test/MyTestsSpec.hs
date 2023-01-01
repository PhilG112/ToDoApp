module MyTestsSpec (spec) where

import Test.Hspec

spec :: Spec
spec = do
    let square x = x * x :: Int

    describe "strip" $ do

        it "Test one" $
            square 4 `shouldBe` 16

        it "Test one2" $
            square 4 `shouldBe` 16
    
    describe "strip2" $ do
        it "Test 3" $
            square 10 `shouldBe` 100
