local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(game.ReplicatedStorage.Packages.promise)
local Signal = require(game.ReplicatedStorage.Packages.signal)
local ClientComm = require(game.ReplicatedStorage.Packages.comm).ClientComm

local remoteFolder = game.ReplicatedStorage:WaitForChild("_remotes")

local Client = {}
Client.__index = Client

Client.Client = nil

function Client.new()
    if Client.Client ~= nil then
        return Client.Client
    else
        local self = setmetatable({}, Client)

        self.Controllers = {}

        Client.Client = self
        return self
    end
end

function Client:GetService(serviceName : string)
    local clientComm = ClientComm.new(remoteFolder, true, serviceName)
    clientComm = clientComm:BuildObject()
    return clientComm
end

function Client:Boot()
    local controllersFolder =  ReplicatedStorage:WaitForChild("Controllers")

    local controllersInitArray = {}
    local controllersInitSignal = Signal.new()

    for i, j in controllersFolder:GetChildren() do
        self.Controllers[j.Name] = require(j)
        self.Controllers[j.Name].Client = self
        self.Controllers[j.Name].Controllers  = self.Controllers[j.Name].Client.Controllers
        table.insert(controllersInitArray, Promise.new(function(resolve, reject)
            print("Initializing controller " .. j.Name)
            self.Controllers[j.Name]:Init(self)
            controllersInitSignal:Once(function()
                print("Starting controller " .. j.Name)
                self.Controllers[j.Name]:Start(self)
            end)
            resolve()
        end))
    end

    local controllersInitPromise = Promise.all(controllersInitArray)

    controllersInitPromise:andThen(function()
        controllersInitSignal:Fire()
    end)

end

return Client