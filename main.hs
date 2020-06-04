module Main where

import Control.Monad
import Text.ParserCombinators.Parsec hiding (spaces)
import System.Environment
import System.Environment



data LispVal =  Atom String
                | List [LispVal]
                | DottedList [LispVal] LispVal
                | Number Integer
                | String String
                | Bool Bool
                deriving Show

spaces :: Parser ()
spaces =    skipMany1 space

symbol :: Parser Char
symbol =    oneOf "!#$%&|*+-/:<=>?@^_~"

parseAtom :: Parser LispVal
parseAtom = do
                first <- letter <|> symbol
                rest <- many (letter <|> digit <|> symbol)
                let atom = first:rest
                return $ case atom of
                            "#t" -> Bool True
                            "#f" -> Bool False
                            _    -> Atom atom

parseExpr :: Parser LispVal
parseExpr = parseAtom <|> parseString <|> parseNumber

parseNumber :: Parser LispVal
parseNumber =   liftM (Number . read) $ many1 digit

parseString :: Parser LispVal
parseString =   do
                    char '"'
                    x <- many (noneOf "\"")
                    char '"'
                    return $ String x

readExpr :: String -> String
readExpr input =    case parse parseExpr "lisp" input of
                    Left err    -> "No match: " ++ show err
                    Right _     -> "Found value"

main :: IO()
main =  do
            (expr:_) <- getArgs
            putStrLn (readExpr expr)