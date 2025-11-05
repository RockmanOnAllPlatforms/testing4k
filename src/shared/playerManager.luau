local playerObj = {}
playerObj.__index = playerObj

function playerObj.new(username, id)
    local newPlayerObj = {}
    newPlayerObj.username = username
    newPlayerObj.id = id
    setmetatable(newPlayerObj, playerObj)
    return newPlayerObj
end


return playerObj