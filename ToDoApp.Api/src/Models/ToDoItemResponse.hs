{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Models.ToDoItemResponse (ToDoItemResponse(..)) where

import GHC.Generics (Generic)
import Data.Aeson ( ToJSON, FromJSON )
import Database.PostgreSQL.Simple (FromRow, ToRow)

newtype ToDoItemResponse = ToDoItemResponse { id :: Int }
    deriving (ToJSON, FromJSON, Eq, Show, Generic, Ord, FromRow, ToRow)
