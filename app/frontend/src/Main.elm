port module Main exposing (..)

-- import Valid as Valid

import Browser
import Browser.Navigation
import Css exposing (Style, after, alignItems, auto, backgroundColor, baseline, borderColor, center, color, displayFlex, focus, fontSize, height, hex, hover, important, int, left, lineHeight, margin, marginLeft, maxWidth, minWidth, padding, property, px, right, spaceBetween, top, width, zIndex)
import Css.Global
import Css.Media exposing (withMediaQuery)
import Css.Transitions exposing (easeInOut, transition)
import File exposing (File)
import File.Select as Select
import Html
import Html.Attributes
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (checked, controls, css, disabled, for, hidden, href, id, name, placeholder, rel, src, step, style, target, title, type_, value)
import Html.Styled.Events exposing (on, onCheck, onClick, onInput, preventDefaultOn)
import Http
import Icon
import Json.Decode as Decode
import Json.Encode
import List.Extra
import LngLat exposing (LngLat)
import MapCommands
import Mapbox.Cmd.Option as Opt
import Mapbox.Element as MapBoxElem
import Mapbox.Expression as E exposing (false, float, int, str, true)
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..))
import Mask
import Modal
import Process
import Set exposing (Set)
import Styles.Outdoors
import Tailwind.Breakpoints exposing (md, sm)
import Tailwind.Utilities as TW
import Task
import Toasty
import Toasty.Defaults
import TypedTime as Time
import Util as Util



--------------------------------------------------------------------------------
-- Ports


port walletConnect : String -> Cmd msg


port disconnect : String -> Cmd msg


port walletSentry : (String -> msg) -> Sub msg


port sendInitTransaction : Json.Encode.Value -> Cmd msg


port sendUpdateTransaction : Json.Encode.Value -> Cmd msg


port viewRoutes : String -> Cmd msg


port txOut : String -> Cmd msg


port txIn : (String -> msg) -> Sub msg


port sendData : String -> Cmd msg


port receiveConnect : (String -> msg) -> Sub msg


port newTab : String -> Cmd msg



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


type ContentView
    = MainView
    | ExploreView
    | AddView



-- MODEL


type alias Model =
    { isWeb3Available : Bool
    , isWeb3Connected : Bool
    , isModalVisible : Bool
    , currAddress : String
    , currCoordinate : Coordinate
    , currLabel : String
    , currContentView : ContentView
    , features : List Json.Encode.Value
    , toasties : Toasty.Stack Toasty.Defaults.Toast
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { isWeb3Available = False
      , isWeb3Connected = False
      , isModalVisible = False
      , currAddress = ""
      , currCoordinate = Coordinate 0 0
      , currLabel = "Null Island"
      , currContentView = MainView
      , features = []
      , toasties = Toasty.initialState
      }
      -- , Task.succeed SubmitCoordinate |> Task.perform identity
    , Cmd.none
    )


myConfig : Toasty.Config Msg
myConfig =
    Toasty.Defaults.config
        |> Toasty.delay 3000
        |> Toasty.containerAttrs
            [ Html.Attributes.style "position" "fixed"
            , Html.Attributes.style "top" "90px"
            , Html.Attributes.style "right" "0"
            , Html.Attributes.style "width" "100%"
            , Html.Attributes.style "max-width" "300px"
            , Html.Attributes.style "list-style-type" "none"
            , Html.Attributes.style "padding" "0"
            , Html.Attributes.style "margin" "0"
            ]


addToast : Toasty.Defaults.Toast -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addToast toast ( model, cmd ) =
    Toasty.addToast myConfig ToastyMsg toast ( model, cmd )


addToastIfUnique : Toasty.Defaults.Toast -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addToastIfUnique toast ( model, cmd ) =
    Toasty.addToastIfUnique myConfig ToastyMsg toast ( model, cmd )


addPersistentToast : Toasty.Defaults.Toast -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addPersistentToast toast ( model, cmd ) =
    Toasty.addPersistentToast myConfig ToastyMsg toast ( model, cmd )



-- UPDATE


type Msg
    = NoOp
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)
      ---
    | Web3Connect
    | Web3Disconnect
    | ReceivedConnectFromJS String
    | SendInitTransaction
    | SendUpdateTransaction
    | ViewRoutes
      ---
    | OpenView ContentView
    | ShowWalletModal
    | CloseWalletModal
    | SubmitCoordinate
    | WriteCoordinate Coordinate
    | ReceiveCoordinate
      -- map related
    | Hover MapBoxElem.EventData
    | MapClick MapBoxElem.EventData
    | RedirectToExplorer String
      -- form related
    | SetLatitude String
    | SetLongitude String
    | SetLabel String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitCoordinate ->
            let
                x =
                    Coordinate 0 0
            in
            ( { model | currContentView = MainView }, message SendInitTransaction )

        -- TODO: should request post
        OpenView vw ->
            ( { model | currContentView = vw }, sendData "view" )

        Web3Connect ->
            ( model, walletConnect "ccd" )

        ReceivedConnectFromJS addr ->
            ( { model | isWeb3Available = True, isWeb3Connected = True, currAddress = addr }, Cmd.none )

        SendInitTransaction ->
            ( model, sendInitTransaction (encodeCoord model.currAddress model.currLabel model.currCoordinate) )
                |> addToast (Toasty.Defaults.Success "Allright!" "Coordinate successfully placed!")

        SendUpdateTransaction ->
            ( model, sendUpdateTransaction (encodeCoord model.currAddress model.currLabel model.currCoordinate) )

        ViewRoutes ->
            ( model, viewRoutes model.currAddress )

        ShowWalletModal ->
            ( { model | isModalVisible = True }, Cmd.none )

        CloseWalletModal ->
            ( { model | isModalVisible = False }, Cmd.none )

        MapClick { lngLat, renderedFeatures } ->
            -- position = lngLat,
            ( { model | features = renderedFeatures }, MapCommands.fitBounds [ Opt.linear True, Opt.maxZoom 10 ] ( LngLat.map (\a -> a - 0.2) lngLat, LngLat.map (\a -> a + 0.2) lngLat ) )

        RedirectToExplorer dest ->
            ( model, newTab dest )

        SetLatitude lat ->
            let
                nc =
                    Coordinate (Maybe.withDefault model.currCoordinate.lat <| String.toFloat lat) model.currCoordinate.lon
            in
            ( { model | currCoordinate = nc }, Cmd.none )

        SetLongitude lon ->
            let
                nc =
                    Coordinate model.currCoordinate.lat (Maybe.withDefault model.currCoordinate.lon <| String.toFloat lon)
            in
            ( { model | currCoordinate = nc }, Cmd.none )

        SetLabel label ->
            ( { model | currLabel = label }, Cmd.none )

        ToastyMsg subMsg ->
            Toasty.update myConfig ToastyMsg subMsg model

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ receiveConnect ReceivedConnectFromJS
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ css
            [ TW.flex
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
        , viewConnectPanel model
        , div
            [ css
                [ maxWidth <| px 980
                , minWidth <| px 320
                ]
            ]
            [ div
                [ css
                    [ Util.localStyle
                    , TW.bg_white
                    , TW.rounded_lg
                    , TW.border
                    , TW.border_solid
                    , TW.border_gray_300
                    ]
                ]
                [ case model.currContentView of
                    MainView ->
                        --fromUnstyled (viewExploreContent model)
                        viewStartContent

                    ExploreView ->
                        fromUnstyled (viewExploreContent model)

                    AddView ->
                        viewAddContent
                ]

            -- , div [ css [ TW.text_xs, TW.mt_4, TW.text_right ] ]
            --     [ strong [] [ text "Need help? " ]
            --     , text "Contact us: "
            --     , Util.link [ css [ color Util.colorBlue, TW.cursor_pointer ], href "mailto:contact@kelecorix.com?subject=Need help with the widget" ] [ text "contact@kelecorix.com" ]
            --     ]
            ]

        -- modals
        , if model.isModalVisible then
            viewWalletModal model

          else
            text ""

        --, case model.openModal of
        --     "audioSend" ->
        --         viewModal viewModalContentAudioSent
        --     "audioLimit" ->
        --         viewModal viewModalContentAudioLimit
        --     _ ->
        --         text ""
        , fromUnstyled (Toasty.view myConfig Toasty.Defaults.view ToastyMsg model.toasties)
        ]


viewConnectPanel : Model -> Html Msg
viewConnectPanel model =
    div
        [ css
            [ TW.absolute
            , TW.top_8
            , TW.right_8
            , zIndex (Css.int 100)
            ]
        ]
        [ div
            [ css
                [ maxWidth <| px 235
                , TW.mx_auto
                , height <| px 32
                ]
            ]
            [ if not model.isWeb3Connected then
                Util.btnGray
                    [ css
                        [ height <| px 42
                        , important <| lineHeight <| px 0
                        , displayFlex
                        , alignItems center
                        ]
                    , onClick <| Web3Connect
                    ]
                    [ img
                        [ css
                            [ height <| px 22, width <| px 22, margin <| px 8 ]
                        , src "src/assets/images/logo_256x256.svg"
                        ]
                        []
                    , text "Connect"
                    ]

              else
                Util.btnGreen
                    [ css
                        [ height <| px 42
                        , important <| lineHeight <| px 0
                        , displayFlex
                        , alignItems center
                        ]
                    , onClick <| ShowWalletModal
                    ]
                    [ img
                        [ css
                            [ height <| px 22, width <| px 22, margin <| px 8 ]
                        , src "src/assets/images/logo_white_256x256.svg"
                        ]
                        []
                    , text (String.left 6 model.currAddress ++ "..." ++ String.right 6 model.currAddress)
                    ]
            ]
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
            [ viewTitle "Create"
            , div [ css [ TW.my_6 ] ] (Util.htmlAddedBrFromString "Add geolocation coordinate or a hiking trail\n (collection of coordinates) directly on \n Concordium blockchain.")
            , div [ css [ maxWidth <| px 235, TW.mx_auto ] ] [ Util.btnGreen [ onClick <| OpenView AddView ] [ text "Add" ] ]
            , p [ css [ TW.text_xs, TW.text_gray_400, TW.mt_6 ] ] [ text "Recommended browsers: Google Chrome, Microsoft Edge, Brave" ]
            ]
        , viewOr
        , div [ css [ TW.p_10, TW.text_center, TW.z_20 ] ]
            [ viewTitle "Explore"
            , div [ css [ TW.my_6 ] ] (Util.htmlAddedBrFromString "Review your coordinates and trails \n stored on-chain \n by clicking the button below.")
            , div [ css [ maxWidth <| px 235, TW.mx_auto ] ] [ Util.btnGreen [ onClick <| OpenView ExploreView ] [ text "View" ] ]
            , p [ css [ TW.text_xs, TW.text_gray_400, TW.mt_6 ] ] [ text "System will load coordinates in a historic order from Concordium blockchain" ]
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


viewBack : Html Msg
viewBack =
    div
        [ css
            [ TW.relative
            , top <| px -40
            , md [ TW.absolute, right <| px 70, TW.top_0 ]
            , TW.h_full
            , after
                [ property "content" "''"
                , TW.absolute
                , TW.inset_0
                , height <| px 1
                , TW.w_full
                , md [ TW.h_full, width <| px 1, right <| px -28, left auto ]
                , TW.bg_gray_300
                , TW.mx_auto
                ]
            ]
        ]
        [ button
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
                , TW.z_10
                , TW.cursor_pointer
                , TW.transform
                , TW.rotate_90
                , md [ TW.rotate_0 ]
                ]
            , title "Back to Home"
            , onClick <| OpenView MainView
            ]
            [ Icon.iconChevronLeft ]
        ]


viewBack2 : Html Msg
viewBack2 =
    div
        [ css
            [ TW.relative

            --, top <| px -25
            , md [ TW.absolute, left <| px -50, top <| px 0 ] -- TW.top_0 ]
            , TW.h_full
            , after
                [ property "content" "''"
                , TW.absolute
                , TW.inset_0
                , height <| px 1
                , TW.w_full
                , md [ TW.h_full, width <| px 1, right <| px -28, left auto ]
                , TW.bg_gray_300
                , TW.mx_auto
                ]
            ]
        ]
        [ button
            [ css
                [ TW.absolute
                , TW.inset_0
                , TW.m_auto
                , TW.rounded_full

                --, TW.border
                --, TW.border_solid
                --, TW.border_gray_300
                , TW.font_bold
                , height <| px 36
                , width <| px 36
                , TW.flex
                , TW.justify_center
                , TW.items_center
                , TW.bg_white
                , TW.z_10
                , TW.cursor_pointer
                , TW.transform
                , TW.rotate_90
                , md [ TW.rotate_0 ]
                ]
            , title "Back to Home"
            , onClick <| OpenView MainView
            ]
            [ Icon.iconChevronLeft ]
        ]


viewExploreContent : Model -> Html.Html Msg
viewExploreContent model =
    Html.div [ Html.Attributes.style "width" "100vw", Html.Attributes.style "height" "100vh" ]
        [ MapBoxElem.map
            [ MapBoxElem.maxZoom 15
            , MapBoxElem.onMouseMove Hover
            , MapBoxElem.onClick MapClick
            , MapBoxElem.id "my-map"
            , MapBoxElem.eventFeaturesLayers [ "changes" ]
            , hoveredFeatures model.features
            ]
            Styles.Outdoors.style

        -- customStyle --
        , Html.div
            [ Html.Attributes.style "position" "absolute"
            , Html.Attributes.style "top" "40px"
            , Html.Attributes.style "left" "75px"
            ]
            [ Html.div
                [ Html.Attributes.style "display" "flex"
                , Html.Attributes.style "width" "180px"
                , Html.Attributes.style "flex-direction" "row"
                ]
                [ toUnstyled viewBack2
                , toUnstyled (div [ css [ TW.text_2xl, TW.font_bold ] ] (Util.htmlAddedBrFromString "Explore"))
                ]
            ]
        ]


viewWalletModal : Model -> Html Msg
viewWalletModal model =
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
                , zIndex <| Css.int 9997
                ]
            ]
            []
        , div
            [ css
                [ TW.flex
                , TW.absolute
                , TW.inset_0
                , zIndex <| Css.int 9998
                ]
            ]
            [ div
                [ css
                    [ TW.bg_white
                    , TW.p_6
                    , sm [ TW.m_auto, minWidth <| px 520, TW.rounded_lg ]
                    ]
                ]
                [ div
                    [ css
                        [ displayFlex
                        , width (Css.pct 100)
                        , TW.justify_between
                        , alignItems baseline
                        ]
                    ]
                    [ h2 [ css [ TW.font_bold ] ] [ text "Account" ]
                    , img
                        [ css
                            [ height <| px 22, width <| px 22, margin <| px 8, TW.cursor_pointer ]
                        , onClick CloseWalletModal
                        , src "src/assets/images/close.svg"
                        ]
                        []
                    ]
                , div
                    [ css
                        [ TW.my_6
                        , Css.marginTop (px 15)
                        , height (px 180)
                        , TW.bg_gray_100
                        , TW.rounded_lg
                        , TW.border
                        , TW.border_solid
                        , TW.border_gray_200
                        , padding (px 15)
                        ]
                    ]
                    [ div [ css [ TW.grid, TW.gap_6, TW.text_center ] ]
                        [ div
                            [ css
                                [ displayFlex
                                , TW.justify_between
                                , alignItems baseline
                                ]
                            ]
                            [ p [ css [ TW.h_4, TW.text_gray_500 ] ] [ text "Connected with Concordium" ]
                            , Util.btnGray
                                [ css
                                    [ height <| px 42
                                    , important <| lineHeight <| px 0
                                    , important <| width <| px 120
                                    , important <| TW.text_blue_500
                                    , important <| TW.border_blue_300
                                    , fontSize <| Css.rem 1
                                    , hover
                                        [ important <| TW.text_white
                                        , TW.bg_blue_500
                                        ]
                                    ]
                                , onClick <| Web3Disconnect
                                ]
                                [ text "Disconnect"
                                ]
                            ]
                        , div [ css [ TW.mx_auto, width (Css.pct 100) ] ]
                            [ h3 [] [ text model.currAddress ] ]
                        , div
                            [ css
                                [ displayFlex
                                , alignItems baseline
                                ]
                            ]
                            [ div
                                [ css
                                    [ displayFlex
                                    , alignItems baseline
                                    , TW.cursor_pointer
                                    , Css.padding (px 7)
                                    , TW.rounded_lg
                                    , hover
                                        [ important <| TW.text_white
                                        , TW.bg_blue_100
                                        ]
                                    ]
                                ]
                                [ img
                                    [ css
                                        [ height <| px 16, width <| px 16, margin <| px 8, TW.cursor_pointer ]
                                    , onClick CloseWalletModal
                                    , src "src/assets/images/content-copy-blue.svg"
                                    ]
                                    []
                                , p [ css [ TW.h_4, TW.text_blue_500 ] ] [ text "Copy address" ]
                                ]
                            , div
                                [ css
                                    [ displayFlex
                                    , alignItems baseline
                                    , marginLeft (px 10)
                                    , TW.cursor_pointer
                                    , Css.padding (px 7)
                                    , TW.rounded_lg
                                    , hover
                                        [ important <| TW.text_white
                                        , TW.bg_blue_100
                                        ]
                                    ]
                                , onClick (RedirectToExplorer ("https://testnet.ccdscan.io/accounts?dcount=1&dentity=account&daddress=" ++ model.currAddress))
                                ]
                                [ img
                                    [ css
                                        [ height <| px 16, width <| px 16, margin <| px 8, TW.cursor_pointer ]
                                    , onClick CloseWalletModal
                                    , src "src/assets/images/open-in-new-blue.svg"
                                    ]
                                    []
                                , p [ css [ TW.h_4, TW.text_blue_500 ] ] [ text "View on CCDScan" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


geojson =
    Decode.decodeString Decode.value """
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "id": 1,
      "properties": {
        "name": "Bermuda Triangle",
        "area": 1150180
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [-64.73, 32.31],
            [-80.19, 25.76],
            [-66.09, 18.43],
            [-64.73, 32.31]
          ]
        ]
      }
    }
  ]
}
""" |> Result.withDefault (Json.Encode.object [])


hoveredFeatures : List Json.Encode.Value -> MapBoxElem.MapboxAttr msg
hoveredFeatures =
    List.map (\feat -> ( feat, [ ( "hover", Json.Encode.bool True ) ] ))
        >> MapBoxElem.featureState



-- <div class="grid gap-6 mb-6 md:grid-cols-2">
--         <div>
--             <label for="first_name" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">First name</label>
--             <input type="text" id="first_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="John" required>
--         </div>


viewAddContent : Html Msg
viewAddContent =
    div
        [ css
            [ TW.grid
            , TW.relative
            , TW.gap_12
            , TW.grid_flow_col

            --, md [ TW.grid_cols_2, TW.gap_0 ]
            ]
        ]
        [ div [ css [ TW.relative, TW.p_10, TW.text_center, TW.z_20, TW.col_span_6 ] ]
            [ viewTitle "New Geo Point"
            , div [ css [ TW.my_6 ] ] (Util.htmlAddedBrFromString "Add geolocation coordinate on Concordium blockchain.")
            , div [ css [ TW.grid, TW.gap_4, TW.grid_cols_1, TW.items_start ] ]
                [ Util.wrapInput []
                    [ Util.inputS [ type_ "number", name "lat", step "any", placeholder "Latitude", onInput SetLatitude ] [] -- , onInput <| FormMsg << SetExpiry, value <| Tuple.first formCard.expiry

                    --, Valid.viewValidationError <| Tuple.second formCard.expiry
                    ]
                , Util.wrapInput []
                    [ Util.inputS [ type_ "number", name "lon", step "any", placeholder "Longitude", onInput SetLongitude ] [] -- , onInput <| FormMsg << SetCvcCode, value <| Tuple.first formCard.cvcCode

                    --, Valid.viewValidationError <| Tuple.second formCard.cvcCode
                    ]
                , Util.wrapInput []
                    [ Util.inputS [ type_ "text", name "lon", placeholder "Label", onInput SetLabel ] [] -- , onInput <| FormMsg << SetCvcCode, value <| Tuple.first formCard.cvcCode

                    --, Valid.viewValidationError <| Tuple.second formCard.cvcCode
                    ]
                ]
            , div [ css [ TW.mx_auto, Css.marginTop <| px 20 ] ] [ Util.btnGreen [ onClick SubmitCoordinate ] [ text "Add" ] ]
            ]
        , div [ css [ TW.col_span_1 ] ]
            [ viewBack
            ]
        ]



---------------------------------


customStyle =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , sources =
            [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-terrain-v2,mapbox.mapbox-streets-v7"
            , Source.geoJSONFromValue "changes" [] geojson
            ]
        , misc =
            [ Style.name "light"
            , Style.defaultCenter <| LngLat 6.865575 45.832119
            , Style.defaultZoomLevel 4
            , Style.sprite "mapbox://sprites/mapbox/streets-v9"
            , Style.glyphs "mapbox://fonts/mapbox/{fontstack}/{range}.pbf"
            ]
        , layers =
            [ Layer.background "background"
                [ E.rgba 246 246 244 1 |> Layer.backgroundColor
                ]
            , Layer.fill "landcover"
                "composite"
                [ Layer.sourceLayer "landcover"
                , E.any
                    [ E.getProperty (str "class") |> E.isEqual (str "wood")
                    , E.getProperty (str "class") |> E.isEqual (str "scrub")
                    , E.getProperty (str "class") |> E.isEqual (str "grass")
                    , E.getProperty (str "class") |> E.isEqual (str "crop")
                    ]
                    |> Layer.filter
                , Layer.fillColor (E.rgba 227 227 227 1)
                , Layer.fillOpacity (float 0.6)
                ]
            , Layer.symbol "place-city-lg-n"
                "composite"
                [ Layer.sourceLayer "place_label"
                , Layer.minzoom 1
                , Layer.maxzoom 14
                , Layer.filter <|
                    E.all
                        [ E.getProperty (str "scalerank") |> E.greaterThan (E.int 2)
                        , E.getProperty (str "type") |> E.isEqual (str "city")
                        ]
                , Layer.textField <|
                    E.format
                        [ E.getProperty (str "name_en")
                            |> E.formatted
                            |> E.fontScaledBy (float 1.2)
                        , E.formatted (str "\n")
                        , E.getProperty (str "name")
                            |> E.formatted
                            |> E.fontScaledBy (float 0.8)
                            |> E.withFont (E.strings [ "DIN Offc Pro Medium" ])
                        ]
                , Layer.textTransform <| E.ifElse (E.getProperty (str "name_en") |> E.isEqual (str "Vienna")) E.uppercase E.none
                ]
            , Layer.fill "changes"
                "changes"
                [ Layer.fillOpacity (E.ifElse (E.toBool (E.featureState (str "hover"))) (float 0.9) (float 0.1))
                ]
            ]
        }


encodeCoord : String -> String -> Coordinate -> Json.Encode.Value
encodeCoord address label coord =
    Json.Encode.object
        [ ( "lat", Json.Encode.float coord.lat )
        , ( "lon", Json.Encode.float coord.lon )
        , ( "label", Json.Encode.string label )
        , ( "address", Json.Encode.string address )
        ]


message : msg -> Cmd msg
message msg =
    Process.sleep 0
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
