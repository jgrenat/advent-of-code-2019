module Day10 exposing (..)

import Html exposing (text)
import List.Extra as List
import Set


input : String
input =
    """#.#....#.#......#.....#......####.
       #....#....##...#..#..##....#.##..#
       #.#..#....#..#....##...###......##
       ...........##..##..##.####.#......
       ...##..##....##.#.....#.##....#..#
       ..##.....#..#.......#.#.........##
       ...###..##.###.#..................
       .##...###.#.#.......#.#...##..#.#.
       ...#...##....#....##.#.....#...#.#
       ..##........#.#...#..#...##...##..
       ..#.##.......#..#......#.....##..#
       ....###..#..#...###...#.###...#.##
       ..#........#....#.....##.....#.#.#
       ...#....#.....#..#...###........#.
       .##...#........#.#...#...##.......
       .#....#.#.#.#.....#...........#...
       .......###.##...#..#.#....#..##..#
       #..#..###.#.......##....##.#..#...
       ..##...#.#.#........##..#..#.#..#.
       .#.##..#.......#.#.#.........##.##
       ...#.#.....#.#....###.#.........#.
       .#..#.##...#......#......#..##....
       .##....#.#......##...#....#.##..#.
       #..#..#..#...........#......##...#
       #....##...#......#.###.#..#.#...#.
       #......#.#.#.#....###..##.##...##.
       ......#.......#.#.#.#...#...##....
       ....##..#.....#.......#....#...#..
       .#........#....#...#.#..#....#....
       .#.##.##..##.#.#####..........##..
       ..####...##.#.....##.............#
       ....##......#.#..#....###....##...
       ......#..#.#####.#................
       .#....#.#..#.###....##.......##.#."""


parse : String -> List ( Int, Int )
parse input_ =
    String.lines input_
        |> List.map String.trim
        |> List.map String.toList
        |> List.indexedMap
            (\y elements ->
                List.indexedMap
                    (\x element ->
                        if isAsteroid element then
                            Just ( x, y )

                        else
                            Nothing
                    )
                    elements
                    |> List.filterMap identity
            )
        |> List.concat


main =
    mainPart2



-- part 1 --


getStationDetails : List ( Int, Int ) -> ( ( Int, Int ), Int )
getStationDetails asteroids =
    List.map (\asteroid -> ( asteroid, computeVisibleAsteroids asteroids asteroid )) asteroids
        |> List.maximumBy Tuple.second
        |> unsafeMaybe "Station coordinates not found"


mainPart1 =
    parse input
        |> getStationDetails
        |> Tuple.second
        >> String.fromInt
        |> text


computeVisibleAsteroids : List ( Int, Int ) -> ( Int, Int ) -> Int
computeVisibleAsteroids asteroids stationCoordinates =
    List.foldl (\asteroidCoordinates visibleAxes -> Set.insert (computeAxe stationCoordinates asteroidCoordinates) visibleAxes) Set.empty asteroids
        |> Set.remove ( 0, 0, 0 )
        |> Set.toList
        |> List.length


type alias Axe =
    ( Int, Int, Float )


computeAxe : ( Int, Int ) -> ( Int, Int ) -> Axe
computeAxe ( stationX, stationY ) ( asteroidX, asteroidY ) =
    let
        xDiff =
            stationX - asteroidX

        yDiff =
            stationY - asteroidY

        value =
            if yDiff /= 0 then
                toFloat xDiff / toFloat yDiff

            else
                0
    in
    ( toDiff xDiff, toDiff yDiff, value )


toDiff : Int -> Int
toDiff value =
    if value < 0 then
        -1

    else if value == 0 then
        0

    else
        1


isAsteroid : Char -> Bool
isAsteroid char =
    char == '#'



-- part 2 --


mainPart2 =
    getNthAsteroidCoordinates 200
        |> (\( x, y ) -> x * 100 + y)
        |> String.fromInt
        |> text


getNthAsteroidCoordinates : Int -> ( Int, Int )
getNthAsteroidCoordinates limit =
    let
        asteroids =
            parse input

        ( stationX, stationY ) =
            getStationDetails asteroids
                |> Tuple.first

        asteroidsWithoutStation =
            List.filter ((/=) ( stationX, stationY )) asteroids

        toPolarCoordinates coordinates =
            toStationCentricCoordinates ( stationX, stationY ) coordinates
                |> Tuple.mapBoth toFloat toFloat
                |> toPolar
    in
    List.map toPolarCoordinates asteroidsWithoutStation
        |> sortByAngle
        |> List.groupWhile (\( _, first ) ( _, second ) -> first == second)
        |> List.map (\( first, others ) -> first :: others)
        |> List.map sortByDistance
        |> List.map (List.map (fromPolar >> Tuple.mapBoth round round >> toNormalCoordinates ( stationX, stationY )))
        |> List.indexedMap (\a -> List.indexedMap (\b coordinates -> ( b, a, coordinates )))
        |> List.concat
        |> List.sort
        |> List.getAt (limit - 1)
        |> unsafeMaybe "Unable to found 200th element"
        |> (\( _, _, coordinates ) -> coordinates)


sortByAngle : List ( Float, Float ) -> List ( Float, Float )
sortByAngle elements =
    List.sortBy
        (\( _, angle ) ->
            if pi * 2.5 - angle >= pi * 2 then
                pi * 0.5 - angle

            else
                pi * 2.5 - angle
        )
        elements


toStationCentricCoordinates : ( Int, Int ) -> ( Int, Int ) -> ( Int, Int )
toStationCentricCoordinates ( stationX, stationY ) ( x, y ) =
    ( x - stationX, stationY - y )


toNormalCoordinates : ( Int, Int ) -> ( Int, Int ) -> ( Int, Int )
toNormalCoordinates ( stationX, stationY ) ( x, y ) =
    ( x + stationX, stationY - y )


sortByDistance : List ( Float, Float ) -> List ( Float, Float )
sortByDistance =
    List.sortBy Tuple.first


unsafeMaybe : String -> Maybe a -> a
unsafeMaybe error maybe =
    case maybe of
        Just value ->
            value

        Nothing ->
            Debug.todo error
