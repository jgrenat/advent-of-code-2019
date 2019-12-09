module Day5 exposing (..)

import Array exposing (Array)
import Html exposing (text)
import String.Extra as String


input : String
input =
    """3,225,1,225,6,6,1100,1,238,225,104,0,1101,65,73,225,1101,37,7,225,1101,42,58,225,1102,62,44,224,101,-2728,224,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,1,69,126,224,101,-92,224,224,4,224,1002,223,8,223,101,7,224,224,1,223,224,223,1102,41,84,225,1001,22,92,224,101,-150,224,224,4,224,102,8,223,223,101,3,224,224,1,224,223,223,1101,80,65,225,1101,32,13,224,101,-45,224,224,4,224,102,8,223,223,101,1,224,224,1,224,223,223,1101,21,18,225,1102,5,51,225,2,17,14,224,1001,224,-2701,224,4,224,1002,223,8,223,101,4,224,224,1,223,224,223,101,68,95,224,101,-148,224,224,4,224,1002,223,8,223,101,1,224,224,1,223,224,223,1102,12,22,225,102,58,173,224,1001,224,-696,224,4,224,1002,223,8,223,1001,224,6,224,1,223,224,223,1002,121,62,224,1001,224,-1302,224,4,224,1002,223,8,223,101,4,224,224,1,223,224,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,226,677,224,102,2,223,223,1005,224,329,1001,223,1,223,7,677,226,224,102,2,223,223,1006,224,344,1001,223,1,223,1007,226,677,224,1002,223,2,223,1006,224,359,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,224,374,1001,223,1,223,108,677,677,224,102,2,223,223,1006,224,389,101,1,223,223,8,226,677,224,102,2,223,223,1005,224,404,101,1,223,223,7,226,677,224,1002,223,2,223,1005,224,419,101,1,223,223,8,677,226,224,1002,223,2,223,1005,224,434,101,1,223,223,107,677,677,224,1002,223,2,223,1006,224,449,101,1,223,223,7,677,677,224,1002,223,2,223,1006,224,464,101,1,223,223,1107,226,226,224,102,2,223,223,1006,224,479,1001,223,1,223,1007,226,226,224,102,2,223,223,1006,224,494,101,1,223,223,108,226,677,224,1002,223,2,223,1006,224,509,101,1,223,223,1108,226,677,224,102,2,223,223,1006,224,524,1001,223,1,223,1008,226,226,224,1002,223,2,223,1005,224,539,101,1,223,223,107,226,226,224,102,2,223,223,1006,224,554,101,1,223,223,8,677,677,224,102,2,223,223,1005,224,569,101,1,223,223,107,226,677,224,102,2,223,223,1005,224,584,101,1,223,223,1108,226,226,224,1002,223,2,223,1005,224,599,1001,223,1,223,1008,677,677,224,1002,223,2,223,1005,224,614,101,1,223,223,1107,226,677,224,102,2,223,223,1005,224,629,101,1,223,223,1108,677,226,224,1002,223,2,223,1005,224,644,1001,223,1,223,1107,677,226,224,1002,223,2,223,1006,224,659,1001,223,1,223,108,226,226,224,102,2,223,223,1006,224,674,101,1,223,223,4,223,99,226"""



-- part 1


main =
    parse input
        |> iterate 5 0
        |> Array.get 0
        |> Maybe.map String.fromInt
        |> Maybe.withDefault "error"
        |> text


parse : String -> Array Int
parse stringValues =
    String.split "," stringValues
        |> List.filter (String.isBlank >> not)
        |> List.map String.toInt
        |> List.map (Maybe.withDefault 0)
        |> Array.fromList


type Instruction
    = AddInstruction Int Int Int
    | MultiplyInstruction Int Int Int
    | InputInstruction Int
    | OutputInstruction Int
    | JumpIfTrueInstruction Int Int
    | JumpIfFalseInstruction Int Int
    | LessThanInstruction Int Int Int
    | EqualsInstruction Int Int Int
    | HaltInstruction


type Mode
    = Immediate
    | Position


type Opcode
    = Add Mode Mode
    | Multiply Mode Mode
    | Input
    | Output Mode
    | JumpIfTrue Mode Mode
    | JumpIfFalse Mode Mode
    | LessThan Mode Mode
    | Equals Mode Mode
    | Halt


getOpcode : Int -> Opcode
getOpcode instruction =
    let
        opcodeValue =
            modBy 100 instruction

        mode1 =
            instruction // 100 |> modBy 10 |> intToMode

        mode2 =
            instruction // 1000 |> modBy 10 |> intToMode
    in
    case opcodeValue of
        1 ->
            Add mode1 mode2

        2 ->
            Multiply mode1 mode2

        3 ->
            Input

        4 ->
            Output mode1

        5 ->
            JumpIfTrue mode1 mode2

        6 ->
            JumpIfFalse mode1 mode2

        7 ->
            LessThan mode1 mode2

        8 ->
            Equals mode1 mode2

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

        _ ->
            Debug.todo ("Invalid mode value " ++ String.fromInt int)


modeToValue : Array Int -> Mode -> Int -> Int
modeToValue list mode parameter =
    case mode of
        Immediate ->
            parameter

        Position ->
            Array.get parameter list
                |> Maybe.withDefault 0


iterate : Int -> Int -> Array Int -> Array Int
iterate givenInput index list =
    let
        codeMaybe =
            Array.get index list

        instructionMaybe =
            Maybe.map getOpcode codeMaybe
                |> Maybe.andThen (getInstruction index list)
    in
    case instructionMaybe of
        Just instruction ->
            case instruction of
                AddInstruction first second position ->
                    Array.set position (first + second) list
                        |> iterate givenInput (index + 4)

                MultiplyInstruction first second position ->
                    Array.set position (first * second) list
                        |> iterate givenInput (index + 4)

                HaltInstruction ->
                    list

                InputInstruction position ->
                    Array.set position givenInput list
                        |> iterate givenInput (index + 2)

                OutputInstruction value ->
                    let
                        _ =
                            Debug.log "Output: " value
                    in
                    iterate givenInput (index + 2) list

                JumpIfTrueInstruction value position ->
                    if value /= 0 then
                        iterate givenInput position list

                    else
                        iterate givenInput (index + 3) list

                JumpIfFalseInstruction value position ->
                    if value == 0 then
                        iterate givenInput position list

                    else
                        iterate givenInput (index + 3) list

                LessThanInstruction value1 value2 position ->
                    let
                        result =
                            if value1 < value2 then
                                1

                            else
                                0
                    in
                    Array.set position result list
                        |> iterate givenInput (index + 4)

                EqualsInstruction value1 value2 position ->
                    let
                        result =
                            if value1 == value2 then
                                1

                            else
                                0
                    in
                    Array.set position result list
                        |> iterate givenInput (index + 4)

        Nothing ->
            list


getInstruction index list opcode =
    let
        firstMaybe =
            Array.get (index + 1) list

        secondMaybe =
            Array.get (index + 2) list

        thirdMaybe =
            Array.get (index + 3) list

        toValue mode =
            Maybe.map (modeToValue list mode)
    in
    case opcode of
        Add mode1 mode2 ->
            Maybe.map3 AddInstruction (toValue mode1 firstMaybe) (toValue mode2 secondMaybe) thirdMaybe

        Multiply mode1 mode2 ->
            Maybe.map3 MultiplyInstruction (toValue mode1 firstMaybe) (toValue mode2 secondMaybe) thirdMaybe

        Halt ->
            Just HaltInstruction

        Input ->
            Maybe.map InputInstruction firstMaybe

        Output mode ->
            Maybe.map OutputInstruction (toValue mode firstMaybe)

        JumpIfTrue mode1 mode2 ->
            Maybe.map2 JumpIfTrueInstruction (toValue mode1 firstMaybe) (toValue mode2 secondMaybe)

        JumpIfFalse mode1 mode2 ->
            Maybe.map2 JumpIfFalseInstruction (toValue mode1 firstMaybe) (toValue mode2 secondMaybe)

        LessThan mode1 mode2 ->
            Maybe.map3 LessThanInstruction (toValue mode1 firstMaybe) (toValue mode2 secondMaybe) thirdMaybe

        Equals mode1 mode2 ->
            Maybe.map3 EqualsInstruction (toValue mode1 firstMaybe) (toValue mode2 secondMaybe) thirdMaybe
