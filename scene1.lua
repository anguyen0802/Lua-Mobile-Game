-- Anhkhoa Nguyen
-- scene1.lua

-- hidden status bar
display.setStatusBar(display.HiddenStatusBar)

local composer = require( "composer" )
local scene = composer.newScene()
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------

local function sliderListener(event)
	spawnInterval = event.value
end

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
	
	-- variables to send to scene 2
	spawnInterval = 50	-- default value is 50
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
		-- Called when the scene is still off screen (but is about to come on screen).
		print("scene1")
		local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
		background:setFillColor(0, 0, 0)
		sceneGroup:insert(background)
		
		-- start button
		local startButton = display.newRect(320, 380, 180, 100)
		startButton:setFillColor(0, 0, 0.7)
		sceneGroup:insert(startButton)
		-- start text
		local startText = display.newText("Start", 320, 380, native.systemFont, 48)
		sceneGroup:insert(startText)
		
		-- function to transition scene
		function tap(event)
			composer.gotoScene(
				"scene2",
				{
					effect = "slideLeft",
					params = {
						spawn = spawnInterval * 80	-- [0,100] => [0,8000]
					}
				}
			)
			return true
		end
		startButton:addEventListener("tap", tap)
		
		-- Anhkhoa
		local nameAnhkhoa = display.newText("Anhkhoa Nguyen", 320, 500, native.systemFont, 32)
		nameAnhkhoa:setFillColor(1,1,1)
		sceneGroup:insert(nameAnhkhoa)
		
		-- Joshua
		local nameJoshua = display.newText("Joshua Zills", 320, 550, native.systemFont, 32)
		nameJoshua:setFillColor(1,1,1)
		sceneGroup:insert(nameJoshua)
		
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene