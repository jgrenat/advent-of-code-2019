module Day15 exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, text)
import List.Extra as List
import Maybe.Extra as Maybe
import String.Extra as String


input : String
input =
    """3,1033,1008,1033,1,1032,1005,1032,31,1008,1033,2,1032,1005,1032,58,1008,1033,3,1032,1005,1032,81,1008,1033,4,1032,1005,1032,104,99,101,0,1034,1039,1001,1036,0,1041,1001,1035,-1,1040,1008,1038,0,1043,102,-1,1043,1032,1,1037,1032,1042,1106,0,124,101,0,1034,1039,101,0,1036,1041,1001,1035,1,1040,1008,1038,0,1043,1,1037,1038,1042,1105,1,124,1001,1034,-1,1039,1008,1036,0,1041,1002,1035,1,1040,1001,1038,0,1043,1002,1037,1,1042,1106,0,124,1001,1034,1,1039,1008,1036,0,1041,102,1,1035,1040,1001,1038,0,1043,102,1,1037,1042,1006,1039,217,1006,1040,217,1008,1039,40,1032,1005,1032,217,1008,1040,40,1032,1005,1032,217,1008,1039,39,1032,1006,1032,165,1008,1040,39,1032,1006,1032,165,1101,2,0,1044,1106,0,224,2,1041,1043,1032,1006,1032,179,1102,1,1,1044,1106,0,224,1,1041,1043,1032,1006,1032,217,1,1042,1043,1032,1001,1032,-1,1032,1002,1032,39,1032,1,1032,1039,1032,101,-1,1032,1032,101,252,1032,211,1007,0,59,1044,1106,0,224,1101,0,0,1044,1106,0,224,1006,1044,247,101,0,1039,1034,1001,1040,0,1035,1002,1041,1,1036,102,1,1043,1038,101,0,1042,1037,4,1044,1105,1,0,33,20,19,43,28,91,62,55,96,28,52,9,24,99,11,45,80,58,96,2,8,76,1,37,5,95,18,6,97,67,47,4,19,29,74,57,45,65,17,43,93,33,71,93,26,2,86,11,31,74,85,36,94,20,89,68,45,99,43,21,3,92,69,95,8,30,84,45,10,64,95,49,60,60,45,30,94,36,17,97,90,39,4,97,76,28,80,92,5,66,20,69,95,43,95,35,30,67,67,87,36,44,11,83,62,73,42,80,20,99,79,46,1,75,85,24,5,84,47,78,91,91,38,74,16,31,96,37,60,69,12,96,2,5,83,24,67,42,7,67,94,77,34,6,75,2,61,37,15,11,65,13,63,39,42,93,22,12,89,58,98,28,69,13,98,68,34,13,93,56,85,28,92,45,84,79,70,12,27,85,1,86,94,57,64,30,75,78,49,91,19,94,77,34,40,15,64,26,34,31,70,65,34,65,7,73,61,8,23,82,55,78,36,93,10,29,64,42,99,34,91,17,33,98,45,44,74,98,60,76,6,44,73,11,13,11,73,92,55,90,3,54,23,75,28,36,82,89,84,6,39,31,39,98,34,61,21,93,48,71,80,7,46,76,71,17,7,91,6,22,76,70,27,98,35,29,69,93,42,81,62,46,87,47,51,66,2,60,3,76,68,68,74,70,3,89,18,2,57,74,79,97,16,5,73,19,90,49,6,41,88,83,34,63,52,84,14,19,76,78,88,19,92,90,34,16,69,45,85,30,71,16,77,30,43,65,85,66,11,2,72,3,83,84,14,86,90,74,79,35,33,29,78,9,92,35,64,32,30,66,9,65,30,85,81,44,95,41,22,16,28,75,63,72,23,5,73,24,89,80,25,40,88,62,3,68,6,80,6,39,17,76,24,78,6,90,79,38,44,78,85,29,48,25,75,27,76,92,19,93,21,61,56,13,64,92,52,77,12,33,77,41,75,86,29,34,65,38,66,17,15,95,50,87,52,64,72,73,6,26,80,71,8,86,1,23,67,10,72,89,9,95,60,20,46,64,99,34,46,65,14,54,93,84,4,13,86,12,26,68,56,33,83,12,93,42,74,9,99,62,22,20,83,75,13,71,96,53,96,41,8,15,76,97,55,8,78,85,57,79,30,87,17,46,62,85,14,70,63,82,28,46,96,35,89,6,9,27,44,86,93,28,9,97,73,14,7,84,64,15,62,14,17,88,92,82,11,47,63,73,13,94,98,88,15,37,38,11,2,74,20,73,94,26,96,64,56,80,53,48,85,85,35,15,90,63,9,42,99,81,97,26,94,32,24,96,61,38,18,57,22,76,7,5,43,55,97,74,35,99,86,24,25,8,60,75,18,61,14,97,52,64,97,45,29,69,91,43,40,99,58,72,73,70,45,5,97,37,89,77,32,92,94,6,33,72,64,35,75,14,32,99,64,54,78,1,92,35,30,71,11,48,82,61,49,12,46,75,54,52,33,92,24,11,72,72,16,17,57,72,68,46,15,85,58,74,55,54,87,97,44,94,16,84,57,56,96,33,79,7,70,50,23,98,91,6,62,51,73,68,17,83,93,56,15,81,99,88,15,13,93,53,48,69,2,14,83,86,39,4,54,69,52,42,60,79,92,38,68,90,48,77,46,77,16,89,3,96,77,11,77,23,73,98,35,3,1,97,48,62,36,74,13,93,19,71,23,70,64,64,14,71,86,98,20,95,1,97,30,92,16,98,63,94,56,90,49,94,28,88,43,84,38,74,83,62,4,98,63,69,0,0,21,21,1,10,1,0,0,0,0,0,0"""


main =
    mainPart2


type Direction
    = North
    | East
    | South
    | West


type Status
    = Wall
    | Moved
    | MovedToOxygen


type alias Score =
    Int



-- part 1 --


parse : String -> Dict Int Int
parse stringValues =
    String.split "," stringValues
        |> List.filter (String.isBlank >> not)
        |> List.map String.toInt
        |> List.map (Maybe.withDefault 0)
        |> List.indexedMap Tuple.pair
        |> Dict.fromList


mainPart1 =
    let
        instructions =
            parse input

        iterationStatus =
            iterate (RelativeBase 0) 0 [] instructions
    in
    exploreUntilOxygen iterationStatus 0 Dict.empty ( 0, 0 )
        |> Maybe.map Tuple.first
        |> Maybe.map String.fromInt
        |> Maybe.withDefault "Oxygen not found"
        |> text


exploreUntilOxygen : IterationStatus -> Int -> Dict ( Int, Int ) Int -> ( Int, Int ) -> Maybe ( Int, Int -> IterationStatus )
exploreUntilOxygen iterationStatus step visited current =
    let
        alreadyVisitedInFewerSteps =
            Dict.get current visited |> Maybe.unwrap False (\previousStepValue -> previousStepValue <= step)

        newVisited =
            Dict.insert current step visited
    in
    if alreadyVisitedInFewerSteps then
        Nothing

    else
        case iterationStatus of
            WaitingInput ( giveInstruction, outputs ) ->
                case List.head outputs |> Maybe.map statusCodeToStatus |> Maybe.withDefault Moved of
                    MovedToOxygen ->
                        Just ( step, giveInstruction )

                    Moved ->
                        [ North, South, East, West ]
                            |> List.map (\direction -> ( moveToDirection current direction, giveInstruction (directionToCode direction) ))
                            |> List.map (\( newCurrent, newStatus ) -> exploreUntilOxygen newStatus (step + 1) newVisited newCurrent)
                            |> List.filterMap identity
                            |> List.minimumBy Tuple.first

                    Wall ->
                        Nothing

            Halted _ ->
                Debug.todo "Program unexpectedly halted"


moveToDirection : ( Int, Int ) -> Direction -> ( Int, Int )
moveToDirection ( x, y ) direction =
    case direction of
        North ->
            ( x, y - 1 )

        East ->
            ( x + 1, y )

        South ->
            ( x, y + 1 )

        West ->
            ( x - 1, y )


directionToCode : Direction -> Int
directionToCode direction =
    case direction of
        North ->
            1

        East ->
            3

        South ->
            2

        West ->
            4


statusCodeToStatus : Int -> Status
statusCodeToStatus code =
    case code of
        0 ->
            Wall

        1 ->
            Moved

        2 ->
            MovedToOxygen

        _ ->
            Debug.todo ("Invalid status code: " ++ String.fromInt code)



-- Part 2 --


mainPart2 =
    let
        instructions =
            parse input

        iterationStatus =
            iterate (RelativeBase 0) 0 [] instructions

        ( _, startFromOxygen ) =
            exploreUntilOxygen iterationStatus 0 Dict.empty ( 0, 0 )
                |> unsafeMaybe "Oxygen not found"
    in
    propagateOxygen (WaitingInput ( startFromOxygen, [] )) 0 Dict.empty ( 0, 0 )
        |> Dict.values
        |> List.maximum
        |> Maybe.map (\value -> value - 1)
        |> Maybe.map String.fromInt
        |> Maybe.withDefault "Propagation failed"
        |> text


propagateOxygen : IterationStatus -> Int -> Dict ( Int, Int ) Int -> ( Int, Int ) -> Dict ( Int, Int ) Int
propagateOxygen iterationStatus step visited current =
    let
        alreadyVisitedInFewerSteps =
            Dict.get current visited |> Maybe.unwrap False (\previousStepValue -> previousStepValue <= step)

        newVisited =
            Dict.insert current step visited
    in
    if alreadyVisitedInFewerSteps then
        visited

    else
        case iterationStatus of
            WaitingInput ( giveInstruction, outputs ) ->
                case List.head outputs |> Maybe.map statusCodeToStatus |> Maybe.withDefault Moved of
                    Wall ->
                        newVisited

                    _ ->
                        [ North, South, East, West ]
                            |> List.map (\direction -> ( moveToDirection current direction, giveInstruction (directionToCode direction) ))
                            |> List.map (\( newCurrent, newStatus ) -> propagateOxygen newStatus (step + 1) newVisited newCurrent)
                            |> List.foldr mergeExplorations Dict.empty

            Halted _ ->
                Debug.todo "Program unexpectedly halted"


mergeExplorations : Dict ( Int, Int ) Int -> Dict ( Int, Int ) Int -> Dict ( Int, Int ) Int
mergeExplorations dict1 dict2 =
    Dict.merge
        Dict.insert
        (\key a b dict -> Dict.insert key (min a b) dict)
        Dict.insert
        dict1
        dict2
        Dict.empty



-- IntCode computer --


type Instruction
    = AddInstruction Int Int Int
    | MultiplyInstruction Int Int Int
    | InputInstruction Int
    | OutputInstruction Int
    | JumpIfTrueInstruction Int Int
    | JumpIfFalseInstruction Int Int
    | LessThanInstruction Int Int Int
    | EqualsInstruction Int Int Int
    | AdjustRelativeBaseInstruction Int
    | HaltInstruction


type Mode
    = Immediate
    | Position
    | Relative


type RelativeBase
    = RelativeBase Int


type Opcode
    = Add Mode Mode Mode
    | Multiply Mode Mode Mode
    | Input Mode
    | Output Mode
    | JumpIfTrue Mode Mode
    | JumpIfFalse Mode Mode
    | LessThan Mode Mode Mode
    | Equals Mode Mode Mode
    | AdjustRelativeBase Mode
    | Halt


type alias Output =
    Int


type IterationStatus
    = WaitingInput ( Int -> IterationStatus, List Output )
    | Halted (List Output)


getOpcode : Int -> Opcode
getOpcode instruction =
    let
        opcodeValue =
            modBy 100 instruction

        mode1 =
            instruction // 100 |> modBy 10 |> intToMode

        mode2 =
            instruction // 1000 |> modBy 10 |> intToMode

        mode3 =
            instruction // 10000 |> modBy 10 |> intToMode
    in
    case opcodeValue of
        1 ->
            Add mode1 mode2 mode3

        2 ->
            Multiply mode1 mode2 mode3

        3 ->
            Input mode1

        4 ->
            Output mode1

        5 ->
            JumpIfTrue mode1 mode2

        6 ->
            JumpIfFalse mode1 mode2

        7 ->
            LessThan mode1 mode2 mode3

        8 ->
            Equals mode1 mode2 mode3

        9 ->
            AdjustRelativeBase mode1

        99 ->
            Halt

        value ->
            Debug.todo ("Invalid opcode value " ++ String.fromInt value ++ " in " ++ String.fromInt instruction)


intToMode : Int -> Mode
intToMode int =
    case int of
        0 ->
            Position

        1 ->
            Immediate

        2 ->
            Relative

        _ ->
            Debug.todo ("Invalid mode value " ++ String.fromInt int)


modeToValue : RelativeBase -> Dict Int Int -> Mode -> Int -> Int
modeToValue (RelativeBase relativeBase) list mode parameter =
    case mode of
        Immediate ->
            parameter

        Position ->
            Dict.get parameter list |> Maybe.withDefault 0

        Relative ->
            Dict.get (relativeBase + parameter) list |> Maybe.withDefault 0


iterate : RelativeBase -> Int -> List Output -> Dict Int Int -> IterationStatus
iterate relativeBase index outputs list =
    let
        codeMaybe =
            Dict.get index list

        instruction =
            Maybe.map getOpcode codeMaybe
                |> Maybe.map (getInstruction relativeBase index list)
                |> unsafeMaybe "Unable to get instruction"
    in
    case instruction of
        AddInstruction first second position ->
            iterate relativeBase (index + 4) outputs (Dict.insert position (first + second) list)

        MultiplyInstruction first second position ->
            iterate relativeBase (index + 4) outputs (Dict.insert position (first * second) list)

        HaltInstruction ->
            Halted outputs

        InputInstruction position ->
            WaitingInput ( \givenInput -> iterate relativeBase (index + 2) [] (Dict.insert position givenInput list), outputs )

        OutputInstruction value ->
            iterate relativeBase (index + 2) (value :: outputs) list

        JumpIfTrueInstruction value position ->
            let
                newIndex =
                    if value /= 0 then
                        position

                    else
                        index + 3
            in
            iterate relativeBase newIndex outputs list

        JumpIfFalseInstruction value position ->
            let
                newIndex =
                    if value == 0 then
                        position

                    else
                        index + 3
            in
            iterate relativeBase newIndex outputs list

        LessThanInstruction value1 value2 position ->
            let
                result =
                    if value1 < value2 then
                        1

                    else
                        0
            in
            iterate relativeBase (index + 4) outputs (Dict.insert position result list)

        EqualsInstruction value1 value2 position ->
            let
                result =
                    if value1 == value2 then
                        1

                    else
                        0
            in
            iterate relativeBase (index + 4) outputs (Dict.insert position result list)

        AdjustRelativeBaseInstruction value ->
            let
                relativeBaseValue =
                    case relativeBase of
                        RelativeBase relativeBaseValue_ ->
                            relativeBaseValue_
            in
            iterate (RelativeBase (relativeBaseValue + value)) (index + 2) outputs list


getInstruction : RelativeBase -> Int -> Dict Int Int -> Opcode -> Instruction
getInstruction relativeBase index list opcode =
    let
        firstMaybe =
            Dict.get (index + 1) list

        secondMaybe =
            Dict.get (index + 2) list

        thirdMaybe =
            Dict.get (index + 3) list

        toValue currentRelativeBase mode maybeParameter =
            case maybeParameter of
                Just parameter ->
                    modeToValue currentRelativeBase list mode parameter

                Nothing ->
                    Debug.todo "Parameter not found"

        positionToValue (RelativeBase currentRelativeBase) mode maybeParameter =
            case maybeParameter of
                Just parameter ->
                    case mode of
                        Position ->
                            parameter

                        Relative ->
                            currentRelativeBase + parameter

                        Immediate ->
                            Debug.todo "Position cannot be in Immediate mode"

                Nothing ->
                    Debug.todo "Parameter not found"
    in
    case opcode of
        Add mode1 mode2 mode3 ->
            AddInstruction
                (toValue relativeBase mode1 firstMaybe)
                (toValue relativeBase mode2 secondMaybe)
                (positionToValue relativeBase mode3 thirdMaybe)

        Multiply mode1 mode2 mode3 ->
            MultiplyInstruction
                (toValue relativeBase mode1 firstMaybe)
                (toValue relativeBase mode2 secondMaybe)
                (positionToValue relativeBase mode3 thirdMaybe)

        Halt ->
            HaltInstruction

        Input mode ->
            InputInstruction (positionToValue relativeBase mode firstMaybe)

        Output mode ->
            OutputInstruction (toValue relativeBase mode firstMaybe)

        JumpIfTrue mode1 mode2 ->
            let
                value1 =
                    toValue relativeBase mode1 firstMaybe

                value2 =
                    toValue relativeBase mode2 secondMaybe
            in
            JumpIfTrueInstruction value1 value2

        JumpIfFalse mode1 mode2 ->
            JumpIfFalseInstruction
                (toValue relativeBase mode1 firstMaybe)
                (toValue relativeBase mode2 secondMaybe)

        LessThan mode1 mode2 mode3 ->
            LessThanInstruction
                (toValue relativeBase mode1 firstMaybe)
                (toValue relativeBase mode2 secondMaybe)
                (positionToValue relativeBase mode3 thirdMaybe)

        Equals mode1 mode2 mode3 ->
            EqualsInstruction
                (toValue relativeBase mode1 firstMaybe)
                (toValue relativeBase mode2 secondMaybe)
                (positionToValue relativeBase mode3 thirdMaybe)

        AdjustRelativeBase mode ->
            AdjustRelativeBaseInstruction (toValue relativeBase mode firstMaybe)



-- Helpers --


unsafeMaybe : String -> Maybe a -> a
unsafeMaybe error maybe =
    case maybe of
        Just value ->
            value

        Nothing ->
            Debug.todo error
