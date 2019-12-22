module Day20 exposing (..)

import Array exposing (Array)
import Array.Extra as Array
import Dict exposing (Dict)
import Html exposing (Html, div, pre, span, text)
import Html.Attributes exposing (style, title)
import List.Extra as List
import Set
import String.Extra as String


input : String
input =
    """
                                       T   L           B   P       C       B Z           M
                                       I   P           A   P       U       N Z           S
  #####################################.###.###########.###.#######.#######.#.###########.###################################
  #.......#.....#...#.....#.#.#.....#.#.#.........#.......#.....#.....#.#.....#.#...#.#.....#...#.....#.#.....#.#.#...#.....#
  ###.#######.#.###.#.#.###.#.#.#####.#.#########.#.#.#.#####.#####.###.###.###.#.###.#.#####.###.#####.###.###.#.#.###.#.###
  #.#.#.#...#.#...#...#...#.#.#.#.........#...#...#.#.#.....#.#.#.........#.........#.#.......#.....#...#...#.#.......#.#...#
  #.#.#.#.#######.#######.#.#.#.#######.###.###.###.###.#.###.#.#.###.#########.#.###.###.###.#.#####.###.###.#.#########.###
  #.......#.#...#...#.......#.......#.....#...#...#.#.#.#.#.....#.#.....#.#.#...#...#...#...#.........#...#.......#.#...#...#
  #####.###.###.#.#########.#.#.#######.###.#.#.#.#.#.#####.#.#.###.#####.#.#.#######.#.#.#####.###.#####.#.###.#.#.###.#.#.#
  #...#...#.#...........#.#.#.#...#.#.....#.#.#.#.#.......#.#.#...#.........#...#.#...#.....#.....#.#.#.......#.#.#.#.....#.#
  #.#.#.###.###.###.###.#.#.###.###.#####.#.#.###.#.#############.#######.#####.#.#.#######.#####.###.#.#.###.#####.###.#.###
  #.#...#.#.#...#...#.....................#.#...#.#.#.#...........#...........#...#.......#.#...#.#.#...#.#.....#.#.#...#...#
  ###.#.#.#.###.###.#######.#.#.#######.###.###.#.#.#.#####.#.#.###.###.#.#######.#.###.#.#####.###.#.#######.###.#.###.###.#
  #.#.#.#...#.#.#.#.#.#.#.#.#.#.....#...#.....#...#...#.#...#.#.#.#.#.#.#...#.#...#...#.#...#.#.#.....#.#...#...#.#.#.#...#.#
  #.#.###.###.###.###.#.#.#.###.#######.###.#.#####.###.###.#.###.#.#.###.###.###.#.#####.###.#.#.#####.#.#######.#.#.#.#####
  #...#...#...#...#...#.......#.#.#...#...#.#.....#.#.#.....#.#.#.......#...#.....#.....#.............#.....#...#...#.#...#.#
  ###.###.###.###.###.#.###.#####.###.#.#######.#.#.#.#####.###.###.#####.###.###.#.#####.#####.#######.#######.#.###.###.#.#
  #...#.....#...#.......#...#.#.#...#.........#.#.#.#...#.......#...#.#.....#...#.#.#.......#.....#...#.........#...#...#...#
  ###.###.###.#####.###.#.#.#.#.#.###.#.#.#######.#.#.#####.#.#####.#.#######.###.#####.#.###.###.#.###.#########.###.#####.#
  #.#.#.#...#...#.#...#.#.#.#.....#.#.#.#.#...#.#.#.......#.#.#...........#...#.....#...#.#.....#.........#.....#.#.........#
  #.#.#.###.#.###.###############.#.###.#####.#.#.#.###.#####.#######.###########.#.#####.#######.#.###.#.###.###.###.#######
  #.#.#.#.......#...#.....#.#...#.......#.........#.#.#.#.....#...#...#.......#...#.#.#.........#.#.#...#.#.#.#.#.#.........#
  #.#.#.###.#.#####.###.###.###.#.#####.###.#######.#.###.#.#####.#.#####.#######.###.#.###########.#.#.###.#.#.#.###.#######
  #.........#.#.......#.#.#.......#.......#.....#.#.....#.#.#.#...........#.........#.............#.#.#.#.#.......#.....#.#.#
  #####.###.#######.###.#.#######.#.#.#.###.###.#.###.#####.#.#.#####.#.#########.#######.#.#####.#######.###.###.#.#####.#.#
  #...#.#.....#.#.....#.#...#...#.#.#.#...#.#.#...#.......#.#.#.#.....#.#.#...#...#.....#.#.....#...#.....#.#.#...#.....#.#.#
  ###.#.#######.###.#.#.#.###.###########.###.###.#.#.#####.#.###.#.#####.###.###.#.#.###.#############.###.#####.#####.#.#.#
  #...#...#.#...#...#.#.....#...........#.#.#.....#.#...#.....#...#.....#.........#.#...#.#.#.....#.#.....#.....#.........#.#
  ###.#.###.###.#.#####.#####.###.#####.#.#.#####.#.#######.#########.#######.#.###.###.#.#.#.#####.#####.###.###.#####.###.#
  #...#...#.#...#...#.#...#...#.....#...#...#...#.#.#.....#...#.#.#.........#.#.#...#.#.............#...........#.....#.#...#
  ###.#.###.###.#.###.#.###############.#.###.###.#.#.###.#.###.#.#.###.#######.###.#.###.#.#.#############.#####.###.###.###
  #...#.....#.....#.....#...#.#.......#...#.#...#.#...#.#.#.#...#.....#.#...#.....#.....#.#.#.#.#.#.#.#.....#.......#.#.....#
  #.#####.###.#.#######.#.###.#######.###.#.#.#.#.#.###.#.#.###.#####.#####.###.#.###.###.#####.#.#.#.###.#.#####.#######.#.#
  #.....#...#.#...#.#.#...#...#.....#.....#...#...#.#.....#.....#.....#.........#.#.....#...#.....#...#...#.#.#...#.#.....#.#
  ###.#.#.###.#####.#.#.#.#.#####.#####.#####.#######.#########.###.#########.#########.#####.#.#####.#####.#.###.#.#####.###
  #.#.#...#.#...#.#...#.#.#.#.#...#    F     I       C         B   B         J         K    #.#.#...#.....#...#...#...#.....#
  #.#####.#.#.###.###.###.#.#.###.#    X     O       U         A   N         J         N    ###.#.#####.###.#####.###.###.###
  #.........................#.....#                                                         #.....#.........#.......#.....#.#
  #.#.#.#####.#############.#.###.#                                                         ###.#.#.###.###.#.#####.#.#.###.#
  #.#.#.....#.#.#...#...#...#...#.#                                                         #...#.....#.#.....#.....#.#.#....QD
  #.#.#.#######.###.#.#.#.###.#.#.#                                                         ###.#####.#######.#####.#.#.###.#
MX..#.#...#.#.....#...#...#...#.#..PP                                                     TI..#.....#.#...#...#.#.....#...#.#
  #####.###.###.###.#.#########.#.#                                                         #.###.###.#.#.#####.#########.#.#
  #...#...#...#.#.#.#...........#.#                                                         #.....#.#.#.#.#...#...#.#...#...#
  #.#######.###.#.#################                                                         #######.###.#####.#.###.#.#######
  #.......#...................#.#.#                                                       QD..........#...................#..HM
  #.#.###.#.#.#.#######.#.###.#.#.#                                                         #.###.###.#.#.#.###########.###.#
  #.#...#...#.#.#...#...#...#.....#                                                         #...#...#...#.#.#...#.....#...#.#
  #####.#.#.###.#.#.#######.###.#.#                                                         #.###.#####.#######.#.#.###.###.#
  #.....#.#...#...#.#.#...#.#...#.#                                                       LP..#...#...#.#.........#.....#....OL
  #.#.###.###########.#.#######.###                                                         #########.#####.###.#########.#.#
HG..#.#...#.#...#.#...#...#...#....DY                                                       #...#.........#.#.............#.#
  #.#######.###.#.#.###.###.#######                                                         #.#####.#.#.#####################
  #.#.....................#...#...#                                                         #.....#.#.#.....#...#.....#......FG
  ###.#######.#.#.#.#.#.#.#.#.#.#.#                                                         #####.###.#########.#.#.###.#.###
  #...#.....#.#.#.#.#.#.#...#...#.#                                                         #.....#.#...#.#.#.#...#...#.#...#
  ###.###.#.#####.###.#####.#####.#                                                         #####.#.#.###.#.#.#.#####.#.#.###
  #.......#...#.....#...#.....#.#.#                                                       QQ....................#.#.#...#...#
  #########.#.#.#.###.###.#.#.#.#.#                                                         #####.###############.#.#.#####.#
AJ..........#.#.#...#.#...#.#.#....OL                                                     WP..#...#.................#.#.#.#.#
  ###############.#########.###.#.#                                                         #.#######.###.#.###.###.###.#.###
LQ..#.........#.........#.#.#.#.#.#                                                         #.....#.....#.#...#...#.....#....FN
  #.#.#.#################.###.#####                                                         #.#.#####.#.###.###########.###.#
  #...#.....#.......#.#.#.#.#.....#                                                         #.#.#.....#.#...#...#.#.#...#...#
  #.#.#.#.#.###.#.###.#.#.#.#####.#                                                         ###.#.#####.###.###.#.#.#.###.#.#
  #.#.#.#.#.#.#.#...#.#.....#.#.#..HM                                                       #.#...#.#.#.#.#.#...#.#.#.....#.#
  ###.#.###.#.#.#####.#####.#.#.#.#                                                         #.#####.#.###.#####.#.#.#########
  #.#.#.#.#.......................#                                                       AJ..#.......................#.....#
  #.#####.#######################.#                                                         #.#.###.#.#.###.###.#####.#.###.#
QQ......................#.......#.#                                                         #.....#.#.#.#.....#.#.......#...#
  #.#####.###.#####.#.###.#####.###                                                         #.#####.#.#######.#######.###.###
  #.#.#.#.#.....#...#...#.#.....#..IC                                                       #.#...#.#.....#...#.....#.#.#.#.#
  #.#.#.#.#.#########.###.#.#####.#                                                         ###.#############.#.#.#####.#.#.#
  #.#.#.#.#.#.............#.....#.#                                                         #...#.#.....#...#.#.#.......#....DY
  ###.#.###########.###########.#.#                                                         #.###.#.#####.#########.#########
  #.#.....#.#.#.#.#.#.#...#...#...#                                                       MX....#.......#.................#..IO
  #.###.###.#.#.#.###.###.###.###.#                                                         ###.#.#####.#.###.#.###.#.#.#.#.#
RW..#.....#...................#...#                                                         #...#...#.#...#...#.#...#.#.#.#.#
  #.#.#.#.###.###.#####.#.#.#######                                                         #.###.###.#.###.#####.#.#####.#.#
  #.#.#.#.....#.......#.#.#...#....LQ                                                       #...#.#.#.....#.....#.#.#.......#
  #.#.#####.#.#####.#####.#.#.###.#                                                         ###.#.#.#######.###########.###.#
  #.......#.#.#.#.......#.#.#.#...#                                                         #...........#...#.......#...#...#
  #.#.#######.#.###.#.###.###.###.#                                                         ###.#.#####.###.#.#######.#####.#
  #.#.....#...#.#...#.#...#.......#                                                         #...#.....#.#.....#...#...#.....#
  ###.#####.#.#.###.#####.###.###.#    F         H       U       I     R     F         M    #.#######.#.###.#.#.###########.#
  #...#...#.#.#.........#.#.....#.#    G         G       S       F     W     N         S    #.....#.#.#.#.#.#.......#.......#
  ###.#.#####.###.###.###.#.#####.#####.#########.#######.#######.#####.#####.#########.#######.###.###.#.#.#####.#.#######.#
  #.........#...#.#...#.#.#.#.#...#.......#.......#.#.#.....#.....#.........#.#.............#...#.......#...#.#...#.#.......#
  #.###.#############.#.###.#.#.#.###.###.#####.###.#.#.#####.###########.###.###.###############.#.#####.#.#.###.#####.###.#
  #.#...#.......#.........#.#...#...#...#...#.....#.....#.#.......#...#.#...#.#.#.#...........#.#.#.#.....#...#.#.#.#...#...#
  #.###.#.#####.#.#.###.#######.#####.#####.#.#.#####.#.#.###.###.###.#.#.###.#.#.#.###.#.###.#.###.###.#.###.#.###.###.###.#
  #.#.#.#.#.#.....#.#.....#.#.#...#.....#.#.#.#...#...#.#...#.#.....#.......#...#.#...#.#.#.....#.#...#.#.#.........#.....#.#
  ###.#####.###.#.#####.###.#.###.###.#.#.#####.#####.###.#########.#.#.###.#.#.#.#.###.#.###.###.#.#########.#.#.#########.#
  #.#...........#.#.......#...#...#...#.#.....#.#.#...#.#...#.......#.#...#.#.#.#...#...#...#...#.....#...#...#.#.#.#.#.#...#
  #.#.###.#.#.#.###########.#########.#######.#.#.#.#.###.#.#.###########.#####.#####.#.#.#.#############.#.#.###.#.#.#.###.#
  #...#...#.#.#.#...#...#.....#...#.....#.........#.#.#...#.#.....#.#.....#.#.......#.#.#.#.#.#.#...#.....#.#.#.......#.....#
  #.###.#####.#.###.###.###.#####.###.#####.#.###.###.#.###.#.#####.#.#.###.###.#.#####.#####.#.#.###.#####.#.###.#.###.###.#
  #.#...#.....#...#...................#...#.#...#...#.....#.#.......#.#.....#...#.#.#.#...#.#.#.........#.#.#.#...#.#...#.#.#
  #####.#####.#####.#.###.#.#.#.#.###.#.#####.#############.#.#.###.#####.#####.###.#.#.#.#.#.###.###.#.#.###.###.#####.#.###
  #.....#...#.#.....#...#.#.#.#.#...#.....#...#.#.#.........#.#.#...#.#...#.#.....#.#...#...#.#...#.#.#.#...#.#.#.....#.....#
  #.###.###.#######.#.#######.###.###.#######.#.#.###.###.#######.###.#.###.###.###.###.#####.#.###.#####.###.#.###.###.###.#
  #.#...#...#.#.....#.#.#.....#.#.#...#.#...#...#.....#.........#.....#...#.#.#.......#...........#.......#.......#...#.#...#
  #.#.#####.#.#####.###.#.###.#.#.###.#.#.###.#.#####.###.#########.###.###.#.#.#.#####.###.#########.#.#.#.###.#######.#.###
  #.#.#...............#...#.#...#.#.........#.#.....#.#.#.#.#.#.#...#.....#.#...#...#.....#...........#.#.#.#.........#.#.#.#
  #.###.#.###.#.#.#.###.#.#.###.#####.###.#.#.#######.#.###.#.#.#.#######.#.#.###.#####.#####.###.###.#.#.#####.#######.###.#
  #...#.#.#...#.#.#.#...#.#.#.#.#.....#...#.#.....#.....#.....#.......#...#...#.#.#.........#...#...#.#.#...#.........#.#.#.#
  #.#########.###.#.#######.#.#######.#####.###.#####.#.###.#.#####.#.###.#.###.#.###.###.###.###.#####.#########.###.###.#.#
  #.....#.......#.#.#.....#.#.#.#.#.#.#...#...#...#...#.#...#.#.#...#...#.#...#.#.#.#...#...#.#.....#...........#...#.......#
  #.#.#######.#####.#####.#.#.#.#.#.###.#.#.###.#####.#####.###.#.#######.###.#.###.#.#.#############.#.###.#.#.#######.#####
  #.#...#...#.#.....#.........#.........#.#...#...#.......#...#.....#.#...#.....#.#...#...........#.#.#...#.#.#.......#.....#
  #.#####.#####.#.#########.###.#.###.###.#.###.#.###.###.#.#######.#.#.###.#####.###.#.#.#.#.#.#.#.###.###.###.###.#########
  #.#...#.#.#...#.#.....#.....#.#...#.#.#.....#.#...#.#.#...#.#...#...#...#.....#.#...#.#.#.#.#.#.....#...#...#.#.....#...#.#
  #.###.#.#.###.###.#####.###.###.###.#.#########.#####.###.#.#.#.#.###.#.###.###.###.#.#####.###.#.###.###.###.#####.#.###.#
  #.#...........#.....#.#.#.#...#.#...#.....#.....#.#.#...#...#.#.....#.#.#.........#.#...#...#.#.#.#...#.....#...#.........#
  #.###.#########.#.#.#.###.#.#######.###.#.###.###.#.###.#.#####.#.#####.#####.#######.#######.#######.###.#.#.#.#.#.###.#.#
  #.#.....#.......#.#.................#...#...#.....#.......#.....#...#.....#.#.#.#.#...#.........#.......#.#.#.#.#.#.#...#.#
  #.#######.#.###.#.#.###.#.#.#.###.#.#.###.#######.#.#############.###.#####.#.#.#.###.#.#####.#.###.###.#####.#.###.#####.#
  #.#.......#.#...#.#.#...#.#.#.#...#...#...#.......#.........#.....#.........#.#.............#.#.#.....#...#...#...#...#...#
  #########################################.#.###########.#######.###.###.#####.###.#########################################
                                           I I           J       W   K   A     U   F
                                           F C           J       P   N   A     S   X
"""


type alias Map =
    Array (Array Element)


type Element
    = Void
    | Empty
    | Start
    | End
    | Wall
    | Portal String


type Direction
    = Up
    | Down
    | Left
    | Right


type ExplorationResult
    = Found
    | ToExplore (List ( Int, Int ))


type RecursiveExplorationResult
    = RecursiveFound
    | RecursiveToExplore (List ( ( Int, Int ), Int ))


main =
    mainPart2



-- parsing --


parse : String -> Map
parse input_ =
    let
        rawMap =
            String.lines input_
                |> List.filterNot String.isBlank
                |> List.map String.toList

        rawMapArray =
            rawMap
                |> List.map Array.fromList
                |> Array.fromList

        rowSize =
            List.getAt 3 rawMap
                |> unsafeMaybe "no first row"
                |> List.drop 2
                |> List.takeWhile (\char -> char /= ' ' && (char < 'A' || char > 'Z'))
                |> List.length

        realMapWithoutPortals =
            List.drop 2 rawMap
                |> List.map (\row -> List.drop 2 row |> List.take rowSize)
                |> List.take (List.length rawMap - 4)
                |> List.map (List.map parseToElement)
                |> List.map Array.fromList
                |> Array.fromList
    in
    realMapWithoutPortals
        |> addPortalAndEntrancesToLeft rawMapArray
        |> addPortalAndEntrancesToRight rawMapArray
        |> addPortalAndEntrancesToTop rawMapArray
        |> addPortalAndEntrancesToBottom rawMapArray
        |> addInternalPortalAndEntrancesToLeft ( 35, 35 ) ( 91, 85 ) rawMapArray
        |> addInternalPortalAndEntrancesToRight ( 35, 35 ) ( 91, 85 ) rawMapArray
        |> addInternalPortalAndEntrancesToTop ( 35, 35 ) ( 91, 85 ) rawMapArray
        |> addInternalPortalAndEntrancesToBottom ( 35, 35 ) ( 91, 85 ) rawMapArray



--|> addInternalPortalAndEntrancesToLeft ( 35, 35 ) ( 91, 85 ) rawMapArray


addPortalAndEntrancesToLeft : Array (Array Char) -> Map -> Map
addPortalAndEntrancesToLeft rawMap map =
    List.range 2 (Array.length rawMap - 3)
        |> List.foldl
            (\y newMap ->
                let
                    element1 =
                        Array.get y rawMap
                            |> Maybe.andThen (Array.get 0)
                            |> Maybe.withDefault ' '

                    element2 =
                        Array.get y rawMap
                            |> Maybe.andThen (Array.get 1)
                            |> Maybe.withDefault ' '

                    identifier =
                        String.fromList [ element1, element2 ]
                in
                if identifier == "AA" then
                    Array.update (y - 2) (Array.set 0 Start) newMap

                else if identifier == "ZZ" then
                    Array.update (y - 2) (Array.set 0 End) newMap

                else if identifier > "AA" && identifier < "ZZ" && element2 /= ' ' then
                    Array.update (y - 2) (Array.set 0 (Portal identifier)) newMap

                else
                    newMap
            )
            map


addPortalAndEntrancesToRight : Array (Array Char) -> Map -> Map
addPortalAndEntrancesToRight rawMap map =
    let
        almostLast =
            (Array.get 0 map |> unsafeMaybe "no row in array" |> Array.length) + 2
    in
    List.range 2 (Array.length rawMap - 3)
        |> List.foldl
            (\y newMap ->
                let
                    element1 =
                        Array.get y rawMap
                            |> Maybe.andThen (Array.get almostLast)
                            |> Maybe.withDefault ' '

                    element2 =
                        Array.get y rawMap
                            |> Maybe.andThen (Array.get (almostLast + 1))
                            |> Maybe.withDefault ' '

                    identifier =
                        String.fromList [ element1, element2 ]
                in
                if identifier == "AA" then
                    Array.update (y - 2) (Array.set (almostLast - 3) Start) newMap

                else if identifier == "ZZ" then
                    Array.update (y - 2) (Array.set (almostLast - 3) End) newMap

                else if identifier > "AA" && identifier < "ZZ" then
                    Array.update (y - 2) (Array.set (almostLast - 3) (Portal identifier)) newMap

                else
                    newMap
            )
            map


addPortalAndEntrancesToTop : Array (Array Char) -> Map -> Map
addPortalAndEntrancesToTop rawMap map =
    List.range 2 ((Array.get 3 rawMap |> unsafeMaybe "no row in array" |> Array.length) - 3)
        |> List.foldl
            (\x newMap ->
                let
                    element1 =
                        Array.get 0 rawMap
                            |> Maybe.andThen (Array.get x)
                            |> Maybe.withDefault ' '

                    element2 =
                        Array.get 1 rawMap
                            |> Maybe.andThen (Array.get x)
                            |> Maybe.withDefault ' '

                    identifier =
                        String.fromList [ element1, element2 ]
                in
                if identifier == "AA" then
                    Array.update 0 (Array.set (x - 2) Start) newMap

                else if identifier == "ZZ" then
                    Array.update 0 (Array.set (x - 2) End) newMap

                else if identifier > "AA" && identifier < "ZZ" then
                    Array.update 0 (Array.set (x - 2) (Portal identifier)) newMap

                else
                    newMap
            )
            map


addPortalAndEntrancesToBottom : Array (Array Char) -> Map -> Map
addPortalAndEntrancesToBottom rawMap map =
    let
        almostLast =
            Array.length rawMap - 2
    in
    List.range 2 ((Array.get 3 rawMap |> unsafeMaybe "no row in array" |> Array.length) - 1)
        |> List.foldl
            (\x newMap ->
                let
                    element1 =
                        Array.get almostLast rawMap
                            |> Maybe.andThen (Array.get x)
                            |> Maybe.withDefault ' '

                    element2 =
                        Array.get (almostLast + 1) rawMap
                            |> Maybe.andThen (Array.get x)
                            |> Maybe.withDefault ' '

                    identifier =
                        String.fromList [ element1, element2 ]
                in
                if identifier == "AA" then
                    Array.update (Array.length map - 1) (Array.set (x - 2) Start) newMap

                else if identifier == "ZZ" then
                    Array.update (Array.length map - 1) (Array.set (x - 2) End) newMap

                else if identifier > "AA" && identifier < "ZZ" then
                    Array.update (Array.length map - 1) (Array.set (x - 2) (Portal identifier)) newMap

                else
                    newMap
            )
            map


addInternalPortalAndEntrancesToLeft : ( Int, Int ) -> ( Int, Int ) -> Array (Array Char) -> Map -> Map
addInternalPortalAndEntrancesToLeft ( x1, y1 ) ( x2, y2 ) rawMap map =
    List.range y1 y2
        |> List.foldl
            (\y newMap ->
                let
                    element1 =
                        Array.get y rawMap
                            |> Maybe.andThen (Array.get x1)
                            |> Maybe.withDefault ' '

                    element2 =
                        Array.get y rawMap
                            |> Maybe.andThen (Array.get (x1 + 1))
                            |> Maybe.withDefault ' '

                    identifier =
                        String.fromList [ element1, element2 ]
                in
                if identifier == "AA" then
                    Array.update (y - 2) (Array.set (x1 - 3) Start) newMap

                else if identifier == "ZZ" then
                    Array.update (y - 2) (Array.set (x1 - 3) End) newMap

                else if identifier > "AA" && identifier < "ZZ" then
                    Array.update (y - 2) (Array.set (x1 - 3) (Portal identifier)) newMap

                else
                    newMap
            )
            map


addInternalPortalAndEntrancesToRight : ( Int, Int ) -> ( Int, Int ) -> Array (Array Char) -> Map -> Map
addInternalPortalAndEntrancesToRight ( x1, y1 ) ( x2, y2 ) rawMap map =
    List.range y1 y2
        |> List.foldl
            (\y newMap ->
                let
                    element1 =
                        Array.get y rawMap
                            |> Maybe.andThen (Array.get (x2 - 1))
                            |> Maybe.withDefault ' '

                    element2 =
                        Array.get y rawMap
                            |> Maybe.andThen (Array.get x2)
                            |> Maybe.withDefault ' '

                    identifier =
                        String.fromList [ element1, element2 ]
                in
                if identifier == "AA" then
                    Array.update (y - 2) (Array.set (x2 - 1) Start) newMap

                else if identifier == "ZZ" then
                    Array.update (y - 2) (Array.set (x2 - 1) End) newMap

                else if identifier > "AA" && identifier < "ZZ" then
                    Array.update (y - 2) (Array.set (x2 - 1) (Portal identifier)) newMap

                else
                    newMap
            )
            map


addInternalPortalAndEntrancesToTop : ( Int, Int ) -> ( Int, Int ) -> Array (Array Char) -> Map -> Map
addInternalPortalAndEntrancesToTop ( x1, y1 ) ( x2, y2 ) rawMap map =
    List.range x1 x2
        |> List.foldl
            (\x newMap ->
                let
                    element1 =
                        Array.get y1 rawMap
                            |> Maybe.andThen (Array.get x)
                            |> Maybe.withDefault ' '

                    element2 =
                        Array.get (y1 + 1) rawMap
                            |> Maybe.andThen (Array.get x)
                            |> Maybe.withDefault ' '

                    identifier =
                        String.fromList [ element1, element2 ]
                in
                if identifier == "AA" then
                    Array.update (y1 - 3) (Array.set (x - 2) Start) newMap

                else if identifier == "ZZ" then
                    Array.update (y1 - 3) (Array.set (x - 2) End) newMap

                else if identifier > "AA" && identifier < "ZZ" then
                    Array.update (y1 - 3) (Array.set (x - 2) (Portal identifier)) newMap

                else
                    newMap
            )
            map


addInternalPortalAndEntrancesToBottom : ( Int, Int ) -> ( Int, Int ) -> Array (Array Char) -> Map -> Map
addInternalPortalAndEntrancesToBottom ( x1, y1 ) ( x2, y2 ) rawMap map =
    List.range x1 x2
        |> List.foldl
            (\x newMap ->
                let
                    element1 =
                        Array.get (y2 - 1) rawMap
                            |> Maybe.andThen (Array.get x)
                            |> Maybe.withDefault ' '

                    element2 =
                        Array.get y2 rawMap
                            |> Maybe.andThen (Array.get x)
                            |> Maybe.withDefault ' '

                    identifier =
                        String.fromList [ element1, element2 ]
                in
                if identifier == "AA" then
                    Array.update (y2 - 1) (Array.set (x - 2) Start) newMap

                else if identifier == "ZZ" then
                    Array.update (y2 - 1) (Array.set (x - 2) End) newMap

                else if identifier > "AA" && identifier < "ZZ" && element2 /= ' ' then
                    Array.update (y2 - 1) (Array.set (x - 2) (Portal identifier)) newMap

                else
                    newMap
            )
            map


parseToElement : Char -> Element
parseToElement char =
    case char of
        '#' ->
            Wall

        ' ' ->
            Void

        '.' ->
            Empty

        _ ->
            Void



-- part 1 --


mainPart1 =
    let
        map =
            parse input

        entrance =
            findEntrance map
    in
    exploreUntilEnd map 0 Dict.empty [ entrance ]
        |> Maybe.map String.fromInt
        |> Maybe.withDefault "Error: path not found"
        |> text


exploreUntilEnd : Map -> Int -> Dict ( Int, Int ) Int -> List ( Int, Int ) -> Maybe Int
exploreUntilEnd map steps visited explorations =
    let
        filteredExplorations =
            explorations
                |> List.filter
                    (\position ->
                        case Dict.get position visited of
                            Nothing ->
                                True

                            Just previousSteps ->
                                if previousSteps <= steps then
                                    False

                                else
                                    True
                    )

        newVisited =
            List.foldl (\position visited_ -> Dict.insert position steps visited_) visited filteredExplorations

        explorationResults =
            List.map (exploreStep map) filteredExplorations

        ( toExplore, hasSolution ) =
            List.foldl
                (\explorationResult ( toExplore_, hasSolution_ ) ->
                    case explorationResult of
                        ToExplore newPositions ->
                            ( toExplore_ ++ newPositions, hasSolution_ )

                        Found ->
                            ( toExplore_, True )
                )
                ( [], False )
                explorationResults
    in
    if hasSolution then
        Just steps

    else
        exploreUntilEnd map (steps + 1) newVisited toExplore


exploreStep : Map -> ( Int, Int ) -> ExplorationResult
exploreStep map currentPosition =
    case elementAt map currentPosition of
        End ->
            Found

        Wall ->
            ToExplore []

        Void ->
            ToExplore []

        _ ->
            [ Up, Down, Left, Right ]
                |> List.map (moveTo map currentPosition)
                |> ToExplore


elementAt : Map -> ( Int, Int ) -> Element
elementAt map ( x, y ) =
    Array.get y map
        |> Maybe.andThen (Array.get x)
        |> Maybe.withDefault Void


moveTo : Map -> ( Int, Int ) -> Direction -> ( Int, Int )
moveTo map ( x, y ) direction =
    let
        element =
            elementAt map ( x, y )

        newPosition =
            case direction of
                Up ->
                    ( x, y - 1 )

                Down ->
                    ( x, y + 1 )

                Left ->
                    ( x - 1, y )

                Right ->
                    ( x + 1, y )
    in
    case element of
        Portal name ->
            if elementAt map newPosition == Void then
                findPortalExit map ( x, y ) name

            else
                newPosition

        _ ->
            newPosition


findPortalExit : Map -> ( Int, Int ) -> String -> ( Int, Int )
findPortalExit map position name =
    Array.indexedMapToList (\y -> Array.indexedMapToList (\x element -> ( x, y, element ))) map
        |> List.concat
        |> List.find (\( x, y, element ) -> element == Portal name && ( x, y ) /= position)
        |> Maybe.map (\( x, y, _ ) -> ( x, y ))
        |> unsafeMaybe ("Unable to find exit of portal " ++ name)


findEntrance : Map -> ( Int, Int )
findEntrance map =
    Array.indexedMapToList (\y -> Array.indexedMapToList (\x element -> ( x, y, element ))) map
        |> List.concat
        |> List.find (\( _, _, element ) -> element == Start)
        |> Maybe.map (\( x, y, _ ) -> ( x, y ))
        |> unsafeMaybe "Unable to find start"



-- Step 2 --


mainPart2 =
    let
        map =
            parse input

        entrance =
            findEntrance map
    in
    exploreRecursivelyUntilEnd map 0 Dict.empty [ ( entrance, 0 ) ]
        |> Maybe.map String.fromInt
        |> Maybe.withDefault "Error: path not found"
        |> text


exploreRecursivelyUntilEnd : Map -> Int -> Dict ( ( Int, Int ), Int ) Int -> List ( ( Int, Int ), Int ) -> Maybe Int
exploreRecursivelyUntilEnd map steps visited explorations =
    let
        filteredExplorations : List ( ( Int, Int ), Int )
        filteredExplorations =
            explorations
                |> List.filter
                    (\position ->
                        case Dict.get position visited of
                            Nothing ->
                                True

                            Just previousSteps ->
                                if previousSteps <= steps then
                                    False

                                else
                                    True
                    )

        newVisited =
            List.foldl (\position visited_ -> Dict.insert position steps visited_) visited filteredExplorations

        explorationResults =
            List.map (exploreRecursivelyStep map) filteredExplorations

        ( toExplore, hasSolution ) =
            List.foldl
                (\explorationResult ( toExplore_, hasSolution_ ) ->
                    case explorationResult of
                        RecursiveToExplore newPositions ->
                            ( toExplore_ ++ newPositions, hasSolution_ )

                        RecursiveFound ->
                            ( toExplore_, True )
                )
                ( [], False )
                explorationResults
    in
    if hasSolution then
        Just steps

    else
        exploreRecursivelyUntilEnd map (steps + 1) newVisited (toExplore |> Set.fromList |> Set.toList)


exploreRecursivelyStep : Map -> ( ( Int, Int ), Int ) -> RecursiveExplorationResult
exploreRecursivelyStep map ( currentPosition, currentLevel ) =
    case ( elementAt map currentPosition, currentLevel ) of
        ( End, 0 ) ->
            RecursiveFound

        ( Wall, _ ) ->
            RecursiveToExplore []

        ( Void, _ ) ->
            RecursiveToExplore []

        ( Portal _, 0 ) ->
            if isOuterPortal map currentPosition then
                RecursiveToExplore []

            else
                [ Up, Down, Left, Right ]
                    |> List.map (moveToRecursive map currentPosition currentLevel)
                    |> RecursiveToExplore

        _ ->
            [ Up, Down, Left, Right ]
                |> List.map (moveToRecursive map currentPosition currentLevel)
                |> RecursiveToExplore


isOuterPortal : Map -> ( Int, Int ) -> Bool
isOuterPortal map ( x, y ) =
    let
        rowSize =
            Array.get 0 map
                |> Maybe.map Array.length
                |> unsafeMaybe "No first row"
    in
    y == 0 || y == (Array.length map - 1) || x == 0 || x == (rowSize - 1)


moveToRecursive : Map -> ( Int, Int ) -> Int -> Direction -> ( ( Int, Int ), Int )
moveToRecursive map ( x, y ) level direction =
    let
        element =
            elementAt map ( x, y )

        newPosition =
            case direction of
                Up ->
                    ( x, y - 1 )

                Down ->
                    ( x, y + 1 )

                Left ->
                    ( x - 1, y )

                Right ->
                    ( x + 1, y )
    in
    case element of
        Portal name ->
            if elementAt map newPosition == Void then
                ( findPortalExit map ( x, y ) name
                , if isOuterPortal map ( x, y ) then
                    level - 1

                  else
                    level + 1
                )

            else
                ( newPosition, level )

        _ ->
            ( newPosition, level )


viewMap : Map -> Html msg
viewMap map =
    map
        |> Array.mapToList (Array.mapToList elementToSpan)
        |> List.map (pre [ style "margin" "0" ])
        |> div []


elementToSpan : Element -> Html msg
elementToSpan element =
    case element of
        Void ->
            span [] [ text " " ]

        Empty ->
            span [] [ text "." ]

        Start ->
            span [] [ text "S" ]

        End ->
            span [] [ text "E" ]

        Wall ->
            span [] [ text "#" ]

        Portal portalName ->
            span [ title portalName ] [ text "P" ]



-- Helpers --


unsafeMaybe : String -> Maybe a -> a
unsafeMaybe error maybe =
    case maybe of
        Just value ->
            value

        Nothing ->
            Debug.todo error
