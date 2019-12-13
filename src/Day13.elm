module Day13 exposing (..)

import Browser
import Browser.Events as Browser
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Json.Decode as Decode exposing (Decoder)
import List.Extra as List
import String.Extra as String


input : String
input =
    """1,380,379,385,1008,2563,747932,381,1005,381,12,99,109,2564,1101,0,0,383,1101,0,0,382,20102,1,382,1,21002,383,1,2,21101,37,0,0,1105,1,578,4,382,4,383,204,1,1001,382,1,382,1007,382,37,381,1005,381,22,1001,383,1,383,1007,383,26,381,1005,381,18,1006,385,69,99,104,-1,104,0,4,386,3,384,1007,384,0,381,1005,381,94,107,0,384,381,1005,381,108,1106,0,161,107,1,392,381,1006,381,161,1102,1,-1,384,1105,1,119,1007,392,35,381,1006,381,161,1101,0,1,384,20101,0,392,1,21102,1,24,2,21101,0,0,3,21102,138,1,0,1105,1,549,1,392,384,392,21001,392,0,1,21102,1,24,2,21102,1,3,3,21101,161,0,0,1106,0,549,1102,1,0,384,20001,388,390,1,21002,389,1,2,21101,180,0,0,1105,1,578,1206,1,213,1208,1,2,381,1006,381,205,20001,388,390,1,20101,0,389,2,21101,205,0,0,1106,0,393,1002,390,-1,390,1101,0,1,384,21001,388,0,1,20001,389,391,2,21101,0,228,0,1105,1,578,1206,1,261,1208,1,2,381,1006,381,253,20102,1,388,1,20001,389,391,2,21101,0,253,0,1106,0,393,1002,391,-1,391,1102,1,1,384,1005,384,161,20001,388,390,1,20001,389,391,2,21101,0,279,0,1105,1,578,1206,1,316,1208,1,2,381,1006,381,304,20001,388,390,1,20001,389,391,2,21101,0,304,0,1106,0,393,1002,390,-1,390,1002,391,-1,391,1101,1,0,384,1005,384,161,21002,388,1,1,20102,1,389,2,21102,0,1,3,21101,0,338,0,1105,1,549,1,388,390,388,1,389,391,389,20102,1,388,1,20101,0,389,2,21101,0,4,3,21101,0,365,0,1105,1,549,1007,389,25,381,1005,381,75,104,-1,104,0,104,0,99,0,1,0,0,0,0,0,0,369,16,21,1,1,18,109,3,22101,0,-2,1,21202,-1,1,2,21102,0,1,3,21101,0,414,0,1105,1,549,21201,-2,0,1,21201,-1,0,2,21102,429,1,0,1105,1,601,1201,1,0,435,1,386,0,386,104,-1,104,0,4,386,1001,387,-1,387,1005,387,451,99,109,-3,2105,1,0,109,8,22202,-7,-6,-3,22201,-3,-5,-3,21202,-4,64,-2,2207,-3,-2,381,1005,381,492,21202,-2,-1,-1,22201,-3,-1,-3,2207,-3,-2,381,1006,381,481,21202,-4,8,-2,2207,-3,-2,381,1005,381,518,21202,-2,-1,-1,22201,-3,-1,-3,2207,-3,-2,381,1006,381,507,2207,-3,-4,381,1005,381,540,21202,-4,-1,-1,22201,-3,-1,-3,2207,-3,-4,381,1006,381,529,21202,-3,1,-7,109,-8,2106,0,0,109,4,1202,-2,37,566,201,-3,566,566,101,639,566,566,1201,-1,0,0,204,-3,204,-2,204,-1,109,-4,2105,1,0,109,3,1202,-1,37,593,201,-2,593,593,101,639,593,593,21001,0,0,-2,109,-3,2106,0,0,109,3,22102,26,-2,1,22201,1,-1,1,21102,1,487,2,21101,0,575,3,21102,1,962,4,21102,1,630,0,1105,1,456,21201,1,1601,-2,109,-3,2105,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,2,2,2,2,0,2,0,0,0,2,0,2,2,2,2,2,2,0,2,2,2,0,2,0,2,0,2,2,0,2,2,0,2,0,1,1,0,2,0,0,2,0,2,2,2,0,2,2,2,2,2,2,2,2,2,0,2,2,0,2,2,2,2,2,0,2,2,2,0,0,0,1,1,0,2,0,2,2,2,0,0,2,2,2,2,0,2,0,2,0,0,2,2,2,2,2,2,2,0,2,2,0,2,0,0,2,0,0,1,1,0,2,0,2,2,2,2,0,2,2,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,2,2,2,0,0,2,0,0,2,0,1,1,0,0,2,0,0,0,0,2,0,2,0,2,2,2,2,0,0,2,0,2,2,0,0,2,2,0,2,0,2,2,2,2,0,2,0,1,1,0,2,2,0,2,2,0,0,0,0,0,2,0,2,0,0,2,2,2,0,2,2,0,2,2,2,2,0,2,2,2,2,0,0,0,1,1,0,2,2,2,2,2,2,0,2,0,2,2,2,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,2,0,2,0,0,1,1,0,2,2,2,2,2,0,0,2,0,2,0,2,2,0,0,0,0,2,0,0,2,2,2,2,2,2,0,0,0,2,2,2,0,0,1,1,0,0,2,2,2,2,0,0,2,0,2,2,0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,2,2,2,0,0,0,2,0,1,1,0,2,0,2,2,2,0,2,0,2,2,2,2,0,2,2,2,2,0,0,2,2,0,0,2,0,0,0,2,2,2,2,0,0,0,1,1,0,2,0,2,2,2,2,2,2,2,0,0,2,0,0,2,2,2,0,0,2,2,0,2,0,2,0,2,2,2,2,2,0,2,0,1,1,0,2,2,2,0,2,0,2,2,0,2,2,2,2,2,0,0,0,2,2,0,2,2,0,2,0,0,0,0,2,2,2,0,0,0,1,1,0,2,2,0,0,2,2,2,0,0,2,0,2,2,2,0,0,2,2,2,0,0,2,2,2,2,0,0,0,2,0,2,2,2,0,1,1,0,0,0,0,0,2,2,0,2,2,0,2,2,0,2,2,2,0,0,0,2,2,0,0,2,2,0,2,0,0,2,2,0,2,0,1,1,0,2,0,2,0,2,2,0,0,2,2,0,2,0,2,0,2,2,0,2,0,0,2,2,0,2,2,0,2,2,2,2,2,2,0,1,1,0,2,0,0,2,0,2,2,2,0,2,2,2,2,2,2,0,0,2,0,0,2,2,0,0,2,2,2,2,0,0,2,2,0,0,1,1,0,2,2,2,2,0,2,2,2,0,2,2,2,2,0,0,2,2,2,0,2,0,2,0,2,2,0,2,2,0,0,2,2,0,0,1,1,0,2,2,2,2,2,0,0,0,2,2,2,2,2,2,0,2,2,2,0,2,2,0,2,2,2,2,2,0,0,0,2,2,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,36,15,49,65,33,64,90,69,80,38,6,11,42,79,20,83,19,67,76,39,23,24,21,94,31,77,25,39,50,66,66,19,40,89,50,59,3,34,57,47,41,75,90,15,29,53,32,72,19,20,88,89,42,54,77,15,96,66,74,77,51,46,71,16,76,96,20,52,26,56,86,80,43,98,91,64,12,86,11,44,14,18,35,40,53,17,44,43,29,69,75,25,8,46,26,18,14,61,89,42,10,21,57,69,13,74,3,68,8,46,35,29,35,79,81,28,30,87,3,67,75,1,95,98,88,18,29,40,28,23,17,5,52,51,5,40,42,89,31,86,67,42,53,43,42,45,63,43,10,46,95,10,26,65,77,38,24,17,30,21,18,25,59,25,72,54,83,34,36,48,60,48,28,3,6,14,92,84,20,31,68,38,16,11,95,36,89,38,69,70,73,49,15,23,70,65,23,11,34,69,6,60,11,38,70,75,18,43,29,53,26,59,95,27,46,3,78,68,7,61,36,20,77,54,43,54,45,26,86,98,21,11,83,60,30,47,46,83,25,74,36,3,54,22,98,70,10,49,35,14,24,38,31,77,95,33,8,17,43,42,93,81,56,13,72,60,18,70,36,64,15,24,49,60,92,47,67,34,24,58,15,96,13,83,55,67,17,43,84,72,55,38,43,90,94,55,11,56,16,8,68,87,14,19,93,6,23,21,41,17,19,13,37,85,69,77,83,91,70,61,5,13,98,87,45,88,13,71,63,98,41,13,81,19,30,34,83,44,70,84,76,22,68,30,55,42,96,1,71,42,32,95,14,33,50,96,61,95,35,18,67,84,7,39,10,95,7,33,69,55,82,19,94,52,60,46,63,62,93,92,39,69,42,60,35,64,69,62,50,29,13,53,90,62,1,45,92,16,89,3,8,81,45,61,88,12,34,27,23,31,73,65,30,43,19,9,44,45,81,17,57,18,3,64,84,70,15,49,34,53,62,58,11,39,90,28,81,61,38,11,96,52,92,71,49,22,69,25,23,4,98,98,3,83,29,70,39,59,79,56,21,45,75,82,48,52,60,44,89,57,42,63,67,30,16,57,26,28,17,65,90,73,22,8,26,72,47,13,68,19,45,45,49,26,20,6,35,65,85,1,59,51,27,13,88,84,63,66,12,78,43,60,79,92,31,44,72,1,18,12,95,6,50,61,66,79,81,21,8,81,33,63,67,31,12,92,48,13,17,27,15,43,45,1,7,58,17,97,45,36,61,28,23,87,97,27,5,97,2,84,30,29,36,60,95,21,97,32,76,78,83,93,28,35,73,26,27,10,90,50,29,24,78,1,71,6,76,44,89,6,94,44,17,80,66,5,43,23,49,52,40,47,39,81,80,80,87,38,26,2,43,97,15,50,79,73,32,73,12,20,53,73,82,7,38,63,78,68,29,96,14,29,52,54,95,6,59,93,98,46,66,91,16,88,95,55,37,2,44,16,97,30,35,19,96,3,8,47,64,4,49,74,89,1,76,90,77,80,46,48,63,11,93,97,71,37,82,75,91,7,33,20,59,8,93,83,83,49,85,92,33,89,58,72,37,27,56,37,91,39,7,52,19,77,20,3,52,57,12,63,14,34,6,89,93,21,62,53,75,3,97,76,75,68,24,83,84,26,66,16,45,46,6,57,48,84,29,1,60,89,63,40,29,63,63,70,10,74,97,94,95,49,55,87,98,2,98,50,93,18,88,39,80,34,41,57,78,12,41,15,13,11,55,22,65,37,21,46,78,17,78,8,62,1,16,9,33,94,26,55,33,22,25,22,93,71,62,82,51,86,66,97,88,82,9,93,9,30,46,37,95,36,21,80,21,36,89,96,44,97,80,42,29,82,87,78,4,58,19,80,95,85,90,64,4,27,65,5,64,71,43,64,92,92,23,80,14,61,12,11,41,12,16,49,93,67,27,68,29,35,66,14,10,46,11,12,79,76,26,62,4,51,35,22,67,83,62,94,95,53,1,94,61,91,5,54,68,24,3,24,98,38,33,78,72,15,9,82,21,59,73,39,23,97,5,13,39,90,61,10,73,92,48,34,47,54,3,54,69,89,67,13,54,41,51,92,51,59,53,76,3,38,93,45,28,10,90,78,40,24,14,58,72,98,19,70,79,18,62,20,79,3,79,73,54,17,10,31,1,70,42,77,747932"""


main =
    mainPart2


type alias Position =
    ( Int, Int )


type Element
    = Empty
    | Wall
    | Block
    | HorizontalPaddle
    | Ball


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
        result =
            parse input
                |> iterate (RelativeBase 0) 0 []
    in
    case result of
        WaitingInput _ ->
            Debug.todo "Program is waiting input but shouldn't."

        Halted outputs ->
            List.reverse outputs
                |> buildBoard Dict.empty 0
                |> Tuple.first
                |> Dict.toList
                |> List.count (\( _, element ) -> element == Block)
                |> String.fromInt
                |> text


buildBoard : Dict Position Element -> Score -> List Output -> ( Dict Position Element, Int )
buildBoard board score outputs =
    case outputs of
        [] ->
            ( board, score )

        x :: y :: elementCodeOrScore :: remainingOutputs ->
            if ( x, y ) == ( -1, 0 ) then
                buildBoard board elementCodeOrScore remainingOutputs

            else
                let
                    newBoard =
                        Dict.insert ( x, y ) (elementFromCode elementCodeOrScore) board
                in
                buildBoard newBoard score remainingOutputs

        _ ->
            Debug.todo "Invalid number of remaining outputs: not a multiple of 3"


elementFromCode : Int -> Element
elementFromCode code =
    case code of
        0 ->
            Empty

        1 ->
            Wall

        2 ->
            Block

        3 ->
            HorizontalPaddle

        4 ->
            Ball

        _ ->
            Debug.todo ("Invalid element code: " ++ String.fromInt code)



-- part 2 --


type Msg
    = MovePaddle Move
    | BackInTime


mainPart2 : Program () Model Msg
mainPart2 =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { board : Dict Position Element
    , score : Int
    , status : IterationStatus
    , previousStates : List SavedState
    }


type alias SavedState =
    { board : Dict Position Element
    , score : Int
    , status : IterationStatus
    }


type Move
    = Left
    | Right
    | NoMove


init : () -> ( Model, Cmd Msg )
init () =
    let
        firstIterationStatus =
            parse input
                |> Dict.insert 0 2
                |> iterate (RelativeBase 0) 0 []

        ( board, score ) =
            statusToBoardAndScore 0 Dict.empty firstIterationStatus
    in
    ( Model board score firstIterationStatus [], Cmd.none )


statusToBoardAndScore : Score -> Dict Position Element -> IterationStatus -> ( Dict Position Element, Int )
statusToBoardAndScore score board iterationStatus =
    case iterationStatus of
        WaitingInput ( _, outputs ) ->
            List.reverse outputs
                |> buildBoard board score

        Halted outputs ->
            List.reverse outputs
                |> buildBoard board score


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( model.status, msg ) of
        ( WaitingInput ( continue, _ ), MovePaddle move ) ->
            let
                newIterationStatus =
                    continue (moveToCode move)

                ( newBoard, newScore ) =
                    statusToBoardAndScore model.score model.board newIterationStatus

                newPreviousStates =
                    SavedState model.board model.score model.status :: model.previousStates
            in
            ( Model newBoard newScore newIterationStatus newPreviousStates, Cmd.none )

        ( _, BackInTime ) ->
            case model.previousStates of
                previous :: others ->
                    ( Model previous.board previous.score previous.status others, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


moveToCode : Move -> Int
moveToCode move =
    case move of
        Left ->
            -1

        Right ->
            1

        NoMove ->
            0


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.onKeyDown keyDecoder


keyDecoder : Decoder Msg
keyDecoder =
    Decode.andThen toMsg (Decode.field "key" Decode.string)


toMsg : String -> Decoder Msg
toMsg string =
    case string of
        "ArrowLeft" ->
            Decode.succeed (MovePaddle Left)

        "ArrowRight" ->
            Decode.succeed (MovePaddle Right)

        " " ->
            Decode.succeed (MovePaddle NoMove)

        "Backspace" ->
            Decode.succeed BackInTime

        _ ->
            Decode.fail "Not a key we want to listen"


view : Model -> Html msg
view model =
    div []
        [ displayBoard model.board
        , div [ style "margin-top" "15px", style "font-size" "16px" ] [ text ("Score: " ++ String.fromInt model.score) ]
        ]


displayBoard : Dict Position Element -> Html msg
displayBoard board =
    let
        boardPositions =
            Dict.keys board

        minX =
            boardPositions
                |> List.map Tuple.first
                |> List.minimum
                |> unsafeMaybe "Unable to find min X"

        maxX =
            boardPositions
                |> List.map Tuple.first
                |> List.maximum
                |> unsafeMaybe "Unable to find max X"

        minY =
            boardPositions
                |> List.map Tuple.second
                |> List.minimum
                |> unsafeMaybe "Unable to find min X"

        maxY =
            boardPositions
                |> List.map Tuple.second
                |> List.maximum
                |> unsafeMaybe "Unable to find max X"
    in
    List.range minY maxY
        |> List.map (\y -> List.range minX maxX |> List.map (\x -> ( x, y )))
        |> List.map (List.map (\position -> Dict.get position board |> Maybe.withDefault Empty))
        |> List.map (List.map toBlock)
        |> List.map (div [ style "display" "flex" ])
        |> div []


toBlock : Element -> Html msg
toBlock color =
    div [ style "width" "10px", style "height" "10px", style "background-color" (elementToColor color) ] []


elementToColor : Element -> String
elementToColor color =
    case color of
        Empty ->
            "transparent"

        Wall ->
            "red"

        Block ->
            "maroon"

        HorizontalPaddle ->
            "gray"

        Ball ->
            "gold"



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
