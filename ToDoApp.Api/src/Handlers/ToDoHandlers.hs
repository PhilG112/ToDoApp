module Handlers.ToDoHandlers (toDoHandler)  where

import ToDoApi (SortBy (..), ToDoItem(..))
import Servant (Handler)
import Data.List ( sortOn )
import Data.Time ( fromGregorian )
import Data.PostgresDataStore
import Control.Monad.IO.Class

toDoHandler :: Maybe SortBy -> Handler [ToDoItem]
toDoHandler Nothing = liftIO getItems
toDoHandler (Just s) = case s of
    IsDone -> return $ sortOn isDone dummyToDoItems
    DateCreated -> return $ sortOn dateComplete dummyToDoItems

getItems :: IO [ToDoItem]
getItems = do
    c <- conn
    getAllToDoItems c

dummyToDoItems :: [ToDoItem]
dummyToDoItems =
  [ ]