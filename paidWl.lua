local whitelistedUsers = {
    "Moha194xxx", 
}

local function isWhitelisted(username)
    for _, whitelisted in ipairs(whitelistedUsers) do
        if username == whitelisted then
            return true
        end
    end
    return false
end


if game.Players.LocalPlayer then
    local player = game.Players.LocalPlayer
    local username = player.Name

    if not isWhitelisted(username) then
        player:Kick("NOT  WhiteListed || BUY PAID - JUST 230 ROBUX  ")
    else

loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/99216c7b6975950291de00accd6ee51d"))()



  end 
end 
