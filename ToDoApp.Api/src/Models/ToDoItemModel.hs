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
} deriving ( ToJSON -- ^ Automatically serialize to JSON in requests
           , FromJSON -- ^ Automatically deserialize from JSON from requests
           , Eq -- ^ Default 'EQ' instance
           , Show -- ^ Default 'Show' instance
           , Generic -- ^ Allow the compiler to provide a default generic implementation of ToJson. Prevent having to write your own instances of ToJson.
           , Ord -- ^ Default 'Ord' instance
           , FromRow) -- ^ Allow postgres to provide a default instance to map a result to this object when querying the DB. 

-- | Define custom instance of ToRow to ignore the Id column as it is the Identity.
instance ToRow ToDoItem where
    toRow :: ToDoItem -> [Action]
    toRow u = [toField (description u), toField (isDone u), toField (dateCompleted u), toField (dateCreated u)]


