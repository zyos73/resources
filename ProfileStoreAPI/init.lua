-- @zyos
-- 2025/11/12
-- Use: API for profileStore

local profileStore = require(script.profileStore)

local config = require(script.config)

local playerStore = profileStore.New(config.store, config.template)
local profiles = setmetatable({}, { __mode = "k" })

local players = game:GetService("Players")

local api = {}

local function StartSessionFor(pl)
	local profile = playerStore:StartSessionAsync(tostring(pl.UserId), {
		Cancel = function()
			return pl.Parent ~= players
		end,
	})

	if not profile then
		return nil
	end

	profile:AddUserId(pl.UserId)
	profile:Reconcile()

	profile.OnSessionEnd:Connect(function()
		profiles[pl] = nil
		if pl.Parent == players then
			pl:Kick("Profile session end - Please rejoin")
		end
	end)

	if pl.Parent == players then
		profiles[pl] = profile
		return profile
	else
		profile:EndSession()
		return nil
	end
end

function api.init()
	for _, pl in pairs(players:GetPlayers()) do
		task.spawn(function()
			StartSessionFor(pl)
		end)
	end

	players.PlayerAdded:Connect(function(pl)
		task.spawn(function()
			StartSessionFor(pl)
		end)
	end)

	players.PlayerRemoving:Connect(function(pl)
		local p = profiles[pl]
		if p then
			p:EndSession()
		end
	end)
end

function api.GetProfile(pl)
	return profiles[pl]
end

function api.GetData(pl)
	local p = profiles[pl]
	return p and p.Data or nil
end

function api.GetOrWaitProfile(pl, timeout)
	local elapsed = 0
	local interval = .05
	while elapsed < (timeout or 7) do
		local p = profiles[pl]
		if p then
			return p
		end
		task.wait(interval)
		elapsed += interval
	end
	return nil, "timeout"
end

function api.Update(pl, fn)
	local p = profiles[pl]
	if not p then
		return false, "profile not loaded"
	end
	local ok, err = pcall(fn, p.Data)
	if not ok then
		return false, err
	end
	return true
end

function api.EndSession(pl)
	local p = profiles[pl]
	if p then
		p:EndSession()
	end
end

api._rawProfiles = profiles

return api