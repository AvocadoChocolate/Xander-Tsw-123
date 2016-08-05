---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
native.setProperty( "androidSystemUiVisibility", "immersive" )
-- require the composer library
local composer = require "composer"
local GA = require ( "plugin.gameanalytics" )
GA.init ( {
        	game_key = '827b17918faa8e9f0e075c18ac44426a',
        	secret_key = 'f64db10f8c6d1f22f514aa720f3e6515c8f2b57e',
        	build_name = "1.0",
} )
local analytics = require 'vendor.analytics-mixpanel.analytics-mixpanel'
analytics.init("7a964e935eb1f53dcc85e41ea6ba31b9")

local addon = false
-- load scene1
composer.gotoScene( "menu" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc)
local image = display.newImageRect( "bg.jpg", display.contentWidth, display.contentHeight )
	image.x = display.contentCenterX
	image.y = display.contentCenterY
	image:toBack()
	
	
	function ShowAdd()
		-- if addon == false then
		-- addon = true
		-- native.showWebPopup( 10, 30, display.contentWidth-20, display.contentHeight-40, "https://play.google.com/store/search?q=everafrica%20xander" )
		
		-- local t = display.newText( "Kry meer van Xander", display.contentWidth/2, 20 )

		-- local c = display.newImage("close.png")
		-- c:scale(0.1,0.1)
		-- c.x = display.contentWidth-c.contentWidth/2
		-- c.y = 20
		-- c:addEventListener("tap",(function() native.cancelWebPopup() addon = false timer.performWithDelay( 300000, ShowAdd ) c.alpha=0 t.alpha = 0 end))
		-- end
	end
	
--timer.performWithDelay( 1000, ShowAdd )