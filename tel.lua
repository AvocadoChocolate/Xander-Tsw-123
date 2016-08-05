---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

local teachersPetFont

--To let font show correctly in both emulator and devices
if system.getInfo( "platformName" ) == "Win" then
	teachersPetFont = "TeachersPet"
else
	teachersPetFont = "Tptr"
end
-------------------------------------------------------------------------------------------------------------------------------	
-------------------------------------------------------------------------------------------------------------------------------
--Declarations-----------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
--functions----------------------------
local ActiveNommerChanged 
local dierImageClicklistener
local handleNommerButtonEvent
local draggedLeft
local draggedRight
local shiftLeft
local shiftRight
local slideListener
local InitializeBouSelf
-------------------------------------------------------------------------------------------------------------------------------
--variables and parameters--------------
local sounds = {
		869,1674 ,2550, 3484, 4231,5086,6001,6631,7514,8067,
		8863,9086,9497,9770,13771,14066,
		15272,15897,17241
}
local slimkop123
local slimkop12 ,een,twee,drie,vier,vyf,ses,sewe,agt,nege,tien,puik,fantasties,uitstekend
local audioNotLoaded = true
local soundTable ={}

local clippingContainer
local cWidth = display.contentWidth
local cHeight = display.contentHeight
local _transition_time = 500
local _dierImageScale = { } 
local _borderwidth = cWidth/110

local curDierImage = { }
local curDierImageX, curDierImageY
local nextDierImage = { }
local nrTextLinks = { } 
local nrTextLinksX, nrTextLinksY
local nrTextOnder = { }
local nrTextOnderX, nrTextOnderY
local curNomImage = { }
local curNomImageX, curNomImageY
 

local currentActiveNommerButtonTel = { } 
local currentActiveNommerButtonTelBack = { } 

local colourTable = {	{ 1, 0, 0 }, { 0, 153/255, 51/255  }, 
						{ 1, 153/255, 1 }, { 1, 102/255, 0 }, 
						{ 0, 204/255, 204/255 }, { 153/255, 51/255, 153/255 },
						{ 1, 1, 102/255 }, { 102/255, 51/255, 0 },
						{ 0, 102/255, 204/255 }, {1, 204/255, 0 } 
					}					
local nommerTextTable = { "Nngwe", "Pedi", "Tharo", "Nne", "Tlhano", "Thataro", "Supa", "Robedi", "Robongwe", "Lesome" }

local nommerButtonTable = { } 	
local nommerButtonBackTable = { }				

local nextSceneButton
local homeBtn
local xInset = 25
local yInset = 25

local whitebg
local sceneGroup

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
--Scene Functions
-------------------------------------------------------------------------------------------------------------------------------

function scene:create( event )
    sceneGroup = self.view
	
	slimkop123 = audio.loadStream("slimkop123.mp3")
	slimkop12 = audio.loadStream("slimkop123.mp3")
	een = audio.loadStream("Audio/01-Een.mp3")
	twee = audio.loadStream("Audio/02-Twee.mp3")
	drie = audio.loadStream("Audio/03-Drie.mp3")
	vier = audio.loadStream("Audio/04-Vier.mp3")
	vyf = audio.loadStream("Audio/05-Vyf.mp3")
	ses = audio.loadStream("Audio/06-Ses.mp3")
	sewe = audio.loadStream("Audio/07-Sewe.mp3")
	agt = audio.loadStream("Audio/08-Agt.mp3")
	nege = audio.loadStream("Audio/09-Nege.mp3")
	tien = audio.loadStream("Audio/10-Tien.mp3") 
	puik = audio.loadStream("Audio/01-Puik.mp3")
	fantasties = audio.loadStream("Audio/01-Fantasties.mp3")
	uitstekend = audio.loadStream("Audio/01-Uitstekend.mp3")
	soundTable = {een,twee,drie,vier,vyf,ses,sewe,agt,nege,tien,fantasties, puik,uitstekend}
	audioNotLoaded = false
	
	local image = display.newImageRect( "bg.jpg", display.contentWidth, display.contentHeight )
	image.x = display.contentCenterX
	image.y = display.contentCenterY
	sceneGroup:insert(image)
	
	homeBtn = display.newImage("icons/home.png")
	homeBtn.x = homeBtn.width / 2 
	homeBtn.y = display.contentCenterY -yInset*6
	homeBtn.xScale = 0.5
	homeBtn.yScale = 0.5
	homeBtn.alpha = 0.8
	sceneGroup:insert(homeBtn)
	
	-- White rectangle with purple border
	whitebg = display.newImageRect("whitebg.png",display.contentWidth,display.contentHeight-yInset*2.5)
	whitebg.x = display.contentCenterX
	whitebg.y = display.contentCenterY+yInset*1.2
	sceneGroup:insert( whitebg )
	whitebg:addEventListener( "touch", slideListener )
	
	--image container
	clippingContainer = display.newContainer( whitebg.width - 2 / 3 * xInset -1, whitebg.height - 1 / 3 * xInset -2.5 )
	clippingContainer:translate( whitebg.x, whitebg.y )

	-- Place number buttons at top and initialise first images. 	
	for i = 1, 10 do
		local nommerButton = display.newText( i, cWidth* (i+2)  / 15, display.contentCenterY -yInset*6, teachersPetFont, 36 )
		nommerButton.no = i
			
		local nommerButtonBack = display.newRect( cWidth * (i+2) / 15, display.contentCenterY -yInset*6, cWidth / 14, cWidth / 14 )
		nommerButtonBack.coupledNommer = nommerButton
		
		nommerButtonBack.alpha = 0
		nommerButtonBack.isHitTestable = true
		nommerButton.isActive = false
		
		sceneGroup:insert(nommerButton)
		sceneGroup:insert(nommerButtonBack)

		--initialise "1" to be active on start
		if i == 1 then
			nommerButton.isActive = true
			currentActiveNommerButtonTel = nommerButton
			currentActiveNommerButtonTelBack = nommerButtonBack
			nommerButton:setFillColor(unpack(colourTable[1]))
			transition.to(currentActiveNommerButtonTel, {transition = easing.outSine, time = 300, xScale = 2, yScale = 2})
			local t_X = - clippingContainer.x + display.contentCenterX
			local t_Y = - clippingContainer.y + display.contentCenterY
			curDierImageX, curDierImageY = 0, t_Y
			curDierImage = display.newImage( "diere/1.png",curDierImageX, curDierImageY , true )
			local currentDierHeight = curDierImage.height
			local aimHeight = cHeight / 2.5
			_dierImageScale = aimHeight / currentDierHeight 
			curDierImage:scale( _dierImageScale, _dierImageScale )
				
			nrTextLinksX, nrTextLinksY = -( clippingContainer.width / 2 ) + ( clippingContainer.width / 6 ), 0 --cWidth / 6, whitebg.y
			nrTextLinks = display.newText(currentActiveNommerButtonTel.no, nrTextLinksX, nrTextLinksY , teachersPetFont, 170 / 480 * cHeight )
			nrTextLinks:setFillColor( unpack( colourTable [ 1 ] ) )
			nrTextLinks.anchorY = 0.5	
					
			nrTextOnderX, nrTextOnderY =  0, clippingContainer.height / 14 * 5
			nrTextOnder = display.newText(nommerTextTable [ i ],nrTextOnderX, nrTextOnderY , teachersPetFont, 1 / 8 * cHeight )
			nrTextOnder:setFillColor( unpack( colourTable [ 1 ] ) )
			
			curNomImageX, curNomImageY =  clippingContainer.width / 3, 0
			curNomImage = display.newImage( "onstelOLD/1.png", curNomImageX, curNomImageY )
			curNomImage:scale( cWidth / 1000, cWidth / 1000 )
			
			
			clippingContainer:insert( curDierImage )
			clippingContainer:insert( nrTextLinks )
			clippingContainer:insert( nrTextOnder )
			clippingContainer:insert( curNomImage )
			
			sceneGroup:insert( clippingContainer )
			transition.from( curDierImage, { time = _transition_time, delay = _transition_time, alpha = 0 } )
			transition.from( nrTextLinks, { time = _transition_time, delay = _transition_time, alpha = 0 } )
			transition.from( nrTextOnder, { time = _transition_time, delay = _transition_time, alpha = 0 } )
			transition.from( curNomImage, { time = _transition_time, delay = _transition_time, alpha = 0 } )
			
			 curDierImage:addEventListener( "tap", dierImageClicklistener )
		end
		nommerButtonBack:addEventListener( "tap", handleNommerButtonEvent )
		nommerButtonBack:toFront()
		nommerButtonTable [ i ] = nommerButton
		nommerButtonBackTable[i] = nommerButtonBack
		
		--X-X-X-X-X-X-X fokken Zander kak
		
		
	end

	
end

-------------------------------------------------------------------------------------------------------------------------------
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
        if audioNotLoaded then
			slimkop123 = audio.loadStream("slimkop123.mp3")
			slimkop12 = audio.loadStream("slimkop123.mp3")
			een = audio.loadStream("Audio/01-Een.mp3")
			twee = audio.loadStream("Audio/02-Twee.mp3")
			drie = audio.loadStream("Audio/03-Drie.mp3")
			vier = audio.loadStream("Audio/04-Vier.mp3")
			vyf = audio.loadStream("Audio/05-Vyf.mp3")
			ses = audio.loadStream("Audio/06-Ses.mp3")
			sewe = audio.loadStream("Audio/07-Sewe.mp3")
		    agt = audio.loadStream("Audio/08-Agt.mp3")
			nege = audio.loadStream("Audio/09-Nege.mp3")
			tien = audio.loadStream("Audio/10-Tien.mp3") 
			puik = audio.loadStream("Audio/01-Puik.mp3")
			fantasties = audio.loadStream("Audio/01-Fantasties.mp3")
			uitstekend = audio.loadStream("Audio/01-Uitstekend.mp3")
			soundTable = {een,twee,drie,vier,vyf,ses,sewe,agt,nege,tien,fantasties, puik,uitstekend}
		end
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
		local group = display.newGroup()
		local speech = display.newImage(group,"zanders/speechDark.png")
		speech.x = - xInset*4.3
		speech.y = - yInset*2.5
		speech.xScale = 0.45
		speech.yScale = 0.31
		
		local zander = display.newImage(group,"zanders/zander.png")
		zander.xScale = 0.35
		zander.yScale =0.35
		zander.y = -yInset*0.5
		
		local optionsZanderTxt =
		{
		
			parent = group,
			text = "Utlwella, ebe o \nbala le rona.",
			y = - yInset*3,
			x = - xInset*5.2,
			font = teachersPetFont,
			fontSize = 20,
			align = "left"
		}
		local zanderTxt = display.newText(optionsZanderTxt)
		zanderTxt:setFillColor( 0, 0, 0 )
		
		z = zanderTxt.parent
		z:insert(zanderTxt)
		z:insert(1,speech)
		z.x =display.contentCenterX +xInset*10
		z.y =display.contentCenterY + yInset*7
		z.xScale = 1
		z.yScale = 1
		sceneGroup:insert(z)
		timer.performWithDelay(5000,function() transition.fadeOut( z, {time = 300 } ); end)
		timer.performWithDelay(5300,function() z:removeSelf(); end)
		
		if currentActiveNommerButtonTel ~= nil then
			local sound = unpack(soundTable,currentActiveNommerButtonTel.no)
			audio.play(sound)
		end
       function homeBtn:touch( event )
			if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene
				transition.to(homeBtn,{time=250,xScale=0.4,yScale=0.4})
				timer.performWithDelay(1, function() composer.gotoScene("menu", "fade", 500); end)
				return true
			end
		end
		
		homeBtn:addEventListener( "touch", homeBtn )
        
    end 
end

-------------------------------------------------------------------------------------------------------------------------------
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
		audio.dispose(slimkop12)
		audio.dispose(slimkop123)
		audio.dispose(een)
		audio.dispose(twee)
		audio.dispose(drie)
		audio.dispose(vier)
		audio.dispose(vyf)
		audio.dispose(ses)
		audio.dispose(sewe)
		audio.dispose(agt)
		audio.dispose(nege)
		audio.dispose(tien)
		audio.dispose(puik)
		audio.dispose(fantasties)
		audio.dispose(uitstekend)
		slimkop12 = nil
		slimkop123 = nil
		een = nil
		twee = nil
		drie =nil
		vier = nil
		vyf = nil
		ses = nil
		sewe = nil
		agt =nil
		nege =nil
		tien = nil
		fantasties = nil
		puik=nil
		uitstekend =nil
		soundTable = {}
		audioNotLoaded =true
    elseif phase == "did" then
        -- Called when the scene is now off screen
		if homeBtn then
			homeBtn.xScale = 0.5
			homeBtn.yScale = 0.5
			homeBtn:removeEventListener( "touch", homeBtn )
		end
		
    end 
end

-------------------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
--Function Definitions
-------------------------------------------------------------------------------------------------------------------------------

handleNommerButtonEvent =  function (event)
	
	if event.target.coupledNommer.isActive == false then
		ActiveNommerChanged(event.target.coupledNommer.no, false)
	else
	end
	
 end
 
------------------------------------------------------------------------------------------------------------------------------- 
-- Fired if clicked on number in top row or if screen slided. Leftside: boolean
 ActiveNommerChanged = function (newNommer, leftSlide)
	
	local sound = unpack(soundTable,newNommer)
	audio.play(sound)
	currentActiveNommerButtonTel.isActive = false
	local oldNommer = currentActiveNommerButtonTel.no
	
	currentActiveNommerButtonTel:setFillColor(1, 1, 1)
	transition.to(currentActiveNommerButtonTel, {transition = easing.outSine, time = 300, xScale = 1, yScale = 1})
	currentActiveNommerButtonTel = nommerButtonTable[newNommer]
	currentActiveNommerButtonTel.isActive = true
	currentActiveNommerButtonTel:setFillColor(unpack(colourTable[newNommer]))
	transition.to(currentActiveNommerButtonTel, {transition = easing.outSine, time = 300, xScale = 2, yScale = 2})
		--left in
		 if currentActiveNommerButtonTel.no < oldNommer or leftslide then
			shiftLeft()
		else
			shiftRight()
		end
		curDierImage:addEventListener( "tap", dierImageClicklistener )
 end

-------------------------------------------------------------------------------------------------------------------------------
draggedLeft = function ( x1, x2 )
	
	if ( xInset< x1 - x2 ) then
		return true
	else 
		return false
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------
draggedRight = function ( x1, x2 )
	
	if ( x2 - x1 > xInset ) then
		return true
	else 
		return false
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------

shiftLeft = function ()

	local nextDierImage = display.newImage( "diere/" .. currentActiveNommerButtonTel.no .. ".png", curDierImageX, curDierImage.y)
	nextDierImage:scale( _dierImageScale, _dierImageScale )
	nextDierImage.anchorY = curDierImage.anchorY
	
	local nextNrTextLinks = display.newText( "" .. currentActiveNommerButtonTel.no, nrTextLinksX, nrTextLinks.y, teachersPetFont,  170 / 480 * cHeight  )
	nextNrTextLinks:setFillColor( unpack( colourTable [currentActiveNommerButtonTel.no ] ) )
	
	local nextNrTextOnder = display.newText( nommerTextTable [ currentActiveNommerButtonTel.no ], nrTextOnderX, nrTextOnder.y, teachersPetFont, 1 / 8 * cHeight )
	nextNrTextOnder:setFillColor( unpack( colourTable [currentActiveNommerButtonTel.no ] ) )
	
	local nextNomImage = display.newImage( "onstelOLD/" .. currentActiveNommerButtonTel.no .. ".png", curNomImageX, curNomImageY )
	nextNomImage:scale( cWidth / 1000, cWidth / 1000 )
	
	clippingContainer:insert( nextDierImage )
	clippingContainer:insert( nextNrTextLinks )
	clippingContainer:insert( nextNrTextOnder )
	clippingContainer:insert( nextNomImage ) 
	--old ones out
	transition.to(curDierImage, {time = _transition_time, x = curDierImageX + cWidth } )
	transition.to(nrTextLinks, {time = _transition_time, x = nrTextLinksX + cWidth } )
	transition.to(nrTextOnder, {time = _transition_time, x = nrTextOnderX + cWidth } )
	transition.to(curNomImage, {time = _transition_time, x = curNomImageX + cWidth } )
	
	--*-*-*-*-*
	--new ones in
	transition.from( nextNrTextLinks, { time  = _transition_time, x = nrTextLinksX - cWidth } )
	transition.from(nextNrTextOnder, {time = _transition_time, x = nrTextOnderX - cWidth } )
	transition.from(nextNomImage, {time = _transition_time, x = curNomImageX - cWidth } )
	transition.from( nextDierImage, {time = _transition_time, x = curDierImageX - cWidth } )
	curDierImage:removeEventListener( "tap", dierImageClicklistener )
	curDierImage = nil
	curDierImage = nextDierImage
	nrTextLinks = nextNrTextLinks
	nrTextOnder = nextNrTextOnder
	curNomImage = nil
	curNomImage = nextNomImage
	curDierImage:addEventListener( "tap", dierImageClicklistener )
			
end

-------------------------------------------------------------------------------------------------------------------------------
shiftRight = function ()
	local nextDierImage = display.newImage( "diere/" .. currentActiveNommerButtonTel.no .. ".png", curDierImageX, curDierImage.y )
	local nextNrTextLinks = display.newText( "" .. currentActiveNommerButtonTel.no, nrTextLinksX, nrTextLinks.y, teachersPetFont,  170 / 480 * cHeight  )
	nextNrTextLinks:setFillColor( unpack( colourTable [currentActiveNommerButtonTel.no ] ) )
	local nextNrTextOnder = display.newText( nommerTextTable [ currentActiveNommerButtonTel.no ], nrTextOnderX, nrTextOnder.y, teachersPetFont, 1 / 8 * cHeight  )
	nextNrTextOnder:setFillColor( unpack( colourTable [currentActiveNommerButtonTel.no ] ) )
	local nextNomImage = display.newImage( "onstelOLD/" .. currentActiveNommerButtonTel.no .. ".png",  curNomImageX, curNomImageY  )
	nextNomImage:scale( cWidth / 1000, cWidth / 1000 )
	
	nextDierImage:scale( _dierImageScale, _dierImageScale )
	nextDierImage.anchorY = curDierImage.anchorY
	
	clippingContainer:insert( nextDierImage )
	clippingContainer:insert( nextNrTextLinks )
	clippingContainer:insert( nextNrTextOnder )
	clippingContainer:insert( nextNomImage ) 
	
	
	transition.to(curDierImage, {time = _transition_time, x = curDierImageX - cWidth } )
	transition.to(nrTextLinks, {time = _transition_time, x = nrTextLinksX - cWidth } )
	transition.to(nrTextOnder, {time = _transition_time, x = nrTextOnderX - cWidth } )
	transition.to(curNomImage, {time = _transition_time, x = curNomImageX - cWidth } )
	

	
	transition.from( nextNrTextLinks, { time = _transition_time, x = nrTextLinksX + cWidth } )
	transition.from( nextNrTextOnder, { time = _transition_time, x = nrTextOnderX + cWidth } )
	transition.from( nextNomImage, { time  = _transition_time, x = curNomImageX + cWidth } )
	transition.from( nextDierImage, { time = _transition_time, x = curDierImageX + cWidth } )
			
	
	curDierImage:removeEventListener( "tap", dierImageClicklistener )
	curDierImage = nil
	curDierImage = nextDierImage
	nrTextLinks = nextNrTextLinks
	nrTextOnder = nextNrTextOnder
	curNomImage = nil
	curNomImage = nextNomImage
	curDierImage:addEventListener( "tap", dierImageClicklistener )
end

-------------------------------------------------------------------------------------------------------------------------------
dierImageClicklistener = function ( event )		

	local _cur_scale = _dierImageScale
	local _shrink_scale =  _cur_scale * 0.5
	local _spin1_scale = _shrink_scale * -1
	local _spin2_scale = _spin1_scale * -1
	
	local options =
	{
		channel =2,
		loops = 0, -- -1 is infinite loop and 1 will play sound twice
		duration = getDuration(15,16) --swipe is van 14 tot 15
	}
	audio.stop(slimkop12)
	audio.seek(sounds[15],slimkop12) --swipe begin waar 14 eindig
	audio.play(slimkop12,options) 
			
	transition.to	( curDierImage, { time = 200, xScale = _shrink_scale, yScale = _shrink_scale, 
	onComplete = 		function() 
							transition.to( curDierImage, { time = 100, xScale = _spin1_scale,
							onComplete = 	function()
												transition.to( curDierImage, { time = 100, xScale = _spin2_scale,
												onComplete = 	function()
																	transition.to( curDierImage, { transition = easing.outBack, time = 200, delay = 300,
																	xScale = _cur_scale, yScale = _cur_scale } )
																end } ) 
											end } ) 
						end } 
					)
end

-------------------------------------------------------------------------------------------------------------------------------
slideListener = function ( event )

	if event.phase == "ended" then
		if draggedLeft( event.xStart, event.x ) then
			if currentActiveNommerButtonTel.no < 10 then
				ActiveNommerChanged( currentActiveNommerButtonTel.no + 1, false ) 
			end
			
		elseif draggedRight( event.xStart, event.x ) then
			if currentActiveNommerButtonTel.no > 1 then
				ActiveNommerChanged( currentActiveNommerButtonTel.no - 1, true )
			end
		end
	end
end		

---------------------------------------------------------------------------------
--back key listener


-------------------------------------------------------------------------------------------------------------------------------
getDuration = function(from, to)
	return (sounds[to]-sounds[from])
end
-------------------------------------------------------------------------------------------------------------------------------
return scene
