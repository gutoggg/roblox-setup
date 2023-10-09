local ServerScriptService = game:GetService("ServerScriptService")
local Classes = ServerScriptService:WaitForChild('Classes')
local Server = require(Classes:WaitForChild("Server")).new()

Server:Boot()
