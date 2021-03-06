-- include useful files
execScript("utils.lua")
execScript("common.lua")
execScript("commonpatterns.lua")
execScript("nextpatterns.lua")

-- this function adds a pattern to the timeline based on a key
function addPattern(mKey)
		if mKey == 0 then pRCBarrage()
	elseif mKey == 1 then pRCBarrageDouble()
	elseif mKey == 2 then pRCBarrageSpin()
	end
end

-- shuffle the keys, and then call them to add all the patterns
-- shuffling is better than randomizing - it guarantees all the patterns will be called
keys = { 0, 0, 1, 1, 2 }
keys = shuffle(keys)
index = 0
lowerBound = 4
upperBound = 6

-- onLoad is an hardcoded function that is called when the level is started/restarted
function onLoad()
	messageImportantAdd("Sides ("..lowerBound.." / "..upperBound..")", 170)
end

-- onStep is an hardcoded function that is called when the level timeline is empty
-- onStep should contain your pattern spawning logic
function onStep()	
	setLevelValueInt("sides", math.random(lowerBound, upperBound))
	addPattern(keys[index])
	index = index + 1
	
	if index - 1 == table.getn(keys) then
		index = 1
	end
end

-- onIncrement is an hardcoded function that is called when the level difficulty is incremented
function onIncrement()
	lowerBound = math.random(4, 6)
	upperBound = lowerBound + math.random(1, 3)
	messageImportantAdd("Sides ("..lowerBound.." / "..upperBound..")", 170)
end

-- onUnload is an hardcoded function that is called when the level is closed/restarted
function onUnload()
end

-- continuous direction change (even if not on level increment)
dirChangeTime = 400
hueIMin = 0.0
hueIMax = 22.0
hueIStep = 0.0065

-- onUpdate is an hardcoded function that is called every frame
function onUpdate(mFrameTime)
	dirChangeTime = dirChangeTime - mFrameTime;
	if dirChangeTime < 0 then
		-- do not change direction while fast spinning
		if isFastSpinning() == false then
			setLevelValueFloat("rotation_speed", getLevelValueFloat("rotation_speed") * -1)
			dirChangeTime = 400
		end
	end 

	setStyleValueFloat("hue_increment", getStyleValueFloat("hue_increment") + hueIStep)
	if(getStyleValueFloat("hue_increment") > hueIMax) then hueIStep = hueIStep * -1 end
	if(getStyleValueFloat("hue_increment") < hueIMin) then hueIStep = hueIStep * -1 end
end