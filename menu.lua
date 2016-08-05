---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------
--back key listener
local function onKeyEvent( event )
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
    -- If the "back" key was pressed on Android or Windows Phone, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
		return false
      
    end
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )


local sceneName = ...
local widget = require("widget")
local composer = require( "composer" )

-- Load scene with same root file name as this file
local scene = composer.newScene( sceneName )

--[[
	To let font show correctly in both emulator and devices
	]]
if system.getInfo( "platformName" ) == "Win" then
	teachersPetFont = "TeachersPet"
else
	teachersPetFont = "Tptr"
end




---------------------------------------------------------------------------------
--initialize locals
---------------------------------------------------------------------------------


local tel ,raam, skryf,bou
local xInset = display.contentWidth / 20
local yInset = display.contentHeight / 20
local checker = true
local checkTel = true
local checkRaam = true
local checkSkryf = true
local checkBou = true
local mixpanel = require 'vendor.mixpanel.mixpanel'
mixpanel.initMixpanel("7a964e935eb1f53dcc85e41ea6ba31b9")
function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    --
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
	if checker then
		checker = false
		mixpanel.track('Game Loaded')
		print("Event tracked")
	end
	local image = display.newImageRect( "bgfirstscreen.jpg", display.contentWidth, display.contentHeight )
	image.x = display.contentCenterX
	image.y = display.contentCenterY
	sceneGroup:insert(image)
	
	local zander = display.newImage("zanders/zander.png")
	zander.x = display.contentCenterX + xInset*8
	zander.y = display.contentCenterY + yInset*8.5
	zander:scale(xInset*2/zander.width,xInset*2/zander.width)
	sceneGroup:insert(zander)
	
	local optionsZanderTxt =
	{
		--parent = telGroup,
		width = 120,
		text = "Dumela, kgetha \nmotshameko, o \nbale le rona.",
		font = teachersPetFont,
		fontSize = 20,
		align = "left"
	}
	local zanderTxt = display.newText(optionsZanderTxt)
	zanderTxt:setFillColor( 0, 0, 0 )
	zanderTxt.x =display.contentCenterX + xInset*3.5
	zanderTxt.y =display.contentCenterY + yInset*7
	local speech = display.newImage("zanders/speech.png")
	speech.x =display.contentCenterX + xInset*4.2
	speech.y =display.contentCenterY + yInset*8.3
	speech:scale(0.5,0.5)
	sceneGroup:insert(speech)
	sceneGroup:insert(zanderTxt)
	local telGroup = display.newGroup()
	local optionsTel =
	{
		parent = telGroup,
		text = "Are bale ba botlhe",
		y=yInset*6.5,
		font = teachersPetFont,
		fontSize = 38,
		align = "right"
	}
	local textTel = display.newText(optionsTel)
	local imageTel = display.newImage(telGroup,"startscreen/4.png")
	imageTel.xScale = 0.8
	imageTel.yScale = 0.8
	local circleTel = display.newImage( telGroup,"startscreen/boxthing.png")
	tel = imageTel.parent
	tel:insert( imageTel )
	tel:insert( 1, circleTel)
	tel.x =display.contentCenterX - xInset*7.5
	tel.y =display.contentCenterY - yInset*0.5
	tel.xScale = 0.5
	tel.yScale = 0.5
	sceneGroup:insert(tel)

	local raamGroup = display.newGroup()
	local optionsRaam =
	{
		parent = raamGroup,
		text = "Abacus",
		y=yInset*6.5,
		font = teachersPetFont,
		fontSize = 38,
		align = "right"
	}
	local textRaam = display.newText(optionsRaam)
	local imageRaam = display.newImage(raamGroup,"startscreen/telraam.png")
	imageRaam.xScale =0.75
	imageRaam.yScale =0.75
	local circleRaam = display.newImage( raamGroup,"startscreen/boxthing.png")
	raam = imageRaam.parent
	raam:insert( imageRaam )
	raam:insert( 1, circleRaam)
	raam.x =display.contentCenterX - xInset*2.5
	raam.y =display.contentCenterY - yInset*0.5
	raam.xScale = 0.5
	raam.yScale = 0.5
	sceneGroup:insert(raam)
	
	local skryfGroup = display.newGroup()
	local optionsSkryf =
	{
		parent = skryfGroup,
		text = "e'Kwale ka bowena",
		y=yInset*6.5,
		font = teachersPetFont,
		fontSize = 38,
		align = "right"
	}
	local textSkryf = display.newText(optionsSkryf)
	local imageSkryf = display.newImage(skryfGroup,"startscreen/skryfself.png")
	imageSkryf.xScale =0.75
	imageSkryf.yScale =0.75
	local circleSkryf = display.newImage( skryfGroup,"startscreen/boxthing.png")
	skryf = imageSkryf.parent
	skryf:insert( imageSkryf)
	skryf:insert( 1, circleSkryf)
	skryf.x =display.contentCenterX + xInset*2.5
	skryf.y =display.contentCenterY - yInset*0.5
	skryf.xScale = 0.5
	skryf.yScale = 0.5
	sceneGroup:insert(skryf)
	
	local bouGroup = display.newGroup() -- Die group
	--Dit net options vir text
	local optionsBou =
	{
		parent = bouGroup, -- dit sit basies die text in bouGroup
		text = "Ikagele yone",
		y=yInset*6.5, -- die yInset het ek heelbo define as 25 dit skyf die text net bietjie af in die group
		font = teachersPetFont, 
		fontSize = 38,
		align = "right"
	}
	local textBou = display.newText(optionsBou)
	local imageBou = display.newImage(bouGroup,"startscreen/bouself.png")
	imageBou.xScale =0.75
	imageBou.yScale =0.75 --ek nie die position define nie so dit sit dit center in die group
	local circleBou = display.newImage( bouGroup,"startscreen/boxthing.png") -- ek ook nie die position hier define nie en sit dit bo op die ander een
	bou = imageBou.parent --sit die image heelbo
	bou:insert( imageBou) -- ek nie seker hoekom jy dit hier insert nie dink dit deel van hom bo sit
	bou:insert( 1, circleBou) -- soos ek verstaan sit dit die circleBou heel agter
	bou.x = display.contentCenterX + xInset*7.5
	bou.y = display.contentCenterY - yInset*0.5
	bou.xScale = 0.5
	bou.yScale = 0.5
	sceneGroup:insert(bou)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen


    elseif phase == "did" then
        -- Called when the scene is now on screen
        --
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
		function tel:touch( event )
			if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene
				if checkTel then
					checkTel = false
					mixpanel.track( 'Tel saam')
					print("Event tracked")
				end
				transition.to(tel,{time=250,xScale=0.45,yScale=0.45})
				timer.performWithDelay(300, function() composer.gotoScene("tel", "fade", 500); end)
				return true
			end
		end
		
		tel:addEventListener( "touch", tel )
		
		function raam:touch( event )
			if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene
				if checkRaam then
					checkRaam = false
					mixpanel.track( 'Telraam')
					print("Event tracked")
				end
				transition.to(raam,{time=250,xScale=0.45,yScale=0.45})
				timer.performWithDelay(300, function() composer.gotoScene("raam", "fade", 500); end)
				return true
			end
		end
		raam:addEventListener( "touch", raam )
		
		function skryf:touch( event )
			if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene
				if checkSkryf then
					checkSkryf = false
					mixpanel.track( 'Skryf Self')
					print("Event tracked")
				end
				transition.to(skryf,{time=250,xScale=0.45,yScale=0.45})
				timer.performWithDelay(300, function() composer.gotoScene("skryf", "fade", 500); end)
				return true
			end
		end

		skryf:addEventListener( "touch", skryf )
		
		function bou:touch( event )
			if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene
				if checkBou then
					checkBou = false
					mixpanel.track( 'Ikagele yone')
					print("Event tracked")
				end
				transition.to(bou,{time=250,xScale=0.45,yScale=0.45})
				timer.performWithDelay(300, function() composer.gotoScene("bou", "fade", 500); end)
				return true
			end
		end

		bou:addEventListener( "touch", bou )

		

    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
        -- Called when the scene is now off screen
		if tel then
			tel.xScale = 0.5
			tel.yScale = 0.5
			tel:removeEventListener( "touch", tel )
		end
		if bou then
			bou.xScale = 0.5
			bou.yScale = 0.5
			bou:removeEventListener( "touch", bou )
		end
		if skryf then
			skryf.xScale = 0.5
			skryf.yScale = 0.5
			skryf:removeEventListener( "touch", skryf )
		end
		if raam then
			raam.xScale = 0.5
			raam.yScale = 0.5
			raam:removeEventListener( "touch", raam )
		end
    end
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    --
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
