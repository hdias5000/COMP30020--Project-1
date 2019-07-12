-- Author: Hasitha Dias <diasi@student.unimelb.edu.au>
-- Student ID: 789929
-- Date Modified: 03/09/2018
--
-- Purpose: Project 1 COMP30020
--
-- This file implements an algorithm to guess the features of the culprits
-- from a fixed list of features and comparison of suspect list with actual
-- culprit list.

module Proj1 (Person, parsePerson, height, hair, sex, GameState, initialGuess,
    nextGuess, feedback, filterSingle, filterSex,filterHair,filterHeight) where

        -- used to store all possible, relevant lineups
        type GameState = [(Person,Person)]
        -- used for height,hair,sex
        data Height = Short | Tall deriving (Eq,Show)
        data Hair = Blonde | Redhead | Dark deriving (Eq,Show)
        data Sex = Male | Female deriving (Eq,Show)
        -- data constructor for storing person information
        data Person = Person Height Hair Sex deriving (Eq,Show)


        -- changes character height to data type Height
        parseHeight :: String -> Height
        parseHeight person
            |'S' `elem` person = Short
            |'T' `elem` person = Tall

        -- changes character hair to data type Hair
        parseHair :: String -> Hair
        parseHair person
            |'B' `elem` person = Blonde
            |'R' `elem` person = Redhead
            |'D' `elem` person = Dark

        -- changes character sex to data type Sex
        parseSex :: String -> Sex
        parseSex person
            |'F' `elem` person = Female
            |'M' `elem` person = Male


        -- changes the character combination of a person into data type Person
        parsePerson :: String -> Maybe Person
        parsePerson string =
            case string of
                (x:y:z) -> Just (Person (parseHeight string) (parseHair string)
                    (parseSex string))
                otherwise -> Nothing

        -- returns Height for a Person
        height :: Person -> Height
        height (Person ht _ _) = ht
        -- returns Hair colour for a Person
        hair :: Person -> Hair
        hair (Person _ hr _) = hr
        -- returns Sex for a Person
        sex :: Person -> Sex
        sex (Person _ _ sx) = sx

        -- Takes first a list of the true culprits and second a list of the
        -- suspects in your lineup, and returns a quadruple of correct suspects,
        -- correct heights, correct hair colours, and correct sexes, in that
        -- order.
        feedback :: [Person] -> [Person] -> (Int,Int,Int,Int)
        feedback (true1:true2:[]) (suspect1:suspect2:[])
            -- the possible combinations for a correct lineup
            | (suspect1==true1)&&(suspect2==true2) = (2,0,0,0)
            | (suspect1==true2)&&(suspect2==true1) = (2,0,0,0)
            -- the possible combinations when one person in lineup is a culprit
            | (suspect1==true1)||(suspect1==true2) =
                (1,ht2-htneg,hr2-hrneg,sx2-sxneg)
            | (suspect2==true1)||(suspect2==true2) =
                (1,ht1-htneg,hr1-hrneg,sx1-sxneg)
            -- when none of the people lineup are the actual culprits
            | otherwise = (0,ht1+ht2-htneg,hr1+hr2-hrneg,sx1+sx2-sxneg)
            -- since we can only count each person (and each culprit) once
            where htneg = (if ((height_s1)==(height_s2))&&
                      ((height_t1)/=(height_t2))&&((ht1+ht2)==2)
                        then 1 else 0)
                  hrneg = (if ((hair_s1)==(hair_s2))&&((hair_t1)/=(hair_t2))
                      &&((hr1+hr2)==2) then 1 else 0)
                  sxneg = (if ((sex_s1)==(sex_s2))&&((sex_t1)/=(sex_t2))&&
                      ((sx1+sx2)==2) then 1 else 0)
                  -- checking for similar heights
                  ht1 = (if ((height_s1)==(height_t1))||
                      ((height_s1)==(height_t2)) then 1 else 0)
                  ht2 = (if ((height_s2)==(height_t1))||
                      ((height_s2)==(height_t2)) then 1 else 0)
                  -- checking for similar hair colours
                  hr1 = (if ((hair_s1)==(hair_t1))||((hair_s1)==(hair_t2))
                      then 1 else 0)
                  hr2 = (if ((hair_s2)==(hair_t1))||((hair_s2)==(hair_t2))
                      then 1 else 0)
                  -- checking for similar genders
                  sx1 = (if ((sex_s1)==(sex_t1))||((sex_s1)==(sex_t2))
                      then 1 else 0)
                  sx2 = (if ((sex_s2)==(sex_t1))||((sex_s2)==(sex_t2))
                      then 1 else 0)
                  -- used to simplify the expressions above
                  height_s1 = height suspect1
                  height_s2 = height suspect2
                  height_t1 = height true1
                  height_t2 = height true2
                  hair_s1 = hair suspect1
                  hair_s2 = hair suspect2
                  hair_t1 = hair true1
                  hair_t2 = hair true2
                  sex_s1 = sex suspect1
                  sex_s2 = sex suspect2
                  sex_t1 = sex true1
                  sex_t2 = sex true2

        -- Returns your initial lineup and initial game state
        initialGuess :: ([Person],GameState)
        initialGuess = ([person1, person2], newGameState)
                  -- first guess is removed from the gameState
            where newGameState = removeItem (person1,person2) gameState
                  -- first guess derived based on best performance compared to
                  -- other lineups
                  person1 = (Person Short Redhead Male)
                  person2 = (Person Tall Dark Female)
                  -- finding all combinations of lineups available
                  gameState = [(l1,l2) | l1 <- singleList,l2 <- singleList,
                    l1/=l2]
                  singleList = [(Person (parseHeight ht) (parseHair hr)
                    (parseSex sx)) | ht <- ["S","T"], hr <- ["B","R","D"],
                      sx <- ["F","M"]]

        -- removes a given item from a list
        removeItem :: Eq a => a -> [a] -> [a]
        removeItem _ [] = []
        removeItem x (y:ys)
            | x == y    = ys
            | otherwise = y : removeItem x ys

        -- Takes as input a pair of the previous guess and game state (as
        -- returned by initialGuess and nextGuess), and the feedback to this guess
        -- as a quadruple of correct suspects,correct height, correct hair colour,
        -- and correct sex, in that order, and returns a pair of the next guess
        -- and new game state.
        nextGuess :: ([Person],GameState) -> (Int,Int,Int,Int) ->
            ([Person],GameState)
        nextGuess (guess, (gameState)) result = ([person1, person2],
                newGameState)
                  -- removes new guess from gameState
            where newGameState = removeItem (person1,person2) tempGameState
                  -- finds the best lineup for next guess
                  (person1,person2) = bestLineup maxLineups initLineup
                    tempGameState tempGameState
                  (initLineup:pairs) = tempGameState
                  -- prunes the irrelevant lineups to simplify process
                  tempGameState = prune result guess gameState

        -- prunes out the lineups which have no chance of being the actual
        -- culprits
        prune :: (Int,Int,Int,Int) -> [Person] -> GameState -> GameState
        prune (val1,val2,val3,val4) guess gameState =
          case (val1,val2,val3,val4) of
              -- prunes lineups not containing any of the previous people
              (1, _, _, _) -> filter (filterSingle guess) gameState
              -- prune lineups to only contain height combination of
              -- previous lineup
              (0, 2, _, _) -> prune (val1,-1,val3,val4) guess (filter
                (filterHeight guess nRemove) gameState)
              -- prune lineups to not contain heights of previous lineup
              (0, 0, _, _) -> prune (val1,-1,val3,val4) guess (filter
                (filterHeight guess remove) gameState)
              -- prune lineups to only contain sex combination of
              -- previous lineup
              (0, _, _, 2) -> prune (val1,val2,val3,-1) guess (filter
                (filterSex guess nRemove) gameState)
              -- prune lineups to not contain genders of previous lineup
              (0, _, _, 0) -> prune (val1,val2,val3,-1) guess (filter
                (filterSex guess remove) gameState)
              -- prune lineups to only contain hair colour combination of
              -- previous lineup
              (0, _, 2, _) -> prune (val1,val2,-1,val4) guess (filter
                (filterHair guess nRemove) gameState)
              -- prune lineups to not contain hair colours of previous lineup
              (0, _, 0, _) -> prune (val1,val2,-1,val4) guess (filter
                (filterHair guess remove) gameState)

              otherwise -> gameState

              where nRemove = False
                    remove = True

        -- filters out lineups without the valid people
        filterSingle :: [Person] -> (Person,Person) -> Bool
        filterSingle (person1:person2:_) (true1, true2)
            -- retains lineup only if it contains one of the people in
            -- previous lineup
            | (person1==true1)||(person1==true2)||(person2==true1)||
              (person2==true2) = True
            | otherwise = False

        -- filters out people with invalid height
        filterHeight :: [Person] -> Bool -> (Person,Person) -> Bool
        filterHeight (person1:person2:_) remove (true1, true2)
            -- ensures that every lineup contains the heights of the previous
            -- lineup
            | (not remove) && (((height1==(height true1))&&(height2==
              (height true2)))||((height1==(height true2))&&
                  (height2==(height true1)))) = True
            -- ensures that every lineup does not contains the heights of the
            -- previous lineup
            | (remove) && ((height1/=(height true1))&&(height1/=(height true2))
              &&(height2/=(height true1))&&(height2/=(height true2))) = True
            | otherwise = False

            where height1 = height person1
                  height2 = height person2

        -- filters out people with invalid hair colours
        filterHair :: [Person] -> Bool -> (Person,Person) -> Bool
        filterHair (person1:person2:_) remove (true1, true2)
            -- ensures that every lineup contains the hair colours of the
            -- previous lineup
            | (not remove) && (((hair1==(hair true1))&&(hair2==(hair true2)))
              ||((hair1==(hair true2))&&(hair2==(hair true1)))) = True
            -- ensures that every lineup does not contains the hair colours of
            -- the previous lineup
            | (remove) && ((hair1/=(hair true1))&&(hair1/=(hair true2))
              &&(hair2/=(hair true1))&&(hair2/=(hair true2))) = True
            | otherwise = False

            where hair1 = hair person1
                  hair2 = hair person2

        -- filters out people of the invalid sex
        filterSex :: [Person] -> Bool -> (Person,Person) -> Bool
        filterSex (person1:person2:_) remove (true1, true2)
            -- ensures that every lineup contains the genders of the previous
            -- lineup
            | (not remove) && (((sex1==(sex true1))&&(sex2==(sex true2)))
              ||((sex1==(sex true2))&&(sex2==(sex true1)))) = True
            -- ensures that every lineup does not contains the genders of the
            -- previous lineup
            | (remove) && ((sex1/=(sex true1))&&(sex1/=(sex true2))
              &&(sex2/=(sex true1))&&(sex2/=(sex true2))) = True
            | otherwise = False

            where sex1 = sex person1
                  sex2 = sex person2


        -- finds the best lineup depending on the average remaining lineups
        -- for each lineup
        bestLineup :: Double -> (Person,Person) -> GameState -> GameState ->
            (Person,Person)
        -- returns the lineup with the best average once entire list is over
        bestLineup _ lineup [] _ = lineup
        bestLineup avg lineup (y:ys) gameState
            -- calculates the best average
            | newAvg > avg = bestLineup newAvg y ys gameState
            | otherwise    = bestLineup avg lineup ys gameState

            where newAvg = calculateAvg y gameState gameState

        -- calculates the average remaining lineups for a given lineup
        calculateAvg :: (Person,Person) -> GameState -> GameState -> Double
        calculateAvg _ [] _ = 0
        calculateAvg culprits (y:ys) gameState
            -- when it's the correct lineup
            | y == culprits = ((fromIntegral 1)/(fromIntegral len)) +
                calculateAvg culprits ys gameState
            -- adds to avg of remaining lineups
            | otherwise     = ((fromIntegral tot)/(fromIntegral len)) +
                calculateAvg culprits ys gameState
            -- finds total remaining lineups if current configuration is
            -- used
            where tot = length (prune (feedback [true1,true2]
                    [suspect1,suspect2]) [suspect1,suspect2] gameState)
                  len = length gameState
                  (suspect1,suspect2) = y
                  (true1,true2)       = culprits


        -- maximum number of possible lineups
        maxLineups :: Double
        maxLineups = fromIntegral 66
