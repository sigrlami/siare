module Modal exposing (..)

import Css exposing (color, int, minWidth, px, zIndex)
import Html.Styled exposing (Html, div, p, span, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Tailwind.Breakpoints exposing (sm)
import Tailwind.Utilities as TW
import Util


viewModal : Html msg -> Html msg
viewModal content =
    div []
        [ --wrapper
          div
            [ css
                [ TW.fixed
                , TW.w_screen
                , TW.h_screen
                , TW.inset_0
                , TW.bg_gray_900
                , TW.bg_opacity_80
                , zIndex <| int 9997
                ]
            ]
            []
        , div
            [ css
                [ TW.flex
                , TW.absolute
                , TW.inset_0
                , zIndex <| int 9998
                ]
            ]
            [ div
                [ css
                    [ TW.bg_white
                    , TW.p_6
                    , sm [ TW.m_auto, minWidth <| px 520, TW.rounded_lg ]
                    ]
                ]
                [ viewModalHeader ""
                , div [ css [ TW.my_6 ] ] [ content ]
                ]
            ]
        ]


viewModalHeader : String -> Html msg
viewModalHeader title =
    div [ css [ TW.grid, Util.grid_col_1fr_auto ] ]
        [ div [] [ text title ]

        --, Util.pseudoLinkBtn [ onClick CloseModal, css [ color Util.colorBlue, TW.cursor_pointer ] ] [ text "Close" ]
        ]


viewModalContentAudioSent : Html msg
viewModalContentAudioSent =
    div [ css [ TW.grid, TW.gap_6, TW.text_center ] ]
        [ div [] [ text "Estimated Time Remaining: ", span [ css [ color Util.colorGreen, TW.font_bold ] ] [ text "About 15 - 25 Minutes" ] ]
        , Util.viewTitle "We Are Transcribing Your File!"
        , div [] <| Util.htmlAddedBrFromString "You will get notified by email when your \n transcription is done."

        --, div [ css [ TW.w_9over12, TW.mx_auto, sm [ TW.w_1over2 ] ] ] [ Util.btnGreen [ onClick CloseModal ] [ text "Return To Home" ] ]
        ]


viewModalContentAudioLimit : Html msg
viewModalContentAudioLimit =
    div [ css [ TW.grid, TW.gap_6, TW.text_center ] ]
        [ Util.viewTitle "You’ve Just Reached \n Your 15 Minute Limit."
        , div [] <| Util.htmlAddedBrFromString "Upgrade to one of our premium plans to avail of \n unlimited transcription minutes."

        --, div [ css [ TW.w_9over12, TW.mx_auto, sm [ TW.w_1over2 ] ] ] [ Util.btnGreen [ onClick CloseModal ] [ text "Upgrade Now" ] ]
        , p [ css [ color Util.colorBlue, TW.cursor_pointer, TW.underline ] ] <| Util.htmlAddedBrFromString "Skip & only transcribe the first 15 \n minutes of my recording"
        ]

