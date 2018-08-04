module Main exposing (..)

import Html exposing (Html, text)
import Html.Attributes
import Svg exposing (Svg)
import Svg.Attributes
import Grid exposing (grid)


-- MODEL


type alias Model =
    { size : Int }


type alias Point =
    { x : Float, y : Float }


type alias Segment =
    { start : Point, end : Point }


init : ( Model, Cmd Msg )
init =
    ( { size = 15 }
    , Cmd.none
    )


segments : Int -> List Segment
segments n =
    List.repeat n ({ start = Point -0.5 -0.5, end = Point 0.5 0.5 })



-- UPDATE


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html msg
view model =
    List.map2
        placeSegment
        (grid model.size)
        (segments (model.size * model.size))
        |> canvas ((toFloat model.size) * scale)
        |> container


scale : Float
scale =
    50.0


placeSegment : ( Int, Int ) -> Segment -> Svg msg
placeSegment ( x, y ) segment =
    Svg.g
        [ Svg.Attributes.transform
            ("scale(" ++ toString scale ++ ")" ++ " translate(" ++ toString x ++ "," ++ toString y ++ ")")
        , Svg.Attributes.strokeWidth <| (toString (2 / scale)) ++ "px"
        ]
        [ viewSegment segment ]


viewSegment : Segment -> Html msg
viewSegment segment =
    Svg.line
        [ Svg.Attributes.x1 (toString segment.start.x)
        , Svg.Attributes.x2 (toString segment.end.x)
        , Svg.Attributes.y1 (toString segment.start.y)
        , Svg.Attributes.y2 (toString segment.end.y)
        , Svg.Attributes.stroke "black"
        ]
        []


container : Html msg -> Html msg
container element =
    Html.div
        [ Html.Attributes.style
            [ ( "display", "flex" )
            , ( "justify-content", "center" )
            , ( "align-items", "center" )
            , ( "height", "100%" )
            ]
        ]
        [ element ]


canvas : Float -> List (Svg msg) -> Svg msg
canvas size elements =
    Svg.svg
        [ Svg.Attributes.viewBox ("0 0 " ++ toString size ++ " " ++ toString size)
        , Svg.Attributes.width (toString size)
        , Svg.Attributes.height (toString size)
        ]
        elements



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
