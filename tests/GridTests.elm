module GridTests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Grid exposing (grid)
import Test exposing (..)


suite : Test
suite =
    describe "grid"
        [ test "3 by 3" <|
            \_ ->
                grid 3
                    |> Expect.equal [ ( 0, 0 ), ( 0, 1 ), ( 0, 2 ), ( 1, 0 ), ( 1, 1 ), ( 1, 2 ), ( 2, 0 ), ( 2, 1 ), ( 2, 2 ) ]
        , test "0 by 0" <|
            \_ ->
                grid 0 |> Expect.equal []
        , fuzz (Fuzz.intRange 0 1000) "grid of side n contains n * n elements" <|
            \n ->
                grid n
                    |> List.length
                    |> Expect.equal (n * n)
        , fuzz (Fuzz.intRange 1 100) "coordinates are positive" <|
            \n ->
                grid n
                    |> List.concatMap (\( x, y ) -> [ x, y ])
                    |> List.minimum
                    |> Expect.equal (Just 0)
        , fuzz (Fuzz.intRange 1 100) "coordinates are bounded to the grid size" <|
            \n ->
                grid n
                    |> List.concatMap (\( x, y ) -> [ x, y ])
                    |> List.maximum
                    |> Expect.equal (Just (n - 1))
        ]
