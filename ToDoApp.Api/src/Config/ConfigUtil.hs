{-# LANGUAGE OverloadedStrings #-}

module Config.ConfigUtil (getConfig, Config(..), DatabaseConfig(..)) where

import Data.Ini.Config
    ( fieldOf, number, parseIniFile, section, string, IniParser )
import GHC.IO.IOMode ( IOMode(ReadMode) )
import System.IO (openFile, hGetContents)
import Data.Text

getConfig :: IO Config
getConfig = do
    handle <- openFile "config.dev.ini" ReadMode
    contents <- hGetContents handle
    case parseIniFile (pack contents) parseConfig of
        Left s -> error s
        Right a -> return a

parseConfig :: IniParser Config
parseConfig = do
    dbSection <- section "DATABASE" $ do
        cs <- fieldOf "connstring" string
        return $ DatabaseConfig { connString  = cs}
    return $ Config { databaseCfg = dbSection }

data Config = Config {
    databaseCfg :: DatabaseConfig
}

data DatabaseConfig = DatabaseConfig {
    connString :: String
}