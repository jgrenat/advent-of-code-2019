module Day19 exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, text)
import String.Extra as String


input : String
input =
    """109,424,203,1,21102,11,1,0,1106,0,282,21101,18,0,0,1106,0,259,1202,1,1,221,203,1,21101,31,0,0,1105,1,282,21101,0,38,0,1106,0,259,20101,0,23,2,22101,0,1,3,21102,1,1,1,21102,57,1,0,1105,1,303,2102,1,1,222,21002,221,1,3,21001,221,0,2,21101,0,259,1,21101,80,0,0,1106,0,225,21101,0,149,2,21101,91,0,0,1106,0,303,1202,1,1,223,21002,222,1,4,21102,1,259,3,21101,225,0,2,21101,0,225,1,21101,118,0,0,1106,0,225,21001,222,0,3,21102,1,58,2,21102,1,133,0,1106,0,303,21202,1,-1,1,22001,223,1,1,21101,148,0,0,1105,1,259,1201,1,0,223,21002,221,1,4,20102,1,222,3,21101,21,0,2,1001,132,-2,224,1002,224,2,224,1001,224,3,224,1002,132,-1,132,1,224,132,224,21001,224,1,1,21102,195,1,0,105,1,109,20207,1,223,2,20102,1,23,1,21101,0,-1,3,21102,1,214,0,1106,0,303,22101,1,1,1,204,1,99,0,0,0,0,109,5,2101,0,-4,249,22101,0,-3,1,21201,-2,0,2,22101,0,-1,3,21101,250,0,0,1106,0,225,22101,0,1,-4,109,-5,2106,0,0,109,3,22107,0,-2,-1,21202,-1,2,-1,21201,-1,-1,-1,22202,-1,-2,-2,109,-3,2105,1,0,109,3,21207,-2,0,-1,1206,-1,294,104,0,99,22101,0,-2,-2,109,-3,2106,0,0,109,5,22207,-3,-4,-1,1206,-1,346,22201,-4,-3,-4,21202,-3,-1,-1,22201,-4,-1,2,21202,2,-1,-1,22201,-4,-1,1,22101,0,-2,3,21101,0,343,0,1105,1,303,1105,1,415,22207,-2,-3,-1,1206,-1,387,22201,-3,-2,-3,21202,-2,-1,-1,22201,-3,-1,3,21202,3,-1,-1,22201,-3,-1,2,22102,1,-4,1,21102,1,384,0,1105,1,303,1105,1,415,21202,-4,-1,-4,22201,-4,-3,-4,22202,-3,-2,-2,22202,-2,-4,-4,22202,-3,-2,-3,21202,-4,-1,-2,22201,-3,-2,1,21202,1,1,-4,109,-5,2105,1,0"""


main =
    mainPart2


pulledBySomething : number
pulledBySomething =
    1



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

        range =
            List.range 0 49

        coordinatesToTest =
            List.concatMap (\x -> List.map (Tuple.pair x) range) range
    in
    coordinatesToTest
        |> List.filter
            (\( x, y ) ->
                let
                    iterationStatus =
                        iterate (RelativeBase 0) 0 [ x, y ] [] instructions
                in
                case iterationStatus of
                    Halted (firstOutput :: []) ->
                        firstOutput == pulledBySomething

                    Halted _ ->
                        Debug.todo "Unexpected number of outputs!"

                    WaitingInput _ ->
                        Debug.todo "Program should have halted"
            )
        |> List.length
        |> String.fromInt
        |> text



-- Part 2 --


spaceshiftSize =
    100


mainPart2 =
    let
        instructions =
            parse input

        range =
            List.range 300 1200

        coordinatesToTest =
            List.concatMap (\x -> List.map (Tuple.pair x) range) range

        isUnderBeamInfluence ( x, y ) =
            let
                iterationStatus =
                    iterate (RelativeBase 0) 0 [ x, y ] [] instructions
            in
            case iterationStatus of
                Halted (firstOutput :: []) ->
                    firstOutput == pulledBySomething

                Halted _ ->
                    Debug.todo "Unexpected number of outputs!"

                WaitingInput _ ->
                    Debug.todo "Program should have halted"
    in
    coordinatesToTest
        |> List.filter isUnderBeamInfluence
        |> List.filter (canContainShip isUnderBeamInfluence)
        |> List.sort
        |> List.head
        |> Maybe.map (\( x, y ) -> String.fromInt (x * 10000 + y))
        |> Maybe.withDefault "Not found in this range"
        |> text


canContainShip : (( Int, Int ) -> Bool) -> ( Int, Int ) -> Bool
canContainShip isUnderBeamInfluence ( x, y ) =
    [ ( x + 99, y ), ( x, y + 99 ), ( x + 99, y + 99 ) ]
        |> List.all isUnderBeamInfluence



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
    = WaitingInput ( Int -> List Int -> IterationStatus, List Output )
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


iterate : RelativeBase -> Int -> List Int -> List Output -> Dict Int Int -> IterationStatus
iterate relativeBase index inputs outputs list =
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
            iterate relativeBase (index + 4) inputs outputs (Dict.insert position (first + second) list)

        MultiplyInstruction first second position ->
            iterate relativeBase (index + 4) inputs outputs (Dict.insert position (first * second) list)

        HaltInstruction ->
            Halted outputs

        InputInstruction position ->
            case inputs of
                [] ->
                    WaitingInput ( \firstInput others -> iterate relativeBase (index + 2) others [] (Dict.insert position firstInput list), outputs )

                firstInput :: others ->
                    iterate relativeBase (index + 2) others [] (Dict.insert position firstInput list)

        OutputInstruction value ->
            iterate relativeBase (index + 2) inputs (value :: outputs) list

        JumpIfTrueInstruction value position ->
            let
                newIndex =
                    if value /= 0 then
                        position

                    else
                        index + 3
            in
            iterate relativeBase newIndex inputs outputs list

        JumpIfFalseInstruction value position ->
            let
                newIndex =
                    if value == 0 then
                        position

                    else
                        index + 3
            in
            iterate relativeBase newIndex inputs outputs list

        LessThanInstruction value1 value2 position ->
            let
                result =
                    if value1 < value2 then
                        1

                    else
                        0
            in
            iterate relativeBase (index + 4) inputs outputs (Dict.insert position result list)

        EqualsInstruction value1 value2 position ->
            let
                result =
                    if value1 == value2 then
                        1

                    else
                        0
            in
            iterate relativeBase (index + 4) inputs outputs (Dict.insert position result list)

        AdjustRelativeBaseInstruction value ->
            let
                relativeBaseValue =
                    case relativeBase of
                        RelativeBase relativeBaseValue_ ->
                            relativeBaseValue_
            in
            iterate (RelativeBase (relativeBaseValue + value)) (index + 2) inputs outputs list


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
