module Main where

import Servant (Proxy (Proxy), Server, Application, serve, Handler, (:<|>) ((:<|>)))
import Network.Wai.Handler.Warp (run)
import Data.List (sortOn, sortBy)
import Handlers.ToDoHandlers ( getHandler, postHandler )
import ToDoApi (SortBy, ToDoApi )
import Data.PostgresDataStore ()
import Models.ToDoItemModel ( ToDoItem )
import Models.ToDoItemResponse ( ToDoItemResponse )
import Data.Int

server :: Server ToDoApi
server = get :<|> post :<|> getById
    where
        get :: Maybe SortBy -> Handler [ToDoItem]
        get = getHandler

        post :: ToDoItem -> Handler ToDoItemResponse
        post = postHandler

        getById :: Int64 -> Handler ToDoItem
        getById = getById

toDoApi :: Proxy ToDoApi
toDoApi = Proxy

app :: Application
app = serve toDoApi server

main :: IO ()
main = run 8081 app