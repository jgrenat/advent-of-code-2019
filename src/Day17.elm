module Day17 exposing (..)

import Array exposing (Array)
import Array.Extra as Array
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import List.Extra as List
import String.Extra as String


input : String
input =
    """1,330,331,332,109,3072,1101,1182,0,16,1101,1481,0,24,102,1,0,570,1006,570,36,1002,571,1,0,1001,570,-1,570,1001,24,1,24,1105,1,18,1008,571,0,571,1001,16,1,16,1008,16,1481,570,1006,570,14,21101,0,58,0,1105,1,786,1006,332,62,99,21101,333,0,1,21102,1,73,0,1105,1,579,1102,1,0,572,1101,0,0,573,3,574,101,1,573,573,1007,574,65,570,1005,570,151,107,67,574,570,1005,570,151,1001,574,-64,574,1002,574,-1,574,1001,572,1,572,1007,572,11,570,1006,570,165,101,1182,572,127,101,0,574,0,3,574,101,1,573,573,1008,574,10,570,1005,570,189,1008,574,44,570,1006,570,158,1106,0,81,21102,1,340,1,1105,1,177,21101,0,477,1,1105,1,177,21102,1,514,1,21102,1,176,0,1105,1,579,99,21101,0,184,0,1105,1,579,4,574,104,10,99,1007,573,22,570,1006,570,165,1002,572,1,1182,21101,0,375,1,21101,211,0,0,1105,1,579,21101,1182,11,1,21102,222,1,0,1106,0,979,21102,1,388,1,21102,1,233,0,1106,0,579,21101,1182,22,1,21101,0,244,0,1106,0,979,21102,401,1,1,21102,1,255,0,1105,1,579,21101,1182,33,1,21101,266,0,0,1106,0,979,21101,414,0,1,21102,277,1,0,1105,1,579,3,575,1008,575,89,570,1008,575,121,575,1,575,570,575,3,574,1008,574,10,570,1006,570,291,104,10,21102,1182,1,1,21102,313,1,0,1105,1,622,1005,575,327,1101,1,0,575,21101,0,327,0,1105,1,786,4,438,99,0,1,1,6,77,97,105,110,58,10,33,10,69,120,112,101,99,116,101,100,32,102,117,110,99,116,105,111,110,32,110,97,109,101,32,98,117,116,32,103,111,116,58,32,0,12,70,117,110,99,116,105,111,110,32,65,58,10,12,70,117,110,99,116,105,111,110,32,66,58,10,12,70,117,110,99,116,105,111,110,32,67,58,10,23,67,111,110,116,105,110,117,111,117,115,32,118,105,100,101,111,32,102,101,101,100,63,10,0,37,10,69,120,112,101,99,116,101,100,32,82,44,32,76,44,32,111,114,32,100,105,115,116,97,110,99,101,32,98,117,116,32,103,111,116,58,32,36,10,69,120,112,101,99,116,101,100,32,99,111,109,109,97,32,111,114,32,110,101,119,108,105,110,101,32,98,117,116,32,103,111,116,58,32,43,10,68,101,102,105,110,105,116,105,111,110,115,32,109,97,121,32,98,101,32,97,116,32,109,111,115,116,32,50,48,32,99,104,97,114,97,99,116,101,114,115,33,10,94,62,118,60,0,1,0,-1,-1,0,1,0,0,0,0,0,0,1,28,0,0,109,4,1202,-3,1,587,20101,0,0,-1,22101,1,-3,-3,21101,0,0,-2,2208,-2,-1,570,1005,570,617,2201,-3,-2,609,4,0,21201,-2,1,-2,1106,0,597,109,-4,2106,0,0,109,5,1202,-4,1,630,20102,1,0,-2,22101,1,-4,-4,21102,0,1,-3,2208,-3,-2,570,1005,570,781,2201,-4,-3,652,21001,0,0,-1,1208,-1,-4,570,1005,570,709,1208,-1,-5,570,1005,570,734,1207,-1,0,570,1005,570,759,1206,-1,774,1001,578,562,684,1,0,576,576,1001,578,566,692,1,0,577,577,21101,0,702,0,1105,1,786,21201,-1,-1,-1,1106,0,676,1001,578,1,578,1008,578,4,570,1006,570,724,1001,578,-4,578,21102,731,1,0,1105,1,786,1106,0,774,1001,578,-1,578,1008,578,-1,570,1006,570,749,1001,578,4,578,21102,1,756,0,1105,1,786,1106,0,774,21202,-1,-11,1,22101,1182,1,1,21101,0,774,0,1106,0,622,21201,-3,1,-3,1106,0,640,109,-5,2106,0,0,109,7,1005,575,802,20102,1,576,-6,20102,1,577,-5,1105,1,814,21101,0,0,-1,21101,0,0,-5,21101,0,0,-6,20208,-6,576,-2,208,-5,577,570,22002,570,-2,-2,21202,-5,37,-3,22201,-6,-3,-3,22101,1481,-3,-3,1201,-3,0,843,1005,0,863,21202,-2,42,-4,22101,46,-4,-4,1206,-2,924,21101,1,0,-1,1106,0,924,1205,-2,873,21102,1,35,-4,1106,0,924,1201,-3,0,878,1008,0,1,570,1006,570,916,1001,374,1,374,2101,0,-3,895,1102,2,1,0,2102,1,-3,902,1001,438,0,438,2202,-6,-5,570,1,570,374,570,1,570,438,438,1001,578,558,921,21002,0,1,-4,1006,575,959,204,-4,22101,1,-6,-6,1208,-6,37,570,1006,570,814,104,10,22101,1,-5,-5,1208,-5,43,570,1006,570,810,104,10,1206,-1,974,99,1206,-1,974,1101,0,1,575,21101,0,973,0,1106,0,786,99,109,-7,2105,1,0,109,6,21101,0,0,-4,21101,0,0,-3,203,-2,22101,1,-3,-3,21208,-2,82,-1,1205,-1,1030,21208,-2,76,-1,1205,-1,1037,21207,-2,48,-1,1205,-1,1124,22107,57,-2,-1,1205,-1,1124,21201,-2,-48,-2,1105,1,1041,21102,-4,1,-2,1105,1,1041,21101,-5,0,-2,21201,-4,1,-4,21207,-4,11,-1,1206,-1,1138,2201,-5,-4,1059,1201,-2,0,0,203,-2,22101,1,-3,-3,21207,-2,48,-1,1205,-1,1107,22107,57,-2,-1,1205,-1,1107,21201,-2,-48,-2,2201,-5,-4,1090,20102,10,0,-1,22201,-2,-1,-2,2201,-5,-4,1103,1201,-2,0,0,1106,0,1060,21208,-2,10,-1,1205,-1,1162,21208,-2,44,-1,1206,-1,1131,1105,1,989,21101,439,0,1,1105,1,1150,21102,1,477,1,1106,0,1150,21101,514,0,1,21101,0,1149,0,1105,1,579,99,21101,1157,0,0,1105,1,579,204,-2,104,10,99,21207,-3,22,-1,1206,-1,1138,1201,-5,0,1176,2101,0,-4,0,109,-6,2106,0,0,28,9,36,1,36,1,36,1,36,1,36,1,26,9,1,1,26,1,7,1,1,1,22,11,1,1,1,1,22,1,3,1,5,1,1,1,1,1,2,13,7,1,3,11,2,1,11,1,7,1,9,1,1,1,4,1,11,1,7,1,9,1,1,1,4,1,11,1,7,1,9,1,1,1,4,1,5,13,1,1,9,1,1,1,4,1,5,1,5,1,5,1,1,1,9,1,1,1,2,11,3,1,5,1,1,13,2,1,1,1,5,1,1,1,3,1,5,1,11,1,4,1,1,1,5,1,1,1,3,1,5,13,4,1,1,1,5,1,1,1,3,1,22,1,1,9,3,1,15,1,6,1,7,1,5,1,15,1,6,1,7,1,1,5,15,1,6,1,7,1,1,1,19,1,6,1,7,1,1,1,19,1,6,1,7,1,1,1,19,1,6,9,1,1,19,1,16,1,19,1,12,13,11,1,12,1,3,1,7,1,11,1,12,1,3,1,7,1,11,1,12,1,3,1,7,1,11,1,12,1,3,1,1,5,1,13,12,1,3,1,1,1,3,1,26,1,3,13,20,1,5,1,3,1,5,1,20,1,5,1,3,1,5,1,20,1,5,1,3,1,5,1,20,1,5,1,3,1,5,1,20,1,5,1,3,1,5,1,20,11,5,1,26,1,9,1,26,11,14"""


main =
    mainPart2


type Element
    = Robot Direction
    | Scaffold
    | OpenSpace
    | NewLine
    | FallenRobot


type Direction
    = Up
    | Down
    | Left
    | Right


type RobotInstruction
    = TurnLeft
    | TurnRight
    | MoveForward Int



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

        map =
            getMap instructions

        width =
            Array.get 0 map
                |> unsafeMaybe "No row found in the map"
                |> Array.length

        height =
            Array.length map
    in
    List.range 1 (height - 2)
        |> List.concatMap (\x -> List.range 1 (width - 2) |> List.map (Tuple.pair x))
        |> List.filter (isIntersection map)
        |> List.map computeAlignment
        |> List.sum
        |> String.fromInt
        |> text


getMap : Dict Int Int -> Array (Array Element)
getMap instructions =
    let
        iterationStatus =
            iterate (RelativeBase 0) 0 [] instructions

        outputs =
            case iterationStatus of
                WaitingInput ( _, outputs_ ) ->
                    outputs_

                Halted outputs_ ->
                    outputs_
    in
    List.reverse outputs
        |> List.map codeToElement
        |> List.groupWhile (\_ b -> b /= NewLine)
        |> List.map (\( first, others ) -> first :: others)
        |> List.map (List.filter ((/=) NewLine))
        |> List.filterNot List.isEmpty
        |> List.map Array.fromList
        |> Array.fromList


computeAlignment : ( Int, Int ) -> Int
computeAlignment ( x, y ) =
    x * y


isIntersection : Array (Array Element) -> ( Int, Int ) -> Bool
isIntersection map ( x, y ) =
    let
        elementAt ( x_, y_ ) =
            Array.get x_ map
                |> unsafeMaybe "row not found"
                |> Array.get y_
                |> unsafeMaybe ("column not found: " ++ String.fromInt y_ ++ " in row: " ++ String.fromInt x_)
    in
    isRobotOrScaffold (elementAt ( x, y ))
        && ([ ( x - 1, y ), ( x + 1, y ), ( x, y - 1 ), ( x, y + 1 ) ]
                |> List.map elementAt
                |> List.all isRobotOrScaffold
           )


isRobotOrScaffold : Element -> Bool
isRobotOrScaffold element =
    case element of
        Robot _ ->
            True

        Scaffold ->
            True

        _ ->
            False


codeToElement : Int -> Element
codeToElement code =
    case code of
        10 ->
            NewLine

        35 ->
            Scaffold

        46 ->
            OpenSpace

        88 ->
            FallenRobot

        118 ->
            Robot Down

        94 ->
            Robot Up

        60 ->
            Robot Left

        62 ->
            Robot Right

        _ ->
            Debug.todo ("Invalid ASCII value: " ++ String.fromInt code)



-- Part 2 --


mainPart2 =
    let
        instructions =
            parse input

        map =
            getMap instructions

        program =
            getProgram map

        programCodes =
            List.map instructionsToCode program

        subsequences =
            (nGrams 3 programCodes |> List.unique)
                ++ (nGrams 4 programCodes |> List.unique)
                ++ (nGrams 5 programCodes |> List.unique)
                ++ (nGrams 6 programCodes |> List.unique)
                ++ (nGrams 7 programCodes |> List.unique)
                ++ (nGrams 8 programCodes |> List.unique)
                ++ (nGrams 9 programCodes |> List.unique)
                ++ (nGrams 10 programCodes |> List.unique)
                |> List.map (\nGram -> ( nGram, countOccurences nGram programCodes ))
                |> List.filter (\( _, occurrences ) -> occurrences > 2)
                |> List.map Tuple.first

        combinations =
            List.cartesianProduct [ subsequences, subsequences, subsequences ]

        solution =
            List.find
                (\sequences ->
                    List.foldr removeSubsequences programCodes sequences
                        |> List.isEmpty
                )
                combinations
    in
    case solution of
        Just (firstGroup :: secondGroup :: thirdGroup :: []) ->
            let
                mainSequence =
                    prepareMainSequence firstGroup secondGroup thirdGroup programCodes

                iterationStatus =
                    Dict.insert 0 2 instructions
                        |> iterate (RelativeBase 0) 0 []
            in
            applySequence mainSequence iterationStatus
                |> applySequence firstGroup
                |> applySequence secondGroup
                |> applySequence thirdGroup
                |> applySequence [ Char.toCode 'n' ]
                |> getResult
                |> String.fromInt
                |> text

        _ ->
            Debug.todo "Unable to find a candidate solution!"


getResult : IterationStatus -> Int
getResult iterationStatus =
    case iterationStatus of
        WaitingInput _ ->
            Debug.todo "No result found: program not halted"

        Halted outputs ->
            List.head outputs
                |> unsafeMaybe "Program halted without outputs"


applySequence : List Int -> IterationStatus -> IterationStatus
applySequence sequence iterationStatus =
    (List.intersperse (Char.toCode ',') sequence
        |> List.concatMap
            (\a ->
                if a < 30 then
                    String.fromInt a
                        |> String.toList
                        |> List.map Char.toCode

                else
                    [ a ]
            )
    )
        ++ [ 10 ]
        |> applyInputs iterationStatus


applyInputs : IterationStatus -> List Int -> IterationStatus
applyInputs iterationStatus inputs =
    case iterationStatus of
        WaitingInput ( toContinue, outputs ) ->
            case inputs of
                first :: others ->
                    applyInputs (toContinue first) others

                [] ->
                    iterationStatus

        Halted _ ->
            iterationStatus


prepareMainSequence : List Int -> List Int -> List Int -> List Int -> List Int
prepareMainSequence a b c list =
    case list of
        [] ->
            []

        _ ->
            if List.isPrefixOf a list then
                Char.toCode 'A' :: (List.drop (List.length a) list |> prepareMainSequence a b c)

            else if List.isPrefixOf b list then
                Char.toCode 'B' :: (List.drop (List.length b) list |> prepareMainSequence a b c)

            else if List.isPrefixOf c list then
                Char.toCode 'C' :: (List.drop (List.length c) list |> prepareMainSequence a b c)

            else
                Debug.todo "Sequence not handled 😱"


instructionsToCode : RobotInstruction -> Int
instructionsToCode robotInstruction =
    case robotInstruction of
        TurnLeft ->
            Char.toCode 'L'

        TurnRight ->
            Char.toCode 'R'

        MoveForward step ->
            step


nGrams : Int -> List a -> List (List a)
nGrams size list =
    List.groupsOfWithStep size 1 list


removeSubsequences : List a -> List a -> List a
removeSubsequences toRemove list =
    case list of
        [] ->
            []

        first :: others ->
            if List.isPrefixOf toRemove list then
                List.drop (List.length toRemove) list
                    |> removeSubsequences toRemove

            else
                first :: removeSubsequences toRemove others


countOccurences : List a -> List a -> Int
countOccurences toFind list =
    let
        score =
            if List.isPrefixOf toFind list then
                1

            else
                0
    in
    case list of
        [] ->
            0

        _ :: others ->
            score + countOccurences toFind others


getProgram : Array (Array Element) -> List RobotInstruction
getProgram map =
    let
        ( startPosition, startDirection ) =
            getRobot map
    in
    computePath map startPosition startDirection []


computePath : Array (Array Element) -> ( Int, Int ) -> Direction -> List RobotInstruction -> List RobotInstruction
computePath map ( x, y ) direction instructions =
    let
        rightDirection =
            turnRight direction

        leftDirection =
            turnLeft direction

        rightDistance =
            calculateDistanceForward map ( x, y ) rightDirection

        leftDistance =
            calculateDistanceForward map ( x, y ) leftDirection
    in
    if rightDistance > 0 then
        computePath map (move ( x, y ) rightDirection rightDistance) rightDirection (instructions ++ [ TurnRight, MoveForward rightDistance ])

    else if leftDistance > 0 then
        computePath map (move ( x, y ) leftDirection leftDistance) leftDirection (instructions ++ [ TurnLeft, MoveForward leftDistance ])

    else
        instructions


move : ( Int, Int ) -> Direction -> Int -> ( Int, Int )
move ( x, y ) direction steps =
    case direction of
        Up ->
            ( x - steps, y )

        Down ->
            ( x + steps, y )

        Left ->
            ( x, y - steps )

        Right ->
            ( x, y + steps )


calculateDistanceForward : Array (Array Element) -> ( Int, Int ) -> Direction -> Int
calculateDistanceForward map ( x, y ) direction =
    let
        ( xForward, yForward ) =
            move ( x, y ) direction 1

        elementForward =
            Array.get xForward map
                |> Maybe.andThen (Array.get yForward)
    in
    case elementForward of
        Just Scaffold ->
            1 + calculateDistanceForward map ( xForward, yForward ) direction

        _ ->
            0


turnRight : Direction -> Direction
turnRight direction =
    case direction of
        Up ->
            Right

        Down ->
            Left

        Left ->
            Up

        Right ->
            Down


turnLeft : Direction -> Direction
turnLeft direction =
    case direction of
        Down ->
            Right

        Up ->
            Left

        Right ->
            Up

        Left ->
            Down


getRobot : Array (Array Element) -> ( ( Int, Int ), Direction )
getRobot map =
    Array.indexedMapToList
        (\x row ->
            Array.indexedMapToList
                (\y element ->
                    case element of
                        Robot direction ->
                            Just ( ( x, y ), direction )

                        _ ->
                            Nothing
                )
                row
        )
        map
        |> List.concat
        |> List.filterMap identity
        |> List.head
        |> unsafeMaybe "This is not the droid you are looking for"


displayMap : Array (Array Element) -> Html msg
displayMap map =
    Array.map Array.toList map
        |> Array.toList
        |> List.map (List.map toCell)
        |> List.map (div [ style "display" "flex" ])
        |> div []


toCell : Element -> Html msg
toCell element =
    div
        [ style "width" "15px"
        , style "height" "15px"
        , style "background-color" (elementToColor element)
        , style "border" "1px solid lightgrey"
        , style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ case element of
            Robot Up ->
                text "^"

            Robot Down ->
                text "v"

            Robot Left ->
                text "<"

            Robot Right ->
                text ">"

            _ ->
                text ""
        ]


elementToColor : Element -> String
elementToColor element =
    case element of
        Robot _ ->
            "green"

        Scaffold ->
            "gray"

        OpenSpace ->
            "white"

        NewLine ->
            "transparent"

        FallenRobot ->
            "red"



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
