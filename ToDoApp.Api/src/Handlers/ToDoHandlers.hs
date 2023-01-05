{-# LANGUAGE OverloadedStrings #-}

module Handlers.ToDoHandlers (getHandler, postHandler, getByIdHandler)  where

import ToDoApi (SortBy (..))
import Servant (Handler, ServerError (..), throwError, err404)
import Data.List ( sortOn )
import Data.Time ( fromGregorian )
import Data.PostgresDataStore ( getAllToDoItems, insertToDoItem, getById )
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
        else throwError custom404Error
    where
        custom404Error :: ServerError
        custom404Error = err404 {
            errHTTPCode = 404,
            errReasonPhrase = "Not found.",
            errBody = "No item found with that Id." }