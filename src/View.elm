module View exposing (view)

import Grid exposing (Cell, Grid)
import Html exposing (Html)
import Html.Attributes
import Model exposing (Model)
import Style
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
        Style.gridContainer
        [ Html.div
            Style.mainContainer
            [ Html.div
                Style.leftPanel
                [ renderHoldSpace model
                , Html.text ("Level: " ++ String.fromInt model.levelStatus.level ++ "  Score: " ++ String.fromInt model.score)
                ]
            , Html.div
                []
                [ svg
                    [ width "800", height "800", viewBox <| "0 0 " ++ boardWidth ++ " " ++ boardHeight ]
                    board
                ]
            ]
        ]


renderHoldSpace : Model -> Html.Html msg
renderHoldSpace model =
    let
        piece =
            case model.hold of
                Nothing ->
                    Grid.empty

                Just i ->
                    let
                        t =
                            Tetronimo.fromInt i

                        t_ =
                            case t.name of
                                Tetronimo.O ->
                                    Tetronimo.setOffset 1.5 1.5 t

                                Tetronimo.I _ ->
                                    Tetronimo.setOffset 0.5 1.5 t

                                _ ->
                                    Tetronimo.setOffset 0 1 t
                    in
                    Tetronimo.toGrid t_

        coords =
            List.concatMap
                (\i -> List.map (\j -> ( i, j )) (List.range 0 4))
                (List.range 0 4)

        space =
            Grid.fromList model.board.insideColor False coords
                |> Grid.merge piece

        spaceWidth =
            String.fromInt <| 5 * model.board.cellSize

        spaceHeight =
            String.fromInt <| 5 * model.board.cellSize
    in
    Html.div
        Style.holdSpace
        [ svg
            ([ width "200", height "200", viewBox <| "0 0 " ++ spaceWidth ++ " " ++ spaceHeight ]
                ++ Style.style [ ( "display", "block" ), ( "margin", "auto" ) ]
            )
            (renderBoard model.board.cellSize piece)
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
