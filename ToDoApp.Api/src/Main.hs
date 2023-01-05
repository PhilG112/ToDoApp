{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ExplicitNamespaces #-}

module Main where

import Servant
    ( Proxy(..),
      type (:<|>)((:<|>)),
      serve,
      Server,
      Handler,
      Application, HasServer (ServerT), Capture, (:>), Get, JSON, hoistServer, QueryParam, ReqBody, Post )
import ToDoApi ( ToDoApi, SortBy )
import Models.ToDoItemModel ( ToDoItem )
import Models.ToDoItemResponse ( ToDoItemResponse )
import Data.Int ( Int64 )
import Handlers.ToDoHandlers
    ( getHandler, postHandler, getByIdHandler )
import Network.Wai.Handler.Warp ( run )
import Control.Monad.Reader
    ( MonadIO(liftIO), ReaderT(runReaderT) )
import Config.ConfigUtil ( Config, getConfig )

readerToHandler :: Config -> ReaderT Config Handler a -> Handler a
readerToHandler cfg readerT = runReaderT readerT cfg
    
hoistedServer :: Config -> Server ToDoApi
hoistedServer cfg = hoistServer toDoApiProxy (readerToHandler cfg) serverT

toDoApiProxy :: Proxy ToDoApi
toDoApiProxy = Proxy

serverT :: ServerT ToDoApi (ReaderT Config Handler)
serverT = get :<|> post :<|> getById
    where
        get :: Maybe SortBy -> ReaderT Config Handler [ToDoItem]
        get = getHandler

        post :: ToDoItem -> ReaderT Config Handler ToDoItemResponse
        post = postHandler

        getById :: Int64 -> ReaderT Config Handler ToDoItem
        getById = getByIdHandler

app :: Config -> Application
app cfg = serve toDoApiProxy (hoistedServer cfg)

main :: IO ()
main = do
    cfg <- getConfig
    run 8081 (app cfg)