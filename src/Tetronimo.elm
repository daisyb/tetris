module Tetronimo exposing (Tetronimo, TetronimoName(..), addToGrid, fromInt, generator, getCoords, moveDown, moveDownBy, moveLeft, moveRight, rotateLeft, rotateRight, setOffset, toGrid, toInt)

import Grid exposing (Grid)
import Random exposing (Generator)


type alias Coord =
    ( Int, Int )


type TetronimoName
    = I Int
    | O
    | T
    | J
    | L
    | S
    | Z


type alias Tetronimo =
    { name : TetronimoName, color : String, coords : List Coord, xoffset : Int, yoffset : Int, center : Coord }


applyOffsets : Tetronimo -> Tetronimo
applyOffsets t =
    let
        newCoords =
            List.map (\( i, j ) -> ( i + t.xoffset, j + t.yoffset )) t.coords
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
    Grid.merge (toGrid t) g


removeFromGrid : String -> Tetronimo -> Grid -> Grid
removeFromGrid color t g =
    Grid.merge (Grid.fromList color False t.coords) g


moveDown : Tetronimo -> Tetronimo
moveDown t =
    { t | yoffset = t.yoffset + 1 }


moveDownBy : Int -> Tetronimo -> Tetronimo
moveDownBy by t =
    { t | yoffset = t.yoffset + by }


moveLeft : Tetronimo -> Tetronimo
moveLeft t =
    { t | xoffset = t.xoffset - 1 }


moveRight : Tetronimo -> Tetronimo
moveRight t =
    { t | xoffset = t.xoffset + 1 }


setOffset : Int -> Int -> Tetronimo -> Tetronimo
setOffset x y t =
    { t | xoffset = x, yoffset = y }


getCoords : Tetronimo -> List Coord
getCoords t =
    let
        newT =
            applyOffsets t
    in
    newT.coords


rotateRight : Tetronimo -> Tetronimo
rotateRight t =
    case t.name of
        O ->
            t

        I x ->
            let
                x_ =
                    if x == 3 then
                        0

                    else
                        x + 1
            in
            { t
                | name = I x_
                , coords = rotI x_
            }

        _ ->
            let
                ( xPivot, yPivot ) =
                    t.center

                rotCoord ( i, j ) =
                    ( xPivot + yPivot - j, yPivot - xPivot + i )
            in
            { t | coords = List.map rotCoord t.coords }


rotateLeft : Tetronimo -> Tetronimo
rotateLeft t =
    case t.name of
        O ->
            t

        I x ->
            let
                x_ =
                    if x == 0 then
                        3

                    else
                        x - 1
            in
            { t
                | name = I x_
                , coords = rotI x_
            }

        _ ->
            let
                ( xPivot, yPivot ) =
                    t.center

                rotCoord ( i, j ) =
                    ( xPivot - yPivot + j, yPivot + xPivot - i )
            in
            { t | coords = List.map rotCoord t.coords }


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


toInt : Tetronimo -> Int
toInt t =
    case t.name of
        I _ ->
            0

        O ->
            1

        T ->
            2

        J ->
            3

        L ->
            4

        S ->
            5

        Z ->
            6


rotI : Int -> List Coord
rotI state =
    case state of
        0 ->
            [ ( 0, 0 ), ( 1, 0 ), ( 2, 0 ), ( 3, 0 ) ]

        1 ->
            [ ( 2, -1 ), ( 2, 0 ), ( 2, 1 ), ( 2, 2 ) ]

        2 ->
            [ ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 3, 1 ) ]

        3 ->
            [ ( 1, -1 ), ( 1, 0 ), ( 1, 1 ), ( 1, 2 ) ]

        _ ->
            Debug.todo "rotI unreachablexs"


initialY : Int
initialY =
    0


initI : Tetronimo
initI =
    { name = I 0, color = "cyan", coords = rotI 0, xoffset = 3, yoffset = initialY, center = ( 1, 1 ) }


initO : Tetronimo
initO =
    let
        coords =
            [ ( 0, 0 ), ( 1, 0 ), ( 0, 1 ), ( 1, 1 ) ]
    in
    { name = O, color = "yellow", coords = coords, center = ( 1, 0 ), yoffset = initialY, xoffset = 4 }


initT : Tetronimo
initT =
    let
        coords =
            [ ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 1, 0 ) ]
    in
    { name = T, color = "purple", coords = coords, xoffset = 3, yoffset = initialY, center = ( 1, 1 ) }


initJ : Tetronimo
initJ =
    let
        coords =
            [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    in
    { name = J, color = "blue", coords = coords, yoffset = initialY, xoffset = 3, center = ( 1, 1 ) }


initL : Tetronimo
initL =
    let
        coords =
            [ ( 2, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]
    in
    { name = L, color = "orange", coords = coords, xoffset = 3, yoffset = initialY, center = ( 1, 1 ) }


initS : Tetronimo
initS =
    let
        coords =
            [ ( 1, 0 ), ( 2, 0 ), ( 0, 1 ), ( 1, 1 ) ]
    in
    { name = S, color = "green", coords = coords, xoffset = 3, yoffset = initialY, center = ( 1, 1 ) }


initZ : Tetronimo
initZ =
    let
        coords =
            [ ( 0, 0 ), ( 1, 0 ), ( 1, 1 ), ( 2, 1 ) ]
    in
    { name = Z, color = "red", coords = coords, xoffset = 3, yoffset = initialY, center = ( 1, 1 ) }
