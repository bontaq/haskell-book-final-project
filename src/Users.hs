{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Main where

import qualified Data.Text                    as T
import           Database.SQLite.Simple       hiding (close)
import qualified Database.SQLite.Simple       as SQLite
import           Database.SQLite.Simple.Types
import           System.Environment           (getArgs)
import           Text.RawString.QQ
import           Types

insertUser :: Query
insertUser =
  "INSERT INTO users VALUES (?, ?, ?, ?, ?, ?)"

handleInsert :: Connection -> UserRow -> IO ()
handleInsert conn =
  execute conn insertUser

updateUser :: Query
updateUser = [r|
UPDATE
  users
SET
  username=?,
  shell=?,
  homeDirectory=?,
  realName=?,
  phone=?
WHERE
  username=?
|]

-- use the email address to target update
handleUpdate :: Connection -> UserRow -> IO ()
handleUpdate conn =
  execute conn updateUser

mkUser :: [T.Text] -> Maybe UserRow
mkUser [a, b, c, d, e] = Just (Null, a, b, c, d, e)
mkUser _               = Nothing

main = do
  (command:userInfo) <- getArgs
  let
    user = mkUser (fmap T.pack userInfo)
  putStrLn $ show user
  conn <- open "finger.db"
  case user of
    Nothing -> putStrLn "bad user"
    Just u  -> do
      handleInsert conn u
      putStrLn "user created"
  SQLite.close conn
