module Main exposing (main)

import Browser
import Model exposing (Model, initModel)
import Update exposing (Msg, subscriptions, update)
import View exposing (view)


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init () =
    ( initModel, Cmd.none )


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
