{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Servant (Proxy (Proxy), Server, Application, serve, Handler, (:<|>) ((:<|>)), HasServer (ServerT), (:>), Get, JSON, Capture)
import Network.Wai.Handler.Warp (run)
import Data.List (sortOn, sortBy)
import Handlers.ToDoHandlers ( getHandler, postHandler )
import ToDoApi (SortBy, ToDoApi )
import Models.ToDoItemModel ( ToDoItem (ToDoItem) )
import Models.ToDoItemResponse ( ToDoItemResponse )
import Data.Int ( Int64 )
import Control.Monad.Reader ( ReaderT, MonadReader (ask), Reader, runReader, MonadIO (liftIO) )
import Config.ConfigUtil (Config (databaseCfg), getConfig, DatabaseConfig (connString))
import Database.PostgreSQL.Simple
import qualified Data.Text as T
import Data.Text.Encoding

type RHandler env = ReaderT env Handler

readerToHandler :: Reader (IO Config) a -> Handler a
readerToHandler r = return (runReader r getConfig)

type ReaderAPI = "a" :> Capture "id" Int64 :>  Get '[JSON] ToDoItem

readerAPI :: Proxy ReaderAPI
readerAPI = Proxy

readerServerT :: ServerT ReaderAPI (Reader Config)
readerServerT = getById'
    where
        getById' :: Int64 -> Reader Config ToDoItem
        getById' i = do
            cfg <- ask
            return $ getById cfg i

getById :: Int64 -> Reader Config (IO ToDoItem)
getById id = do
    c2 <- conn c
    r :: [ToDoItem] <- query c2 "select * form todo_items where id = ?" (Only id)
    head r

conn :: Config -> IO Connection
conn c = do
        let dbCfg = databaseCfg c
        connectPostgreSQL (encodeUtf8 $ T.pack (connString dbCfg))

server :: Config -> Server ToDoApi
server c = get :<|> post :<|> getById
    where
        get :: Maybe SortBy -> Handler [ToDoItem]
        get = getHandler

        post :: ToDoItem -> Handler ToDoItemResponse
        post = postHandler

        getById :: Int64 -> Handler ToDoItem
        getById = getById

toDoApi :: Proxy ToDoApi
toDoApi = Proxy

app ::Config ->  Application
app c = serve toDoApi $ server c

main :: IO ()
main = do
    cfg <- getConfig
    run 8081 (app cfg) 