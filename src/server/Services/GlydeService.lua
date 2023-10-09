local GlydeService = {}
GlydeService.RemoteEvents = {}

function GlydeService:Init()
    self.Comm:BindFunction("testFunction", print)

    self.RemoteEvents.TestSignal = self.Comm:CreateSignal("TestSignal")

end

function GlydeService:Start()
    game.Players.PlayerAdded:Connect(function(player)
        task.wait(5)
        self.RemoteEvents.TestSignal:FireAll(player.Name)
    end)
end

function GlydeService:Test()

end

return GlydeService