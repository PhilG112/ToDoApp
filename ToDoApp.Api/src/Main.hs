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
      Application, throwError, ServerError(..), err404)
import ToDoApi ( ToDoApi, SortBy )
import Models.ToDoItemModel ( ToDoItem )
import Models.ToDoItemResponse ( ToDoItemResponse )
import Data.Int ( Int64 )
import Handlers.ToDoHandlers
    ( getHandler, postHandler, getByIdHandler )
import Network.Wai.Handler.Warp ( run )

server :: Server ToDoApi
server = get :<|> post :<|> getById
    where
        get :: Maybe SortBy -> Handler [ToDoItem]
        get = getHandler

        post :: ToDoItem -> Handler ToDoItemResponse
        post = postHandler

        getById :: Int64 -> Handler ToDoItem
        getById = getByIdHandler

toDoApi :: Proxy ToDoApi
toDoApi = Proxy

app :: Application
app = serve toDoApi server 

main :: IO ()
main = do
    run 8081 app