module Model exposing (Model, initModel)

import Grid exposing (Grid)
import Tetronimo exposing (Tetronimo)


type alias Model =
    { board :
        { grid : Grid
        , cellSize : Int
        , insideColor : String
        , outsideColor : String
        , height : Int
        , width : Int
        }
    , current : Tetronimo
    , tick : Float
    , paused : Bool
    , gameover : Bool
    , levelStatus :
        { level : Int
        , lines : Int
        }
    , score : Int
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
    , current = Tetronimo.fromInt 2
    , tick = 1000
    , paused = False
    , gameover = False
    , levelStatus =
        { level = 1
        , lines = 0
        }
    , score = 0
    }
