module Handlers.ToDoHandlers (getHandler, postHandler)  where

import ToDoApi (SortBy (..))
import Servant (Handler)
import Data.List ( sortOn )
import Data.Time ( fromGregorian )
import Data.PostgresDataStore ( getAllToDoItems, conn, insertToDoItem, getById )
import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Models.ToDoItemModel
import Models.ToDoItemResponse
import Data.Int

getHandler :: Maybe SortBy -> Handler [ToDoItem]
getHandler Nothing = liftIO $ getItems Nothing
getHandler (Just s) = liftIO $ getItems (Just s)

postHandler :: ToDoItem -> Handler ToDoItemResponse
postHandler i = liftIO $ postItems i

getByIdHandler :: Int64 -> Handler ToDoItem
getByIdHandler id = liftIO $ getById id

getItems :: Maybe SortBy -> IO [ToDoItem]
getItems = getAllToDoItems

postItems :: ToDoItem -> IO ToDoItemResponse
postItems = insertToDoItem