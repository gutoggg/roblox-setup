local ServerScriptService = game:GetService("ServerScriptService")
local Classes = ServerScriptService:WaitForChild('Classes')
local Server = require(Classes:WaitForChild("Server")).new()

Server:Start()

task.wait(5)

print(Server)
print(getmetatable(Server))