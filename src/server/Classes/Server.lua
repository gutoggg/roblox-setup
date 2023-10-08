local ServerScriptServer = game:GetService("ServerScriptService")
local Promise = require(game.ReplicatedStorage.Packages.promise)
local Signal = require(game.ReplicatedStorage.Packages.signal)

local Server = {}

Server.CurrentServer = nil

function Server.new()
    if Server.CurrentServer ~= nil then
        return Server.CurrentServer
    else
        local self = setmetatable({}, Server)

        self.Services = {}

        Server.CurrentServer = self
        return self
    end
end

function Server:Start()
    local servicesFolder =  ServerScriptServer:WaitForChild("Services")

    local servicesInitArray = {}
    local servicesInitSignal = Signal.new()

    for i, j in servicesFolder:GetChildren() do
        self.Services[j.Name] = require(j)
        table.insert(servicesInitArray, Promise.new(function(resolve, reject)
            print("Initializing service " .. j.Name)
            self.Services[j.Name]:Init()
            servicesInitSignal:Once(function()
                print("Starting service " .. j.Name)
                self.Services[j.Name]:Start()
            end)
            resolve()
        end))
    end

    local servicesInitPromise = Promise.all(servicesInitArray)

    servicesInitPromise:andThen(function()
        servicesInitSignal:Fire()
    end)

end

function Server:GetService(serviceName : string)
    return self.Services[serviceName]
end

return Server