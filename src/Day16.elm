module Day16 exposing (..)

import Array exposing (Array)
import Html exposing (text)
import List.Extra as List


input : String
input =
    """59790132880344516900093091154955597199863490073342910249565395038806135885706290664499164028251508292041959926849162473699550018653393834944216172810195882161876866188294352485183178740261279280213486011018791012560046012995409807741782162189252951939029564062935408459914894373210511494699108265315264830173403743547300700976944780004513514866386570658448247527151658945604790687693036691590606045331434271899594734825392560698221510565391059565109571638751133487824774572142934078485772422422132834305704887084146829228294925039109858598295988853017494057928948890390543290199918610303090142501490713145935617325806587528883833726972378426243439037"""


phasesCount : Int
phasesCount =
    100


main =
    mainPart2


pattern : List Int
pattern =
    [ 0, 1, 0, -1 ]



-- parsing --


parse : String -> List Int
parse input_ =
    String.trim input_
        |> String.toList
        |> List.map (String.fromChar >> String.toInt >> unsafeMaybe "Invalid number")



-- part 1 --


mainPart1 =
    parse input
        |> (\first -> List.foldr runFFT first (List.range 0 (phasesCount - 1)))
        |> List.take 8
        |> List.map String.fromInt
        |> List.foldr (++) ""
        |> text


runFFT : Int -> List Int -> List Int
runFFT _ numbers =
    List.indexedMap
        (\index _ ->
            let
                currentPattern =
                    List.concatMap (List.repeat (index + 1)) pattern

                currentPatternArray =
                    Array.fromList currentPattern

                patternLength =
                    List.length currentPattern
            in
            List.indexedFoldl
                (\numberIndex number sum ->
                    (Array.get ((numberIndex + 1) |> modBy patternLength) currentPatternArray
                        |> unsafeMaybe "Not found pattern value"
                    )
                        * number
                        + sum
                )
                0
                numbers
                |> abs
                |> modBy 10
        )
        numbers



-- Part 2 --


mainPart2 =
    let
        realInput =
            parse input
                |> List.repeat 10000
                |> List.concat

        toDrop =
            List.take 7 realInput
                |> List.foldl (\number current -> current * 10 + number) 0

        truncatedInput =
            List.drop toDrop realInput
    in
    List.foldr runOptimizedFFT truncatedInput (List.range 0 (phasesCount - 1))
        |> List.take 8
        |> List.map String.fromInt
        |> List.foldr (++) ""
        |> text


runOptimizedFFT : Int -> List Int -> List Int
runOptimizedFFT _ numbers =
    List.foldr
        (\number ( lastNumber, resultingNumbers ) ->
            let
                newNumber =
                    (lastNumber + number) |> modBy 10
            in
            ( newNumber, newNumber :: resultingNumbers )
        )
        ( 0, [] )
        numbers
        |> Tuple.second



-- Helpers --


unsafeMaybe : String -> Maybe a -> a
unsafeMaybe error maybe =
    case maybe of
        Just value ->
            value

        Nothing ->
            Debug.todo error
