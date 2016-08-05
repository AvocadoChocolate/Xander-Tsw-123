---------------------------------------------------------------------------------
--
-- scene.lua
-- Known bugs
-- when clicking in a new number there is a bug that it seems the numbers are off by one
-- it seems to play fine if it is played correctly
---------------------------------------------------------------------------------
local sceneName = ...
local composer = require( "composer" )
-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )


-- To let font show correctly in both emulator and devices
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


local complete = false									
local tel ,raam, skryf,bou,z,fadedRect 					

local isOverlapping
local ActiveNommerChanged
local handleNommerButtonEvent
local GetRandomNommer
local PlaceTargetCircles
local PlaceDragCircles
local DragCircle
local BlockNumberTouches 

----------------------------------------
--variables-----------------------------
local sounds = {
		869,1674 ,2550, 3484, 4231,5086,6001,6631,7514,8067,
		8863,9086,9497,9770,13771,14066,
		15272,15897,17241
}
local slimkop123
local slimkop12 ,een,twee,drie,vier,vyf,ses,sewe,agt,nege,tien,puik,fantasties,uitstekend
local audioNotLoaded = true
local soundTable ={}

local containers = { }
local currentContainer
local completedNommers = { }

local nextSceneButton
local homeBtn
local xInset = 25
local yInset = 25
local nommerButton
local nommerButtonBack
local tick
local cWidth = display.contentWidth
local cHeight = display.contentHeight
local _transition_delay = 400
local _dierImageScale = { }
local curDierImage = { }
local nrTextBoImage = { }
local nommers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local nommersOor = 10
local currentActiveNommerButtonBou = { }
local currentActiveNommerButtonBouBack = { }
local tickTable = {}
local currentTargetCircles =  { }
local currentDragCircles = { }
local colourTable = {	{ 1, 0, 0 }, { 0, 153/255, 51/255  },
						{ 1, 153/255, 1 }, { 1, 102/255, 0 },
						{ 0, 204/255, 204/255 }, { 153/255, 51/255, 153/255 },
						{ 1, 1, 102/255 }, { 102/255, 51/255, 0 },
						{ 0, 102/255, 204/255 }, {1, 204/255, 0 }
					}
local isDraggingImage = false	--image is currently being dragged
local nommerButtonTable = { }
local nommerButtonBackTable = { }
local circleRadius = 19/480*cHeight
local whitebg
local greyRec
local sceneGroup



-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
--Scene Functions
-------------------------------------------------------------------------------------------------------------------------------
handleNommerButtonEvent = function (event)

	if event.target.coupledNommer.isActive == false then
		ActiveNommerChanged(event.target.coupledNommer.no, false)
	end
end

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
	
	local backgroundImage = display.newImageRect( "bg.jpg", display.contentWidth, display.contentHeight )
	backgroundImage.x = display.contentCenterX
	backgroundImage.y = display.contentCenterY
	sceneGroup:insert(backgroundImage)
	
	homeBtn = display.newImage("icons/home.png")
	homeBtn.x = homeBtn.width / 2 --display.contentCenterX - xInset*10
	homeBtn.y = display.contentCenterY -yInset*6
	homeBtn.xScale = 0.5
	homeBtn.yScale = 0.5
	homeBtn.alpha = 0.8
	sceneGroup:insert(homeBtn)


	-- White rectangle with purple border
	whitebg = display.newImageRect( "whitebg.png", display.contentWidth, display.contentHeight - yInset * 2.5 )
	whitebg.x = display.contentCenterX
	whitebg.y = display.contentCenterY + yInset * 1.2
	sceneGroup:insert(whitebg)
	local _borderwidth = cWidth / 110

	-- Get white rectangle coordinates and size and create grey rectangle on right
	local sqCenterX, sqCenterY = whitebg:localToContent( 0, 0 )
	local greyRecHeight = whitebg.height - 4*_borderwidth
	local greyRecWidth = whitebg.width/7
	greyRec = display.newRoundedRect(whitebg.width - xInset * 2.5, sqCenterY, greyRecWidth, greyRecHeight, 2 * _borderwidth)
	greyRec:setFillColor(240/255, 240/255, 240/255)
	sceneGroup:insert(greyRec)
	
	--X-X-X-X-X-X-X NET OM SCALE TE CALCULATE
	local tempDierImage = display.newImage("diere/1.png", cWidth/6, display.contentHeight - yInset*6.5, true)
	local currentDierHeight = tempDierImage.height
	local aimHeight = cHeight / 3.2
	_dierImageScale = aimHeight / currentDierHeight
	_dierImageHeight = tempDierImage.height * _dierImageScale
	tempDierImage:scale( _dierImageScale, _dierImageScale )
	tempDierImage:removeSelf()
	--X-X-X-X-X-X-X--------------------------
		
	
	for i = 1, 10 do
		nommerButton = display.newText( i, cWidth* (i+2)  / 15, display.contentCenterY -yInset*6, teachersPetFont, 36 )
		nommerButton.no = i
		
		nommerButtonBack = display.newRect( cWidth * (i+2) / 15, display.contentCenterY -yInset*6, cWidth / 14 - 5, cWidth / 14 )
		nommerButtonBack.coupledNommer = nommerButton
		nommerButtonBack.strokeWidth = 4
		nommerButtonBack:setStrokeColor( 1, 0, 0 )
		nommerButtonBack.alpha = 0
		nommerButtonBack.isHitTestable = true
		sceneGroup:insert(nommerButton)
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
			currentActiveNommerButtonBou = nommerButton
			currentActiveNommerButtonBouBack = nommerButtonBack
			transition.to(currentActiveNommerButtonBou, {transition = easing.outSine, time = 1, xScale = 1.8, yScale = 1.8})
			nommerButton:setFillColor(unpack(colourTable[1]))
		else
			nommerButton.isActive = false
		end
		nommerButtonBack:addEventListener( "touch", handleNommerButtonEvent )
		nommerButtonTable[i] = nommerButton
		nommerButtonBackTable[i] = nommerButtonBack
		tickTable[i] = tick
		
	end
	
	
	--Create new container
		
	currentContainer = display.newContainer( whitebg.width - 2 / 3 * xInset + 1, whitebg.height - 1 / 3 * xInset - 2.5 )
	currentContainer.nommerOor = 1
	table.insert( containers, 1, currentContainer )
	currentContainer:translate( whitebg.x, whitebg.y )

	curDierImage = display.newImage( "diere/" .. 1 .. ".png" )
	curDierImage.x, curDierImage.y =  - currentContainer.width * 0.33, - yInset * 2.5
	curDierImage.anchorY = 0
	curDierImage:scale( _dierImageScale, _dierImageScale )
	currentContainer:insert( curDierImage )
	
	nrTextBoImage = display.newText(1, - currentContainer.width * 0.33, - (currentContainer.height / 2 + _dierImageHeight / 2 ) / 2, teachersPetFont, 60)
	nrTextBoImage:setFillColor( unpack( colourTable[ 1 ] ) )
	currentContainer:insert( nrTextBoImage )

	PlaceDragCircles(1)
	PlaceTargetCircles(1)

	transition.from(currentContainer, {time = _transition_delay, delay = _transition_delay, alpha = 0 } )
	sceneGroup:insert( currentContainer )
	
	
	
	
	
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
		speech.x = - xInset*5.5
		speech.y = - yInset*1.5
		speech.xScale = 0.8
		speech.yScale = 0.5
		
		local zander = display.newImage(group,"zanders/zander.png")
		zander.xScale = 0.35
		zander.yScale =0.35
		zander.y = -yInset*0.5
		
		local optionsZanderTxt =
		{
			parent = group,
			 
			text = "Aa o ka kgona go gogela \ndipheta koo di \ntshwanetseng gonna teng?",
			y = - yInset*2.6,
			x = - xInset*7.2,
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
		if currentActiveNommerButtonBou ~= nil then
			local sound = unpack(soundTable,currentActiveNommerButtonBou.no)
			audio.play(sound)
		end
	   function homeBtn:touch( event )
			if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene
				transition.to( homeBtn,{ time=250,xScale=0.4,yScale=0.4 } )
				timer.performWithDelay( 1, function() composer.gotoScene( "menu", "fade", 500 ); end )


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
			homeBtn:removeEventListener( "touch", homeBtn )
			
		end
		
		if complete then
			complete = false
			containers = { }
			ActiveNommerChanged( 1, false )
			nommersOor =10
			nommers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
			for i=1,10 do
				tick = unpack(tickTable,i)
				tick.alpha=0
			end
			for i =2,10 do
				nommerButton = unpack(nommerButtonTable,i)
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

-------------------------------------------------------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
--Function Definitions
-------------------------------------------------------------------------------------------------------------------------------

PlaceTargetCircles = function (nommer)
	currentContainer.targetCircles = { }
	local midX, midY = currentContainer.x - currentContainer.x, 0 -- whitebg.x, whitebg.y
	local dx, dy = circleRadius * 1.3, circleRadius * 3
	local iterations = math.ceil( nommer / 2 )
	local starty = midY
	local tmp = math.ceil(nommer / 2)

	if tmp % 2 == 0 then    --equal number of rows
		starty = -dy * ( math.ceil( nommer / 4) - 1 / 2 )
	else
		starty = -dy *  math.floor( nommer / 4 )
	end

	local even = ( nommer % 2 == 0 )
	for i = 0, iterations - 1 do -- i : rows
		local even = ( nommer % 2 == 0 )
		if i == 0 then
			if even then  -- Even then two targets at top
				local c = display.newImage( "bouImages/" .. 1 .. ".png", midX - dx, starty )
				c.width = circleRadius * 2
				c.height = circleRadius * 2

				currentContainer:insert( c )

				c:setFillColor( 0, 0, 0 )
				c.alpha = 0.2

				local c2 = display.newImage( "bouImages/" .. 1 .. ".png", midX + dx, starty,  circleRadius, circleRadius )
				c2.width = circleRadius * 2
				c2.height = circleRadius * 2 
				
				currentContainer.targetCircles[ 1 ] = c				
				currentContainer.targetCircles[ 2 ] = c2

				c2:setFillColor( 0, 0, 0 )
				c2.alpha = 0.2

				c.isStillTarget = true
				c2.isStillTarget = true

				currentContainer:insert( c )
				currentContainer:insert( c2 )

			else --Odd then one target at top
				local c = display.newImage( "bouImages/" .. nommer .. ".png", midX, starty )

				c.width = circleRadius * 2
				c.height = circleRadius * 2

				currentContainer:insert( c )
				currentContainer.targetCircles[ 1 ] = c		

				c:setFillColor( 0, 0, 0 )
				c.alpha = 0.2

				c.isStillTarget = true
			end
		else
			local c = display.newImage( "bouImages/" .. 1 .. ".png", midX - dx, starty + ( dy * i ),  circleRadius, circleRadius )
			c.width = circleRadius * 2
			c.height = circleRadius * 2

			local c2 = display.newImage( "bouImages/" .. 1 .. ".png", midX + dx, starty + ( dy * i ),  circleRadius, circleRadius )
			c2.width = circleRadius * 2
			c2.height = circleRadius * 2
			if even then
			
				currentContainer.targetCircles[ 2*i + 1 ] = c
				currentContainer.targetCircles[ 2*i + 2 ] = c2
			else
				currentContainer.targetCircles[ 2*i ] = c
				currentContainer.targetCircles[ 2*i + 1 ] = c2
		end

		c:setFillColor( 0, 0, 0 )
		c.alpha = 0.2
		c2:setFillColor( 0, 0, 0 )
		c2.alpha = 0.2

		c.isStillTarget = true
		c2.isStillTarget = true

		currentContainer:insert( c )
		currentContainer:insert( c2 )
	end
end
end

-------------------------------------------------------------------------------------------------------------------------------
PlaceDragCircles = function ( nommer )

	local midX, starty = currentContainer.x - xInset * 2.5, -currentContainer.y / 2
	local dx, dy = circleRadius * 1.3, circleRadius * 3
	local iterations = math.ceil( nommer / 2 )

	for i = 0, iterations - 1 do -- i : rows
		local even = ( nommer % 2 == 0 )
		if i == 0 then
			if even then  -- Even then two targets at top
				local c = display.newImage( "bouImages/" .. nommer .. ".png", midX - dx, starty )
				c.width = circleRadius * 2
				c.height = circleRadius * 2
				local c2 = display.newImage( "bouImages/" .. nommer .. ".png", midX + dx, starty,  circleRadius, circleRadius )
				c2.width = circleRadius * 2
				c2.height = circleRadius * 2
				currentDragCircles[ 1 ] = c
				currentDragCircles[ 2 ] = c2
				
				c:addEventListener( "touch", DragCircle )
				c2:addEventListener( "touch", DragCircle )

				currentContainer:insert( c )
				currentContainer:insert( c2 )

			else --Odd then one target at top

				local c = display.newImage( "bouImages/" .. nommer .. ".png", midX, starty )
				c.width = circleRadius * 2
				c.height = circleRadius * 2
				currentDragCircles[ 1 ] = c
				
				c:addEventListener( "touch", DragCircle )
				currentContainer:insert( c )
			end
		else
			local c = display.newImage( "bouImages/" .. nommer .. ".png", midX - dx, starty + ( dy * i ),  circleRadius, circleRadius )
			c.width = circleRadius * 2
			c.height = circleRadius * 2
			local c2 = display.newImage( "bouImages/" .. nommer .. ".png", midX + dx, starty + ( dy * i ),  circleRadius, circleRadius )
			c2.width = circleRadius * 2
			c2.height = circleRadius * 2
			if even then
				currentDragCircles[ 2*i + 1 ] = c
				currentDragCircles[ 2*i + 2 ] = c2
			else
				currentDragCircles[ 2*i ] = c
				currentDragCircles[ 2*i + 1 ] = c2
			end

			c:addEventListener("touch", DragCircle)
			c2:addEventListener("touch", DragCircle)

			currentContainer:insert( c )
			currentContainer:insert( c2 )
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------
 -- Fired if clicked on number in top row or if number completed
 -- by dropping last circle ( thus dropped = current # completed)
ActiveNommerChanged = function (newNommer, dropped)
	
	local sound = unpack(soundTable,newNommer)
	audio.play(sound)
	
	currentActiveNommerButtonBou.isActive = false

	

	-- If newNommer already clicked on previously then find it and make it visible
	if containers[ newNommer ] ~= nil then
		
	
		transition.to( currentContainer, { time = _transition_delay, alpha = 0 } ) --, oncomplete = function() currentContainer.isVisible = false; end } )
		--currentContainer.isVisible = false
		
		local function delayedShowContainer()
			currentContainer = containers[ newNommer ]
			--currentContainer.isVisible = true	
			transition.to(currentActiveNommerButtonBou, {transition = easing.outSine, time = 1, xScale = 1.8, yScale = 1.8})

			transition.to( currentContainer, { time = _transition_delay, delay = _transition_delay, alpha = 1 } )
			
		end
		timer.performWithDelay( _transition_delay, delayedShowContainer() )

		if dropped then
			table.insert(completedNommers, ( currentActiveNommerButtonBou.no ))
			containers[ currentActiveNommerButtonBou.no ] = nil
			--currentActiveNommerButtonBouBack:removeEventListener( "tap", handleNommerButtonEvent )
			currentActiveNommerButtonBouBack:removeEventListener( "touch" , handleNommerButtonEvent )
			print("backButton removed")
			currentActiveNommerButtonBou:setFillColor( 0.5, 0.5, 0.5 )
			
		else
			currentActiveNommerButtonBou:setFillColor( 1, 1, 1 )
		end
		
	else
		for i = 1, currentActiveNommerButtonBou.no do
			currentDragCircles[ i ] = nil
		end
		if dropped then
			table.insert(completedNommers, ( currentActiveNommerButtonBou.no ))
			--currentActiveNommerButtonBouBack:removeEventListener( "tap", handleNommerButtonEvent )
			currentActiveNommerButtonBouBack:removeEventListener( "touch" , handleNommerButtonEvent )
			currentActiveNommerButtonBou:setFillColor(0.5, 0.5, 0.5)
			print( "was dropped" )
			print("backButton removed")
			containers[ currentActiveNommerButtonBou.no ] = nil
		else
			currentActiveNommerButtonBou:setFillColor(1, 1, 1)
			print( "wasn't dropped" )
		end
		--Hide old container
		transition.to( currentContainer, { time = _transition_delay, alpha = 0 } )

		--Create new container
		
		currentContainer = display.newContainer( whitebg.width - 2 / 3 * xInset + 1, whitebg.height - 1 / 3 * xInset - 2.5 )
		currentContainer.nommerOor = newNommer
		table.insert( containers, newNommer, currentContainer )
		currentContainer:translate( whitebg.x, whitebg.y )

		curDierImage = display.newImage( "diere/" .. newNommer .. ".png" )
		curDierImage.x, curDierImage.y =  - currentContainer.width * 0.33, - yInset * 2.5
		curDierImage.anchorY = 0
		curDierImage:scale( _dierImageScale, _dierImageScale )
		currentContainer:insert( curDierImage )
		
		nrTextBoImage = display.newText(newNommer, - currentContainer.width * 0.33, - (currentContainer.height / 2 + _dierImageHeight / 2 ) / 2, teachersPetFont, 60)
		nrTextBoImage:setFillColor( unpack( colourTable[ newNommer ] ) )
		currentContainer:insert( nrTextBoImage )

		PlaceDragCircles(newNommer)
		PlaceTargetCircles(newNommer)
	
		transition.from(currentContainer, {time = _transition_delay, delay = _transition_delay, alpha = 0 } )
		sceneGroup:insert( currentContainer )
		
	end
	transition.to(currentActiveNommerButtonBou, {transition = easing.outSine, time = 300, xScale = 1, yScale = 1})
	currentActiveNommerButtonBou = nommerButtonTable[newNommer]
	currentActiveNommerButtonBouBack = nommerButtonBackTable[newNommer]
	currentActiveNommerButtonBou.isActive = true
	currentActiveNommerButtonBou.no = newNommer
	currentActiveNommerButtonBou:setFillColor(unpack(colourTable[newNommer]))
	transition.to(currentActiveNommerButtonBou, {transition = easing.outSine, time = 300, xScale = 2, yScale = 2})
	
	print("\n")

		
	for i = 1, 10 do
		if containers[ i ] == nil then
			print( i )
		else
			print (containers[ i ])
		end
	end

	print("\n")
	
	--BlockNumberTouches( _transition_delay * 2.5 )   																--X-X-X-X-X-X-X
end

-------------------------------------------------------------------------------------------------------------------------------
DragCircle = function (event)
	if event.phase == "began" then

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
		display.getCurrentStage():setFocus(event.target, event.id)
		event.target.isFocus = true
		event.target:toFront()
		event.target.markX = event.target.x
		event.target.markY = event.target.y
		event.target.hasFocus = true
		transition.to(event.target, {time = 200, xScale = 1.1, yScale = 1.1 } )
		isDraggingImage = true
		
	elseif event.phase == "moved" and event.target.hasFocus then
			if(event.target ~= nil) then
			local x = (event.x - event.xStart) + event.target.markX
			local y = (event.y - event.yStart) + event.target.markY
			event.target.x, event.target.y = x, y
		else
			return
		end
	elseif 
		event.phase == "ended" or event.phase == "cancelled" then
		event.target.isFocus = false
		event.target.hasFocus = false
		isDraggingImage = false
		display.getCurrentStage():setFocus(event.target, nil)
		overlaps, targetObject = isOverlapping(event.target)
		
		if overlaps then
			currentContainer.nommerOor = currentContainer.nommerOor - 1	
			transition.to(event.target, { 	time = 50, x = targetObject.x, y = targetObject.y, xScale = 1, yScale = 1,
											onComplete = 	function()
																targetObject.alpha = 0
															end } )
			targetObject.isStillTarget = false
			event.target:removeEventListener("touch", DragCircle)
			if currentContainer.nommerOor > 0 then
				local options =
				{
					channel =2,
					loops = 0, -- -1 is infinite loop and 1 will play sound twice
					duration = getDuration(12,13) -- van 13 tot 14
				}
				audio.stop(slimkop12)-- stop die audio voor die nuwe audio bepaal word
				audio.seek(sounds[12],slimkop12) -- begin die audio speel van waar vorige nommer eindig het
				audio.play(slimkop12,options) 
			end
			
			if currentContainer.nommerOor == 0 then	
				local options =
				{
					channel =2,
					loops = 0, -- -1 is infinite loop and 1 will play sound twice
					duration = getDuration(10,11) -- van 13 tot 14
				}
				audio.stop(slimkop12)-- stop die audio voor die nuwe audio bepaal word
				audio.seek(sounds[10],slimkop12) -- begin die audio speel van waar vorige nommer eindig het
				audio.play(slimkop12,options)
				
				if ( nommersOor >1 ) then
					nommersOor = nommersOor - 1
					local pos = table.indexOf(nommers, currentActiveNommerButtonBou.no)
					table.remove(nommers, pos)
					local volgende = GetRandomNommer()
					local currentTick = tickTable[currentActiveNommerButtonBou.no]
					currentTick.alpha = 0.3
					
					ActiveNommerChanged(volgende, true)		
					
				else
					-----------------------------------------------------------------
					-- END OF GAME CODE
					-----------------------------------------------------------------

						complete = true
						local currentTick = tickTable[currentActiveNommerButtonBou.no]
						currentTick.alpha = 0.3
						currentActiveNommerButtonBou:setFillColor( 0.5, 0.5, 0.5 )
						transition.to( currentActiveNommerButtonBou, { transition = easing.outSine, time = 300, xScale = 1, yScale = 1 } )
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
			end
			
		else
			transition.to(event.target, { transition = easing.outSine, time=300, x = event.target.markX, y = event.target.markY})
			transition.to(event.target, { time = 300, delay = 300, xScale = 1, yScale = 1 } )
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
		end
	end
	return true
end

-------------------------------------------------------------------------------------------------------------------------------
GetRandomNommer = function ()
	math.randomseed( os.time() )
	local r = math.random( 1, nommersOor )
	
	return nommers[ r ]
end

-------------------------------------------------------------------------------------------------------------------------------
isOverlapping = function(dragObject) --X-X-X-X-X-X-X

	for i, targetObject in ipairs( currentContainer.targetCircles ) do
		local xDiff, yDiff = math.abs( dragObject.x - targetObject.x ), math.abs(dragObject.y - targetObject.y)
		local distance = math.sqrt( xDiff * xDiff + yDiff * yDiff )

		if( distance < circleRadius * 1.1 ) and ( targetObject.isStillTarget == true ) then
			return true, targetObject
		end
	end
	return false, nil
end

-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
--back key listener


-------------------------------------------------------------------------------------------------------------------------------
getDuration = function(from, to)
	return (sounds[to]-sounds[from])
end
return scene