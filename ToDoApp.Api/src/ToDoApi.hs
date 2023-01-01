{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE OverloadedStrings #-}

module ToDoApi (
    ToDoApi
    , ToDoItem(..)
    , SortBy (IsDone, DateCreated)) where 

import Servant.API
import GHC.Generics (Generic)
import Data.Aeson
import Data.Text
import Data.ByteString
import Models.ToDoItemModel

data SortBy = IsDone | DateCreated deriving (Eq)

instance ToHttpApiData SortBy where
    toQueryParam :: SortBy -> Text
    toQueryParam s = case s of
        IsDone -> "isDone"
        DateCreated -> "dateCreated"
    
instance FromHttpApiData SortBy where
    parseQueryParam :: Text -> Either Text SortBy
    parseQueryParam s
        | s == "isDone" = Right IsDone
        | s == "dateCreated" = Right DateCreated
        | otherwise = Left "Cannot sort by given parameter. 'isDone' or 'dateCreated' only."

instance ToJSON ToDoItem

type ToDoApi = "toDoItems"
    :> QueryParam "sortBy" SortBy
    :> Get '[JSON] [ToDoItem]