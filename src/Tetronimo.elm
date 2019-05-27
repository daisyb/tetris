module Tetronimo exposing (Tetronimo, addToGrid, fromInt, generator, getCoords, moveDown, moveDownBy, moveLeft, moveRight, rotateLeft, rotateRight, toGrid)

import Grid exposing (Grid)
import Random exposing (Generator)


type alias Coord =
    ( Int, Int )


type State
    = One
    | Two
    | Three
    | Four


type TetronimoName
    = I
    | O
    | T
    | J
    | L
    | S
    | Z


type alias Tetronimo =
    { name : TetronimoName
    , state : State
    , coords : List Coord
    , offset : Coord
    , center : Coord
    , color : String
    }


applyOffsets : Tetronimo -> Tetronimo
applyOffsets t =
    let
        ( x, y ) =
            t.offset

        newCoords =
            List.map (\( i, j ) -> ( i + x, j + y )) t.coords
    in
    { t | coords = newCoords }


toGrid : Tetronimo -> Grid
toGrid t =
    let
        newT =
            applyOffsets t
    in
    Grid.fromList newT.color True newT.coords


addToGrid : Tetronimo -> Grid -> Grid
addToGrid t g =
    Grid.mergeGrid (toGrid t) g


removeFromGrid : String -> Tetronimo -> Grid -> Grid
removeFromGrid color t g =
    Grid.mergeGrid (Grid.fromList color False t.coords) g


moveDown : Tetronimo -> Tetronimo
moveDown t =
    let
        ( x, y ) =
            t.offset
    in
    { t | offset = ( x, y + 1 ) }


moveDownBy : Int -> Tetronimo -> Tetronimo
moveDownBy by t =
    let
        ( x, y ) =
            t.offset
    in
    { t | offset = ( x, y + by ) }


moveLeft : Tetronimo -> Tetronimo
moveLeft t =
    let
        ( x, y ) =
            t.offset
    in
    { t | offset = ( x - 1, y ) }


moveRight : Tetronimo -> Tetronimo
moveRight t =
    let
        ( x, y ) =
            t.offset
    in
    { t | offset = ( x + 1, y ) }


getCoords : Tetronimo -> List Coord
getCoords t =
    let
        newT =
            applyOffsets t
    in
    newT.coords


rotateRight : Tetronimo -> Tetronimo
rotateRight t =
    let
        state =
            prevState t.state
    in
    case t.name of
        O ->
            { t | state = state }

        I ->
            { t
                | state = state
                , coords = rotI state
            }

        _ ->
            let
                ( xPivot, yPivot ) =
                    t.center

                rotCoord ( i, j ) =
                    ( xPivot + yPivot - j, yPivot - xPivot + i )
            in
            { t | state = state, coords = List.map rotCoord t.coords }


rotateLeft : Tetronimo -> Tetronimo
rotateLeft t =
    let
        state =
            nextState t.state
    in
    case t.name of
        O ->
            { t | state = state }

        I ->
            { t | state = state, coords = rotI state }

        _ ->
            let
                ( xPivot, yPivot ) =
                    t.center

                rotCoord ( i, j ) =
                    ( xPivot - yPivot + j, yPivot + xPivot - i )
            in
            { t | state = state, coords = List.map rotCoord t.coords }


generator : Generator Tetronimo
generator =
    Random.map fromInt (Random.int 0 6)


fromInt : Int -> Tetronimo
fromInt i =
    case i of
        0 ->
            initI

        1 ->
            initO

        2 ->
            initT

        3 ->
            initJ

        4 ->
            initL

        5 ->
            initS

        6 ->
            initZ

        _ ->
            Debug.todo "fromInt unreachable line"


nextState : State -> State
nextState state =
    case state of
        One ->
            Two

        Two ->
            Three

        Three ->
            Four

        Four ->
            One


prevState : State -> State
prevState state =
    case state of
        One ->
            Four

        Two ->
            Three

        Three ->
            Two

        Four ->
            Three


initialY : Int
initialY =
    -2


rotI : State -> List Coord
rotI state =
    case state of
        One ->
            [ ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 3, 1 ) ]

        Two ->
            [ ( 2, 0 ), ( 2, 1 ), ( 2, 0 ), ( 2, 1 ) ]

        Three ->
            [ ( 0, 2 ), ( 1, 2 ), ( 2, 2 ), ( 3, 2 ) ]

        Four ->
            [ ( 1, 0 ), ( 1, 1 ), ( 1, 2 ), ( 1, 3 ) ]


initI : Tetronimo
initI =
    { name = I, color = "cyan", state = One, coords = rotI One, offset = ( 3, initialY ), center = ( 1, 1 ) }


initO : Tetronimo
initO =
    let
        coords =
            [ ( 0, 0 ), ( 1, 0 ), ( 0, 1 ), ( 1, 1 ) ]
    in
    { name = O, state = One, color = "yellow", coords = coords, offset = ( 3, initialY ), center = ( 1, 1 ) }


initT : Tetronimo
initT =
    let
        coords =
            [ ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 1, 0 ) ]
    in
    { name = T, state = One, color = "purple", coords = coords, offset = ( 3, initialY ), center = ( 1, 1 ) }


initJ : Tetronimo
initJ =
    let
        coords =
            [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    in
    { name = T, state = One, color = "blue", coords = coords, offset = ( 3, initialY ), center = ( 1, 1 ) }


initL : Tetronimo
initL =
    let
        coords =
            [ ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    in
    { name = L, state = One, color = "orange", coords = coords, offset = ( 3, initialY ), center = ( 1, 1 ) }


initS : Tetronimo
initS =
    let
        coords =
            [ ( 1, 0 ), ( 2, 0 ), ( 0, 1 ), ( 1, 1 ) ]
    in
    { name = S, state = One, color = "green", coords = coords, offset = ( 3, initialY ), center = ( 1, 1 ) }


initZ : Tetronimo
initZ =
    let
        coords =
            [ ( 0, 0 ), ( 1, 0 ), ( 1, 1 ), ( 2, 1 ) ]
    in
    { name = Z, state = One, color = "red", coords = coords, offset = ( 3, initialY ), center = ( 1, 1 ) }



-- J : State -> List Coord
-- J state =
--     case state of
--         One, ->
--             [(0,0), (0,1) (1,1), (2,1)]
--         Two ->
--             [(1,0), (2,0), (1,1), (1,2)]
--         Three ->
--             [(0,1), (1,1), (2,1), (2,2)]
--         Four ->
--             [(2,0), (2,1), (1,1), (0,1)]
-- L : State -> List Coord
-- L state =
--     case state of
--         One, -> [(0,1), (1,1), (2,1), (2,0)]
--         Two - >
