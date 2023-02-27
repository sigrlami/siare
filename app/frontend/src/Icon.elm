module Icon exposing (..)

import Css.Transitions exposing (easeInOut, transition)
import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (id)
import Svg.Styled as Svg exposing (animate, circle, clipPath, defs, feBlend, feColorMatrix, feFlood, feGaussianBlur, feOffset, filter, g, line, rect, svg)
import Svg.Styled.Attributes as Attr exposing (attributeName, begin, clipRule, colorInterpolationFilters, css, cx, cy, d, dur, dy, fill, fillRule, filterUnits, floodOpacity, from, height, in2, in_, mode, r, result, rx, ry, stdDeviation, stroke, strokeDasharray, strokeDashoffset, strokeWidth, style, to, values, viewBox, width, x, x1, x2, y, y1, y2)


iconChevronLeft =
    svg [ width "19", height "19", viewBox "0 0 19 19", fill "none" ] [ Svg.path [ d "M1.22191 10.3215L9.67716 18.7765C9.87271 18.9723 10.1338 19.0801 10.4121 19.0801C10.6905 19.0801 10.9515 18.9723 11.1471 18.7765L11.7698 18.154C12.1749 17.7484 12.1749 17.0891 11.7698 16.6841L4.66969 9.58402L11.7776 2.47607C11.9732 2.28035 12.0812 2.01945 12.0812 1.74125C12.0812 1.46274 11.9732 1.20184 11.7776 1.00597L11.155 0.383611C10.9593 0.187897 10.6984 0.0800775 10.42 0.0800775C10.1416 0.0800775 9.88059 0.187897 9.68503 0.383611L1.22191 8.84642C1.02589 9.04275 0.918225 9.30489 0.918843 9.58355C0.918225 9.8633 1.02589 10.1253 1.22191 10.3215Z", fill "#A5A5A5" ] [] ]


play =
    svg [ width "42", height "43", viewBox "0 0 42 43", fill "none" ] [ g [ Attr.filter "url(#filter0_d)" ] [ Svg.path [ fillRule "evenodd", clipRule "evenodd", d "M21 39C31.4934 39 40 30.4934 40 20C40 9.50659 31.4934 1 21 1C10.5066 1 2 9.50659 2 20C2 30.4934 10.5066 39 21 39Z", fill "white" ] [], Svg.path [ fillRule "evenodd", clipRule "evenodd", d "M21 39C31.4934 39 40 30.4934 40 20C40 9.50659 31.4934 1 21 1C10.5066 1 2 9.50659 2 20C2 30.4934 10.5066 39 21 39Z", stroke "#00B112", strokeWidth "2" ] [] ], Svg.path [ d "M30.2793 19.5583L17.0235 11.9051L17.0235 27.2115L30.2793 19.5583Z", fill "#2CB83A" ] [], defs [] [ filter [ id "filter0_d", x "0", y "0", width "42", height "43", filterUnits "userSpaceOnUse", colorInterpolationFilters "sRGB" ] [ feFlood [ floodOpacity "0", result "BackgroundImageFix" ] [], feColorMatrix [ in_ "SourceAlpha", values "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0", result "hardAlpha" ] [], feOffset [ dy "2" ] [], feGaussianBlur [ stdDeviation "0.5" ] [], feColorMatrix [ values "0 0 0 0 0.925 0 0 0 0 0.925 0 0 0 0 0.925 0 0 0 1 0" ] [], feBlend [ mode "normal", in2 "BackgroundImageFix", result "effect1_dropShadow" ] [], feBlend [ mode "normal", in_ "SourceGraphic", in2 "effect1_dropShadow", result "shape" ] [] ] ] ]


lock =
    svg [ width "19", height "19", viewBox "0 0 19 19", fill "none" ] [ g [ Attr.clipPath "url(#clip0)" ] [ Svg.path [ d "M14.8438 19H4.15625C3.17458 19 2.375 18.2012 2.375 17.2188V8.90625C2.375 7.92379 3.17458 7.125 4.15625 7.125H14.8438C15.8254 7.125 16.625 7.92379 16.625 8.90625V17.2188C16.625 18.2012 15.8254 19 14.8438 19ZM4.15625 8.3125C3.82929 8.3125 3.5625 8.5785 3.5625 8.90625V17.2188C3.5625 17.5465 3.82929 17.8125 4.15625 17.8125H14.8438C15.1707 17.8125 15.4375 17.5465 15.4375 17.2188V8.90625C15.4375 8.5785 15.1707 8.3125 14.8438 8.3125H4.15625Z", fill "currentColor" ] [], Svg.path [ d "M13.6562 8.3125C13.3285 8.3125 13.0625 8.0465 13.0625 7.71875V4.75C13.0625 2.78588 11.4641 1.1875 9.5 1.1875C7.53588 1.1875 5.9375 2.78588 5.9375 4.75V7.71875C5.9375 8.0465 5.6715 8.3125 5.34375 8.3125C5.016 8.3125 4.75 8.0465 4.75 7.71875V4.75C4.75 2.13038 6.88038 0 9.5 0C12.1196 0 14.25 2.13038 14.25 4.75V7.71875C14.25 8.0465 13.984 8.3125 13.6562 8.3125Z", fill "currentColor" ] [], Svg.path [ d "M9.49983 13.4587C8.62663 13.4587 7.9165 12.7485 7.9165 11.8753C7.9165 11.0021 8.62663 10.292 9.49983 10.292C10.373 10.292 11.0832 11.0021 11.0832 11.8753C11.0832 12.7485 10.373 13.4587 9.49983 13.4587ZM9.49983 11.4795C9.28213 11.4795 9.104 11.6568 9.104 11.8753C9.104 12.0938 9.28213 12.2712 9.49983 12.2712C9.71754 12.2712 9.89567 12.0938 9.89567 11.8753C9.89567 11.6568 9.71754 11.4795 9.49983 11.4795Z", fill "currentColor" ] [], Svg.path [ d "M9.5 15.8333C9.17225 15.8333 8.90625 15.5673 8.90625 15.2396V13.0625C8.90625 12.7347 9.17225 12.4688 9.5 12.4688C9.82775 12.4688 10.0938 12.7347 10.0938 13.0625V15.2396C10.0938 15.5673 9.82775 15.8333 9.5 15.8333Z", fill "currentColor" ] [] ], defs [] [ clipPath [ id "clip0" ] [ rect [ width "19", height "19", fill "white" ] [] ] ] ]


playAndPause : Bool -> Html msg
playAndPause isActive =
    if isActive then
        svg [ width "100%", height "100%", viewBox "0 0 448 448", fill "currentColor" ] [ Svg.path [ d "M144 448H48C21.5 448 0 426.5 0 400V48C0 21.5 21.5 0 48 0H144C170.5 0 192 21.5 192 48V400C192 426.5 170.5 448 144 448ZM448 400V48C448 21.5 426.5 0 400 0H304C277.5 0 256 21.5 256 48V400C256 426.5 277.5 448 304 448H400C426.5 448 448 426.5 448 400Z", fill "currentColor" ] [] ]

    else
        svg [ width "100%", height "100%", viewBox "0 0 448 512", fill "currentColor" ] [ g [ Attr.clipPath "url(#clip0)" ] [ Svg.path [ d "M424.4 214.7L72.4 6.6C43.8 -10.3 0 6.10001 0 47.9V464C0 501.5 40.7 524.1 72.4 505.3L424.4 297.3C455.8 278.8 455.9 233.2 424.4 214.7V214.7Z", fill "currentColor" ] [] ], defs [] [ clipPath [ id "clip0" ] [ rect [ width "448", height "512", fill "white" ] [] ] ] ]


skipStart =
    svg [ width "100%", height "100%", viewBox "0 0 512 512", fill "currentColor" ] [ Svg.path [ d "M0 436V76C0 69.4 5.4 64 12 64H52C58.6 64 64 69.4 64 76V227.9L235.5 71.4C256.1 54.3 288 68.6 288 96V227.9L459.5 71.4C480.1 54.3 512 68.6 512 96V416C512 443.4 480.1 457.7 459.5 440.6L288 285.3V416C288 443.4 256.1 457.7 235.5 440.6L64 285.3V436C64 442.6 58.6 448 52 448H12C5.4 448 0 442.6 0 436Z", fill "currentColor" ] [] ]


back =
    svg [ width "100%", height "100%", viewBox "0 0 512 512", fill "currentColor" ] [ g [ Attr.clipPath "url(#clip0)" ] [ Svg.path [ d "M11.5 280.6L203.5 440.6C224.1 457.8 256 443.4 256 416V96C256 68.6 224.1 54.2 203.5 71.4L11.5 231.4C-3.79998 244.2 -3.79998 267.8 11.5 280.6ZM267.5 280.6L459.5 440.6C480.1 457.8 512 443.4 512 416V96C512 68.6 480.1 54.2 459.5 71.4L267.5 231.4C252.2 244.2 252.2 267.8 267.5 280.6Z", fill "currentColor" ] [] ], defs [] [ clipPath [ id "clip0" ] [ rect [ width "512", height "512", fill "white" ] [] ] ] ]


next =
    svg [ width "100%", height "100%", viewBox "0 0 512 512", fill "currentColor" ] [ Svg.path [ d "M500.5 231.4L308.5 71.4C287.9 54.3 256 68.6 256 96V416C256 443.4 287.9 457.8 308.5 440.6L500.5 280.6C515.8 267.8 515.8 244.2 500.5 231.4V231.4ZM244.5 231.4L52.5 71.4C31.9 54.3 0 68.6 0 96V416C0 443.4 31.9 457.8 52.5 440.6L244.5 280.6C259.8 267.8 259.8 244.2 244.5 231.4V231.4Z", fill "currentColor" ] [] ]
