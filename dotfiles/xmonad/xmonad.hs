import Data.Map (Map)
import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Prompt
import XMonad.Hooks.ManageDocks
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)

data MyColor = Background
             | Current
             | Selection
             | Foreground
             | Comment
             | Red
             | Orange
             | Yellow
             | Green
             | Aqua
             | Blue
             | Purple
               --
instance Show MyColor where
  show Background = "#1d1f21"
  show Current = "#282a2e"
  show Selection  = "#373b41"
  show Foreground = "#c5c8c6"
  show Comment = "#969896"
  show Red = "#cc6666"
  show Orange = "#de935f"
  show Yellow = "#f0c674"
  show Green = "#b5bd68"
  show Aqua = "#8abeb7"
  show Blue = "#81a2be"
  show Purple = "#b294bb"

myXPConfig :: XPConfig
myXPConfig =
  def
  { font = "xft:DejaVu Sans Mono-12"
  , bgColor = show Blue
  , fgColor = show Background
  , fgHLight = show Yellow
  , bgHLight = show Blue
  , borderColor = show Background
  , promptBorderWidth = 1
  , height = 34
  , position = Top
  , defaultText = []
  }

myKeys :: XConfig l -> Map (KeyMask, KeySym) (X ())
myKeys c =
  mkKeymap c
  [ ("C-d x", spawn $ terminal c)
  , ("C-d e", spawn "emacs")
  , ("C-d f", spawn "google-chrome-stable")
  , ("M-C-l", nextWS)
  , ("M-C-h", prevWS)
  , ("C-d k", kill)
  , ("C-d S-4", shellPrompt myXPConfig)
  , ("C-d S-l", spawn "i3lock -e -c 000000")
  , ("<XF86Display>", spawn "i3lock -e -c 000000 && systemctl hibernate")
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
main = do
  xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc"
  xmonad $ ewmh $ def
    { terminal = "xterm"
    , manageHook = manageDocks <+> manageHook def
    , layoutHook = avoidStruts  $ layoutHook def
    , handleEventHook = handleEventHook def <+> docksEventHook
    , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor (show Green)  "" . shorten 50
                , ppHiddenNoWindows = xmobarColor (show Comment) ""
                , ppCurrent = xmobarColor (show Orange) ""  . wrap "[" "]"
                }
    , normalBorderColor = show Background
    , focusedBorderColor = show Selection
    , workspaces = map show [(1 :: Integer)..9]
    , keys = myKeys
    }
