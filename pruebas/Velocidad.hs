-- Mide cuánto se tarda en cifrar un millón de letras.
module Main (main) where

import qualified Data.ByteString.Char8 as BC
import EnigmaM3
import EnigmaNucleo (cifrarBytes)
import System.CPUTime (getCPUTime)

segundos :: IO a -> IO Double
segundos f = do
  t0 <- getCPUTime
  _ <- f
  t1 <- getCPUTime
  pure (fromIntegral (t1 - t0) / 1e12)

main :: IO ()
main = do
  let w = W rotor_02 rotor_04 rotor_05
      r = RS (CharacterI 'B') (CharacterI 'U') (CharacterI 'L')
      s = rotorSetup w r (GS 'B' 'L' 'A') reflector_B
      p = createPbSet "AV BS CG DL FU HZ IN KM OW RX"
      t = take 1000000 (cycle "ATTACKATDAWN")
      b = BC.pack t
  a <- segundos (print (length (filter (== 'A') (encodeTextEnigmaM3 s p t))))
  c <- segundos (print (BC.count 'A' (fst (cifrarBytes s p b))))
  d <- segundos (print (BC.count 'A' (fst (cifrarBytes s p (BC.concat (replicate 100 b))))))
  putStrLn ("cadena, 1 millón:   " ++ show a ++ " s")
  putStrLn ("bytes, 1 millón:    " ++ show c ++ " s")
  putStrLn ("bytes, 100 millones: " ++ show d ++ " s")
