module Handlers.ToDoHandlers (toDoHandler)  where

import ToDoApi (SortBy (..), ToDoItem(..))
import Servant (Handler)
import Data.List ( sortOn )
import Data.Time ( fromGregorian )

toDoHandler :: Maybe SortBy -> Handler [ToDoItem]
toDoHandler Nothing = return dummyToDoItems
toDoHandler (Just s) = case s of
    IsDone -> return $ sortOn isDone dummyToDoItems
    DateCreated -> return $ sortOn dateCreated dummyToDoItems


dummyToDoItems :: [ToDoItem]
dummyToDoItems =
  [ ToDoItem "Buy dog Food" False (fromGregorian 1683  3 1)
  , ToDoItem "Take out rubbish" True (fromGregorian 1905 12 1)
  ]