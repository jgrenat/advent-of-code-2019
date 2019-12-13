module Day11 exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Set exposing (Set)
import String.Extra as String


input : String
input =
    """3,8,1005,8,358,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,101,0,8,29,1,1104,7,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,54,1,103,17,10,1,7,3,10,2,8,9,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,102,1,8,89,1,1009,16,10,1006,0,86,1006,0,89,1006,0,35,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,102,1,8,124,1,105,8,10,1,2,0,10,1,1106,5,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,1001,8,0,158,1,102,2,10,1,109,17,10,1,109,6,10,1,1003,1,10,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,1001,8,0,195,1006,0,49,1,101,5,10,1006,0,5,1,108,6,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,232,2,1102,9,10,1,1108,9,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,1002,8,1,262,1006,0,47,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,101,0,8,286,1006,0,79,2,1003,2,10,2,107,0,10,1006,0,89,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,323,1006,0,51,2,5,1,10,1,6,15,10,2,1102,3,10,101,1,9,9,1007,9,905,10,1005,10,15,99,109,680,104,0,104,1,21101,838211572492,0,1,21101,0,375,0,1106,0,479,21102,1,48063328668,1,21102,386,1,0,1106,0,479,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,1,21679533248,1,21101,0,433,0,1105,1,479,21102,235190455527,1,1,21102,444,1,0,1106,0,479,3,10,104,0,104,0,3,10,104,0,104,0,21101,0,837901247244,1,21102,1,467,0,1106,0,479,21101,0,709488169828,1,21102,1,478,0,1105,1,479,99,109,2,22102,1,-1,1,21102,1,40,2,21101,0,510,3,21102,1,500,0,1105,1,543,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,505,506,521,4,0,1001,505,1,505,108,4,505,10,1006,10,537,1102,1,0,505,109,-2,2106,0,0,0,109,4,2101,0,-1,542,1207,-3,0,10,1006,10,560,21101,0,0,-3,21201,-3,0,1,21202,-2,1,2,21102,1,1,3,21102,1,579,0,1105,1,584,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,607,2207,-4,-2,10,1006,10,607,21202,-4,1,-4,1106,0,675,21202,-4,1,1,21201,-3,-1,2,21202,-2,2,3,21101,0,626,0,1106,0,584,22101,0,1,-4,21102,1,1,-1,2207,-4,-2,10,1006,10,645,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,667,22101,0,-1,1,21102,1,667,0,105,1,542,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0"""



-- part 1


type alias BoardStatus =
    { panels : Dict Position Color
    , paintedPanels : Set Position
    , currentPosition : Position
    , currentDirection : Direction
    }


type Direction
    = Up
    | Down
    | Left
    | Right


type alias Position =
    ( Int, Int )


type Color
    = Black
    | White


main =
    mainStep2


parse : String -> Dict Int Int
parse stringValues =
    String.split "," stringValues
        |> List.filter (String.isBlank >> not)
        |> List.map String.toInt
        |> List.map (Maybe.withDefault 0)
        |> List.indexedMap Tuple.pair
        |> Dict.fromList


mainStep1 =
    parse input
        |> iterate (RelativeBase 0) 0 []
        |> (\iterationStatus ->
                runRobot 0
                    { panels = Dict.empty
                    , paintedPanels = Set.empty
                    , currentPosition = ( 0, 0 )
                    , currentDirection = Up
                    }
                    iterationStatus
           )
        |> .paintedPanels
        |> Set.toList
        |> List.length
        |> String.fromInt
        |> text


runRobot : Int -> BoardStatus -> IterationStatus -> BoardStatus
runRobot startingColorCode boardStatus iterationStatus =
    case iterationStatus of
        Halted ->
            boardStatus

        WaitingInput ( continueIteration, outputs ) ->
            case outputs of
                move :: paintColor :: [] ->
                    let
                        ( newPosition, newDirection ) =
                            moveRobot boardStatus.currentPosition boardStatus.currentDirection move

                        newBoardStatus =
                            { boardStatus
                                | currentPosition = newPosition
                                , currentDirection = newDirection
                                , paintedPanels = Set.insert boardStatus.currentPosition boardStatus.paintedPanels
                                , panels = paintPanel boardStatus.currentPosition paintColor boardStatus.panels
                            }

                        newColor =
                            getColorCode newPosition boardStatus.panels
                    in
                    runRobot startingColorCode newBoardStatus (continueIteration newColor)

                _ ->
                    runRobot startingColorCode boardStatus (continueIteration startingColorCode)


paintPanel : Position -> Int -> Dict Position Color -> Dict Position Color
paintPanel position colorCode panels =
    let
        color =
            case colorCode of
                0 ->
                    Black

                1 ->
                    White

                _ ->
                    Debug.todo ("Invalid color code: " ++ String.fromInt colorCode)
    in
    Dict.insert position color panels


moveRobot : Position -> Direction -> Int -> ( Position, Direction )
moveRobot ( x, y ) direction moveCode =
    case ( moveCode, direction ) of
        ( 0, Up ) ->
            ( ( x - 1, y ), Left )

        ( 1, Up ) ->
            ( ( x + 1, y ), Right )

        ( 0, Right ) ->
            ( ( x, y - 1 ), Up )

        ( 1, Right ) ->
            ( ( x, y + 1 ), Down )

        ( 0, Down ) ->
            ( ( x + 1, y ), Right )

        ( 1, Down ) ->
            ( ( x - 1, y ), Left )

        ( 0, Left ) ->
            ( ( x, y + 1 ), Down )

        ( 1, Left ) ->
            ( ( x, y - 1 ), Up )

        ( _, _ ) ->
            Debug.todo ("Invalid move code: " ++ String.fromInt moveCode)


getColorCode : Position -> Dict Position Color -> Int
getColorCode position panels =
    let
        color =
            Dict.get position panels |> Maybe.withDefault Black
    in
    case color of
        Black ->
            0

        White ->
            1



-- step 2 --


mainStep2 =
    let
        panels =
            parse input
                |> iterate (RelativeBase 0) 0 []
                |> (\iterationStatus ->
                        runRobot 1
                            { panels = Dict.empty
                            , paintedPanels = Set.empty
                            , currentPosition = ( 0, 0 )
                            , currentDirection = Up
                            }
                            iterationStatus
                   )
                |> .panels

        panelsPositions =
            Dict.toList panels
                |> List.map Tuple.first

        minX =
            panelsPositions
                |> List.map Tuple.first
                |> List.minimum
                |> unsafeMaybe "Unable to find min X"

        maxX =
            panelsPositions
                |> List.map Tuple.first
                |> List.maximum
                |> unsafeMaybe "Unable to find max X"

        minY =
            panelsPositions
                |> List.map Tuple.second
                |> List.minimum
                |> unsafeMaybe "Unable to find min X"

        maxY =
            panelsPositions
                |> List.map Tuple.second
                |> List.maximum
                |> unsafeMaybe "Unable to find max X"
    in
    List.range minY maxY
        |> List.map (\y -> List.range minX maxX |> List.map (\x -> ( x, y )))
        |> List.map (List.map (\position -> Dict.get position panels |> Maybe.withDefault Black))
        |> List.map (List.map toCell)
        |> List.map (div [ style "display" "flex" ])
        |> div []


toCell : Color -> Html msg
toCell color =
    div [ style "width" "10px", style "height" "10px", style "background-color" (colorToString color) ] []


colorToString : Color -> String
colorToString color =
    case color of
        Black ->
            "black"

        White ->
            "white"



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
    | Halted


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
            Halted

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
