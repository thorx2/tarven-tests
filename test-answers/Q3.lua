-- Q3 - Fix or improve the name and the implementation of the below method

function do_sth_with_PlayerParty(playerId, membername)
    player = Player(playerId)
    local party = player:getParty()

    for k, v in pairs(party:getMembers()) do
        if v == Player(membername) then
            party:removeMember(Player(membername))
            -- Exit flow once the conditional action has been satisfied within the loop
            -- seems this loops on unique player rather hence the argument to loop out quick
            break
        end
    end
end
