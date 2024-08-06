local OmegaSpamtonBossfight, super = Class(Encounter)

function OmegaSpamtonBossfight:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Omega Spamton emerges!"
	self.progress = 0

    -- Battle music ("battle" is rude buster)
    self.music = "almighty"
    -- Enables the purple grid battle background
	if Mod:isInRematchMode() then
    	self.background = true
	else
		self.background = false
	end

    -- Add the dummy enemy to the encounter
    self:addEnemy("omega_spamton", 800, 600)

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
	
	self.flee = false

    self.boss_rush = false
	
    if Game:getFlag("omegaspamton_defeated") == true then
        self.boss_rush = true
    end
end

function OmegaSpamtonBossfight:onBattleInit()
    super.onBattleInit(self)
    if self.boss_rush == true then
        Game.battle.dojo_bg = DojoBG({1, 1, 1})
        Game.battle:addChild(Game.battle.dojo_bg)
    end
end

function OmegaSpamtonBossfight:onBattleStart()

	Game.battle:startCutscene("omegaspamton_intro", "omegaspamton_intro")
	
	--if not Game.battle:getState() == "INTRO" then
	--	exit
	--end
	--return true
end

function OmegaSpamtonBossfight:beforeStateChange(old, new)

	local override = false
	
	if not old == "CUTSCENE" then
	
	if Game.battle.enemies[1].health <= 0 then
		Game.battle.music:fade(0, 1)
		--Game.battle:setState("CUTSCENE")
		Game.battle:startCutscene("omegaspamton_intro", "omegaspamton_outro")
		override = true
	end
		
	if Game.battle.enemies[1].mercy >= 100 then
		Game.battle.music:fade(0, 1)
		--Game.battle:setState("CUTSCENE")
		Game.battle:startCutscene("omegaspamton_intro", "omegaspamton_outro_alt")
		override = true
	end
	
	end

	if new == "ENEMYDIALOGUE" then
		local cutscene = Game.battle:startCutscene("omegaspamton_fight.talk")
		cutscene:after(function()
            Game.battle:setState("DIALOGUEEND")
		end)
	end
	if new == "ACTIONS" and self.progress >= 200 then
		local spamton = Game.battle.enemies[1]
		if spamton ~= nil then
			spamton.lowestHP = math.min(spamton.health, spamton.lowestHP)
			if spamton.lastHealed ~= Game.battle.turn_count then
				spamton:heal(spamton.max_health)
				spamton.lastHealed = Game.battle.turn_count
			end
		end
	end
	return override
end

function OmegaSpamtonBossfight:skip()
	local spamton = Game.battle.enemies[1]
	spamton.defense = spamton.defense - 30
	spamton.attack = spamton.attack - 15
end

return OmegaSpamtonBossfight
