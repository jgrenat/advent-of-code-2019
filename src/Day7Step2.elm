module Day7Step2 exposing (..)

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


type GlobalStatus
    = GeneralHalt Output
    | KeepGoing Output (List ( Array Int, Int ))


tryWithPermutation : Array Int -> List Int -> Output
tryWithPermutation instructions phaseSettings =
    feedbackLoop
        (phaseSettings |> List.map (\phaseSetting -> ( instructions, 0, Just phaseSetting )))
        0
        |> iterateGlobally


feedbackLoop : List ( Array Int, Int, Maybe Int ) -> Output -> GlobalStatus
feedbackLoop states output =
    List.foldl
        (\( instructions, index, maybeConfig ) currentStatus ->
            case currentStatus of
                KeepGoing currentOutput newStates ->
                    let
                        inputs =
                            Maybe.map List.singleton maybeConfig
                                |> Maybe.withDefault []
                                |> (::) currentOutput
                                |> List.reverse
                    in
                    Running inputs index instructions
                        |> iterate
                        |> (\result ->
                                case result of
                                    Halted resultReceived ->
                                        GeneralHalt resultReceived

                                    Running _ _ _ ->
                                        Debug.todo "This should not be running..."

                                    Outputed list currentIndex value ->
                                        KeepGoing value (( list, currentIndex ) :: newStates)
                           )

                GeneralHalt result ->
                    GeneralHalt result
        )
        (KeepGoing output [])
        states


iterateGlobally : GlobalStatus -> Output
iterateGlobally status =
    case status of
        GeneralHalt output ->
            output

        KeepGoing output states ->
            let
                augmentedStates =
                    List.map (\( instructions, index ) -> ( instructions, index, Nothing )) states
                        |> List.reverse
            in
            feedbackLoop augmentedStates output
                |> iterateGlobally


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


type Status
    = Running (List Int) Int (Array Int)
    | Outputed (Array Int) Int Output
    | Halted Output


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


iterate : Status -> Status
iterate status =
    case status of
        Outputed _ _ _ ->
            status

        Halted _ ->
            status

        Running inputs index list ->
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
                                |> Running inputs (index + 4)
                                |> iterate

                        MultiplyInstruction first second position ->
                            Array.set position (first * second) list
                                |> Running inputs (index + 4)
                                |> iterate

                        HaltInstruction ->
                            case inputs of
                                firstInput :: _ ->
                                    Halted firstInput

                                _ ->
                                    Debug.todo "program halted with no input available"

                        InputInstruction position ->
                            case inputs of
                                firstInput :: remaining ->
                                    Array.set position firstInput list
                                        |> Running remaining (index + 2)
                                        |> iterate

                                [] ->
                                    Debug.todo "Error: input asked when no input left"

                        OutputInstruction value ->
                            Outputed list (index + 2) value

                        JumpIfTrueInstruction value position ->
                            if value /= 0 then
                                Running inputs position list
                                    |> iterate

                            else
                                Running inputs (index + 3) list
                                    |> iterate

                        JumpIfFalseInstruction value position ->
                            if value == 0 then
                                Running inputs position list
                                    |> iterate

                            else
                                Running inputs (index + 3) list
                                    |> iterate

                        LessThanInstruction value1 value2 position ->
                            let
                                result =
                                    if value1 < value2 then
                                        1

                                    else
                                        0
                            in
                            Array.set position result list
                                |> Running inputs (index + 4)
                                |> iterate

                        EqualsInstruction value1 value2 position ->
                            let
                                result =
                                    if value1 == value2 then
                                        1

                                    else
                                        0
                            in
                            Array.set position result list
                                |> Running inputs (index + 4)
                                |> iterate

                Nothing ->
                    Debug.todo "Invalid instruction found!!!"


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
