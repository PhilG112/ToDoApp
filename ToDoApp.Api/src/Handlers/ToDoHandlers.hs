{-# LANGUAGE OverloadedStrings #-}

module Handlers.ToDoHandlers (getHandler, postHandler, getByIdHandler)  where

import ToDoApi (SortBy (..))
import Servant (Handler, ServerError (..), throwError)
import Data.List ( sortOn )
import Data.Time ( fromGregorian )
import Data.PostgresDataStore ( getAllToDoItems, insertToDoItem, getById )
import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Models.ToDoItemModel
import Models.ToDoItemResponse
import Data.Int
import Config.ConfigUtil
import Database.PostgreSQL.Simple
import Servant.Server

getHandler :: Maybe SortBy -> Handler [ToDoItem]
getHandler Nothing = liftIO $ getAllToDoItems Nothing 
getHandler (Just s) = liftIO $ getAllToDoItems (Just s)

postHandler :: ToDoItem -> Handler ToDoItemResponse
postHandler i = liftIO $ insertToDoItem i

getByIdHandler :: Int64 -> Handler ToDoItem
getByIdHandler id = do 
    r <- liftIO $ getById id
    if length r > 0
        then return $ head r
        else throwError custom404Error

    where
        custom404Error = err404 {
            errHTTPCode = 404,
            errReasonPhrase = "Not found.",
            errBody = "No item found with that Id." }