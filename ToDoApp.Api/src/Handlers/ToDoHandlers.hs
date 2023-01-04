module Handlers.ToDoHandlers (getHandler, postHandler, getByIdHandler)  where

import ToDoApi (SortBy (..))
import Servant (Handler)
import Data.List ( sortOn )
import Data.Time ( fromGregorian )
import Data.PostgresDataStore ( getAllToDoItems, insertToDoItem, getById )
import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Models.ToDoItemModel
import Models.ToDoItemResponse
import Data.Int
import Config.ConfigUtil
import Database.PostgreSQL.Simple

getHandler :: Maybe SortBy -> Handler [ToDoItem]
getHandler Nothing = liftIO $ getAllToDoItems Nothing 
getHandler (Just s) = liftIO $ getAllToDoItems (Just s)

postHandler :: ToDoItem -> Handler ToDoItemResponse
postHandler i = liftIO $ insertToDoItem i

getByIdHandler :: Int64 -> Handler ToDoItem
getByIdHandler id = liftIO $ getById id