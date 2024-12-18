local Enemy = require("Enemy");
local soundTable=require("soundTable");

local Boss = {tag="boss", HP=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT=500};

local Boss = Enemy:new({
    HP = 30,
    fR = 720,
	fT = 700,
	bT = 700,
	tT = 5000 -- towards movement time
});

-- Animation Sequence Data
local seqData =
{
	{
		name = "noseF",	-- nose anim forwards
		frames = {2, 3, 4},
		time = 500,
		loopCount = 1
	},
	{
		name = "noseB",	-- nose anim backwards
		frames = {4, 3, 2},
		time = 500,
		loopCount = 1
	},
	{
		name = "mouthF", -- mouth anim forwards
		frames = {5, 6, 7},
		time = 500,
		loopCount = 1
	},
	{
		name = "mouthB", -- mouth anim backwards
		frames = {7, 6, 5},
		time = 500,
		loopCount = 1
	},
	{
		name = "botFinF", -- bottom fin anim forwards
		frames = {8, 9, 10},
		time = 500,
		loopCount = 1
	},
	{
		name = "botFinB", -- bottom fin anim backwards
		frames = {10, 9, 8},
		time = 500,
		loopCount = 1
	},
	{
		name = "tailF", -- tail anim forwards
		frames = {11, 12, 13},
		time = 500,
		loopCount = 1
	},
	{
		name = "tailB", -- tail anim backwards
		frames = {13, 12, 11},
		time = 500,
		loopCount = 1
	}
}

-- loading audio files
local noseSound = audio.loadSound("sounds/nose.wav")
local mouthSound = audio.loadSound("sounds/mouth.wav")
local botFinSound = audio.loadSound("sounds/botFin.wav")
local tailSound = audio.loadSound("sounds/tail.wav")
local bodySound = audio.loadSound("sounds/body.wav")
local topFinSound = audio.loadSound("sounds/topFin.wav")

-- nose animation event
function moveNose(event)
	--print("nose touched")
	if (event.target.forOrBack % 2 == 0) then	-- anim forwards
		event.target:setSequence("noseF")
		event.target:play()
	end
	if (event.target.forOrBack % 2 == 1) then	-- anim backwards
		event.target:setSequence("noseB")
		event.target:play()
	end
	
	-- play sound
	audio.play(noseSound)
	
	-- toggle
	event.target.forOrBack = event.target.forOrBack + 1
end

-- mouth animation event
function moveMouth(event)
	--print("mouth touched")
	if (event.target.forOrBack % 2 == 0) then	-- anim forwards
		event.target:setSequence("mouthF")
		event.target:play();
	end
	if (event.target.forOrBack % 2 == 1) then	-- anim backwards
		event.target:setSequence("mouthB")
		event.target:play();
	end
	
	-- play sound
	audio.play(mouthSound)
	
	-- toggle
	event.target.forOrBack = event.target.forOrBack + 1
end

-- fin animation event
function moveBotFin(event)
	--print("fin touched")
	if (event.target.forOrBack % 2 == 0) then	-- anim forwards
		event.target:setSequence("botFinF")
		event.target:play();
	end
	if (event.target.forOrBack % 2 == 1) then	-- anim backwards
		event.target:setSequence("botFinB")
		event.target:play();
	end
	
	-- play sound
	audio.play(botFinSound)
	
	-- toggle
	event.target.forOrBack = event.target.forOrBack + 1
end

-- tail animation event
function moveTail(event)
	--print("tail touched")
	if (event.target.forOrBack % 2 == 0) then	-- anim forwards
		event.target:setSequence("tailF")
		event.target:play()
	end
	if (event.target.forOrBack % 2 == 1) then	-- anim backwards
		event.target:setSequence("tailB")
		event.target:play()
	end
	
	-- play sound
	audio.play(tailSound)
	
	-- toggle
	event.target.forOrBack = event.target.forOrBack + 1
end

-- body play sound
-- no animation for body
function playBodySound(event)
	--print("body touched")
	-- play sound
	audio.play(bodySound)
end

-- top fin play sound
-- no animation for top fin
function playTopFinSound(event)
	--print("top fin touched")
	-- play sound
	audio.play(topFinSound)
end

-- sprite sheet data
		local opt =
		{
			frames = {
				{ x = 22, y = 8, width = 167, height = 50}, -- 1. main body
				{ x = 207, y = 27, width = 16, height = 9}, -- 2. nose 1
				{ x = 228, y = 27, width = 16, height = 9}, -- 3. nose 2
				{ x = 249, y = 27, width = 16, height = 9}, -- 4. nose 3
				{ x = 281, y = 20, width = 56, height = 26}, -- 5. mouth 1
				{ x = 344, y = 20, width = 56, height = 26}, -- 6. mouth 2
				{ x = 407, y = 20, width = 56, height = 26}, -- 7. mouth 3
				{ x = 22, y = 93, width = 52, height = 37}, -- 8. bottom fin 1
				{ x = 80, y = 99, width = 53, height = 31}, -- 9. bottom fin 2
				{ x = 140, y = 102, width = 54, height = 28}, -- 10. bottom fin 3
				{ x = 210, y = 70, width = 48, height = 92}, -- 11. tail 1
				{ x = 267, y = 70, width = 55, height = 92}, -- 12. tail 2
				{ x = 331, y = 70, width = 60, height = 92}, -- 13. tail 3
				{ x = 405, y = 93, width = 60, height = 46} -- 14. top fin
			}
		}
		local sheet = graphics.newImageSheet( "KingBayonet.png", opt);
		
local fishGroup = display.newGroup()

function Boss:spawn()
	 local noseAnim = display.newSprite(sheet, seqData)
			noseAnim.x = 0
			noseAnim.y = 65
			noseAnim.anchorX = 0
			noseAnim.anchorX = 0
			noseAnim.forOrBack = 0 -- tracks if we need to play anim forwards or backwards, will use this % 2, even is for, odd is back
			noseAnim:setSequence("noseF")
			noseAnim.tag = "boss"
			noseAnim:addEventListener("tap", moveNose)
			--noseAnim:play();

			local mouthAnim = display.newSprite(sheet, seqData)
			mouthAnim.x = 31.3
			mouthAnim.y = 68
			mouthAnim.anchorX = 0
			mouthAnim.anchorX = 0
			mouthAnim.forOrBack = 0 -- tracks if we need to play anim forwards or backwards, will use this % 2, even is for, odd is back
			mouthAnim:setSequence("mouthF")
			mouthAnim.tag = "boss"
			mouthAnim:addEventListener("tap", moveMouth)
			--mouthAnim:play();

			local botFinAnim = display.newSprite(sheet, seqData)
			botFinAnim.x = 100
			botFinAnim.y = 71
			botFinAnim.anchorX = 0
			botFinAnim.anchorY = 0
			botFinAnim.forOrBack = 0 -- tracks if we need to play anim forwards or backwards, will use this % 2, even is for, odd is back
			botFinAnim:setSequence("botFinF")
			botFinAnim.tag = "boss"
			botFinAnim:addEventListener("tap", moveBotFin)
			--botFinAnim:play();

			local tailAnim = display.newSprite(sheet, seqData)
			tailAnim.x = 174
			tailAnim.y = 58
			tailAnim.anchorX = 0
			tailAnim.anchorX = 0
			tailAnim.forOrBack = 0 -- tracks if we need to play anim forwards or backwards, will use this % 2, even is for, odd is back
			tailAnim:setSequence("tailF")
			tailAnim.tag = "boss"
			tailAnim:addEventListener("tap", moveTail)
			--tailAnim:play();

			local fishBody = display.newImage(sheet, 1)
			fishBody.x = 15
			fishBody.y = 36
			fishBody.anchorX = 0
			fishBody.anchorY = 0
			fishBody.tag = "boss"
			fishBody:addEventListener("tap", playBodySound)

			local topFin = display.newImage(sheet, 14)
			topFin.x = 82
			topFin.y = 0
			topFin.anchorX = 0
			topFin.anchorY = 0
			topFin.tag = "boss"
			topFin:addEventListener("tap", playTopFinSound)

			-- insert parts into one group
			fishGroup:insert(noseAnim)
			fishGroup:insert(mouthAnim)
			fishGroup:insert(botFinAnim)
			fishGroup:insert(tailAnim)
			fishGroup:insert(fishBody)
			fishGroup:insert(topFin)
			
			self.shape = fishGroup
			self.shape.anchorX = 0.5
			self.shape.anchorY = 0.5
			self.shape.HP = 30
			self.shape.pp = self;  -- parent object
			self.shape.tag = "boss"
			self.shape.rotation = 0
			local bossBox = {0, 0,
							 0, 105,
							 224, 0,
							 224, 105}
			physics.addBody(self.shape, "dynamic", {shape = bossBox})
			print("Boss Spawned")
			fishGroup.isFixedRotation = true
			
			self.shape.y = 300
			self.shape.x = 600

end

-- move to random pos on screen
function Boss:move()
    transition.to(self.shape, {
        time = 2000,
        x = math.random(0, 1163),
        y = math.random(0, 640),
        onComplete = function()
            self:move()  -- Call the move function again after completion
        end
    })
end


function Boss:hit () 
	self.HP = self.HP - 1;
	if (self.HP > 0) then 
		audio.play( soundTable["hitSound"] );
		self.shape:setFillColor(0.5,0.5,0.5);
	
	else 
		audio.play( soundTable["explodeSound"] );
		
    transition.cancel( self.shape );
		
		if (self.timerRef ~= nil) then
			timer.cancel ( self.timerRef );
		end

		-- die
		self.shape:removeSelf();
		self.shape=nil;	
		--self = nil;  
	end		
end

function Boss:shoot (interval)
  local interval = interval or 1500;
  local function createShot(obj)
  
    local pp = display.newRect (self.shape.x, self.shape.y+50, 
                               10,10);
    pp:setFillColor(1,0,0);
    pp.anchorY=0;
    physics.addBody (pp, "dynamic");
    pp:applyForce(-1, 0, pp.x, pp.y);
	pp.tag = "fishBullet"
	print("shot")
		
    --local function shotHandler (event)
    --  if (event.phase == "began") then
	--	local obj1 = event.target
    --    local obj2 = event.other
	--	print("coll detected")
	--	print(obj1)
	--	print(obj2)
	--	if (event.other.tag == "player") then
	--		event.target:removeSelf();
	--		event.target = nil;
	--		circ:hit()
	--	end
    --  end
    --end
    --p:addEventListener("collision", shotHandler);
  end
	self.timerRef = timer.performWithDelay(interval, 
		function (event) createShot(self) end, -1);
end

return Boss