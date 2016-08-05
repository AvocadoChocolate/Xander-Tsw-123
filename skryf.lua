---------------------------------------------------------------------------------
--
-- scene.lua
-- TODO: Swap if statements at 496 and 498
-- Insert check boxes on numberbar on top when a number is completed
-- Insert circles indicating number
-- kill screen
---------------------------------------------------------------------------------

local sceneName = ...
local teachersPetFont
local composer = require( "composer" )
local fingerPaint = require("fingerPaint")

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
--functions-----------------------------
local handleNommerButtonEvent
local isOverlapping
local GetRandomNommer
local ActiveNommerChanged
----------------------------------------
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

local _transition_time = 400
local _transition_delay = 100
local one = false
local two = false
local three = false
local four = false
local five = false
local complete =false
local tel ,raam, skryf,bou,z,fadedRect			--
local nextSceneButton
local homeBtn
local canvas
local xInset = 25
local yInset = 25
local cWidth, cHeight = display.contentWidth, display.contentHeight
local nommer
local numberPattern
local nommerButton
local nommerButtonBack
local tick
local currentActiveNommerButton = { }
local currentActiveNommerButtonBack = { }
local nommerButtonBackTable = {}	
local tickTable = {}
local nommerSirkels
local nommers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local nommersOor = 10
local nommerButtonTable = { } 
local colourTable = {	{ 1, 0, 0 }, { 0, 153/255, 51/255  }, 
						{ 1, 153/255, 1 }, { 1, 102/255, 0 }, 
						{ 0, 204/255, 204/255 }, { 153/255, 51/255, 153/255 },
						{ 1, 1, 102/255 }, { 102/255, 51/255, 0 },
						{ 0, 102/255, 204/255 }, {1, 204/255, 0 } }

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
	homeBtn.x = homeBtn.width / 2 -- display.contentCenterX - xInset * 9
	homeBtn.y = display.contentCenterY - yInset * 6
	homeBtn.xScale = 0.5
	homeBtn.yScale = 0.5
	homeBtn.alpha = 0.8
	sceneGroup:insert(homeBtn)
	
	whitebg = display.newImageRect("whitebg.png",display.contentWidth,display.contentHeight-yInset*2.5)
	whitebg.x = display.contentCenterX
	whitebg.y = display.contentCenterY+yInset*1.2
	sceneGroup:insert(whitebg)
	
	canvas = fingerPaint.newCanvas(display.contentWidth/2,display.contentHeight-yInset*3)
	canvas.x = display.contentCenterX - xInset*4
	canvas.y = display.contentCenterY+yInset*1.2
	canvas:setCanvasColor(0, 0, 0, 0)
	canvas:setStrokeWidth(12)
	
	
						
	
	for i = 1, 10 do
		-----------------------------------------------------------------------------------------------------------------------
		--NommerButtons
        -----------------------------------------------------------------------------------------------------------------------
		nommerButton = display.newText( i, cWidth* (i+2)  / 15, display.contentCenterY -yInset*6, teachersPetFont, 36 )
		nommerButton.no = i
		
		nommerButtonBack = display.newRect( cWidth * (i+2) / 15, display.contentCenterY -yInset*6, cWidth / 14, cWidth / 14 )
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
			currentActiveNommerButton = nommerButton
			currentActiveNommerButtonBack = nommerButtonBack
			transition.to( currentActiveNommerButton, { transition = easing.outSine, time = 1, xScale = 1.5, yScale = 1.5 } ) 
			nommerButton:setFillColor( unpack( colourTable [ 1 ] ) )
			local r,g,b = unpack( colourTable[ 1 ] )
			canvas:setPaintColor(r,g,b,1)
			numberPattern = display.newImage("skryfself/1.png")
			numberPattern.x = display.contentCenterX - xInset * 7.5 +  xInset
			numberPattern.y = display.contentCenterY+yInset * 1.5
			numberPattern.xScale = 0.35
			numberPattern.yScale = 0.35
			
			
			nommer = display.newText( "1", display.contentCenterX - xInset*7 + xInset, display.contentCenterY+yInset*2, teachersPetFont, 234)
			nommer:setFillColor( 0.8, 0.8, 0.8 )
			
			nommerSirkels = display.newImage("onstelOLD/1.png")
			nommerSirkels.x = cWidth * 5 / 6
			nommerSirkels.y = whitebg.y
			nommerSirkels.xScale =0.5
			nommerSirkels.yScale =0.5
			sceneGroup:insert(nommerSirkels)
			sceneGroup:insert(numberPattern)
			sceneGroup:insert(nommer)
			
		else
			nommerButton.isActive = false
			
		end
		nommerButtonBack:addEventListener( "touch", handleNommerButtonEvent )
		nommerButtonTable[ i ] = nommerButton
		nommerButtonBackTable[i] = nommerButtonBack
		tickTable[i] = tick
		--X-X-X-X-X-X-X fokken Zander kak

	end
	
	sceneGroup:insert(canvas)
	
end


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
		speech.y = - yInset*2
		speech.xScale = 0.6
		speech.yScale = 0.21
		
		local zander = display.newImage(group,"zanders/zander.png")
		zander.xScale = 0.35
		zander.yScale = 0.35
		zander.y = -yInset*0.5
		
		local optionsZanderTxt =
		{
			parent = group,
			text = "e'Kwale ka bowena.",
			y = - yInset*2.4,
			x = - xInset*6.8,
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
		if currentActiveNommerButton ~= nil then
			local sound = unpack(soundTable,currentActiveNommerButton.no)
			audio.play(sound)
		end
		canvas.isActive =true
		function homeBtn:touch( event )
			if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene
				transition.to(homeBtn,{time=250,xScale=0.4,yScale=0.4})
				timer.performWithDelay(1, function() composer.gotoScene("menu", "fade", 500); end)
				return true
			end
		end
		
		homeBtn:addEventListener( "touch", homeBtn )
		function canvas:touch( event )
			if ( event.phase == "began" ) then
				print("touched canvas")
				print(currentActiveNommerButton.no)
			elseif ( event.phase == "moved" ) then
				--Check what number is active to make checks more efficient
				--Checks are made for each number as each number is unique and each number has five unique markers
				if(currentActiveNommerButton.no==1)then
					--Check if points are intersected once intersected it is not needed to check again
					if one == false then
						one = isOverlapping(nommer,event,0,80,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,0,40,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,0,10,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,0,-20,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,0,-40,10)
					end
				end
				if(currentActiveNommerButton.no==2)then
					if one == false then
						one = isOverlapping(nommer,event,30,60,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,0,80,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,-30,50,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,30,-50,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,-30,-50,10)
					end
				end
				if(currentActiveNommerButton.no==3)then
					if one == false then
						one = isOverlapping(nommer,event,30,60,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,-25,60,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,5,10,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,-25,-40,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,30,-30,10)
					end
				end
				if(currentActiveNommerButton.no==4)then
					if one == false then
						one = isOverlapping(nommer,event,40,-45,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,0,60,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,-30,-45,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,-10,-20,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,-10,-75,10)
					end
				end
				if(currentActiveNommerButton.no==5)then
					if one == false then
						one = isOverlapping(nommer,event,-25,75,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,30,75,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,30,20,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,-25,20,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,0,-50,10)
					end
				end
				if(currentActiveNommerButton.no==6)then
					if one == false then
						one = isOverlapping(nommer,event,-5,75,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,30,10,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,25,-40,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,-20,-40,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,-20,10,10)
					end
				end
				if(currentActiveNommerButton.no==7)then
					if one == false then
						one = isOverlapping(nommer,event,20,80,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,-25,80,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,-15,30,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,0,-10,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,15,-45,10)
					end
				end
				if(currentActiveNommerButton.no==8)then
					if one == false then
						one = isOverlapping(nommer,event,-10,75,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,30,50,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,-30,-10,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,40,-15,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,-40,70,10)
					end
				end
				if(currentActiveNommerButton.no==9)then
					if one == false then
						one = isOverlapping(nommer,event,-30,75,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,-25,40,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,-20,-40,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,30,70,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,10,15,10)
					end
				end
				if(currentActiveNommerButton.no==10)then
					if one == false then
						one = isOverlapping(nommer,event,50,70,10)
					end
					if two == false then
						two = isOverlapping(nommer,event,50,-40,10)
					end
					if three == false then
						three = isOverlapping(nommer,event,-15,80,10)
					end
					if four == false then
						four = isOverlapping(nommer,event,-50,15,10)
					end
					if five == false then
						five = isOverlapping(nommer,event,20,10,10)
					end
				end
			elseif ( event.phase == "ended" ) then
				
			
				-- Check if number is drawn correctly then go to another number 
				if one and two and three and four and five then
					--Check if all ten numbers are drawn and if there are any left to draw
					if(nommersOor > 1 ) then
						
						local options =
						{
							channel =2,
							loops = 0, -- -1 is infinite loop and 1 will play sound twice
							duration = getDuration(10,11)
						}
						
						audio.seek(sounds[10],slimkop12)
						audio.play(slimkop12,options)
						
						nommersOor = nommersOor - 1
						local pos = table.indexOf( nommers, currentActiveNommerButton.no )
						table.remove( nommers, pos )
						local volgende = GetRandomNommer()	
						local currentTick = tickTable[currentActiveNommerButton.no]
						currentTick.alpha = 0.3
						ActiveNommerChanged( volgende, true )
					
					else
						complete = true
						local currentTick = tickTable[currentActiveNommerButton.no]
						currentTick.alpha = 0.3
						currentActiveNommerButton:setFillColor( 0.5, 0.5, 0.5 )
						transition.to( currentActiveNommerButton, { transition = easing.outSine, time = 300, xScale = 1, yScale = 1 } )
						one =false
						two =false
						three =false
						four =false
						five =false
						--timer.performWithDelay(500, function() composer.gotoScene("menu", "fade", 1000); end)
						canvas.isActive =false
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
						transition.to(bou,{time = 10, xScale =0.55 ,yScale =0.55})
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
			end
			return true
		end
		canvas:addEventListener("touch",canvas)
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
		canvas:erase()
		if homeBtn then
			homeBtn.xScale = 0.5
			homeBtn.yScale = 0.5
			homeBtn:removeEventListener( "touch", homeBtn )
			
		end
		
		if complete then
			complete = false
			ActiveNommerChanged( 1, true )
			nommersOor =10
			nommers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
			
			for i=1,10 do
				tick = unpack(tickTable,i)
				tick.alpha=0
			end
			for i =2,10 do
				nommerButton =unpack(nommerButtonTable,i)
				nommerButton:setFillColor( 1, 1, 1 )
				nommerButtonBack = unpack(nommerButtonBackTable,i)
				nommerButtonBack:addEventListener( "touch", handleNommerButtonEvent )
			end
			one= false
			two= false
			three= false 
			four= false
			five = false
			
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

handleNommerButtonEvent = function ( event )
	local phase = event.phase
	if "ended" == phase and event.target.coupledNommer.isActive == false then
		
		ActiveNommerChanged( event.target.coupledNommer.no, false )
	
	else
	end
	
 end

-------------------------------------------------------------------------------------------------------------------------------
ActiveNommerChanged = function ( newNommer, dropped )
	one =false 
	two =false
	three=false 
	four=false
	five = false
	local sound = unpack(soundTable,newNommer)
	audio.play(sound)
	
	currentActiveNommerButton.isActive = false
	currentActiveNommerButton:setFillColor( 1, 1, 1 )
	if dropped then
		currentActiveNommerButtonBack:removeEventListener( "touch" , handleNommerButtonEvent )
		currentActiveNommerButton:setFillColor( 0.5, 0.5, 0.5 )
	end
	transition.to( currentActiveNommerButton, { transition = easing.outSine, time = 300, xScale = 1, yScale = 1 } )
	
	currentActiveNommerButton = nommerButtonTable[ newNommer ]
	currentActiveNommerButtonBack = nommerButtonBackTable[newNommer]
	currentActiveNommerButton.isActive = true
	currentActiveNommerButton:setFillColor( unpack( colourTable[ newNommer ] ) )
	canvas:erase()
	
	local r,g,b = unpack( colourTable[ newNommer ] )
	canvas:setPaintColor(r,g,b,1)
	transition.to( currentActiveNommerButton, { transition = easing.outSine, time = 300, xScale = 1.5, yScale = 1.5 } ) 
	
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
	--EDIT START ( NEILL ) 
	------------------------------------------------------------------------------------------------------------
	local setNumberPatternXY
	local changeNrTxt = function() 
		nommer:removeSelf()
		local nommerTxt =string.format("%i",newNommer)
		nommer = display.newText( nommerTxt, display.contentCenterX - xInset*6, display.contentCenterY+yInset*2, teachersPetFont, 234)
		nommer:setFillColor(0.8,0.8,0.8)
		transition.from ( nommer, { time = _transition_time, delay = _transition_delay, alpha = 0 } )
		
		sceneGroup:insert( nommer ) 
		canvas:toFront()
	end
	
	local newNumberPattern = function()
		numberPattern:removeSelf()
		
		local filePath = string.format("skryfself/%i.png",newNommer)
		numberPattern = display.newImage(filePath)
		setNumberPatternXY()
		numberPattern.xScale =0.35
		numberPattern.yScale =0.35
		numberPattern.x = numberPattern.x + xInset
		transition.from ( numberPattern, { time = _transition_time, delay = _transition_delay, alpha = 0 } )
		
		sceneGroup:insert(numberPattern)
	end
	
	local newNommerSirkels = function()
		nommerSirkels:removeSelf()
		
		local filePathSirkels = string.format("onstelOLD/%i.png",newNommer)
		nommerSirkels = display.newImage(filePathSirkels)
		nommerSirkels.x = cWidth * 5 / 6 
		nommerSirkels.y = whitebg.y
		nommerSirkels.xScale =0.5
		nommerSirkels.yScale =0.5
		transition.from ( nommerSirkels, { time = _transition_time, delay = _transition_delay, alpha = 0 } )
		
		sceneGroup:insert(nommerSirkels)
	end
	
	transition.to ( numberPattern, { time = _transition_time, alpha = 0, onComplete = newNumberPattern } )
	transition.to ( nommer, { time = _transition_time, alpha = 0, onComplete = changeNrTxt } )
	transition.to ( nommerSirkels, { time = _transition_time, alpha = 0, onComplete = newNommerSirkels } )
	
	function setNumberPatternXY()
		if newNommer == 10 then
			numberPattern.x = display.contentCenterX - xInset*7.6
			numberPattern.y = display.contentCenterY+yInset
			
		elseif newNommer == 9 then
			numberPattern.x = display.contentCenterX - xInset*7.1
			numberPattern.y = display.contentCenterY+yInset*0.4
			
		elseif newNommer == 8 then
			numberPattern.x = display.contentCenterX - xInset*7
			numberPattern.y = display.contentCenterY+yInset*1.3
			
		elseif newNommer == 7 then
			numberPattern.x = display.contentCenterX - xInset*6.8
			numberPattern.y = display.contentCenterY+yInset*0.7
			
		elseif newNommer == 6 then
			numberPattern.x = display.contentCenterX - xInset*7.3
			numberPattern.y = display.contentCenterY+yInset*2
			
		elseif newNommer == 5 then
			numberPattern.x = display.contentCenterX - xInset*7.4
			numberPattern.y = display.contentCenterY+yInset*0.8
			
		elseif newNommer == 4 then
			numberPattern.x = display.contentCenterX - xInset*7.3
			numberPattern.y = display.contentCenterY+yInset*2.5
			
		elseif newNommer == 3 then
			numberPattern.x = display.contentCenterX - xInset*6.8
			numberPattern.y = display.contentCenterY+yInset*1.5

		elseif newNommer == 2 then
			numberPattern.x = display.contentCenterX - xInset*6.8
			numberPattern.y = display.contentCenterY+yInset*0.8
		
		elseif newNommer == 1 then
			numberPattern.x = display.contentCenterX - xInset*7.5
			numberPattern.y = display.contentCenterY+yInset*1.5
		end
	end
	
	------------------------------------------------------------------------------------------------------------
	--EDIT END
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
end

-------------------------------------------------------------------------------------------------------------------------------
GetRandomNommer = function ()
	math.randomseed( os.time() )
	local r = math.random( 1, nommersOor )
	
	return nommers[ r ]
end

-------------------------------------------------------------------------------------------------------------------------------
--back key listener


-------------------------------------------------------------------------------------------------------------------------------
getDuration = function(from, to)
	return (sounds[to]-sounds[from])
end
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-- This function checks if the target line being drawn intersects with 
--some position on the number determined by some constantX and constantY
-- parameters:
-- 				nommerTxt - The nommer txt being displayed. The fontsize of this txt should not be changed else the constants will change!!
-- 				target - The touch event.
-- 				tolerance - This value determines the difficulty in checking if the numbers are correctly drawn. Set to 10 seems to work fine
isOverlapping = function (nommerTxt , target, constantX ,constantY,tolerance)
	if((nommerTxt.x - target.x) > (constantX - tolerance*2) and (nommerTxt.x -target.x) <(constantX + tolerance*2) and  (nommerTxt.y - target.y) > (constantY -tolerance*2) and (nommerTxt.y - target.y) < (constantY + tolerance*2)) then
		
		return true
	else
		return false
	end
end
---------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
return scene
