module Day2 exposing (..)

import Array exposing (Array)
import Html exposing (text)
import List.Extra as List
import String.Extra as String


input : String
input =
    """1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,6,23,2,13,23,27,1,27,13,31,1,9,31,35,1,35,9,39,1,39,5,43,2,6,43,47,1,47,6,51,2,51,9,55,2,55,13,59,1,59,6,63,1,10,63,67,2,67,9,71,2,6,71,75,1,75,5,79,2,79,10,83,1,5,83,87,2,9,87,91,1,5,91,95,2,13,95,99,1,99,10,103,1,103,2,107,1,107,6,0,99,2,14,0,0"""


parse : String -> Array Int
parse stringValues =
    String.split "," stringValues
        |> List.filter (String.isBlank >> not)
        |> List.map String.toInt
        |> List.map (Maybe.withDefault 0)
        |> Array.fromList


type alias Instruction =
    { code : Int
    , first : Int
    , second : Int
    , third : Int
    }


expectedOutput : Int
expectedOutput =
    19690720


iterate : Int -> Array Int -> Array Int
iterate index list =
    let
        codeMaybe =
            Array.get index list

        firstMaybe =
            Array.get (index + 1) list
                |> Maybe.andThen (\position -> Array.get position list)

        secondMaybe =
            Array.get (index + 2) list
                |> Maybe.andThen (\position -> Array.get position list)

        thirdMaybe =
            Array.get (index + 3) list

        instruction =
            Maybe.andThen
                (\code ->
                    if code == 99 then
                        Just (Instruction code 0 0 0)

                    else
                        Maybe.map3 (Instruction code) firstMaybe secondMaybe thirdMaybe
                )
                codeMaybe
                |> Maybe.map (Debug.log "instruction")
    in
    instruction
        |> Maybe.map
            (\{ code, first, second, third } ->
                case code of
                    1 ->
                        Array.set third (first + second) list
                            |> iterate (index + 4)

                    2 ->
                        Array.set third (first * second) list
                            |> iterate (index + 4)

                    99 ->
                        list

                    value ->
                        Debug.todo ("value " ++ String.fromInt value ++ " is invalid.")
            )
        |> Maybe.withDefault list


possibilities : List ( Int, Int )
possibilities =
    List.range 0 99
        |> List.map (\noun -> List.range 0 99 |> List.map (Tuple.pair noun))
        |> List.concat


tryWith : Array Int -> ( Int, Int ) -> Int
tryWith values ( noun, verb ) =
    Array.set 1 noun values
        |> Array.set 2 verb
        |> iterate 0
        |> Array.get 0
        |> Maybe.withDefault 0



-- part 2


main2 =
    let
        list =
            parse input
    in
    List.find (\solution -> tryWith list solution == expectedOutput) possibilities
        |> Maybe.map (\( noun, verb ) -> String.fromInt (100 * noun + verb))
        |> Maybe.withDefault "not found"
        |> text



-- part 1


main =
    parse input
        |> Array.set 1 12
        |> Array.set 2 2
        |> iterate 0
        |> Array.get 0
        |> Maybe.map String.fromInt
        |> Maybe.withDefault "error"
        |> text
