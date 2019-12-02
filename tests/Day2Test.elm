module Day2Test exposing (..)

import Array
import Day2 exposing (iterate, parse)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Expected results"
        [ test "Example 1" <|
            \_ ->
                let
                    result =
                        "1,0,0,0,99"
                            |> parse
                            |> Debug.log "parsed"
                            |> iterate 0
                            |> Debug.log "result"
                            |> Array.get 0
                in
                Expect.equal (Just 2) result
        ]
