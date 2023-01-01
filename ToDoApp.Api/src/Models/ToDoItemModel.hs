{-# LANGUAGE DeriveGeneric #-}
module Models.ToDoItemModel (ToDoItem(..)) where

import Data.Time ( Day )
import GHC.Generics (Generic)

data ToDoItem = ToDoItem {
    id :: Int,
    description :: String,
    isDone :: Bool,
    dateCreated :: Day,
    dateComplete :: Day
} deriving (Eq, Show, Generic, Ord)