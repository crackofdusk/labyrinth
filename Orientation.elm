module Orientation exposing (Orientation, generator, toAngle)

import Random exposing (Generator)



{- Representation of line orientation -}


type Orientation
    = Main
    | Cross


generator : Generator Orientation
generator =
    Random.uniform Main [ Main, Cross ]


{-| Transforms the orientation to an angle in degrees
-}
toAngle : Orientation -> Int
toAngle orientation =
    case orientation of
        Main ->
            0

        Cross ->
            90
