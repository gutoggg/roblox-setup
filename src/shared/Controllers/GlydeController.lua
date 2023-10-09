local GlydeController = {}

function GlydeController:Init(client)
   local GlydeService = self.Client:GetService("GlydeService")

    GlydeService.TestSignal:Connect(function(playerName)
        print(playerName)
    end)

end

function GlydeController:Start(client)

end

function GlydeController:Test()

end

return GlydeController