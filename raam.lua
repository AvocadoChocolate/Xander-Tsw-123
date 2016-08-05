---------------------------------------------------------------------------------
--
-- scene.lua
-- Known bugs:
-- Sound bug on click button while moving
-- Sound when missed bugs(Audio is stopped on click bug)
---------------------------------------------------------------------------------

local sceneName = ...
local teachersPetFont
local composer = require( "composer" )

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

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


--functions-----------------------------
local isOverlapping
local ActiveNommerChanged
local handleNommerButtonEvent
local GetRandomNommer
local dragNommerBar

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
local clicked =true
local tel ,raam, skryf,bou,z,fadedRect
local nextSceneButton
local homeBtn
local xInset = 25
local yInset = 25
local nommerButton
local nommerButtonBack
local tick
local cWidth = display.contentWidth
local cHeight = display.contentHeight
local _transition_delay = 400	;  local _dragBarTransTime = 250
local _imageScale = { }
local complete = false
local _borderwidth = cWidth / 110


local nommers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
local nommersOor = 10
local currentActiveNommerButton = { }
local currentActiveNommerButtonBack = { }

local currentDragNommerBar = { } 
local currentTargetNommerBar = { }
local currentActiveNommerButtonBack = { } 
local colourTable = {	{ 1, 0, 0 }, { 0, 153/255, 51/255  }, 
						{ 1, 153/255, 1 }, { 1, 102/255, 0 }, 
						{ 0, 204/255, 204/255 }, { 153/255, 51/255, 153/255 },
						{ 1, 1, 102/255 }, { 102/255, 51/255, 0 },
						{ 0, 102/255, 204/255 }, {1, 204/255, 0 } 
					}
local nommerBarTable = { }	
local nommerButtonTable = { } 
local nommerButtonBackTable = {}	
local tickTable = {}
local sqCenterX, sqCenterY 
local greyRecHeight
local greyRecWidth 
local greyRec 

local sceneGroup
local container
		
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
--Scene Functions
-------------------------------------------------------------------------------------------------------------------------------

function scene:create( event )
    sceneGroup = self.view
	
	
	
    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
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
	homeBtn.x = homeBtn.width / 2 --display.contentCenterX - xInset*10
	homeBtn.y = display.contentCenterY -yInset*6
	homeBtn.xScale = 0.5
	homeBtn.yScale = 0.5
	homeBtn.alpha = 0.8
	sceneGroup:insert(homeBtn)
	
	-- White rectangle with purple border
	local whitebg = display.newImageRect("whitebg.png",display.contentWidth,display.contentHeight-yInset*2.5)
	whitebg.x = display.contentCenterX
	whitebg.y = display.contentCenterY+yInset*1.2
	sceneGroup:insert(whitebg)
	

	--Get white rectangle coordinates and size and create grey rectangle on left
	sqCenterX, sqCenterY = whitebg:localToContent( 0, 0 )
	greyRecHeight = whitebg.height - 4 * _borderwidth
	greyRecWidth = whitebg.width / 12
	greyRec = display.newRoundedRect(sqCenterX - whitebg.width * 11 / 24 + 2.5 * _borderwidth,
											sqCenterY, greyRecWidth, greyRecHeight, 2 * _borderwidth )
	--Grey background of dragbars
	greyRec:setFillColor(240/255, 240/255, 240/255)
	sceneGroup:insert(greyRec)		
	
	--container duh
	container = display.newContainer( whitebg.width - 2 / 3 * xInset + 1, whitebg.height - 1 / 3 * xInset - 2.5 )
	container:translate( whitebg.x, whitebg.y )
	-- local tbg = display.newRect(  0, 0, container.width, container.height )
	-- container:insert( tbg )
	-- tbg:setFillColor( 0, 1, 1 )
	-- tbg.alpha = 0.2
	-- tbg.x, tbg.y = 0, 0
	sceneGroup:insert( container )
	
	-------------------------------------------------------------------------------------------------
	----Methods for handling events ( clicking on number row or dropping of bar on target )
	-------------------------------------------------------------------------------------------------						
							
							
	handleNommerButtonEvent = function( event )
		local phase = event.phase
		if "ended" == phase and event.target.coupledNommer.isActive == false then
			
			ActiveNommerChanged( event.target.coupledNommer.no, false )
		
		else
		end
		
	end
 

	-- find imagescale - relative to 10th numberBar image and contentHeight
	local tempImage = display.newImage( "telraam/10.png", 0, 0 )
	local currentBarHeight = tempImage.height
	local aimHeight = cHeight / 1.5
	_imageScale = aimHeight / currentBarHeight 
	tempImage:removeSelf()
	for i = 1, 10 do
		-----------------------------------------------------------------------------------------------------------------------
		--NommerButtons
        -----------------------------------------------------------------------------------------------------------------------
		nommerButton = display.newText( i, cWidth* (i+2)  / 15, display.contentCenterY -yInset*6, teachersPetFont, 36 )
		nommerButton.no = i
		sceneGroup:insert(nommerButton)
		nommerButtonBack = display.newRect( cWidth * (i+2) / 15, display.contentCenterY -yInset*6, cWidth / 14, cWidth / 14 )
		nommerButtonBack.coupledNommer = nommerButton
		nommerButtonBack.strokeWidth = 4
		nommerButtonBack:setStrokeColor( 1, 0, 0 )
		nommerButtonBack.alpha = 0
		nommerButtonBack.isHitTestable = true
		sceneGroup:insert(nommerButtonBack)
		
		tick = display.newGroup()
		local c = display.newImage(tick,"icons/tickCircle.png")
		local arrow = display.newImage(tick,"icons/arrow.png")
		arrow.xScale =0.2
		arrow.yScale =0.2
		arrow.x = xInset*0.25
		arrow.y = -yInset*0.2
		tick.x = cWidth* (i+2)  / 15
		tick.y = display.contentCenterY -yInset*6
		c.xScale = 0.05
		c.yScale = 0.05
		tick.alpha =0 
		sceneGroup:insert(tick)
		
		--initialise "1" to be active on start
		if i == 1 then
			nommerButton.isActive = true
			currentActiveNommerButton = nommerButton
			currentActiveNommerButtonBack = nommerButtonBack
			transition.to( currentActiveNommerButton, { transition = easing.outSine, time = 1, xScale = 1.8, yScale = 1.8 } ) 
			nommerButton:setFillColor( unpack( colourTable [ 1 ] ) )
		else
			nommerButton.isActive = false
		end
	
		nommerButtonBack:addEventListener( "touch", handleNommerButtonEvent )
		nommerButtonTable[ i ] = nommerButton
		nommerButtonBackTable[i] = nommerButtonBack
		tickTable[i] = tick
	
		----------------
		--NommerBars
		----------------
		_filename = "telraam/" .. i .. ".png"
		--local nommerBar =  display.newImage( _filename, cWidth* (i+2)  / 15, 
		--										cHeight -yInset*10.15, true )
		local nommerBar =  display.newImage( _filename, - container.width / 1.94 + cWidth* (i+2)  / 15, 
												- container.height / 2, true )
		
		-- sceneGroup:insert( nommerBar )										
		container:insert( nommerBar )										
		if i == 1 then 
			currentTargetNommerBar = nommerBar
			--currentDragNommerBar = display.newImage( _filename, greyRec.x, greyRec.y - greyRec.height / 2, true )
			currentDragNommerBar = display.newImage( _filename, - whitebg.width * 11 / 24 + 2.25 * _borderwidth,
			-container.height / 2 + _borderwidth, true )

			--sceneGroup:insert(currentDragNommerBar)
			container:insert(currentDragNommerBar)
			currentDragNommerBar.anchorY = 0
			currentDragNommerBar:scale( _imageScale, _imageScale )
			transition.from( currentDragNommerBar, { time = _dragBartransTime, alpha = 0 } )
			currentDragNommerBar:addEventListener( "touch", dragNommerBar )
		end
		
		nommerBar.alpha = 0.4
		nommerBar.anchorY = 0
		nommerBar.filename = _filename
		nommerBar:scale( _imageScale, _imageScale )
		
		
		function nommerBar:highlight( event )
			
			if event.state == "on" then
				transition.to( nommerBar, { time = 100, alpha = 1 } )
			
			elseif event.state == "off" then
				transition.to ( nommerBar, {time = 100, alpha = 0.4 } )
			end
		end
		nommerBarTable[ i ] = nommerBar
		nommerButtonBackTable[i] = nommerButtonBack
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
		speech.x = xInset*3.8
		speech.y = yInset*0.1
		speech.xScale =-0.55
		speech.yScale =0.3
		
		local zander = display.newImage(group,"zanders/2.png")
		zander.xScale = 0.3
		zander.yScale =0.3
		zander.y = -yInset*0.5
		
		local optionsZanderTxt =
		{
			parent = group,
			text = "Gogela dipheta \nko abucuseng.",
			y = - yInset*0.5,
			x =  xInset*5,
			font = teachersPetFont,
			fontSize = 20,
			align = "left"
		}
		local zanderTxt = display.newText(optionsZanderTxt)
		zanderTxt:setFillColor( 0, 0, 0 )
		
		z = zanderTxt.parent
		z:insert(zanderTxt)
		z:insert(1,speech)
		z.x =display.contentCenterX - xInset*6.5
		z.y =display.contentCenterY + yInset*4.5
		z.xScale =1
		z.yScale =1
		sceneGroup:insert(z)
		timer.performWithDelay(5000,function() transition.fadeOut( z, {time = 300 } ); end)
		timer.performWithDelay(5300,function() z:removeSelf(); end)
		if currentActiveNommerButton ~= nil then
			local sound = unpack(soundTable,currentActiveNommerButton.no)
			audio.play(sound)
		end
       function homeBtn:touch( event )
			if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene
				transition.to(homeBtn,{time=250,xScale=0.4,yScale=0.4})
				timer.performWithDelay(300, function() composer.gotoScene("menu", "fade", 500); end)
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
		if complete then
			complete = false -- incase the same game is chosen again and homeBtn is pressed
			
			for i = 1,10 do
				nommerBar = unpack(nommerBarTable,i)
				nommerBar.alpha =0.4
				tick = unpack(tickTable,i)
				tick.alpha=0
			end
			ActiveNommerChanged( 1, true )
			nommersOor =10
			nommers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
			for i =2,10 do
				nommerButton =unpack(nommerButtonTable,i)
				nommerButton:setFillColor( 1, 1, 1 )
				nommerButtonBack = unpack(nommerButtonBackTable,i)
				nommerButtonBack:addEventListener( "touch", handleNommerButtonEvent )
			end
			
			tel:removeSelf()
			skryf:removeSelf()
			raam:removeSelf()
			bou:removeSelf()
			z:removeSelf()
			fadedRect:removeSelf()
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


-------------------------------------------------------------------------------------------------------------------------------
--Happens whenever active number changes ( bar dropped on target or number row clicked. )
--parameters:	newNommer: number clicked on or random number in case of bar dropped on target
-- 				dropped: true if bar dropped, false if number clicked

ActiveNommerChanged = function ( newNommer, dropped )

	local sound = unpack(soundTable,newNommer)
	audio.play(sound)
		
	currentActiveNommerButton.isActive = false
	local _delay = _dragBarTransTime
	currentActiveNommerButton:setFillColor( 1, 1, 1 )
	if dropped then
		currentActiveNommerButtonBack:removeEventListener( "touch" , handleNommerButtonEvent )
		currentActiveNommerButton:setFillColor( 0.5, 0.5, 0.5 )
		_delay = 0
		
	end
	
	transition.to( currentActiveNommerButton, { transition = easing.outSine, time = 300, xScale = 1, yScale = 1 } )
		
	if currentDragNommerBar ~= nil then
		transition.to( currentDragNommerBar, { time = _dragBarTransTime, alpha = 0 } )
		currentDragNommerBar:removeSelf()
		currentDragNommerBar = nil
	end
	
	currentActiveNommerButton = nommerButtonTable[ newNommer ]
	currentActiveNommerButtonBack = nommerButtonBackTable[newNommer]
	currentActiveNommerButton.isActive = true
	currentActiveNommerButton:setFillColor( unpack( colourTable[ newNommer ] ) )
	transition.to( currentActiveNommerButton, { transition = easing.outSine, time = 300, xScale = 2, yScale = 2 } ) 
	
	currentTargetNommerBar = nommerBarTable[ newNommer ]
	--currentDragNommerBar = display.newImage( currentTargetNommerBar.filename, greyRec.x, greyRec.y - greyRec.height/2, true )
	
	currentDragNommerBar = display.newImage( currentTargetNommerBar.filename, - cWidth * 11 / 24 + 2.25 * _borderwidth,
											-container.height / 2 + _borderwidth, true )

	
	--sceneGroup:insert(currentDragNommerBar)
	container:insert(currentDragNommerBar)
	transition.from( currentDragNommerBar, { time = _dragBarTransTime, delay = _delay, alpha = 0 } )
	currentDragNommerBar:scale ( _imageScale, _imageScale )

	currentDragNommerBar.anchorY = 0
	currentDragNommerBar:addEventListener( "touch", dragNommerBar )
	--BlockNumberTouches( _transition_delay * 2 )
end


-------------------------------------------------------------------------------------------------
----Click, drag and drop handler for bars
dragNommerBar = function( event )
	
	--onClick
	if event.phase == "began" then
		--set focus and bring to front
		display.getCurrentStage():setFocus( event.target, event.id )
		event.target.isFocus = true
		event.target:toFront()
		event.target.hasFocus = true
		--mark original position
		event.target.markX = event.target.x
		event.target.markY = event.target.y
		--click sound
		
			
		local options =
		{
			channel =2,
			loops = 0, -- -1 is infinite loop and 1 will play sound twice
			duration = getDuration(11,12) -- click is 11 tot 12
		}
		audio.stop(slimkop12)-- stop die audio voor die nuwe audio bepaal word
		audio.seek(sounds[11],slimkop12) -- begin die audio speel van waar vorige nommer eindig het
		audio.play(slimkop12,options)
		
	--onDrag
	elseif event.phase == "moved" and event.target.hasFocus then
		if(event.target ~= nil) then
			--Update position of bar to actually move with touch
			local x = ( event.x - event.xStart ) + event.target.markX
			local y = ( event.y - event.yStart ) + event.target.markY
			
			event.target.x = x
			event.target.y =  y
			
			--If hovering over target then animate / highlight target
			if isOverlapping( currentDragNommerBar, currentTargetNommerBar ) then
				transition.to( currentTargetNommerBar, { time = 150, alpha = 1 } )
			else
				transition.to( currentTargetNommerBar, { time = 100, alpha = 0.4 } )
			end
			
		else
			return
		end
		
	--onDrop
	elseif event.phase == "ended" then
		event.target.isFocus = false
		event.target.hasFocus = false
		isDraggingImage = false
		display.getCurrentStage():setFocus(event.target, nil)
		--if hovered over target on drop 
		if isOverlapping( event.target, currentTargetNommerBar ) then
		
			transition.to( event.target, { time = 150, scaleX = 0.8, scaleY = 0.8, alpha = 0 } )
			currentDragNommerBar:removeEventListener( "touch", currentDragNommerBar )
			
			--check if all bars have been dropped to begin new-game scene
			if ( nommersOor > 1 ) then
				nommersOor = nommersOor - 1
				local pos = table.indexOf( nommers, currentActiveNommerButton.no )
				table.remove( nommers, pos )
				local volgende = GetRandomNommer()
				--biep sound
				
				local options =
				{
					channel =2,
					loops = 0, -- -1 is infinite loop and 1 will play sound twice
					duration = getDuration(12,13) -- van 13 tot 14
				}
				audio.stop(slimkop12)-- stop die audio voor die nuwe audio bepaal word
				audio.seek(sounds[12],slimkop12) -- begin die audio speel van waar vorige nommer eindig het
				audio.play(slimkop12,options) 
				
				local currentTick = tickTable[currentActiveNommerButton.no]
				currentTick.alpha = 0.3
				ActiveNommerChanged( volgende, true )
				
			else
				-----------------------------------------------------------------
				-- END OF GAME CODE
				-----------------------------------------------------------------
				
				complete = true
				local currentTick = tickTable[currentActiveNommerButton.no]
				currentTick.alpha = 0.3
				currentActiveNommerButton:setFillColor( 0.5, 0.5, 0.5 )
				transition.to( currentActiveNommerButton, { transition = easing.outSine, time = 300, xScale = 1, yScale = 1 } )
				--timer.performWithDelay(500, function() composer.gotoScene("menu", "fade", 1000); end)
				fadedRect = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth, display.contentHeight)
				fadedRect:setFillColor(0,0,0)
				fadedRect.alpha=0.5
				sceneGroup:insert(fadedRect)
				
				local group = display.newGroup()
				local speech = display.newImage(group,"zanders/speech.png")
				speech.x = - xInset*6
				speech.y = - yInset*0.5
				speech.xScale =0.78
				speech.yScale =0.6
				
				local zander = display.newImage(group,"zanders/4.png")
				zander.xScale = 0.35
				zander.yScale =0.35
				zander.y = -yInset*0.5
				local woorde ={"Kea go lebogisa","O dirile sentle","Sentle"}
				math.randomseed( os.time() )
				local r = math.random( 1, 3 )
				
				--fantasties puik of uitstekend sound
				local sound = unpack(soundTable,14-r)
				audio.play(sound)
				
				local optionsZanderTxt =
				{
					parent = group,
					text = woorde[r]..". \nKgetha motshameko, \no bale le rona",
					y = - yInset*1.7,
					x = - xInset*7.6,
					font = teachersPetFont,
					fontSize = 26,
					align = "left"
				}
				local zanderTxt = display.newText(optionsZanderTxt)
				zanderTxt:setFillColor( 0, 0, 0 )
				
				z = zanderTxt.parent
				z:insert(zanderTxt)
				z:insert(1,speech)
				z.x =display.contentCenterX +xInset*4
				z.y =display.contentCenterY - yInset*2
				sceneGroup:insert(z)
				
				local telGroup = display.newGroup()
				local optionsTel =
				{
					parent = telGroup,
					text = "Are bale ba botlhe",
					y=yInset*4.5,
					font = teachersPetFont,
					fontSize = 33,
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
				tel.y =display.contentCenterY + yInset*2.5
				tel.xScale = 0.5
				tel.yScale = 0.5
				sceneGroup:insert(tel)
				transition.to(tel,{time = 10,xScale =0.55 ,yScale =0.55})
				local raamGroup = display.newGroup()
				timer.performWithDelay(400,function() 
				
					local optionsRaam =
					{
						parent = raamGroup,
						text = "Abacus",
						y=yInset*4.5,
						font = teachersPetFont,
						fontSize = 33,
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
					raam.y =display.contentCenterY + yInset*2.5
					raam.xScale = 0.5
					raam.yScale = 0.5
					sceneGroup:insert(raam)
					transition.to(raam,{time = 10,xScale =0.55 ,yScale =0.55})
					function raam:touch( event )
						if event.phase == "began" then
							--transition image to shrink with a small delay then gotoScene
							transition.to(raam,{time=250,xScale=0.45,yScale=0.45})
							timer.performWithDelay(300, function() composer.gotoScene("raam", "fade", 500); end)
							return true
						end
					end
					raam:addEventListener( "touch", raam );
				end)
				
				local skryfGroup = display.newGroup()
				timer.performWithDelay(800,function()
				local optionsSkryf =
				{
					parent = skryfGroup,
					text = "e'Kwale ka bowena",
					y=yInset*4.5,
					font = teachersPetFont,
					fontSize = 33,
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
				skryf.y =display.contentCenterY + yInset*2.5
				skryf.xScale = 0.5
				skryf.yScale = 0.5
				sceneGroup:insert(skryf)
				transition.to(skryf,{time = 10,xScale =0.55 ,yScale =0.55})
				function skryf:touch( event )
					if event.phase == "began" then
						--transition image to shrink with a small delay then gotoScene
						transition.to(skryf,{time=250,xScale=0.45,yScale=0.45})
						timer.performWithDelay(300, function() composer.gotoScene("skryf", "fade", 500); end)
						return true
					end
				end

				skryf:addEventListener( "touch", skryf );
				
				end)
				
				
				
				local bouGroup = display.newGroup() -- Die group
				--Dit net options vir text
				timer.performWithDelay(1200,function()
				local optionsBou =
				{
					parent = bouGroup, -- dit sit basies die text in bouGroup
					text = "Ikagele yone",
					y=yInset*4.5, -- die yInset het ek heelbo define as 25 dit skyf die text net bietjie af in die group
					font = teachersPetFont, 
					fontSize = 33,
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
				bou.x =display.contentCenterX + xInset*7.5
				bou.y =display.contentCenterY + yInset*2.5
				bou.xScale = 0.5
				bou.yScale = 0.5
				sceneGroup:insert(bou)
				transition.to(bou,{time = 10,xScale =0.55 ,yScale =0.55})
				function bou:touch( event )
					if event.phase == "began" then
						--transition image to shrink with a small delay then gotoScene
						transition.to(bou,{time=250,xScale=0.45,yScale=0.45})
						timer.performWithDelay(300, function() composer.gotoScene("bou", "fade", 500); end)
						return true
					end
				end

				bou:addEventListener( "touch", bou );
				
				end)
				
				function tel:touch( event )
					if event.phase == "began" then
						--transition image to shrink with a small delay then gotoScene
						transition.to(tel,{time=250,xScale=0.45,yScale=0.45})
						timer.performWithDelay(300, function() composer.gotoScene("tel", "fade", 500); end)
						return true
					end
				end
				
				tel:addEventListener( "touch", tel )
				
				
				
				
				
				
			end
			
		else --If missed target transition back to original target
			--boop sound
			local options =
			{
				channel =2,
				loops = 0, -- -1 is infinite loop and 1 will play sound twice
				duration = getDuration(13,14) -- van 13 tot 14
			}
			audio.stop(slimkop12)-- stop die audio voor die nuwe audio bepaal word
			audio.seek(sounds[13],slimkop12) -- begin die audio speel van waar vorige nommer eindig het
			audio.play(slimkop12,options) 
			currentDragNommerBar:removeEventListener("touch",dragNommerBar)
			transition.to( currentDragNommerBar, { transition = easing.outSine, time=300, x = event.target.markX, y = event.target.markY ,
			onComplete = function() currentDragNommerBar:addEventListener("touch", dragNommerBar) end } )
		end
	end
	return true
end

---------------------------------------------------------------------------------
--Get random number from numbers left to be completed
GetRandomNommer = function ()
	math.randomseed( os.time() )
	local r = math.random( 1, nommersOor )
	
	return nommers[ r ]
end

-------------------------------------------------------------------------------------------------------------------------------
--Check to see if currently dragged/dropped image is over / in range of targets
isOverlapping = function ( dragObject, targetObject )
	if math.abs( dragObject.x - targetObject.x ) < ( dragObject.width / 1.5 * _imageScale ) and 
	math.abs( dragObject.y - targetObject.y ) < ( dragObject.height / 2 ) * _imageScale then
		return true
	else
		return false
	end
end

-------------------------------------------------------------------------------------------------------------------------------
BlockNumberTouches = function( timeDelay )  --X-X-X-X-X-X-X
	local toBlockAndReturn = { }
	for i = 1, 10 do
		local pos = table.indexOf( nommers, i )
		if pos ~= nil then
			print ( pos )
			local tempNommerButtonBack = nommerButtonBackTable[ pos ] 
			print(tempNommerButtonBack.coupledNommer.no .. "\n" )
			local pos2 = table.indexOf( completedNommers, i )
			if pos2 == nil then
				table.insert( toBlockAndReturn, tempNommerButtonBack )
			end
		end
	end
	for i, nom in ipairs ( completedNommers ) do
		print(nom.."poes")
	end
	
	local function ReturnTouch( )
		for i, b in ipairs ( toBlockAndReturn ) do 
			b:addEventListener( "tap", handleNommerButtonEvent )
		end
	end
	
	timer.performWithDelay( timeDelay, ReturnTouch() )
end

-------------------------------------------------------------------------------------------------------------------------------
--back key listener


-------------------------------------------------------------------------------------------------------------------------------
getDuration = function(from, to)
	return (sounds[to]-sounds[from])
end
-------------------------------------------------------------------------------------------------------------------------------
return scene

