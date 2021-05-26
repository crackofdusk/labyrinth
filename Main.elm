module Main exposing (Model, Msg(..), Point, Segment, canvas, container, init, main, orientationsGenerator, placeSegment, scale, segments, update, view, viewSegment)

import Browser
import Grid exposing (grid)
import Html exposing (Html, text)
import Html.Attributes
import Orientation exposing (Orientation)
import Random exposing (Generator)
import Svg exposing (Svg)
import Svg.Attributes



-- MODEL


type alias Model =
    { size : Int
    , orientations : List Orientation
    }


type alias Point =
    { x : Float, y : Float }


type alias Segment =
    { start : Point, end : Point }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { size = 15
      , orientations = []
      }
    , Random.generate OrientationsGenerated (orientationsGenerator (15 * 15))
    )


segments : Int -> List Segment
segments n =
    List.repeat n { start = Point -0.5 -0.5, end = Point 0.5 0.5 }



-- UPDATE


type Msg
    = OrientationsGenerated (List Orientation)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        OrientationsGenerated orientations ->
            ( { model | orientations = orientations }, Cmd.none )


orientationsGenerator : Int -> Generator (List Orientation)
orientationsGenerator n =
    Random.list n Orientation.generator



-- VIEW


view : Model -> Browser.Document msg
view model =
    { title = "Labyrinth"
    , body =
        [ Html.div [ Html.Attributes.style "padding" "2rem" ]
            [ List.map3
                placeSegment
                (grid model.size)
                (segments (model.size * model.size))
                model.orientations
                |> canvas (toFloat model.size * scale)
            , Html.footer
                [ Html.Attributes.style "padding" "2rem"
                , Html.Attributes.style "text-align" "center"
                ]
                [ Html.a
                    [ Html.Attributes.href "https://github.com/crackofdusk/labyrinth"
                    , Html.Attributes.style "font-family" "monospace"
                    ]
                    [ Html.text "Source code" ]
                ]
            ]
            |> container
        ]
    }


scale : Float
scale =
    50.0


placeSegment : ( Int, Int ) -> Segment -> Orientation -> Svg msg
placeSegment ( x, y ) segment orientation =
    Svg.g
        [ Svg.Attributes.transform
            ("scale("
                ++ String.fromFloat scale
                ++ ")"
                ++ " translate("
                ++ String.fromInt x
                ++ ","
                ++ String.fromInt y
                ++ ")"
                ++ " rotate("
                ++ String.fromInt (Orientation.toAngle orientation)
                ++ ")"
            )
        , Svg.Attributes.strokeWidth <| String.fromFloat (2 / scale) ++ "px"
        ]
        [ viewSegment segment ]


viewSegment : Segment -> Html msg
viewSegment segment =
    Svg.line
        [ Svg.Attributes.x1 (String.fromFloat segment.start.x)
        , Svg.Attributes.x2 (String.fromFloat segment.end.x)
        , Svg.Attributes.y1 (String.fromFloat segment.start.y)
        , Svg.Attributes.y2 (String.fromFloat segment.end.y)
        , Svg.Attributes.stroke "black"
        ]
        []


container : Html msg -> Html msg
container element =
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "justify-content" "center"
        , Html.Attributes.style "align-items" "center"
        , Html.Attributes.style "height" "100vh"
        ]
        [ element ]


canvas : Float -> List (Svg msg) -> Svg msg
canvas size elements =
    Svg.svg
        [ Svg.Attributes.viewBox ("0 0 " ++ String.fromFloat size ++ " " ++ String.fromFloat size)
        , Svg.Attributes.width (String.fromFloat size)
        , Svg.Attributes.height (String.fromFloat size)
        ]
        elements



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
