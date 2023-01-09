{-# LANGUAGE OverloadedStrings #-}

module Config.ConfigUtil (getConfig, Config(..), DatabaseConfig(..)) where

import Data.Ini.Config
    ( fieldOf, number, parseIniFile, section, string, IniParser )
import GHC.IO.IOMode ( IOMode(ReadMode) )
import System.IO (openFile, hGetContents)
import Data.Text ( pack )
import Control.Monad.Reader ()

-- | Get the configuration file. File is in *.ini format.
getConfig :: IO Config
getConfig = do
    handle <- openFile "config.dev.ini" ReadMode
    contents <- hGetContents handle
    case parseIniFile (pack contents) parseConfig of
        Left s -> error s
        Right a -> return a

-- | Use Iniparser to parse the given config.
parseConfig :: IniParser Config
parseConfig = do
    dbSection <- section "DATABASE" $ do
        cs <- fieldOf "connstring" string
        return $ DatabaseConfig { connString  = cs}
    return $ Config { databaseCfg = dbSection }

-- | The main configuration object
data Config = Config {
    -- | The database config section
    databaseCfg :: DatabaseConfig
}

data DatabaseConfig = DatabaseConfig {
    -- | The connection string wtihing the database config section
    connString :: String
}