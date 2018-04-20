 module Main where
 import System.Environment(getArgs)
 import Data.Maybe(fromJust)
 import qualified Data.Map as Map
 import qualified Data.List as List
 import Expr


-- Code to beautify the output
 out :: Map.Map ForestId [Branch] -> IO ()
 out f = mapM_ putStrLn $ (kv h):(map (\x -> "/\\ " ++ (kv x)) t)
       where l = filter (\(k, br) -> br /= []) $ Map.toList f
             h = List.head l
             t = List.tail l

 kv :: (ForestId, [Branch]) -> String
 kv (k, br) = "info(" ++ (show k) ++ ", " ++ "(" ++ (formatBranches br) ++ "))"

 formatBranches :: [Branch] -> String
 formatBranches [] = ""
 formatBranches (br:[]) = show $ b_nodes br
 formatBranches (br:brs) =  show (b_nodes br) ++ (if brs == []
                                                  then ""
                                                  else " \\/ " ++ (formatBranches  brs))

-- The main function that calls the parser then the output beautifier
 main
  = do
  -- read input from commmand line
    (s:o) <- getArgs
    let x = concat o
  -- this calls the lexer on the input, then turns every token into a list of one token (the map call there), because
  -- this particular example has no ambiguous tokens.
    case doParse $ map (:[]) $ lexer s of
  -- these three cases here enumerate the final parse state: Ok, EOF, or Error
      ParseOK r f -> do
               out f
      ParseEOF f  -> do
                putStrLn $ "Premature end of input:\n"
                    ++ unlines (map show $ Map.toList f)
      ParseError ts f -> do
                putStrLn $ "Error: " ++ show ts
