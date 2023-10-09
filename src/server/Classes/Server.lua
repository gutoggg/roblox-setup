local ServerScriptServer = game:GetService("ServerScriptService")
local Promise = require(game.ReplicatedStorage.Packages.promise)
local Signal = require(game.ReplicatedStorage.Packages.signal)
local ServerComm = require(game.ReplicatedStorage.Packages.comm).ServerComm

local remoteFolder = Instance.new("Folder", game.ReplicatedStorage)
remoteFolder.Name = "_remotes"

local Server = {}
Server.__index = Server

Server.Server = nil

function Server.new()
    if Server.Server ~= nil then
        return Server.Server
    else
        local self = setmetatable({}, Server)

        self.Services = {}

        Server.Server = self
        return self
    end
end

function Server:Boot()
    local servicesFolder =  ServerScriptServer:WaitForChild("Services")

    local servicesInitArray = {}
    local servicesInitSignal = Signal.new()

    for i, j in servicesFolder:GetChildren() do
        self.Services[j.Name] = require(j)
        self.Services[j.Name].Server = self
        self.Services[j.Name].Comm =  ServerComm.new(remoteFolder, j.Name)
        self.Services[j.Name].Services  = self.Services
        table.insert(servicesInitArray, Promise.new(function(resolve, reject)
            print("Initializing service " .. j.Name)
            self.Services[j.Name]:Init(self)
            servicesInitSignal:Once(function()
                print("Starting service " .. j.Name)
                self.Services[j.Name]:Start(self)
            end)
            resolve()
        end))
    end

    local servicesInitPromise = Promise.all(servicesInitArray)

    servicesInitPromise:andThen(function()
        servicesInitSignal:Fire()
    end)

end


return Server