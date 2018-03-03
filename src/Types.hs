module Types where

import           Data.Text                    (Text)
import           Database.SQLite.Simple.Types

type UserRow =
  (Null, Text, Text, Text, Text, Text)

data User =
  User {
    userId          :: Integer
    , username      :: Text
    , shell         :: Text
    , homeDirectory :: Text
    , realName      :: Text
    , phone         :: Text
  } deriving (Eq, Show)
