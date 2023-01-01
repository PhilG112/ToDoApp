module Handlers.ToDoHandlers (toDoHandler)  where

import ToDoApi (SortBy (..), ToDoItem(..))
import Servant (Handler)
import Data.List ( sortOn )
import Data.Time ( fromGregorian )
import Data.PostgresDataStore ( getAllToDoItems, conn )
import Control.Monad.IO.Class ( MonadIO(liftIO) )

toDoHandler :: Maybe SortBy -> Handler [ToDoItem]
toDoHandler Nothing = liftIO $ getItems Nothing
toDoHandler (Just s) = liftIO $ getItems (Just s)

getItems :: Maybe SortBy -> IO [ToDoItem]
getItems s = do
    c <- conn
    getAllToDoItems s c