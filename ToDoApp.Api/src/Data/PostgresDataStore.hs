{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE InstanceSigs #-}

module Data.PostgresDataStore (conn, insertToDoItem, getAllToDoItems) where

import qualified Data.ByteString as B
import qualified Data.Text as T
import Data.Text.Encoding (encodeUtf8)
import Database.PostgreSQL.Simple
    ( execute, query_, connectPostgreSQL, FromRow, Connection, ToRow )
import Database.PostgreSQL.Simple.ToField
    ( Action, ToField(toField) )
import Database.PostgreSQL.Simple.ToRow ( ToRow(..) )
import Database.PostgreSQL.Simple.FromRow
    ( FromRow(..), RowParser, field )
import Data.Int (Int64)
import ToDoApi (ToDoItem(..), SortBy (IsDone, DateCreated))
import Data.ByteString (ByteString)
import Config.ConfigUtil (getConfig, Config(..), DatabaseConfig(..))
import Control.Monad.IO.Class

instance ToRow ToDoItem where
    toRow :: ToDoItem -> [Action]
    toRow u = [toField (description u), toField (isDone u), toField (dateComplete u)]

instance FromRow ToDoItem where
    fromRow :: RowParser ToDoItem
    fromRow = ToDoItem <$> field <*> field <*> field <*> field <*> field

insertToDoItem :: Connection -> ToDoItem -> IO Int64
insertToDoItem c u = do
    execute c "INSERT INTO todo_items (description, is_done, date_created, date_completed) VALUES (?, ?, ?)" u

getAllToDoItems :: Maybe SortBy -> Connection -> IO [ToDoItem]
getAllToDoItems s c = case s of
    Nothing -> query_ c "select * from todo_items"
    Just s -> case s of
        IsDone -> query_ c "select * from todo_items order by is_done"
        DateCreated -> query_ c "select * from todo_items order by date_created"

conn :: IO Connection
conn = do
        cfg <- getConfig
        let dbCfg = databaseCfg cfg
        connectPostgreSQL (encodeUtf8 $ T.pack (connString dbCfg))

        