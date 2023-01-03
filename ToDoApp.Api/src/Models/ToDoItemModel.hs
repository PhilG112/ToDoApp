{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE InstanceSigs #-}

module Models.ToDoItemModel (ToDoItem(..)) where

import Data.Time ( Day )
import GHC.Generics (Generic)
import Data.Aeson ( ToJSON, FromJSON )
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.ToRow (ToRow(..))
import Control.Monad.Reader (ReaderT)

data ToDoItem = ToDoItem {
    id :: Maybe Int,
    description :: String,
    isDone :: Bool,
    dateCreated :: Day,
    dateCompleted :: Day
} deriving (ToJSON, FromJSON, Eq, Show, Generic, Ord, FromRow)

instance ToRow ToDoItem where
    toRow :: ToDoItem -> [Action]
    toRow u = [toField (description u), toField (isDone u), toField (dateCompleted u), toField (dateCreated u)]


