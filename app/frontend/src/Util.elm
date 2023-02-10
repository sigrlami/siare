module Util exposing
    ( bigLabel
    , btnGray
    , btnGreen
    , buildErrorMessage
    , colorBlue
    , colorBrown
    , colorDimGray
    , colorGrayLight
    , colorGreen
    , colorRed
    , fromValuesWithLabels
    , grid_col_1fr_auto
    , grid_col_auto_1fr
    , htmlAddedBrFromString
    , inputS
    , lineHr
    , link
    , localStyle
    , pseudoLinkBtn
    , selectS
    , smallLabel
    , styleInputCss
    , viewInfo
    , viewInfoError
    , viewInfoSuccess
    , viewInfoWarning
    , wrapInput
    , wrapSelect
    )

import Css exposing (Color, Style, after, backgroundColor, borderColor, bottom, color, cursor, em, focus, fontFamilies, fontFamily, fontSize, height, hex, hover, inherit, left, lineHeight, property, px, qt, rgba, right, sansSerif, top, width)
import Css.Global exposing (adjacentSiblings, descendants, typeSelector, withClass)
import Html.Styled exposing (Attribute, Html, a, br, button, div, h3, hr, input, label, option, select, strong, styled, text)
import Html.Styled.Attributes exposing (class, css, selected)
import Html.Styled.Events exposing (onInput)
import Http
import Tailwind.Utilities as TW


htmlAddedBrFromString : String -> List (Html msg)
htmlAddedBrFromString str =
    List.intersperse (br [] []) (List.map text (String.lines str))


localStyle : Style
localStyle =
    Css.batch
        [ color <| hex "#000"
        , TW.text_sm
        , fontFamilies [ qt "Open Sans", .value sansSerif ]
        , descendants [ typeSelector "a" [ color colorBlue, TW.underline ] ]
        , descendants [ typeSelector "select::-ms-expand" [ TW.hidden ] ]
        , descendants
            [ typeSelector "select"
                [ TW.appearance_none
                , TW.bg_transparent
                , TW.border_none
                , TW.p_3
                , TW.m_0
                , TW.w_full
                , fontFamily inherit
                , fontSize inherit
                , cursor inherit
                , lineHeight inherit
                , TW.outline_none
                , property "grid-area" "select"
                , focus
                    [ adjacentSiblings
                        [ typeSelector "div"
                            [ withClass "focus"
                                [ TW.absolute
                                , top <| px -1
                                , left <| px -1
                                , right <| px -1
                                , bottom <| px -1
                                , TW.border
                                , TW.rounded_lg
                                , TW.border_solid
                                , borderColor colorGreen
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , descendants
            [ typeSelector "*"
                [ TW.box_border
                , TW.leading_normal
                ]
            ]
        ]


colorGreen : Color
colorGreen =
    hex "#53AC42"


colorBlue : Color
colorBlue =
    hex "#0A4DD0"


colorDimGray : Color
colorDimGray =
    hex "#595555"


colorBrown : Color
colorBrown =
    hex "#BBABAB"


colorRed : Color
colorRed =
    hex "#C70202"


colorGrayLight : Color
colorGrayLight =
    hex "#F4F4F4"


lineHr : List (Attribute msg) -> List (Html msg) -> Html msg
lineHr =
    styled hr
        [ borderColor colorBrown, TW.border ]


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled button
        [ TW.text_lg, TW.p_4, TW.w_full, TW.rounded_md, TW.cursor_pointer ]


btnGreen : List (Attribute msg) -> List (Html msg) -> Html msg
btnGreen attr h =
    btn ([ css [ backgroundColor colorGreen, TW.border_0, TW.text_white ] ] ++ attr) h


btnGray : List (Attribute msg) -> List (Html msg) -> Html msg
btnGray attr h =
    btn ([ css [ backgroundColor colorGrayLight, color <| hex "#494949", TW.border_2, borderColor colorBrown ] ] ++ attr) h


pseudoLinkBtn : List (Attribute msg) -> List (Html msg) -> Html msg
pseudoLinkBtn =
    styled button
        [ color colorBlue, TW.cursor_pointer, focus [ TW.outline_none ] ]


link : List (Attribute msg) -> List (Html msg) -> Html msg
link =
    styled a
        [ color colorBlue, TW.cursor_pointer, hover [ color colorGreen ] ]



-- css


grid_col_1fr_auto : Css.Style
grid_col_1fr_auto =
    Css.property "grid-template-columns" "1fr auto"


grid_col_auto_1fr : Css.Style
grid_col_auto_1fr =
    Css.property "grid-template-columns" "auto 1fr"


styleInputCss : Css.Style
styleInputCss =
    Css.batch
        [ TW.w_full
        , TW.rounded_lg
        , TW.border
        , TW.border_solid
        , TW.border_gray_400
        , focus
            [ borderColor colorGreen
            , TW.outline_none
            ]
        ]


inputS : List (Attribute msg) -> List (Html msg) -> Html msg
inputS =
    styled input
        [ styleInputCss, TW.p_3 ]


selectS : List (Attribute msg) -> List (Html msg) -> Html msg
selectS =
    styled select
        [ styleInputCss ]


bigLabel : List (Attribute msg) -> List (Html msg) -> Html msg
bigLabel =
    styled label
        [ TW.text_base, TW.font_bold ]


smallLabel : List (Attribute msg) -> List (Html msg) -> Html msg
smallLabel =
    styled label
        [ TW.text_xs, color colorDimGray ]


wrapInput : List (Attribute msg) -> List (Html msg) -> Html msg
wrapInput =
    styled div
        [ TW.grid, TW.gap_2 ]


selectStyl : List (Attribute msg) -> List (Html msg) -> Html msg
selectStyl =
    styled div
        [ styleInputCss
        , TW.relative
        , TW.cursor_pointer
        , after
            [ TW.relative
            , property "content" "''"
            , width <| em 0.8
            , height <| em 0.5
            , backgroundColor colorDimGray
            , property "clip-path" "polygon(100% 0%, 0 0%, 50% 100%)"
            , property "grid-area" "select"
            , TW.justify_self_end
            , right <| px 10
            ]
        , TW.grid
        , property "grid-template-areas" "'select'"
        , TW.items_center
        ]


wrapSelect : List (Attribute msg) -> List (Html msg) -> Html msg
wrapSelect attr h =
    selectStyl attr <| h ++ [ div [ class "focus" ] [] ]



-- Info


viewInfo : List (Attribute msg) -> List (Html msg) -> Html msg
viewInfo =
    styled div
        [ TW.relative
        , TW.p_4
        , TW.pl_8
        , TW.border
        , TW.border_solid
        , TW.border_gray_300
        , after
            [ TW.absolute
            , property "content" "''"
            , TW.h_full
            , width <| px 4
            , TW.inset_y_0
            , left <| px 0
            ]
        ]


viewInfoWarning : String -> Html msg
viewInfoWarning h =
    viewInfo [ css [ backgroundColor <| rgba 255 243 205 1, color <| hex "#856404", after [ backgroundColor <| hex "#f4c32b" ] ] ] [ viewWarning h ]


viewInfoSuccess : Html msg -> Html msg
viewInfoSuccess h =
    viewInfo [ css [ backgroundColor <| rgba 83 172 66 0.06, after [ backgroundColor colorGreen ] ] ] [ h ]


viewInfoError : String -> Html msg
viewInfoError h =
    viewInfo [ css [ backgroundColor <| rgba 199 2 2 0.6, TW.text_white, after [ backgroundColor colorRed ] ] ] [ viewError h ]



--Todo unite viewError + viewWarning


viewError : String -> Html msg
viewError mess =
    let
        head =
            "Error!"
    in
    div []
        [ div [] [ strong [] [ text head ] ]
        , text ("Error: " ++ mess)
        ]


viewWarning : String -> Html msg
viewWarning mess =
    let
        head =
            "Warning!"
    in
    div []
        [ div [] [ strong [] [ text head ] ]
        , text ("Warning: " ++ mess)
        ]


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


fromValuesWithLabels : List ( a, String ) -> a -> (a -> msg) -> Html msg
fromValuesWithLabels valuesWithLabels defaultValue callback =
    let
        optionForTuple ( value, label ) =
            option [ selected (defaultValue == value) ] [ text label ]

        options val _ =
            List.map optionForTuple val

        maybeValueFromLabel l =
            List.filter (\( _, label ) -> label == l) valuesWithLabels
                |> List.head

        valueFromLabel label =
            case maybeValueFromLabel label of
                Nothing ->
                    defaultValue

                Just ( value, _ ) ->
                    value
    in
    select
        [ onInput (callback << valueFromLabel) ]
        (options valuesWithLabels defaultValue)
