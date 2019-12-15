module Day14 exposing (..)

import Dict exposing (Dict)
import Graph exposing (Edge, Graph)
import Html exposing (text)
import Parser exposing ((|.), (|=), Parser, Step(..), chompWhile, getChompedString, int, loop, spaces, succeed, symbol)
import String.Extra as String


input : String
input =
    """1 QDKHC => 9 RFSZD
       15 FHRN, 17 ZFSLM, 2 TQFKQ => 3 JCHF
       4 KDPV => 4 TQFKQ
       1 FSTRZ, 5 QNXWF, 2 RZSD => 3 FNJM
       15 VQPC, 1 TXCJ => 3 WQTL
       1 PQCQN, 6 HKXPJ, 16 ZFSLM, 6 SJBPT, 1 TKZNJ, 13 JBDF, 1 RZSD => 6 VPCP
       1 LJGZP => 7 VNGD
       1 CTVB, 1 HVGW => 1 LJGZP
       6 HVGW, 1 HJWT => 2 VDKF
       10 PQCQN, 7 WRQLB, 1 XMCH => 3 CDMX
       14 VNGD, 23 ZFSLM, 2 FHRN => 4 SJBPT
       1 FSTRZ, 4 VTWB, 2 BLJC => 4 CKFW
       2 ZTFH, 19 CKFW, 2 FHRN, 4 FNJM, 9 NWTVF, 11 JBDF, 1 VDKF, 2 DMRCN => 4 HMLTV
       1 KVZXR => 5 FPMSL
       8 XBZJ => 8 QDKHC
       1 VQPC => 9 FHRN
       15 RKTFX, 5 HKXPJ => 4 ZFSLM
       1 HKXPJ, 8 LQCTQ, 21 VJGKN => 5 QCKFR
       1 DCLQ, 1 TQFKQ => 4 KVZXR
       4 NWTVF, 20 QNXWF => 9 JFLQD
       11 QFVR => 3 RZSD
       9 RFSZD, 6 WQTL => 7 JBDF
       4 BLJC, 3 LQCTQ, 1 QCKFR => 8 QFVR
       6 VNGD => 5 VQPC
       7 CTMR, 10 SJBPT => 9 VTWB
       1 VTWB => 9 DMRCN
       6 BCGLR, 4 TPTN, 29 VNGD, 25 KDQC, 40 JCHF, 5 HMLTV, 4 CHWS, 2 CDMX, 1 VPCP => 1 FUEL
       1 TQFKQ, 3 FPMSL, 7 KDPV => 6 RKTFX
       8 HKXPJ, 2 WQTL => 6 WRQLB
       146 ORE => 3 KDPV
       9 KDQC => 2 XMCH
       1 BGVXG, 21 KVZXR, 1 LQCTQ => 4 CTVB
       1 LQCTQ => 5 VJGKN
       16 VNGD, 5 VMBM => 1 CTMR
       5 VCVTM, 1 FPMSL => 5 HKXPJ
       4 HKXPJ => 5 BLJC
       14 FHRN, 6 ZFSLM => 1 NWTVF
       7 QCKFR, 2 VNGD => 7 VMBM
       4 TXCJ, 1 VDKF => 2 QNXWF
       136 ORE => 6 BGVXG
       5 LQCTQ, 11 DCLQ => 9 XBZJ
       3 VQPC => 7 ZTFH
       114 ORE => 3 ZWFZX
       1 HJWT, 18 KDPV => 7 TXCJ
       1 VJGKN => 2 VCVTM
       2 KVZXR => 1 HJWT
       12 ZWFZX, 1 FHRN, 9 JFLQD => 1 CHWS
       3 QFVR => 5 FSTRZ
       5 XBZJ => 4 HVGW
       1 ZWFZX => 8 LQCTQ
       16 WQTL, 10 TXCJ => 9 KDQC
       3 FHRN, 12 LJGZP => 5 TPTN
       1 JCHF => 7 PQCQN
       7 KDPV, 17 BGVXG => 7 DCLQ
       1 CKFW, 3 TKZNJ, 4 PQCQN, 1 VQPC, 32 QFVR, 1 FNJM, 13 FSTRZ => 3 BCGLR
       2 FSTRZ => 5 TKZNJ"""


main =
    mainPart2


type alias Element =
    String


type alias Transformation =
    { inputs : List ElementQuantity
    , output : ElementQuantity
    }


type alias ElementQuantity =
    ( Int, Element )



-- parsing --


parse : String -> List Transformation
parse input_ =
    String.lines input_
        |> List.map String.trim
        |> List.filter (String.isBlank >> not)
        |> List.map (Parser.run transformationParser >> unsafeResult "Unable to process line")


transformationParser : Parser Transformation
transformationParser =
    Parser.succeed Transformation
        |. spaces
        |= elementsList
        |. spaces
        |. symbol "=>"
        |. spaces
        |= elementQuantityParser
        |. spaces


elementsList : Parser (List ElementQuantity)
elementsList =
    loop [] elementsListHelp


elementsListHelp : List ElementQuantity -> Parser (Step (List ElementQuantity) (List ElementQuantity))
elementsListHelp previousQuantities =
    Parser.oneOf
        [ succeed (\elementQuantity -> Loop (elementQuantity :: previousQuantities))
            |= elementQuantityParser
            |. spaces
        , succeed (\elementQuantity -> Loop (elementQuantity :: previousQuantities))
            |. spaces
            |. symbol ","
            |. spaces
            |= elementQuantityParser
            |. spaces
        , succeed ()
            |> Parser.map (\_ -> Done (List.reverse previousQuantities))
        ]


elementQuantityParser : Parser ElementQuantity
elementQuantityParser =
    Parser.succeed Tuple.pair
        |= int
        |. spaces
        |= elementNameParser


elementNameParser : Parser String
elementNameParser =
    getChompedString <|
        succeed ()
            |. chompWhile Char.isUpper



-- part 1 --


mainPart1 =
    parse input
        |> toGraph
        |> countNeededQuantities
        |> String.fromInt
        |> text


countNeededQuantities : Graph ElementQuantity Int -> Int
countNeededQuantities dependencies =
    countQuantityFor (Graph.reverseEdges dependencies) 1 ( 1, "ORE" )


countQuantityFor : Graph ElementQuantity Int -> Int -> ElementQuantity -> Int
countQuantityFor dependencies fuelQuantity ( quantity, element ) =
    if element == "FUEL" then
        fuelQuantity

    else
        Graph.outgoingEdgesWithData ( quantity, element ) dependencies
            |> List.map (\( dependency, factor ) -> countQuantityFor dependencies fuelQuantity dependency * factor)
            |> List.sum
            |> (\dependencyQuantity -> ceiling (toFloat dependencyQuantity / toFloat quantity))


toGraph : List Transformation -> Graph ElementQuantity Int
toGraph transformations =
    let
        elementQuantities =
            List.map .output transformations
                |> (::) ( 1, "ORE" )

        elementQuantitiesDict =
            List.map
                (\elementQuantity ->
                    ( Tuple.second elementQuantity, elementQuantity )
                )
                elementQuantities
                |> Dict.fromList

        ingredients =
            List.concatMap (\{ inputs, output } -> List.map (toEdge elementQuantitiesDict output) inputs) transformations
    in
    Graph.fromVerticesAndEdges elementQuantities ingredients


toEdge : Dict Element ElementQuantity -> ElementQuantity -> ElementQuantity -> Edge ElementQuantity Int
toEdge elementQuantitiesDict elementQuantity ( ingredientQuantity, ingredient ) =
    Dict.get ingredient elementQuantitiesDict
        |> unsafeMaybe "Unable to locate ingredient"
        |> (\ingredientVertice -> Edge elementQuantity ingredientVertice ingredientQuantity)



-- Part 2 --


oneTrillion =
    1000000000000


mainPart2 =
    parse input
        |> toGraph
        |> Graph.reverseEdges
        |> (\dependencies ->
                let
                    forOneFuel =
                        countQuantityFor dependencies 1 ( 1, "ORE" )

                    result =
                        countQuantityFor dependencies (oneTrillion // forOneFuel) ( 1, "ORE" )
                in
                maximizeQuantity result (oneTrillion // forOneFuel) 10000000 dependencies
           )
        |> String.fromInt
        |> text


maximizeQuantity : Int -> Int -> Int -> Graph ElementQuantity Int -> Int
maximizeQuantity previousResult previousQuantity increment dependencies =
    let
        newQuantity =
            previousQuantity + increment

        result =
            countQuantityFor dependencies newQuantity ( 1, "ORE" )
    in
    if result > oneTrillion then
        if increment == 1 then
            previousQuantity

        else
            maximizeQuantity previousResult previousQuantity (increment // 10) dependencies

    else
        maximizeQuantity result newQuantity increment dependencies



-- Helpers --


unsafeMaybe : String -> Maybe a -> a
unsafeMaybe error maybe =
    case maybe of
        Just value ->
            value

        Nothing ->
            Debug.todo error


unsafeResult : String -> Result a b -> b
unsafeResult error result =
    case result of
        Ok value ->
            value

        Err _ ->
            Debug.todo error
