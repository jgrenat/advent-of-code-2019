module Day7Step1 exposing (..)

import Array exposing (Array)
import Html exposing (text)
import List.Extra as List
import String.Extra as String


input : String
input =
    """3,8,1001,8,10,8,105,1,0,0,21,38,55,64,81,106,187,268,349,430,99999,3,9,101,2,9,9,1002,9,2,9,101,5,9,9,4,9,99,3,9,102,2,9,9,101,3,9,9,1002,9,4,9,4,9,99,3,9,102,2,9,9,4,9,99,3,9,1002,9,5,9,1001,9,4,9,102,4,9,9,4,9,99,3,9,102,2,9,9,1001,9,5,9,102,3,9,9,1001,9,4,9,102,5,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,99"""



-- part 1


main =
    parse input
        |> (\instructions ->
                List.foldl
                    (\combination previousMax ->
                        let
                            result =
                                tryWithPermutation instructions combination
                        in
                        case previousMax of
                            Nothing ->
                                Just result

                            Just previousValue ->
                                Just (max previousValue result)
                    )
                    Nothing
                    (List.permutations (List.range 5 9))
                    |> Maybe.map String.fromInt
                    |> Maybe.withDefault "error"
                    |> text
           )


parse : String -> Array Int
parse stringValues =
    String.split "," stringValues
        |> List.filter (String.isBlank >> not)
        |> List.map String.toInt
        |> List.map (Maybe.withDefault 0)
        |> Array.fromList


tryWithPermutation : Array Int -> List Int -> Output
tryWithPermutation instructions phaseSettings =
    List.foldl
        (\phaseSetting output ->
            iterate [ phaseSetting, output ] 0 [] instructions
                |> Tuple.second
                |> (\outputs ->
                        case outputs of
                            first :: _ ->
                                first

                            [] ->
                                Debug.todo "No output found"
                   )
        )
        0
        phaseSettings


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


type alias Output =
    Int


iterate : List Int -> Int -> List Output -> Array Int -> ( Array Int, List Output )
iterate inputs index outputs list =
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
                        |> iterate inputs (index + 4) outputs

                MultiplyInstruction first second position ->
                    Array.set position (first * second) list
                        |> iterate inputs (index + 4) outputs

                HaltInstruction ->
                    ( list, outputs )

                InputInstruction position ->
                    case inputs of
                        firstInput :: remaining ->
                            Array.set position firstInput list
                                |> iterate remaining (index + 2) outputs

                        [] ->
                            Debug.todo "Error: input asked when no input left"

                OutputInstruction value ->
                    iterate inputs (index + 2) (value :: outputs) list

                JumpIfTrueInstruction value position ->
                    if value /= 0 then
                        iterate inputs position outputs list

                    else
                        iterate inputs (index + 3) outputs list

                JumpIfFalseInstruction value position ->
                    if value == 0 then
                        iterate inputs position outputs list

                    else
                        iterate inputs (index + 3) outputs list

                LessThanInstruction value1 value2 position ->
                    let
                        result =
                            if value1 < value2 then
                                1

                            else
                                0
                    in
                    Array.set position result list
                        |> iterate inputs (index + 4) outputs

                EqualsInstruction value1 value2 position ->
                    let
                        result =
                            if value1 == value2 then
                                1

                            else
                                0
                    in
                    Array.set position result list
                        |> iterate inputs (index + 4) outputs

        Nothing ->
            ( list, outputs )


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
