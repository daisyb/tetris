module View exposing (view)

import Grid exposing (Cell, Grid)
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (onClick)
import Model exposing (Model)
import Style
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Tetronimo
import Update exposing (Msg(..))


view : Model -> Html Msg
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
        Style.body
        [ Html.node "link"
            [ Html.Attributes.href "https://fonts.googleapis.com/css?family=Sigmar+One&display=swap", Html.Attributes.rel "stylesheet" ]
            []
        , Html.div
            Style.mainContainer
            [ Html.div
                Style.leftPanel
                [ renderHoldSpace model
                , renderScoreBox model
                ]
            , Html.div
                []
                [ popup model
                , svg
                    [ width "600", height "800", viewBox <| "0 0 " ++ boardWidth ++ " " ++ boardHeight ]
                    board
                ]
            ]
        ]


popup : Model -> Html Msg
popup m =
    if not m.start then
        newGameMenu

    else if m.gameover then
        gameoverMenu m.score

    else if m.paused then
        pauseMenu m.score m.levelStatus.level

    else
        Html.div [] []


pauseMenu : Int -> Int -> Html Msg
pauseMenu score level =
    Html.div
        Style.pauseMenu
        [ Html.div
            Style.menuHeader
            [ Html.text "paused" ]
        , Html.div
            Style.menuText
            [ Html.text <| "Score:" ++ String.fromInt score ]
        , Html.div
            Style.menuText
            [ Html.text <| "Level:" ++ String.fromInt level ]
        , Html.div
            (Style.menuButton
                ++ [ onClick Pause ]
            )
            [ Html.text "Resume" ]
        , Html.div
            (Style.menuButton
                ++ [ onClick NewGame ]
            )
            [ Html.text "Restart" ]
        ]


gameoverMenu : Int -> Html Msg
gameoverMenu score =
    Html.div
        Style.pauseMenu
        [ Html.div
            Style.menuHeader
            [ Html.text "Gameover" ]
        , Html.div
            Style.menuText
            [ Html.text "Final Score:" ]
        , Html.div
            Style.menuText
            [ Html.text <| String.fromInt score ]
        , Html.div
            (Style.menuButton
                ++ [ onClick NewGame ]
            )
            [ Html.text "Restart" ]
        ]


newGameMenu : Html Msg
newGameMenu =
    Html.div
        Style.newGameMenu
        [ Html.div
            Style.menuHeader
            [ Html.text "Tetris" ]
        , Html.div
            (Style.menuButton
                ++ [ onClick Start ]
            )
            [ Html.text "New Game" ]
        ]


renderScoreBox : Model -> Html msg
renderScoreBox m =
    let
        level =
            "Level: " ++ String.fromInt m.levelStatus.level

        score =
            "Score: " ++ String.fromInt m.score
    in
    Html.div
        Style.scoreBox
        [ Html.div
            Style.scoreText
            [ Html.text score ]
        , Html.div
            Style.scoreText
            [ Html.text level ]
        ]


renderHoldSpace : Model -> Html.Html msg
renderHoldSpace model =
    let
        piece =
            case model.hold of
                Nothing ->
                    Grid.empty

                Just i ->
                    i
                        |> Tetronimo.fromInt
                        |> Tetronimo.setOffset 1 1
                        |> Tetronimo.toGrid

        spaceWidth =
            String.fromInt <| 5 * model.board.cellSize

        spaceHeight =
            String.fromInt <| 5 * model.board.cellSize
    in
    Html.div
        Style.holdSpace
        [ Html.div (Style.style [ ( "font-family", "Sigmar One, helvetica, monospace" ), ( "color", "white" ), ( "font-size", "30px" ) ]) [ Html.text "Hold" ]
        , svg
            [ width "200", height "200", viewBox <| "0 0 " ++ spaceWidth ++ " " ++ spaceHeight ]
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
