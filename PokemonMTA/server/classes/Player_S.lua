Player_S = inherit(Class)

function Player_S:constructor(id, player)
	self.id = id
	self.player = player
	
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	
	self.skinID = 258
	
	self.companion = nil
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_S " .. self.id .. " was started.")
	end
end


function Player_S:init()
	self.m_ToggleCompanion = bind(self.toggleCompanion, self)
	
	addEvent("DOTOGGLECOMPANION", true)
	addEventHandler("DOTOGGLECOMPANION", root, self.m_ToggleCompanion)
	
	self:initSpawn()
	self:performSpawn()
end


function Player_S:initSpawn()
	local playerSpawns = getElementsByType("PLAYERSPAWN")
		
	if (playerSpawns) then
		if (#playerSpawns > 0) then
			local randomSpawn = playerSpawns[math.random(1, #playerSpawns)]
		
			if (randomSpawn) then
				
				local pos = randomSpawn.position
				local rot = randomSpawn.rotation
				
				self.x = pos.x
				self.y = pos.y
				self.z = pos.z
				self.rx = rot.x
				self.ry = rot.y
				self.rz = rot.z
			end
		end
	end
end


function Player_S:performSpawn()
	if (self.player) then
		self.player:spawn(self.x, self.y, self.z, self.rz, self.skinID)
		fadeCamera(self.player, true, 1.0)
	end
end


function Player_S:update()
	if (self.player and isElement(self.player)) then
		self:updateCoords()
	end
end


function Player_S:updateCoords()
	local pos = self.player:getPosition()

	self.x = pos.x
	self.y = pos.y
	self.z = pos.z
	
	local rot = self.player:getRotation()

	self.rx = rot.x
	self.ry = rot.y
	self.rz = rot.z
end


function Player_S:toggleCompanion()
	if (self.player) and (isElement(client)) then
		if (client == self.player) then
			if (not self.companion) then
				self:sendCompanion()
			else
				self:callCompanion()
			end
		end
	end
end


function Player_S:sendCompanion()
if (not self.companion) and (Pokedex) then
		--PokemonManager_S:getSingleton():addPokemon(1)
		--self.companion = 1
		
		mainOutput("SERVER || Companion send out!")
	end
end


function Player_S:callCompanion()
	if (self.companion) then
		
		--PokemonManager_S:getSingleton():deletePokemon(self.companion)
		self.companion = nil
		
		mainOutput("SERVER || Companion called!")
	end
end


function Player_S:clear()
	removeEventHandler("DOTOGGLECOMPANION", root, self.m_ToggleCompanion)
	
	if (self.companion) then
		PokemonManager_S:getSingleton():deletePokemon(self.companion)
		self.companion = nil
	end
end


function Player_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_S " .. self.id .. " was deleted.")
	end
end
