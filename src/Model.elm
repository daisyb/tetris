module Model exposing (Model, initModel)

import Grid exposing (Grid)
import Tetronimo exposing (Tetronimo)


type alias Model =
    { board :
        { grid : Grid -- holds game board logical representation
        , cellSize : Int -- size of svg rectangles in view
        , insideColor : String -- color of rects inside grid
        , outsideColor : String -- color of rects outside grid
        , height : Int -- num cells per column
        , width : Int -- num cells per row
        }
    , current : Tetronimo -- current playable piece
    , hold : Maybe Int -- piece currently being held, Nothing to start
    , holdWait : Int -- num piece spawns to disallow holds for
    , tick : Float -- length of time between each "tick" (downward movement), increases as game progress
    , paused : Bool -- if true gameplay pauses
    , gameover : Bool -- if true gameplay ends
    , start : Bool -- if true start new game
    , levelStatus :
        { level : Int -- curent level
        , lines : Int -- num lines cleared in current level, reset after each level
        }
    , score : Int -- current score
    }


initModel : Model
initModel =
    let
        insideColor =
            "black"

        outsideColor =
            "gray"

        height =
            20

        width =
            10
    in
    { board =
        { grid = Grid.initGrid insideColor outsideColor height width
        , cellSize = 35
        , insideColor = insideColor
        , outsideColor = outsideColor
        , height = height
        , width = width
        }
    , current = Tetronimo.fromInt 0
    , hold = Nothing
    , start = False
    , holdWait = 0
    , tick = 1000
    , paused = False
    , gameover = False
    , levelStatus =
        { level = 1
        , lines = 0
        }
    , score = 0
    }
