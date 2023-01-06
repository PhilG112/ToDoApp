{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE OverloadedStrings #-}

module ToDoApi where 

import Servant.API
    ( FromHttpApiData(parseQueryParam),
      ToHttpApiData(toQueryParam),
      type (:<|>),
      type (:>),
      QueryParam,
      Get,
      JSON,
      ReqBody,
      Post,
      Capture, Put, NoContent, PutNoContent )
import GHC.Generics (Generic)
import Data.Aeson
import Data.Text ( Text )
import Data.ByteString
import Models.ToDoItemModel ( ToDoItem )
import Models.ToDoItemResponse ( ToDoItemResponse )
import Data.Int ( Int64 )

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

type ToDoApi =
         "toDoItems" :> QueryParam "sortBy" SortBy :> Get '[JSON] [ToDoItem]
    :<|> "toDoItems" :> ReqBody '[JSON] ToDoItem :> Post '[JSON] ToDoItemResponse
    :<|> "toDoItems" :> Capture "id" Int64 :> Get '[JSON] ToDoItem
    :<|> "toDoItems":> "complete" :> Capture "id" Int64 :> PutNoContent