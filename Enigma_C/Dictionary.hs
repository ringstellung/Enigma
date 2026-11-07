module Dictionary(
  Dictionary,
  emptyDict,          -- :: Dictionary a b
  addToDict,          -- :: Eq a => a -> b -> Dictionary a b -> Dictionary a b
  isKeyInDict,        -- :: Eq a => a -> Dictionary a b -> Bool
  isValueInDict,      -- :: Eq b => b -> Dictionary a b -> Bool
  valueInDict,        -- :: Eq a => a -> Dictionary a b -> b
  keysInDict,         -- :: (Eq b, Show a) => b -> Dictionary a b -> [a]
  keysInDictFirst,    -- :: (Eq b, Show a) => b -> Dictionary a b -> a
  valueOrDefectDict,  -- :: Eq a => a -> Dictionary a b -> b -> b
  updateDict,         -- :: Eq a => a -> b -> Dictionary a b -> Dictionary a b
  removeFromDict,     -- :: Eq a => a -> Dictionary a b -> Dictionary a b
  dictToList,         -- :: Ord a => Dictionary a b -> [(a,b)]
  listToDict          -- :: Eq a => [a] -> [b] -> Dictionary a b
  )
       where

import Data.List(sort)

data Assoc a b = Assoc a b deriving Show
type Dictionary a b = [Assoc a b]

instance Eq a => Eq(Assoc a b) where
  Assoc x y == Assoc x' y' = x == x'

instance Ord a => Ord(Assoc a b) where
  Assoc x y <= Assoc x' y' = x <= x'

emptyDict :: Dictionary a b
emptyDict = []

addToDict :: Eq a => a -> b -> Dictionary a b -> Dictionary a b
addToDict k v d
  | elem (Assoc k v) d = error "addToDict: ya existe"
  | otherwise          = Assoc k v : d

isKeyInDict :: Eq a => a -> Dictionary a b -> Bool
isKeyInDict k  = any (\ (Assoc k' v') -> k == k')

isValueInDict :: Eq b => b -> Dictionary a b -> Bool
isValueInDict v  = any (\ (Assoc k' v') -> v == v')

valueInDict :: (Eq a, Show b) => a -> Dictionary a b -> b
valueInDict k dic = valueOrDefectDict k dic (error "valueInDict: no existe" )

keysInDictAux :: (Eq b, Show a) => b -> Dictionary a b -> [a] -> [a]
keysInDictAux v [] lst = lst
keysInDictAux v (Assoc x y: d) lst
  | v == y     = keysInDictAux v d (x:lst)
  | otherwise  = keysInDictAux v d lst

keysInDict :: (Eq b, Show a) => b -> Dictionary a b -> [a]
keysInDict v d = keysInDictAux v d []

keysInDictFirst :: (Eq b, Show a) => b -> Dictionary a b -> a
keysInDictFirst v = head.keysInDict v   

valueOrDefectDict :: (Eq a, Show b) => a -> Dictionary a b -> b -> b
valueOrDefectDict k [] f = f
valueOrDefectDict k (Assoc k' v' : d) f
  | k == k'    = v'
  | otherwise  = valueOrDefectDict k d f

updateDict :: Eq a => a -> b -> Dictionary a b -> Dictionary a b
updateDict k v d
  | k `isKeyInDict` d = Assoc k v : removeFromDict k d
  | otherwise         = Assoc k v : d

removeFromDict :: Eq a => a -> Dictionary a b -> Dictionary a b
removeFromDict k [] = error "removeFromDict: no existe"
removeFromDict k (a@(Assoc k' v'):d)
  | k == k'   = d
  | otherwise = a:removeFromDict k d

dictToList :: Ord a => Dictionary a b -> [(a,b)]
dictToList = map (\(Assoc k v) -> (k,v)).sort

listToDictAux  :: Eq a => [(a,b)] -> Dictionary a b
listToDictAux []     = emptyDict
listToDictAux (x:xs) = addToDict (fst x) (snd x) (listToDictAux xs)

listToDict :: Eq a => [a] -> [b] -> Dictionary a b
listToDict ks vs = listToDictAux. zip ks $ vs
