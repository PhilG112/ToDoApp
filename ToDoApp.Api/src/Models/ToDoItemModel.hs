{-# LANGUAGE DeriveGeneric #-}
module Models.ToDoItemModel (ToDoItem(..)) where

import Data.Time ( Day )
import GHC.Generics (Generic)

data ToDoItem = ToDoItem {
    description :: String,
    id :: Int,
    dateComplete :: Day,
    isDone :: Bool
} deriving (Eq, Show, Generic, Ord)