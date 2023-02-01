{-# LANGUAGE OverloadedStrings #-}

module Handlers.ToDoHandlers (
    getHandler,
    postHandler,
    getByIdHandler,
    completeItemHandler)  where

import ToDoApi (SortBy (..))
import Servant (Handler, ServerError (..), throwError, err404, NoContent (NoContent))
import Data.List ( sortOn )
import Data.Time ( fromGregorian )
import Data.PostgresDataStore ( getAllToDoItems, insertToDoItem, getById, completeItem )
import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Models.ToDoItemModel ( ToDoItem )
import Models.ToDoItemResponse ( ToDoItemResponse )
import Data.Int ( Int64 )
import Config.ConfigUtil ( Config )
import Database.PostgreSQL.Simple ()
import Control.Monad.Reader ( MonadIO(liftIO), ReaderT, MonadTrans (lift) )

getHandler :: Maybe SortBy -> ReaderT Config Handler [ToDoItem]
getHandler Nothing =  getAllToDoItems Nothing 
getHandler (Just s) = getAllToDoItems (Just s)

postHandler :: ToDoItem -> ReaderT Config Handler ToDoItemResponse
postHandler = insertToDoItem

getByIdHandler :: Int64 -> ReaderT Config Handler ToDoItem
getByIdHandler id = do 
    r <- getById id
    if length r > 0
        then return $ head r
        else throwError err404

completeItemHandler :: Int64 -> ReaderT Config Handler NoContent
completeItemHandler id = do
    r <- completeItem id
    case r of
        0 -> throwError err404
        v -> return NoContent
