module Day12 exposing (..)

import Arithmetic exposing (lcm)
import Dict exposing (Dict)
import Html exposing (text)
import List.Extra as List
import Parser exposing ((|.), (|=), Parser, int, spaces, symbol)
import Set exposing (Set)


input : String
input =
    """<x=-14, y=-4, z=-11>
       <x=-9, y=6, z=-7>
       <x=4, y=1, z=4>
       <x=2, y=-14, z=-9>"""


type Position
    = Position ( Int, Int, Int )


type Velocity
    = Velocity ( Int, Int, Int )


main =
    mainStep2


parse : String -> List ( Position, Velocity )
parse input_ =
    String.lines input_
        |> List.map String.trim
        |> List.map (Parser.run positionParser >> unsafeResult "Unable to parse input")
        |> List.map (\position -> ( position, Velocity ( 0, 0, 0 ) ))


positionParser : Parser Position
positionParser =
    Parser.succeed (\x y z -> Position ( x, y, z ))
        |. symbol "<x="
        |. spaces
        |= signedIntParser
        |. spaces
        |. symbol ","
        |. spaces
        |. symbol "y="
        |. spaces
        |= signedIntParser
        |. spaces
        |. symbol ","
        |. spaces
        |. symbol "z="
        |. spaces
        |= signedIntParser
        |. spaces
        |. symbol ">"


signedIntParser : Parser Int
signedIntParser =
    Parser.oneOf
        [ Parser.succeed negate
            |. symbol "-"
            |= int
        , int
        ]



-- step 1 --


mainStep1 =
    let
        initialMoons =
            parse input
    in
    List.range 0 999
        |> List.foldr (\_ -> moveMoons) initialMoons
        |> getTotalEnergy
        |> String.fromInt
        |> text


getTotalEnergy : List ( Position, Velocity ) -> Int
getTotalEnergy moons =
    List.map (\moon -> getPotentialEnergy moon * getKineticEnergy moon) moons
        |> List.sum


getPotentialEnergy : ( Position, Velocity ) -> Int
getPotentialEnergy ( Position ( x, y, z ), _ ) =
    abs x + abs y + abs z


getKineticEnergy : ( Position, Velocity ) -> Int
getKineticEnergy ( _, Velocity ( dx, dy, dz ) ) =
    abs dx + abs dy + abs dz


moveMoons : List ( Position, Velocity ) -> List ( Position, Velocity )
moveMoons moons =
    let
        initialMoonsDict : Dict Int ( Position, Velocity )
        initialMoonsDict =
            List.indexedMap Tuple.pair moons
                |> Dict.fromList
    in
    List.range 0 (List.length moons - 1)
        |> List.uniquePairs
        |> List.foldr
            (\( index1, index2 ) currentMoons ->
                let
                    ( moon1Position, moon1Velocity ) =
                        Dict.get index1 currentMoons |> unsafeMaybe "Moon 1 not found"

                    ( moon2Position, moon2Velocity ) =
                        Dict.get index2 currentMoons |> unsafeMaybe "Moon 2 not found"

                    ( newMoon1Velocity, newMoon2Velocity ) =
                        getNewMoonVelocities ( moon1Position, moon1Velocity ) ( moon2Position, moon2Velocity )
                in
                Dict.insert index1 ( moon1Position, newMoon1Velocity ) currentMoons
                    |> Dict.insert index2 ( moon2Position, newMoon2Velocity )
            )
            initialMoonsDict
        |> Dict.toList
        |> List.map Tuple.second
        |> List.map applyVelocity


getNewMoonVelocities : ( Position, Velocity ) -> ( Position, Velocity ) -> ( Velocity, Velocity )
getNewMoonVelocities moon1 moon2 =
    let
        ( Position ( moon1X, moon1Y, moon1Z ), Velocity ( moon1DX, moon1DY, moon1DZ ) ) =
            moon1

        ( Position ( moon2X, moon2Y, moon2Z ), Velocity ( moon2DX, moon2DY, moon2DZ ) ) =
            moon2

        ( moon1XDelta, moon2XDelta ) =
            if moon1X < moon2X then
                ( 1, -1 )

            else if moon1X > moon2X then
                ( -1, 1 )

            else
                ( 0, 0 )

        ( moon1YDelta, moon2YDelta ) =
            if moon1Y < moon2Y then
                ( 1, -1 )

            else if moon1Y > moon2Y then
                ( -1, 1 )

            else
                ( 0, 0 )

        ( moon1ZDelta, moon2ZDelta ) =
            if moon1Z < moon2Z then
                ( 1, -1 )

            else if moon1Z > moon2Z then
                ( -1, 1 )

            else
                ( 0, 0 )

        newMoon1Velocity =
            ( moon1DX + moon1XDelta, moon1DY + moon1YDelta, moon1DZ + moon1ZDelta )

        newMoon2Velocity =
            ( moon2DX + moon2XDelta, moon2DY + moon2YDelta, moon2DZ + moon2ZDelta )
    in
    ( Velocity newMoon1Velocity, Velocity newMoon2Velocity )


applyVelocity : ( Position, Velocity ) -> ( Position, Velocity )
applyVelocity ( Position ( x, y, z ), Velocity ( dx, dy, dz ) ) =
    ( Position ( x + dx, y + dy, z + dz ), Velocity ( dx, dy, dz ) )



-- step 2 --


mainStep2 =
    let
        moons =
            parse input

        cycleX =
            iterate 0 Set.empty ( \(Position ( x, _, _ )) -> x, \(Velocity ( dx, _, _ )) -> dx ) moons

        cycleY =
            iterate 0 Set.empty ( \(Position ( _, y, _ )) -> y, \(Velocity ( _, dy, _ )) -> dy ) moons

        cycleZ =
            iterate 0 Set.empty ( \(Position ( _, _, z )) -> z, \(Velocity ( _, _, dz )) -> dz ) moons
    in
    lcm cycleX cycleY
        |> lcm cycleZ
        |> String.fromInt
        |> text


type alias PositionAccessor =
    Position -> Int


type alias VelocityAccessor =
    Velocity -> Int


iterate : Int -> Set (List ( Int, Int )) -> ( PositionAccessor, VelocityAccessor ) -> List ( Position, Velocity ) -> Int
iterate step formerPositions ( positionAccessor, velocityAccessor ) moons =
    let
        newMoons =
            moveMoons moons

        newPositions =
            List.map (\( position, velocity ) -> ( positionAccessor position, velocityAccessor velocity )) newMoons
    in
    if Set.member newPositions formerPositions then
        step

    else
        iterate (step + 1) (Set.insert newPositions formerPositions) ( positionAccessor, velocityAccessor ) newMoons



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

        Err err ->
            let
                _ =
                    Debug.log "err" err
            in
            Debug.todo error
