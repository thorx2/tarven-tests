-- Q2 - Fix or improve the implementation of the below method
function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members

    -- NGL I googled "what could break with LUA SQL qurries" and got to a page which mentioned SQL injection
    -- and what they are, literal copy paste of the what to do from where, I honestly have 0 idea about SQL
    -- or any DB for that matter.
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < " .. db.escapeString(memberCount) .. ";"
    local resultId = db.storeQuery(selectGuildQuery)

    -- Your box standard nil check
    if resultId then
        -- Apprantely we loop through all SQL results?
        -- again pure copy paste have a hard time wrapping my head around SQL
        repeat
            local row = resultId:getRow()
            if row then
                local guildName = row["name"]
                print(guildName)
            end
        until not resultId:next()
    end

    -- Clean up? ()
    resultId:free();
end
