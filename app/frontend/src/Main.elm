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
