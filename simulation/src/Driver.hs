{-# Language OverloadedStrings #-}

module Main where

import Data.Maybe (fromMaybe)
import Data.Time.Clock
import Data.Time.Format (parseTime)
import Prelude
import qualified Prelude as PL
import System.Environment (getArgs)
import System.Locale (defaultTimeLocale)
import Text.Read (readMaybe)

import Generate
import Retrieve

parseCmd :: [String] -> IO ()

parseCmd ["get_year", systemStr, moduleStr, yearStr] = retrieveYear system modules year >>= outputMatlab "output"
  where
  year      = read yearStr
  modules   = read moduleStr 
  system    = read systemStr

parseCmd ["get", systemStr, moduleStr, dateStr] = retrieveDay system modules (utctDay date) >>= outputMatlab "output"
  where
  Just date = parseTime defaultTimeLocale "%F" dateStr
  modules   = read moduleStr 
  system    = read systemStr

parseCmd ["gen", systemStr, startYearStr, endYearStr] = generateYears startYear endYear system
  where
  system    = read systemStr
  startYear = read startYearStr
  endYear   = fromMaybe startYear $ readMaybe endYearStr

parseCmd _ = mapM_ putStrLn commands
  where
  commands = ["Invalid command, use:",
              "./driver get system #modules date",
              "./driver get_year system #modules year",
              "./driver gen system start_year end_year"]

main :: IO ()
main = getArgs >>= parseCmd