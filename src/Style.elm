module Style exposing (gridContainer, holdSpace, leftPanel, mainContainer, style)

import Html exposing (Attribute)
import Html.Attributes


type alias Css msg =
    List (Attribute msg)


style : List ( String, String ) -> List (Attribute msg)
style =
    List.map (\( s1, s2 ) -> Html.Attributes.style s1 s2)


mainContainer : Css msg
mainContainer =
    style
        [ ( "display", "flex" )
        , ( "justify-content", "center" )
        ]


gridContainer : Css msg
gridContainer =
    style
        [ ( "text-align", "center" )
        , ( "width", "100%" )
        , ( "height", "100%" )
        , ( "position", "absolute" )
        , ( "top", "0" )
        , ( "left", "0" )
        ]


leftPanel : Css msg
leftPanel =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        ]


holdSpace : Css msg
holdSpace =
    style
        [ ( "width", "300px" )
        , ( "height", "200px" )
        , ( "background", "#000000" )
        , ( "padding-top"
          , "5px"
          )
        , ( "text-align", "center" )
        ]



--            , css [ display block, margin auto ]
