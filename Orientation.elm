module Orientation exposing (Orientation, generator, toAngle)

import Random exposing (Generator)


{- Representation of line orientation -}


type Orientation
    = Main
    | Cross


generator : Generator Orientation
generator =
    Random.map booleanToOrientation Random.bool


{-| Transforms the orientation to an angle in degrees
-}
toAngle : Orientation -> Int
toAngle orientation =
    case orientation of
        Main ->
            0

        Cross ->
            90


booleanToOrientation : Bool -> Orientation
booleanToOrientation bool =
    case bool of
        True ->
            Main

        False ->
            Cross
