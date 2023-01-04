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
      Application )
import ToDoApi ( ToDoApi, SortBy )
import Models.ToDoItemModel ( ToDoItem )
import Models.ToDoItemResponse ( ToDoItemResponse )
import Data.Int ( Int64 )
import Handlers.ToDoHandlers
    ( getHandler, postHandler, getByIdHandler )
import Network.Wai.Handler.Warp ( run )

-- type ReaderAPI2 = "toDoItems" :> Capture "id" Int64  :> Get '[JSON] ToDoItem

-- readerAPI2 :: Proxy ReaderAPI2
-- readerAPI2 = Proxy

-- funServerT :: ServerT ReaderAPI2 ((->) Config)
-- funServerT = a where
--     a :: Int64 -> Config -> ToDoItem
--     a = getById

--     -- unfortunately, we cannot make `String` the first argument.
--     b :: Double -> Config -> Bool
--     b _ s = True

-- getById :: Int64 -> Config -> IO ToDoItem
-- getById id cfg = do
--     c <- conn cfg
--     r :: [ToDoItem] <- query c "select * from todo_items where id = ?" (Only id)
--     return $ head r

-- funToHandler :: (Config -> a) -> Handler a
-- funToHandler f = do
--     cfg <- liftIO getConfig
--     return (f cfg)

-- app5 :: Application
-- app5 = serve readerAPI2 (hoistServer readerAPI2 funToHandler funServerT)

-- ---------------

-- type ReaderAPI = "toDoItems" :> Capture "id" Int64  :> Get '[JSON] Int

-- readerToHandler :: Reader Config a -> Handler a
-- readerToHandler r = do
--     cfg <- liftIO getConfig
--     return (runReader r cfg)

-- readerServer :: Server ReaderAPI
-- readerServer = hoistServer readerAPI readerToHandler readerServerT

-- readerAPI :: Proxy ReaderAPI
-- readerAPI = Proxy

-- readerServerT :: ServerT ReaderAPI (Reader Config)
-- readerServerT = getById'
--     where
--         getById' :: Int64 -> Reader Config Int
--         getById' i = 
--             _

-- getById :: Int64 -> Reader Config (IO Int)
-- getById id = do
--     cfg <- ask
--     c2 <- liftIO $ conn cfg
--     r :: [ToDoItem] <- liftIO $ query c2 "select * form todo_items where id = ?" (Only id)
--     return 3

-- conn :: Config -> IO Connection
-- conn c = do
--         let dbCfg = databaseCfg c
--         connectPostgreSQL (encodeUtf8 $ T.pack (connString dbCfg))

-- app2 :: Application
-- app2 = serve readerAPI readerServer

-- main2 :: IO ()
-- main2 = do
--     run 8081 app2

-- ---------------------------------------------------

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