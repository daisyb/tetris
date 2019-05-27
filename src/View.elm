module View exposing (view)

import Grid exposing (Cell, Grid)
import Html exposing (Html)
import Html.Attributes
import Model exposing (Model)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Tetronimo


view : Model -> Html msg
view model =
    let
        boardWidth =
            String.fromInt <| model.board.cellSize * (model.board.width + 2)

        boardHeight =
            String.fromInt <| model.board.cellSize * (model.board.height + 1)

        board =
            renderBoard model.board.cellSize model.board.grid
                ++ renderBoard model.board.cellSize (Tetronimo.toGrid model.current)
    in
    Html.div
        [ Html.Attributes.style "text-align" "center"
        , Html.Attributes.style "width" "100%"
        , Html.Attributes.style "height" "100%"
        , Html.Attributes.style "position" "absolute"
        , Html.Attributes.style "top" "0"
        , Html.Attributes.style "left" "0"
        ]
        [ Html.text ("Level: " ++ String.fromInt model.levelStatus.level ++ "  Score: " ++ String.fromInt model.score)
        , svg
            [ width "800", height "800", viewBox <| "0 0 " ++ boardWidth ++ " " ++ boardHeight ]
            board
        ]


renderRect : Int -> Cell -> Svg msg
renderRect size cell =
    rect
        [ x <| String.fromInt <| cell.x * size
        , y <| String.fromInt <| cell.y * size
        , width <| String.fromInt size
        , height <| String.fromInt size
        , fill cell.color
        , stroke "gray"
        ]
        []


renderBoard : Int -> Grid -> List (Svg msg)
renderBoard cellSize grid =
    List.map (renderRect cellSize) (Grid.toList grid)