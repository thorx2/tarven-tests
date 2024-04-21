-- Q1 - Fix or improve the implementation of the below methods


local function releaseStorage(player)
    -- A "nil" check on the player should make it much safer
    if player then
        player:setStorageValue(1000, -1)
    end
end

function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        addEvent(releaseStorage, 1000, player)
        return true
    else -- Return false for whatever reason the original flow would fail
        return false
    end
end
