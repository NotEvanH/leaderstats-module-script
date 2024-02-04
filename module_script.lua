local player_manager = {}

local data_store_service = game:GetService("DataStoreService")
local players_service = game:GetService("Players")
local data_store = data_store_service:GetDataStore("Data_Store")

-- PRIVATE

function setup_leaderstats(stats_to_setup: {}): (Folder)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	
	for i, stat in stats_to_setup do
		local value = Instance.new("IntValue")
		value.Name = stat
		value.Parent = leaderstats
	end
	
	return leaderstats
end

function save_data(player: Player, data: {})
	local success, result = pcall(function()
		data_store:SetAsync(player.UserId, data)
	end)
	
	if not success then
		warn(result)
	end
end

-- PUBLIC

function player_manager.on_player_added(player: Player)
	local data = data_store:GetAsync(player.UserId)
	
	local leaderstats = setup_leaderstats({"Coins", "Gems"})
	leaderstats.Parent = player
	
	local coins: IntValue = leaderstats.Coins
	local gems: IntValue = leaderstats.Gems
	
	if data then
		coins.Value = data["Coins"]
		gems.Value = data["Gems"]
	end
	
	coins:GetPropertyChangedSignal("Value"):Connect(function()
		save_data(player, {["Coins"] = coins.Value, ["Gems"] = gems.Value})
	end)
	
	gems:GetPropertyChangedSignal("Value"):Connect(function()
		save_data(player, {["Coins"] = coins.Value, ["Gems"] = gems.Value})
	end)
end

return player_manager
