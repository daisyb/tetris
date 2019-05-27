module Key exposing (Key(..), keyDecoder)

import Json.Decode as Decode


type Key
    = Left
    | Right
    | Down
    | Pause
    | HardDrop
    | LeftRotate
    | RightRotate
    | Hold
    | Other


keyDecoder : Decode.Decoder Key
keyDecoder =
    Decode.map toKey (Decode.field "keyCode" Decode.int)


toKey : Int -> Key
toKey code =
    case code of
        37 ->
            -- left arrow
            Left

        39 ->
            -- right arrow
            Right

        40 ->
            -- down arrow
            Down

        32 ->
            -- space bar
            HardDrop

        38 ->
            -- up arrow
            RightRotate

        88 ->
            -- X
            RightRotate

        90 ->
            -- Z
            LeftRotate

        17 ->
            -- Ctrl
            LeftRotate

        80 ->
            -- P
            Pause

        27 ->
            -- Esc
            Pause

        67 ->
            Hold

        16 ->
            Hold

        _ ->
            Other
