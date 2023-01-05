{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Data.PostgresDataStore (insertToDoItem, getAllToDoItems, getById) where

import qualified Data.ByteString as B
import qualified Data.Text as T
import Data.Text.Encoding (encodeUtf8)
import Database.PostgreSQL.Simple
    ( execute, query_, connectPostgreSQL, FromRow, Connection, ToRow, query, Only (Only), close )
import Database.PostgreSQL.Simple.ToField
    ( Action, ToField(toField) )
import Database.PostgreSQL.Simple.ToRow ( ToRow(..) )
import Database.PostgreSQL.Simple.FromRow
    ( FromRow(..), RowParser, field, numFieldsRemaining )
import Data.Int (Int64)
import Data.ByteString (ByteString)
import Config.ConfigUtil (getConfig, Config(..), DatabaseConfig(..))
import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Control.Monad (forM_)
import Models.ToDoItemResponse ( ToDoItemResponse )
import Models.ToDoItemModel ( ToDoItem )
import ToDoApi ( SortBy(..) )
import Control.Monad.Reader
    ( MonadIO(liftIO), MonadReader(ask), ReaderT )
import Servant (Handler)

insertToDoItem :: ToDoItem -> ReaderT Config Handler ToDoItemResponse
insertToDoItem u = do
    cfg <- ask
    c <- liftIO $ conn cfg
    let q = "INSERT INTO todo_items (description, is_done, date_created, date_completed) VALUES (?, ?, ?, ?) returning id"
    xs :: [ToDoItemResponse] <- liftIO $ query c q u
    liftIO $ close c
    return $  head xs

getById :: Int64 -> ReaderT Config Handler [ToDoItem]
getById id = do
    cfg <- ask
    c <- liftIO $ conn cfg
    r :: [ToDoItem] <- liftIO $ query c "select * from todo_items where id = ?" (Only id)
    liftIO $ close c
    return r

getAllToDoItems :: Maybe SortBy -> ReaderT Config Handler [ToDoItem]
getAllToDoItems s = do
    cfg <- ask
    c <- liftIO $ conn cfg
    case s of
        Nothing -> do 
            r <- liftIO $ query_ c "select * from todo_items"
            liftIO $ close c
            return r
        Just s -> case s of
            IsDone -> do 
                r <- liftIO $ query_ c "select * from todo_items order by is_done"
                liftIO $ close c
                return r
            DateCreated -> do
                r <- liftIO $ query_ c "select * from todo_items order by date_created"
                liftIO $ close c
                return r

conn :: Config -> IO Connection
conn c = do
        let dbCfg = databaseCfg c
        connectPostgreSQL (encodeUtf8 $ T.pack (connString dbCfg))