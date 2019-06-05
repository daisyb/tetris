module Style exposing (body, holdSpace, leftPanel, mainContainer, menu, menuButton, menuHeader, menuText, newGameMenu, pauseMenu, scoreBox, scoreText, style)

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


body : Css msg
body =
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
        , ( "background", "black" )
        ]
        ++ menu


scoreBox : Css msg
scoreBox =
    style
        [ ( "width", "300px" )
        , ( "height", "300px" )
        , ( "margin-top", "10px" )
        , ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "justify-content", "center" )
        ]
        ++ menu


scoreText : Css msg
scoreText =
    style
        [ ( "font-size", "30px" )
        , ( "text-align", "left" )
        , ( "margin", "30px" )
        , ( "color", "white" )
        , ( "font-family", "Sigmar One, helvetica, monospace" )
        ]


menu : Css msg
menu =
    style
        [ ( "font-family", "Sigmar One, helvetica, monospace" )
        , ( "background-color", "#304870" )
        , ( "color", "white" )
        , ( "font-size", "32px" )
        , ( "border", "5px solid #797b7f" )
        , ( "border-radius", "15px" )
        ]


pauseMenu : Css msg
pauseMenu =
    style
        [ ( "width", "220px" )
        , ( "height", "320px" )
        , ( "top", "25%" )
        , ( "left", "50%" )
        , ( "text-align", "center" )
        , ( "position", "fixed" )
        ]
        ++ menu


newGameMenu : Css msg
newGameMenu =
    pauseMenu
        ++ style
            [ ( "width", "220px" )
            , ( "height", "220px" )
            , ( "font-size", "45px" )
            ]


menuHeader : Css msg
menuHeader =
    style
        [ ( "padding", "10px" )
        ]


menuText : Css msg
menuText =
    style
        [ ( "color", "black" )
        ]


menuButton : Css msg
menuButton =
    style
        [ ( "color", "white" )
        , ( "background", " #534bc1" )
        , ( "border", "3px double #797b7f" )
        , ( "border-radius", "10px" )
        , ( "margin", "10px" )
        , ( "padding", "5px 0px 5px 0px" )
        , ( "font-size", "25px" )
        , ( "cursor", "pointer" )
        ]
