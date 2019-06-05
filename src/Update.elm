module Update exposing (Msg(..), checkForCollisions, movePiece, subscriptions, update)

import Browser.Events
import Grid exposing (Grid)
import Json.Decode as Decode
import Key exposing (Key)
import Model exposing (Model, initModel)
import Random
import Tetronimo exposing (Tetronimo)
import Time


type Msg
    = Tick
    | NextPiece Tetronimo
    | KeyDown Key
    | Pause
    | Update
    | NewGame
    | Start


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            if checkForCollisions (Tetronimo.moveDown model.current) model.board.grid then
                update Update model

            else
                movePiece Tetronimo.moveDown model

        NextPiece t ->
            let
                holdWait =
                    if model.holdWait > 0 then
                        model.holdWait - 1

                    else
                        model.holdWait
            in
            ( { model | current = t, holdWait = holdWait }, Cmd.none )

        KeyDown k ->
            onKeyDown k model

        Pause ->
            ( { model | paused = not model.paused }, Cmd.none )

        Update ->
            let
                m =
                    updateBoard model
            in
            if m.gameover then
                ( m, Cmd.none )

            else
                ( m, generateNextPiece )

        NewGame ->
            ( initModel, Cmd.none )

        Start ->
            ( { model | start = True }, generateNextPiece )


checkConditions : Model -> Sub Msg -> Sub Msg
checkConditions model msg =
    if model.paused || model.gameover || not model.start then
        Sub.none

    else
        msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ checkConditions model
            (Time.every model.tick (\_ -> Tick))
        , checkConditions model
            (Browser.Events.onKeyDown (Decode.map KeyDown Key.keyDecoder))
        ]


generateNextPiece : Cmd Msg
generateNextPiece =
    Random.generate NextPiece Tetronimo.generator


onKeyDown : Key -> Model -> ( Model, Cmd Msg )
onKeyDown k m =
    case k of
        Key.Left ->
            movePiece Tetronimo.moveLeft m

        Key.Right ->
            movePiece Tetronimo.moveRight m

        Key.Down ->
            softDrop m

        Key.HardDrop ->
            hardDrop m

        Key.RightRotate ->
            movePiece Tetronimo.rotateRight m

        Key.LeftRotate ->
            movePiece Tetronimo.rotateLeft m

        Key.Pause ->
            update Pause m

        Key.Hold ->
            hold m

        _ ->
            ( m, Cmd.none )


updateScore : Int -> Model -> Model
updateScore numLines m =
    if numLines == 0 then
        m

    else
        let
            linesCleared =
                m.levelStatus.lines
                    + (case numLines of
                        1 ->
                            1

                        2 ->
                            3

                        3 ->
                            5

                        4 ->
                            8

                        _ ->
                            0
                      )

            level =
                m.levelStatus.level

            score =
                m.score + level * 100 * linesCleared

            linesToClear =
                level * 5
        in
        if linesCleared >= linesToClear then
            --next level
            { m
                | score = score
                , levelStatus = { level = level + 1, lines = linesCleared - linesToClear }
                , tick = m.tick - (m.tick / 4.5)
            }

        else
            { m
                | score = score
                , levelStatus = { level = level, lines = linesCleared }
            }


updateBoard : Model -> Model
updateBoard m =
    let
        board =
            m.board

        grid =
            board.grid
                |> Tetronimo.addToGrid m.current

        lines =
            Grid.checkForLines board.height board.width grid

        numLines =
            List.length lines

        newGrid =
            grid
                |> Grid.clearLines board.insideColor board.outsideColor board.width lines

        gameover =
            checkForGameOver board.width newGrid
    in
    { m | board = { board | grid = newGrid }, gameover = gameover }
        |> updateScore numLines


checkForGameOver : Int -> Grid -> Bool
checkForGameOver width g =
    let
        h =
            -1

        widths =
            List.range 0 (width - 1)
    in
    List.foldl (\x -> (||) (Grid.collision ( x, h ) g)) False widths


checkForCollisions : Tetronimo -> Grid -> Bool
checkForCollisions t g =
    t |> Tetronimo.getCoords |> List.foldl (\k -> (||) (Grid.collision k g)) False


movePiece : (Tetronimo -> Tetronimo) -> Model -> ( Model, Cmd Msg )
movePiece moveFunction model =
    let
        newCurrent =
            moveFunction model.current
    in
    if checkForCollisions newCurrent model.board.grid then
        ( model, Cmd.none )

    else
        ( { model | current = newCurrent }, Cmd.none )


softDrop : Model -> ( Model, Cmd Msg )
softDrop m =
    let
        newCurrent =
            Tetronimo.moveDown m.current
    in
    if checkForCollisions newCurrent m.board.grid then
        update Update m

    else
        ( { m | current = newCurrent, score = m.score + 1 }, Cmd.none )


hardDrop : Model -> ( Model, Cmd Msg )
hardDrop m =
    let
        lowestFilled col =
            Grid.lowestCellInCollumn m.board.height m.board.grid col

        dropDist =
            m.current
                |> Tetronimo.getCoords
                |> List.foldl (\( i, j ) -> min (lowestFilled i - (j + 1))) m.board.height

        newCurrent =
            Tetronimo.moveDownBy dropDist m.current
    in
    update Update { m | current = newCurrent, score = m.score + 2 * dropDist }


hold : Model -> ( Model, Cmd Msg )
hold m =
    case m.hold of
        Nothing ->
            ( { m | hold = Just (Tetronimo.toInt m.current), holdWait = 1 }, generateNextPiece )

        Just i ->
            if m.holdWait > 0 then
                ( m, Cmd.none )

            else
                ( { m
                    | current = Tetronimo.fromInt i
                    , hold = Just (Tetronimo.toInt m.current)
                    , holdWait = 1
                  }
                , Cmd.none
                )
