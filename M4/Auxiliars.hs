module Auxiliars (module Auxiliars) where

import Data.List
import Data.Maybe

type Alph = String

alphabet :: Alph 
alphabet = ['A'..'Z']

removeWhiteAux :: String -> String -> String
removeWhiteAux "" strng = strng
removeWhiteAux (c:cs) strng
    | c == ' '  = removeWhiteAux cs strng
    | otherwise = removeWhiteAux cs (c:strng)

removeWhite :: String -> String
removeWhite cs = reverse.removeWhiteAux cs $ ""

charToIndex :: Char -> Alph -> Int
charToIndex x strn = fromJust $ elemIndex x strn

indexToCharAux :: Int -> Alph -> Maybe Char
indexToCharAux n strn
    | n < 0 || n >= length strn = Nothing
    | otherwise                 = Just (strn !! n)

indexToChar :: Int -> Alph -> Char
indexToChar n strn = fromJust $ indexToCharAux n strn

charToIndexA :: Char -> Int
charToIndexA = \x -> charToIndex x alphabet

indexToCharA :: Int -> Char
indexToCharA = \n -> indexToChar n alphabet

nextInAlphabet :: Char -> Char
nextInAlphabet c = indexToCharA(((charToIndexA(c)+1) `mod` 26))

rotateLevAux :: String -> [String]
rotateLevAux xs = take len $ map (take len) $ tails $ cycle xs
    where
        len = length xs

rotateLev :: Int ->  String -> String
rotateLev n xs = (rotateLevAux xs) !! n

rotateLevOne :: String -> String
rotateLevOne xs = rotateLev 1 xs