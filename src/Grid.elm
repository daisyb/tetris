module Grid exposing (Cell, Grid, checkForLines, clearLines, collision, empty, fromList, initGrid, lowestCellInCollumn, merge, toList)

import Dict exposing (Dict)


type alias Coord =
    ( Int, Int )


type alias Cell =
    { color : String, filled : Bool, x : Int, y : Int }


type alias Grid =
    Dict Coord Cell


empty : Grid
empty =
    Dict.empty


initGrid : String -> String -> Int -> Int -> Grid
initGrid insideColor outsideColor height width =
    let
        emptyGrid_ : Int -> Int -> List ( Coord, Cell ) -> List ( Coord, Cell )
        emptyGrid_ i j acc =
            if j > height then
                acc

            else
                let
                    -- boarder cells
                    filled =
                        i == -1 || i == width || j == height

                    color =
                        if filled then
                            outsideColor

                        else
                            insideColor

                    cell =
                        ( ( i, j ), Cell color filled i j )
                in
                let
                    inci =
                        if i >= width then
                            -1

                        else
                            i + 1

                    incj =
                        if i >= width then
                            j + 1

                        else
                            j
                in
                emptyGrid_ inci incj (cell :: acc)
    in
    Dict.fromList <| emptyGrid_ -1 -2 []


fromList : String -> Bool -> List Coord -> Grid
fromList color filled coords =
    Dict.fromList <|
        List.map (\( i, j ) -> ( ( i, j ), Cell color filled i j )) coords


toList : Grid -> List Cell
toList g =
    Dict.toList g |> List.map (\( _, cell ) -> cell)


merge : Grid -> Grid -> Grid
merge g1 g2 =
    Dict.union g1 g2


collision : Coord -> Grid -> Bool
collision key g =
    case Dict.get key g of
        Nothing ->
            False

        Just cell ->
            cell.filled



{-
   for dropping pieces
     finds the cell with the lowest x value in col that is filled
-}


lowestCellInCollumn : Int -> Grid -> Int -> Int
lowestCellInCollumn max grid col =
    Dict.foldl
        (\( i, j ) c acc ->
            if i == col && c.filled && j < acc && j >= 0 then
                j

            else
                acc
        )
        max
        grid


checkForLine : Int -> Int -> Grid -> Int -> Bool
checkForLine rowSize height grid row =
    let
        numFilled =
            Dict.foldl
                (\( _, j ) c acc ->
                    if j == row && c.filled && height > j then
                        acc + 1

                    else
                        acc
                )
                0
                grid
    in
    numFilled == (rowSize + 2)


checkForLines : Int -> Int -> Grid -> List Int
checkForLines height width grid =
    List.filter (checkForLine width height grid) (List.range 0 height)


topRow : String -> String -> Int -> Grid
topRow insideColor outsideColor width =
    let
        minH =
            -2

        transformation i =
            if i == -1 || i >= width then
                ( ( i, minH ), Cell outsideColor True i minH )

            else
                ( ( i, minH ), Cell insideColor False i minH )
    in
    Dict.fromList <| List.map transformation (List.range -1 width)


clearLine : String -> String -> Int -> Grid -> Int -> Grid
clearLine insideColor outsideColor rowSize grid row =
    let
        clearLine_ ( x, y ) cell g =
            if row == y then
                g

            else if y < row then
                Dict.insert ( x, y + 1 ) { cell | y = y + 1 } g

            else
                Dict.insert ( x, y ) cell g
    in
    Dict.foldl clearLine_ Dict.empty grid
        |> Dict.union (topRow insideColor outsideColor rowSize)


clearLines : String -> String -> Int -> List Int -> Grid -> Grid
clearLines insideColor outsideColor width lines grid =
    List.foldl (\i acc -> clearLine insideColor outsideColor width acc i) grid lines
