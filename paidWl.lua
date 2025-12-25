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





  end 
end 
