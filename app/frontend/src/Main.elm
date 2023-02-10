port module Main exposing (..)

import Browser
import Css exposing (Style, after, auto, backgroundColor, borderColor, color, focus, fontSize, height, hex, hover, important, int, left, maxWidth, minWidth, property, px, right, top, width, zIndex)
import Css.Global
import Css.Media exposing (withMediaQuery)
import Css.Transitions exposing (easeInOut, transition)
import File exposing (File)
import File.Select as Select
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (checked, controls, css, disabled, for, hidden, href, id, name, placeholder, rel, src, style, target, title, type_, value)
import Html.Styled.Events exposing (on, onCheck, onClick, onInput, preventDefaultOn)
import Http

import Json.Decode as Decode
import List.Extra
import Mask
import Set exposing (Set)
import Tailwind.Breakpoints exposing (md, sm)
import Tailwind.Utilities as TW
import Task
import TypedTime as Time
import Util as Util
-- import Valid as Valid
-- import Icon
--------------------------------------------------------------------------------


-- Ports

-- Should be Value not string
port walletSentry : (String -> msg) -> Sub msg


port txOut : String -> Cmd msg


port txIn : (String -> msg) -> Sub msg

-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view >> toUnstyled
        }

type alias Coordinate =
    { lat : Float
    , lon : Float
    }

 -- MODEL

type alias Model =
    { isWeb3Available : Bool
    , currAddress  : String
    , currCoordinate : Coordinate
    , currLabel : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { isWeb3Available = False
      , currAddress = ""
      , currCoordinate = Coordinate 0 0
      , currLabel = "Null Island"
      }
    , Task.succeed (SubmitCoordinate (Coordinate 0 0)) |> Task.perform identity
   -- , Cmd.none

    )

-- UPDATE

type Msg
    = NoOp
    | Web3Connect
    | Web3Disconnect
    | SubmitCoordinate Coordinate
    | WriteCoordinate Coordinate
    | ReceiveCoordinate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitCoordinate coord ->
           ( { model | currCoordinate = coord }, Cmd.none ) -- TODO: should request post

        _ -> ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


-- VIEW


view : Model -> Html Msg
view model =
    div [ css [ TW.flex
              , TW.mx_auto
              , TW.p_4
              , Css.justifyContent Css.center
              , Css.alignItems Css.center
              , Css.height (Css.pct 100)
              ] 
        ]
        [ Css.Global.global TW.globalStyles
        , node "link" [ href "https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;700&display=swap", rel "stylesheet" ] []

        -- widget-content
        , div
            [ css
                [ maxWidth <| px 980
                , minWidth <| px 320
                ]
            ]
            [ -- dev menu
            --  viewDevMenu model.statusPlan model.openStep model.isDevelop
             div
                [ css
                    [ Util.localStyle
                    , TW.bg_white
                    , TW.rounded_lg
                    , TW.border
                    , TW.border_solid
                    , TW.border_gray_300
                    ]
                ]
                [
                        viewStartContent

                ]
            -- , div [ css [ TW.text_xs, TW.mt_4, TW.text_right ] ]
            --     [ strong [] [ text "Need help? " ]
            --     , text "Contact us: "
            --     , Util.link [ css [ color Util.colorBlue, TW.cursor_pointer ], href "mailto:contact@kelecorix.com?subject=Need help with the widget" ] [ text "contact@kelecorix.com" ]
            --     ]
            ]

        -- modals
        -- , case model.openModal of
        --     "audioSend" ->
        --         viewModal viewModalContentAudioSent

        --     "audioLimit" ->
        --         viewModal viewModalContentAudioLimit

        --     _ ->
        --         text ""
        ]



viewStartContent : Html Msg
viewStartContent =
    div
        [ css
            [ TW.grid
            , TW.relative
            , TW.gap_6
            , md [ TW.grid_cols_2, TW.gap_0 ]
            ]
        ]
        [ div [ css [ TW.relative, TW.p_10, TW.text_center, TW.z_20 ] ]
            [ --viewComingSoon
             viewTitle "Create"
            , div [ css [ TW.my_6 ] ] (Util.htmlAddedBrFromString "Add geolocation coordinate or a hiking trail\n (collection of coordinates) directly on \n Concordium blockchain.")
            --, div [ css [ maxWidth <| px 235, TW.mx_auto ] ] [ Util.btnGreen [ onClick <| OpenModal "audioLimit" ] [ text "Record" ] ]
            , div [ css [ maxWidth <| px 235, TW.mx_auto ] ] [ Util.btnGreen [  ] [ text "Add" ] ]
            , p [ css [ TW.text_xs, TW.text_gray_400, TW.mt_6 ] ] [ text "Recommended browsers: Google Chrome, Microsoft Edge" ]
            ]
        , viewOr
        , div [ css [ TW.p_10, TW.text_center, TW.z_20 ] ]
            [ viewTitle "Explore"
            , div [ css [ TW.my_6 ] ] (Util.htmlAddedBrFromString "Review your coordinates and trails \n stored on-chain \n by clicking the button below.")
            --, div [ css [ maxWidth <| px 235, TW.mx_auto ] ] [ Util.btnGreen [ onClick <| OpenStep UploadAudio ] [ text "Upload" ] ]
            , div [ css [ maxWidth <| px 235, TW.mx_auto ] ] [ Util.btnGreen [ ] [ text "View" ] ]
            , p [ css [ TW.text_xs, TW.text_gray_400, TW.mt_6 ] ] [ text "System will load coordinates in a historic order from Concordium blockchain" ]
            --, div [ css [ md [ TW.w_4over5, TW.mx_auto ] ] ] [ viewFormUrl ]
            ]
        ]

viewTitle : String -> Html msg
viewTitle t =
    div [ css [ TW.text_2xl, TW.font_bold ] ] (Util.htmlAddedBrFromString t)


viewTitleBig : String -> Html Msg
viewTitleBig t =
    div [ css [ fontSize <| px 32, TW.leading_loose, TW.font_bold ] ] (Util.htmlAddedBrFromString t)

viewOr : Html msg
viewOr =
    div
        [ css
            [ TW.relative
            , md [ TW.absolute ]
            , TW.w_full
            , TW.h_full
            , after
                [ property "content" "''"
                , TW.absolute
                , TW.inset_0
                , height <| px 1
                , TW.w_full
                , md [ TW.h_full, width <| px 1 ]
                , TW.bg_gray_300
                , TW.mx_auto
                ]
            ]
        ]
        [ div
            [ css
                [ TW.absolute
                , TW.inset_0
                , TW.m_auto
                , TW.rounded_full
                , TW.border
                , TW.border_solid
                , TW.border_gray_300
                , TW.font_bold
                , height <| px 56
                , width <| px 56
                , TW.flex
                , TW.justify_center
                , TW.items_center
                , TW.bg_white
                , TW.z_30
                ]
            ]
            [ text "OR" ]
        ]