module Handlers.ToDoHandlers (getHandler, postHandler, getByIdHandler)  where

import ToDoApi (SortBy (..))
import Servant (Handler)
import Data.List ( sortOn )
import Data.Time ( fromGregorian )
import Data.PostgresDataStore ( getAllToDoItems, insertToDoItem, getById )
import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Models.ToDoItemModel ( ToDoItem )
import Models.ToDoItemResponse ( ToDoItemResponse )
import Data.Int ( Int64 )
import Config.ConfigUtil ( Config )
import Database.PostgreSQL.Simple ()
import Control.Monad.Reader ( MonadIO(liftIO), ReaderT )

getHandler :: Maybe SortBy -> ReaderT Config IO [ToDoItem]
getHandler Nothing =  getAllToDoItems Nothing 
getHandler (Just s) = getAllToDoItems (Just s)

postHandler :: ToDoItem -> ReaderT Config IO ToDoItemResponse
postHandler = insertToDoItem

getByIdHandler :: Int64 -> ReaderT Config IO ToDoItem
getByIdHandler = getById


