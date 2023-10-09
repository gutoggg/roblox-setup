local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Classes = ReplicatedStorage:WaitForChild('Classes')
local Client = require(Classes:WaitForChild("Client")).new()

Client:Boot()
