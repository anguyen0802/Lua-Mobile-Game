-- Anhkhoa Nguyen
-- Joshua Zills
-- scene2.lua
-- hidden status bar
display.setStatusBar(display.HiddenStatusBar)
local physics = require("physics");
physics.start();
physics.setGravity(0, 0);
local soundTable = require("soundTable");
local composer = require("composer")
local scene = composer.newScene()
-- physics.setDrawMode("hybrid")
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local Enemy = require("Enemy");
local Boss = require("Boss");
---------------------------------------------------------------------------------
gameIsActive = true
-- "scene:create()"
function scene:create(event)
    local sceneGroup = self.view
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    ---Score

end

-- "scene:show()"
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is still off screen (but is about to come on screen).

        -- scrolling
        -- variables
        local width = display.contentWidth
        local height = display.contentHeight
        local scrollSpeedStars = 3
        local scrollSpeedBack = 1

        -- farback
        -- bg image 1
        local backbg1 = display.newImageRect("farback.png", 1782, 600)
        backbg1.x = width * 0.5
        backbg1.y = height / 2
        backbg1.yScale = display.contentHeight / backbg1.height;
        -- bg image 2
        local backbg2 = display.newImageRect("farback.png", 1782, 600)
        backbg2.x = backbg1.x + 1782
        backbg2.y = height / 2
        backbg2.yScale = display.contentHeight / backbg2.height;

        -- stars
        -- bg image 1
        local starbg1 = display.newImageRect("starfield.png", 640, 1163)
        starbg1.x = width * 0.5
        starbg1.y = height / 2
        -- bg image 2
        local starbg2 = display.newImageRect("starfield.png", 640, 1163)
        starbg2.x = starbg1.x + 800
        starbg2.y = height / 2
        -- bg image 3
        local starbg3 = display.newImageRect("starfield.png", 640, 1163)
        starbg3.x = starbg2.x + 800
        starbg3.y = height / 2

        local function scrolling(event)
            -- move images to the left
            starbg1.x = starbg1.x - scrollSpeedStars
            starbg2.x = starbg2.x - scrollSpeedStars
            starbg3.x = starbg3.x - scrollSpeedStars
            backbg1.x = backbg1.x - scrollSpeedBack
            backbg2.x = backbg2.x - scrollSpeedBack
            -- reset image pos
            if (starbg1.x) < -400 then
                starbg1:translate(1963, 0)
            end
            if (starbg2.x) < -400 then
                starbg2:translate(1963, 0)
            end
            if (starbg3.x) < -400 then
                starbg3:translate(1963, 0)
            end
            if (backbg1.x) < -891 then
                backbg1:translate(3564, 0)
            end
            if (backbg2.x) < -891 then
                backbg2:translate(3564, 0)
            end

        end

        -- event listener for scrolling
        Runtime:addEventListener("enterFrame", scrolling)
        sceneGroup:insert(backbg1)
        sceneGroup:insert(backbg2)
        sceneGroup:insert(starbg1)
        sceneGroup:insert(starbg2)
        sceneGroup:insert(starbg3)

        local controlBar = display.newRect(50, display.contentCenterY, 70, display.contentHeight);
        controlBar:setFillColor(1, 1, 1, 0.5);

        ---- Main Player
        circ = display.newCircle(150, display.contentHeight - 150, 15);
        physics.addBody(circ, "kinematic");
        circ.hp = 5
        circ.tag = "player"
        -- Moves the Main Player
        local function move(event)
            if gameIsActive then
                if event.phase == "began" then
                    circ.markY = circ.y
                elseif event.phase == "moved" then
                    local y = (event.y - event.yStart) + circ.markY

                    if (y <= 20 + circ.height / 2) then
                        circ.y = 20 + circ.height / 2
                    elseif (y >= display.contentHeight - 20 - circ.height / 2) then
                        circ.y = display.contentHeight - 20 - circ.height / 2
                    else
                        circ.y = y
                    end
                end
            end
        end

        controlBar:addEventListener("touch", move);

        -- Inserting into the sceneGroup to ensure it appears above other elements
        sceneGroup:insert(controlBar)
        sceneGroup:insert(circ)

        local scoreText = display.newEmbossedText("Score: 0", 200, 50, native.systemFont, 40);
        local score = 0

        local HPText = display.newEmbossedText("HP: " .. circ.hp, 600, 50, native.systemFont, 40)

        scoreText:setFillColor(0, 0.5, 0);
        HPText:setFillColor(1, 0, 0);

        scoreText.hit = 0;
        sceneGroup:insert(scoreText)
        sceneGroup:insert(HPText)

        function circ:hit()
            self.hp = self.hp - 1 -- Decrease HP by 1

            if (self.hp > 0) then
                -- Handle the Player being hit but not destroyed
                HPText.text = "HP: " .. self.hp -- Update HPText with new HP value
                -- Add any additional effects or actions for a hit here
            else
                -- Handle the Player being destroyed
                HPText.text = "HP: " .. self.hp -- Update HPText with new HP value (usually 0)
                -- Add any additional effects or actions for destruction here
                if circ.hp <= 0 then
                    audio.play(soundTable["explodeSound"]);
                    gameOver()
                end
            end
        end

        -- Projectile 
        local cnt = 0;
        local function fire(event)
            if gameIsActive then
                local p = display.newCircle(circ.x, circ.y - 16, 5);
                p.anchorY = 1;
                p:setFillColor(0, 1, 0);
                physics.addBody(p, "dynamic", {
                    radius = 5
                });
                p:applyForce(2, 0, p.x, p.y);
                cnt = cnt + 1

                audio.play(soundTable["shootSound"]);

                local function removeProjectile(event)
                    if (event.phase == "began" and event.other) then
                        event.target:removeSelf();
                        event.target = nil;
                        cnt = cnt - 1;
                        --print(event.other.tag)
                        -- Check if the projectile hit an enemy
                        if (event.other.tag == "enemy") then
                            event.other.HP = event.other.HP - 1
                            audio.play(soundTable["hitSound"]);
                            event.other:setFillColor(0.5, 0.5, 0.5);
                            if (event.other.HP == 0) then
                                event.other:removeSelf();
                                event.other = nil;
                                score = score + 100
                                scoreText.text = "Score: " .. score
                            end
                        -- Check if the projectile hit the boss
                        elseif (event.other.tag == "boss") then
                             event.other.HP = event.other.HP - 1
                             audio.play(soundTable["hitSound"]);
                             if (event.other.HP == 0) then
                                 event.other:removeSelf();
                                 event.other = nil;
                                 score = score + 10000 -- Adjust the score for hitting the boss
                                 scoreText.text = "Score: " .. score
								 youWin()
                             end
                         end
                    end
                end
                
                
                p:addEventListener("collision", removeProjectile);
            end
        end

        Runtime:addEventListener("tap", fire)

    elseif (phase == "did") then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        local Square = Enemy:new({
            HP = 2,
            fR = 720,
            fT = 700,
            bT = 700,
            sT = 4000 -- straight movement time
        });

        local Triangle = Enemy:new({
            HP = 3,
            fR = 720,
            fT = 700,
            bT = 700,
            tT = 5000 -- towards movement time
        });

        local Boss = Boss:new({
            HP = 30, -- reset to 30
            fR = 720,
            fT = 700,
            bT = 700,
            tT = 5000 -- towards movement time
        });

        local spawnRate = 2000 -- 2 seconds

        function Square:spawn()
            self.shape = display.newRect(self.xPos, self.yPos, 30, 30);
            self.shape.HP = 2
            self.shape.pp = self;
            self.shape.tag = "enemy";
            self.shape:setFillColor(0, 1, 1);
            physics.addBody(self.shape, "dynamic");
        end

        function Triangle:spawn()
            self.shape = display.newPolygon(self.xPos, self.yPos, {0, -15, 15, 15, -15, 15})
            self.shape.HP = 3
            self.shape.pp = self
            self.shape.tag = self.tag
            self.shape:setFillColor(1, 0, 1)
            physics.addBody(self.shape, "dynamic")
        end

        sq = Square:new({
            xPos = 1300,
            yPos = math.random(1, 600) + 20
        });

        tri = Triangle:new({
            xPos = 1300,
            yPos = math.random(1, 600) + 20
        });

        boss = Boss:new({
            xPos = 1300,
            yPos = 320
        });
        local spawnDuration = 120000 -- 2 minutes in milliseconds
        local elapsedTime = 0
        local enemySpawnTimer

        -- function to spawn enemy 1
        function spawnEnemy1()
            sq.yPos = math.random(1, 600) + 20;
            sq:spawn();
            sq:straight();
            sq.tag = "enemy"
        end

        -- function to spawn enemy 2
        function spawnEnemy2()
            tri.yPos = math.random(1, 600) + 20;
            tri:spawn();
            tri.tag = "enemy"
            tri:hunt(circ.x, circ.y) -- move towards the player (circ)
        end

        function spawnBoss()
            boss.yPos = math.random(550, 600) + 20;
            boss:spawn();
            boss:move();
            boss:shoot();
            boss.tag = "boss"
        end

        function whichSpawn()
            local rand = math.random(1, 2)
            if (rand == 1) then -- enemy 1
                spawnEnemy1()
            else -- enemy 2
                spawnEnemy2()
            end
        end

        local function spawnTimerListener()
            elapsedTime = elapsedTime + spawnRate
            if elapsedTime <= spawnDuration then
                -- Spawn enemies as long as the elapsed time is within the specified duration
                if (gameIsActive) then
                    whichSpawn()
                end
            else
                -- Stop spawning after 2 minutes
                timer.cancel(enemySpawnTimer)
                spawnBoss()
            end
        end
        -- Start spawning enemies with the initial spawnRate
        enemySpawnTimer = timer.performWithDelay(spawnRate, spawnTimerListener, 0)

        -- delete enemy
        local function deleteThis(event)
            display.remove(event.target)
            event.target = nil
            return true
        end

        -- enemy 1 movement (square)
        function Square:straight()
            transition.to(self.shape, {
                x = self.shape.x - 2000,
                time = self.sT,
                rotation = self.sR,
                onComplete = deleteThis
            });
        end

        -- enemy 2 movement (triangle)
        function Triangle:hunt(targetX, targetY)
            transition.to(self.shape, {
                time = self.tT,
                x = targetX - 500,
                y = targetY,
                onComplete = deleteThis
            })
        end

        local function onCollision(event)
            if (event.phase == "began") then
                local obj1 = event.object1
                local obj2 = event.object2
                --print("collision detected")
                --print(obj1.tag)
                --print(obj2.tag)
                -- Check if the collision involves the circ and an enemy
                if ((obj1.tag == "player" and obj2.tag == "enemy") or (obj1.tag == "enemy" and obj2.tag == "player")) then
                    circ:hit() -- Call the hit function for the circ
                    audio.play(soundTable["hitSound"]);
                end
                if ((obj1.tag == "boss" and obj2.tag == "player") or (obj1.tag == "player" and obj2.tag == "boss")) then
                    circ:hit()
                    audio.play(soundTable["hitSound"]);
                end
                if ((obj1.tag == "fishBullet" and obj2.tag == "player") or
                    (obj1.tag == "player" and obj2.tag == "fishBullet")) then
                    circ:hit()
                    audio.play(soundTable["hitSound"]);
					if (obj1.tag == "fishBullet") then
						event.object1:removeSelf();
						event.object1 = nil
					else
						event.object2:removeSelf();
						event.object2 = nil
					end
                end
            end
        end

        function gameOver()
            gameIsActive = false
			if (boss.shape) then
				boss.shape:removeSelf()
			end
			
            -- Display "Game Over" message
            local gameOverText = display.newText("Game Over", display.contentCenterX, display.contentCenterY,
                native.systemFont, 50)
            gameOverText:setFillColor(1, 0, 0)
            function tap(event)
                composer.gotoScene("scene1", {
                    effect = "slideRight"
                })
                return true
            end
            Runtime:addEventListener("tap", tap)
            sceneGroup:insert(gameOverText)

        end
        Runtime:addEventListener("collision", onCollision)
		
		function youWin()
			gameIsActive = false
			
			if (boss.shape) then
				boss.shape:removeSelf()
			end
			
			-- Display "You Win" message
			local youWinText = display.newText("You Win!", display.contentCenterX, display.contentCenterY,
                native.systemFont, 50)
			youWinText:setFillColor(0, 1, 0)
			function tap(event)
                composer.gotoScene("scene1", {
                    effect = "slideRight"
                })
                return true
            end
			Runtime:addEventListener("tap", tap)
            sceneGroup:insert(youWinText)
		end

    end
end

-- "scene:hide()"
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif (phase == "did") then
        -- Called immediately after scene goes off screen.
    end
end

-- "scene:destroy()"
function scene:destroy(event)

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

---------------------------------------------------------------------------------

return scene
