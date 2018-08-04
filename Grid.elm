module Grid exposing (grid)

{-| Utilities to deal with grids
-}


{-| Returns a list of coordinates representing a square grid

    grid 2 --> [ ( 0, 0 ), ( 0, 1 ), ( 1, 0 ), ( 1, 1 ) ]

-}
grid : Int -> List ( Int, Int )
grid width =
    List.range 0 (width - 1)
        |> List.concatMap
            (\x ->
                List.range 0 (width - 1)
                    |> List.map
                        (\y -> ( x, y ))
            )
