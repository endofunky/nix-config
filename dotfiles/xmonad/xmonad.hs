import Data.Map (Map)
import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Prompt
import XMonad.Hooks.ManageDocks
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.WindowNavigation
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)
import XMonad.StackSet (focusDown)

import qualified XMonad.Layout.BinarySpacePartition as BSP

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
  { font = "xft:DejaVu Sans Mono-11"
  , bgColor = show Selection
  , fgColor = show Foreground
  , fgHLight = show Yellow
  , bgHLight = show Selection
  , borderColor = show Background
  , promptBorderWidth = 1
  , height = 30
  , position = Top
  , defaultText = []
  , searchPredicate = fuzzyMatch
  }

myKeys :: XConfig l -> Map (KeyMask, KeySym) (X ())
myKeys c =
  mkKeymap c
  [ ("C-d x", spawn $ terminal c)
  , ("C-d e", spawn "emacs")
  , ("C-d f", spawn "google-chrome-stable")
  , ("C-d s", spawn "spotify")
  , ("M1-C-l", nextWS)
  , ("M1-C-h", prevWS)
  , ("M-<Tab>", windows focusDown)
  , ("C-d <Backspace>", confirmPrompt myXPConfig "kill" kill)
  , ("C-d h", windowGo L False)
  , ("C-d j", windowGo D False)
  , ("C-d k", windowGo U False)
  , ("C-d l", windowGo R False)
  , ("C-d S-h", windowSwap L False)
  , ("C-d S-j", windowSwap D False)
  , ("C-d S-k", windowSwap U False)
  , ("C-d S-l", windowSwap R False)
  , ("C-S-l", spawn "sp next")
  , ("C-S-h", spawn "sp prev")
  , ("C-S-p", spawn "sp play")
  , ("M4-h", sendMessage $ BSP.ExpandTowards L)
  , ("M4-j", sendMessage $ BSP.ExpandTowards D)
  , ("M4-k", sendMessage $ BSP.ExpandTowards U)
  , ("M4-l", sendMessage $ BSP.ExpandTowards R)
  , ("M4-S-h", sendMessage $ BSP.ShrinkFrom R)
  , ("M4-S-j", sendMessage $ BSP.ShrinkFrom U)
  , ("M4-S-k", sendMessage $ BSP.ShrinkFrom D)
  , ("M4-S-l", sendMessage $ BSP.ShrinkFrom L)
  , ("C-d <Space>", shellPrompt myXPConfig)
  , ("C-d <Return>", sendMessage $ Toggle FULL)
  , ("C-d C-l", shiftTo Next HiddenWS >> moveTo Next HiddenWS)
  , ("C-d C-h", shiftTo Prev HiddenWS >> moveTo Prev HiddenWS)
  , ("C-d 0", spawn locker)
  , ("C-d S-0", spawn $ locker ++ " && systemctl hibernate")
  , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
  , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
  , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10000")
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10000")
  , ("<XF86AudioMicMute>", spawn "pactl set-source-mute 1 toggle")
  , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
  , ("<Print>", spawn "scrot -e 'mv $f ~/media/images/'")
  , ("M1-<Print>", spawn "scrot -s -e 'mv $f ~/media/images/'")
  ]
  where
    locker = (++) "i3lock -e -c " $ drop 1 $ show Background

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc"
  xmonad
    $ withNavigation2DConfig def
    $ ewmh
    $ def
    { terminal = "xterm"
    , manageHook = manageDocks <+> manageHook def
    , layoutHook = windowNavigation
                 . avoidStruts
                 $ smartBorders
                 $ mkToggle (single FULL)
                 $ BSP.emptyBSP
    , handleEventHook = handleEventHook def
                        <+> fullscreenEventHook
                        <+> docksEventHook
    , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor (show Green)  "" . shorten 50
                , ppHiddenNoWindows = xmobarColor (show Comment) ""
                , ppCurrent = xmobarColor (show Orange) ""  . wrap "[" "]"
                }
    , normalBorderColor = show Background
    , focusedBorderColor = show Comment
    , workspaces = map show [(1 :: Integer)..9]
    , keys = myKeys
    }
