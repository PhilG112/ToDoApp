{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Data.PostgresDataStore (conn, insertToDoItem, getAllToDoItems, getById) where

import qualified Data.ByteString as B
import qualified Data.Text as T
import Data.Text.Encoding (encodeUtf8)
import Database.PostgreSQL.Simple
    ( execute, query_, connectPostgreSQL, FromRow, Connection, ToRow, query, Only (Only) )
import Database.PostgreSQL.Simple.ToField
    ( Action, ToField(toField) )
import Database.PostgreSQL.Simple.ToRow ( ToRow(..) )
import Database.PostgreSQL.Simple.FromRow
    ( FromRow(..), RowParser, field, numFieldsRemaining )
import Data.Int (Int64)
import Data.ByteString (ByteString)
import Config.ConfigUtil (getConfig, Config(..), DatabaseConfig(..))
import Control.Monad.IO.Class
import Control.Monad (forM_)
import Models.ToDoItemResponse
import Models.ToDoItemModel
import ToDoApi

insertToDoItem :: ToDoItem -> IO ToDoItemResponse
insertToDoItem u = do
    c <- conn
    let q = "INSERT INTO todo_items (description, is_done, date_created, date_completed) VALUES (?, ?, ?, ?) returning id"
    xs :: [ToDoItemResponse] <- query c q u
    return $  head xs

getById :: Int64 -> IO ToDoItem
getById id = do
    c <- conn
    r :: [ToDoItem] <- query c "select * form todo_items where id = ?" (Only id)
    return $ head r


getAllToDoItems :: Maybe SortBy -> IO [ToDoItem]
getAllToDoItems s = do
    c <- conn
    case s of
        Nothing -> query_ c "select * from todo_items"
        Just s -> case s of
            IsDone -> query_ c "select * from todo_items order by is_done"
            DateCreated -> query_ c "select * from todo_items order by date_created"

conn :: IO Connection
conn = do
        cfg <- getConfig
        let dbCfg = databaseCfg cfg
        connectPostgreSQL (encodeUtf8 $ T.pack (connString dbCfg))