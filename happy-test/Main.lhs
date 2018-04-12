> module Main where
> import System.Environment(getArgs)
> import Data.Maybe(fromJust)
> import qualified Data.Map as Map
> import qualified Data.List as List
> import Expr

#include "DV_lhs"

This requires CPP / preprocessing; use Hugs.lhs for tests with Hugs

> out :: Map.Map ForestId [Branch] -> IO ()
> out f = mapM_ putStrLn $ (kv h):(map (\x -> "/\\ " ++ (kv x)) t)
>       where l = filter (\(k, br) -> br /= []) $ Map.toList f
>             h = List.head l
>             t = List.tail l

> kv :: (ForestId, [Branch]) -> String
> kv (k, br) = "info(" ++ (show k) ++ ", " ++ "(" ++ (formatBranches br) ++ "))"

> formatBranches :: [Branch] -> String
> formatBranches [] = ""
> formatBranches (br:[]) = show $ b_sem br
> formatBranches (br:brs) =  show (b_sem br) ++ (if brs == []
>                                                then "" 
>												 else " \\/ " ++ (formatBranches  brs))

> main
>  = do
>	(s:o) <- getArgs
>	let x = concat o
>	case doParse $ map (:[]) $ lexer s of
>	  ParseOK r f -> do
>               out f
>	  ParseEOF f  -> do
>			    putStrLn $ "Premature end of input:\n"
>					++ unlines (map show $ Map.toList f)
>			    toDV $ Map.toList f
>	  ParseError ts f -> do
>			    putStrLn $ "Error: " ++ show ts
>			    toDV $ Map.toList f

> forest_lookup f i
>  = fromJust $ Map.lookup f i
