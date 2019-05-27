module Update exposing (Msg, checkForCollisions, movePiece, subscriptions, update)

import Browser.Events
import Grid exposing (Grid)
import Json.Decode as Decode
import Key exposing (Key)
import Model exposing (Model)
import Random
import Tetronimo exposing (Tetronimo)
import Time


type Msg
    = Tick
    | NextPiece Tetronimo
    | KeyDown Key


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            movePiece Tetronimo.moveDown generateNextPiece model

        NextPiece t ->
            ( { model | current = t }
            , Cmd.none
            )

        KeyDown k ->
            onKeyDown k model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.paused || model.gameover then
            Sub.none

          else
            Time.every model.tick (\_ -> Tick)
        , Browser.Events.onKeyDown (Decode.map KeyDown Key.keyDecoder)
        ]


generateNextPiece : Cmd Msg
generateNextPiece =
    Random.generate NextPiece Tetronimo.generator


onKeyDown : Key -> Model -> ( Model, Cmd Msg )
onKeyDown k m =
    case k of
        Key.Left ->
            movePiece Tetronimo.moveLeft Cmd.none m

        Key.Right ->
            movePiece Tetronimo.moveRight Cmd.none m

        Key.Down ->
            movePiece Tetronimo.moveDown Cmd.none m

        Key.HardDrop ->
            dropPiece m

        Key.RightRotate ->
            movePiece Tetronimo.rotateRight Cmd.none m

        Key.LeftRotate ->
            movePiece Tetronimo.rotateLeft Cmd.none m

        Key.Pause ->
            ( { m | paused = not m.paused }, Cmd.none )

        Key.Hold ->
            case m.hold of
                Nothing ->
                    ( { m | hold = Just (Tetronimo.toInt m.current) }, generateNextPiece )

                Just i ->
                    ( { m | current = Tetronimo.fromInt i, hold = Just (Tetronimo.toInt m.current) }, Cmd.none )

        _ ->
            ( m, Cmd.none )


updateScore : Int -> Model -> Model
updateScore numLines m =
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
            level * 100 * linesCleared

        linesToClear =
            level * 5
    in
    if linesCleared >= linesToClear then
        { m
            | score = score
            , levelStatus = { level = level + 1, lines = linesCleared - linesToClear }
            , tick = m.tick - (m.tick / 4)
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
            checkForGameOver board.width board.grid
    in
    { m | board = { board | grid = newGrid } }
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


movePiece : (Tetronimo -> Tetronimo) -> Cmd Msg -> Model -> ( Model, Cmd Msg )
movePiece moveFunction collisionResponse model =
    let
        newCurrent =
            moveFunction model.current
    in
    if checkForCollisions newCurrent model.board.grid then
        ( model |> updateBoard, collisionResponse )

    else
        ( { model | current = newCurrent }, Cmd.none )


dropPiece : Model -> ( Model, Cmd Msg )
dropPiece m =
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
    ( { m | current = newCurrent } |> updateBoard, generateNextPiece )
