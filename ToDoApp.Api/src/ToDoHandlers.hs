module ToDoHandlers (toDoHandler)  where

import ToDoApi (dummyToDoItems, SortBy (..), ToDoItem(..))
import Servant (Handler)
import Data.List

toDoHandler :: Maybe SortBy -> Handler [ToDoItem]
toDoHandler Nothing = return dummyToDoItems
toDoHandler (Just s) = case s of
    IsDone -> return $ sortOn isDone dummyToDoItems
    DateCreated -> return $ sortOn dateCreated dummyToDoItems