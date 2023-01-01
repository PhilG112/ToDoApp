{-# LANGUAGE OverloadedStrings #-}

module Data.PostgresDataStore (conn, insertToDoItem, getAllToDoItems) where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import Data.Int (Int64)
import ToDoApi (ToDoItem(..))
import Data.ByteString (ByteString)

instance ToRow ToDoItem where
    toRow u = [toField (description u), toField (isDone u), toField (dateComplete u)]

instance FromRow ToDoItem where
    fromRow = ToDoItem <$> field <*> field <*> field <*> field

insertToDoItem :: Connection -> ToDoItem -> IO Int64
insertToDoItem c u = do
    execute c "INSERT INTO Todo (description, isDone, dateCreated) VALUES (?, ?, ?)" u

getAllToDoItems :: Connection -> IO [ToDoItem]
getAllToDoItems  c = query_ c "select * from \"ToDoSchema\".\"ToDo\""

conn :: IO Connection
conn = connectPostgreSQL s2

s2 :: ByteString
s2 = "postgres://{userName}:{password}@localhost:5432/testdb";