import qualified Data.Map as Map
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Util.EZConfig

-- Tomorrow Night Colors:
colorBackground = "#1d1f21"
colorCurrent    = "#282a2e"
colorSelection  = "#373b41"
colorForeground = "#c5c8c6"
colorComment    = "#969896"
colorRed        = "#cc6666"
colorOrange     = "#de935f"
colorYellow     = "#f0c674"
colorGreen      = "#b5bd68"
colorAqua       = "#8abeb7"
colorBlue       = "#81a2be"
colorPurple     = "#b294bb"

myKeys :: XConfig l -> Map.Map (KeyMask, KeySym) (X ())
myKeys c = mkKeymap c
    [ ("C-d x", spawn $ terminal c)
    , ("C-d e", spawn "emacs")
    , ("C-d f", spawn "google-chrome-stable")
    , ("M-C-l", nextWS)
    , ("M-C-h", prevWS)
    , ("C-d k", kill)
    , ("C-d l", spawn "i3lock -e -c 000000")
    , ("C-d S-l", spawn "i3lock -e -c 000000 && systemctl hibernate")
    , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
    , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
    , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10000")
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10000")
    , ("<XF86AudioMicMute>", spawn "pactl set-source-mute 1 toggle")
    , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ("<Print>", spawn "scrot -e 'mv $f ~/media/images/'")
    , ("M-<Print>", spawn "scrot -s -e 'mv $f ~/media/images/'")
    ]

main :: IO ()
main = xmonad $ ewmh $ def
    { terminal = "xterm"
    , normalBorderColor = colorBackground
    , focusedBorderColor = colorSelection
    , workspaces = map show [(1 :: Integer)..9]
    , keys = myKeys
    }
