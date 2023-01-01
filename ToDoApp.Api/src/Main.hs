module Main where

import Servant (Proxy (Proxy), Server, Application, serve, Handler)
import Network.Wai.Handler.Warp (run)
import Data.List (sortOn, sortBy)
import ToDoHandlers ( toDoHandler )
import ToDoApi ( ToDoApi )

server :: Server ToDoApi
server = toDoHandler

toDoApi :: Proxy ToDoApi
toDoApi = Proxy

app :: Application
app = serve toDoApi server

main :: IO ()
main = run 8081 app