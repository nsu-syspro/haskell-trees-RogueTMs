{-# OPTIONS_GHC -Wall #-}
-- The above pragma enables all warnings

module Task3 where

-- Explicit import of Prelude to hide functions
-- that are not supposed to be used in this assignment
import Prelude hiding (compare, foldl, foldr, Ordering(..))

import Task1 (Tree(..))      -- from Task 1
import Task2
    ( Cmp, Ordering(..)
    , tinsert, tdelete, tlookup, listToBST, bstToList
    , compare
    )

-- * Type definitions

-- | Tree-based map
type Map k v = Tree (k, v)

-- * Function definitions

-- | Construction of 'Map' from association list
--
-- Usage example:
--
-- >>> listToMap [(2,'a'),(3,'c'),(1,'b')]
-- Branch (2,'a') (Branch (1,'b') Leaf Leaf) (Branch (3,'c') Leaf Leaf)
-- >>> listToMap [] :: Map Int Char
-- Leaf
--

compareKeys :: Ord k => Cmp (k, v)
compareKeys (k1, _) (k2, _) =
  case compare k1 k2 of
    LT -> LT
    EQ -> EQ
    GT -> GT

listToMap :: Ord k => [(k, v)] -> Map k v
listToMap = listToBST compareKeys

-- | Conversion from 'Map' to association list sorted by key
--
-- Usage example:
--
-- >>> mapToList (Branch (2,'a') (Branch (1,'b') Leaf Leaf) (Branch (3,'c') Leaf Leaf))
-- [(1,'b'),(2,'a'),(3,'c')]
-- >>> mapToList Leaf
-- []
--
mapToList :: Map k v -> [(k, v)]
mapToList = bstToList

-- | Searches given 'Map' for a value associated with given key
--
-- Returns value associated with key wrapped into 'Just'
-- if it was found and 'Nothing' otherwise.
--
-- Usage example:
--
-- >>> mlookup 1 (Branch (2,'a') (Branch (1,'b') Leaf Leaf) (Branch (3,'c') Leaf Leaf))
-- Just 'b'
-- >>> mlookup 'a' Leaf
-- Nothing
--
mlookup :: Ord k => k -> Map k v -> Maybe v
mlookup _ Leaf = Nothing
mlookup key tree =
  case tlookup compareKeys (key, error "unused") tree of
    Nothing           -> Nothing
    Just (_, v') -> Just v'

-- | Inserts given key and value into given 'Map'
--
-- If given key was already present in the 'Map'
-- then replaces its value with given value.
--
-- Usage example:
--
-- >>> minsert 0 'd' (Branch (2,'a') (Branch (1,'b') Leaf Leaf) (Branch (3,'c') Leaf Leaf))
-- Branch (2,'a') (Branch (1,'b') (Branch (0,'d') Leaf Leaf) Leaf) (Branch (3,'c') Leaf Leaf)
-- >>> minsert 1 'X' (Branch (2,'a') (Branch (1,'b') Leaf Leaf) (Branch (3,'c') Leaf Leaf))
-- Branch (2,'a') (Branch (1,'X') Leaf Leaf) (Branch (3,'c') Leaf Leaf)
-- >>> minsert 1 'X' Leaf
-- Branch (1,'X') Leaf Leaf
--
minsert :: Ord k => k -> v -> Map k v -> Map k v
minsert key val = tinsert compareKeys (key, val)

-- | Deletes given key from given 'Map'
--
-- Returns updated 'Map' if the key was present in it;
-- or unchanged 'Map' otherwise.
--
-- Usage example:
--
-- >>> mdelete 1 (Branch (2,'a') (Branch (1,'b') Leaf Leaf) (Branch (3,'c') Leaf Leaf))
-- Branch (2,'a') Leaf (Branch (3,'c') Leaf Leaf)
-- >>> mdelete 'a' Leaf
-- Leaf
--
mdelete :: Ord k => k -> Map k v -> Map k v
mdelete _ Leaf = Leaf
mdelete key tree =
  tdelete compareKeys (key, error "unused") tree
