-- Function on panel open
actualMinibuttonPanel = nil
moveBtnElement = nil
moveStep = 5
stepDelay = 25
isOpen = false

function init()
    g_ui.importStyle('movingButtonWindow')
    
    -- Subscribe to game over callbacks I guess
    connect(g_game, { onGameEnd = offline })

    movingPanelButton = modules.client_topmenu.addLeftGameButton('actualMinibuttonPanel', 'Moving button Panel',
        '/images/topbuttons/healthinfo', toggle)
end

-- Function to reset button position to bottom right
function resetButtonPosition()
    -- Reset button position to right and at a random height
    moveBtnElement:setMarginRight(10)
    moveBtnElement:setMarginBottom(randomBetween(moveBtnElement:getHeight(),
        actualMinibuttonPanel:getHeight() - moveBtnElement:getHeight()))
end

-- callback on panel button hit
function toggle()
    if isOpen then
        if actualMinibuttonPanel then
            actualMinibuttonPanel:destroy()
            actualMinibuttonPanel = nil
        end
        isOpen = false
    else
        isOpen = true
        actualMinibuttonPanel = g_ui.createWidget('MovingButtonWindow', rootWidget) -- g_ui.loadUI('movingbutton', modules.game_interface.getRightPanel())
        moveBtnElement = actualMinibuttonPanel:recursiveGetChildById('okButton')
        if moveBtnElement then
            moveBtnElement.onClick = resetButtonPosition
            resetButtonPosition()
            moveButton()
        end
    end
end

-- Function on panel close
function terminate()
    -- Disconnect from game over callbacks
    disconnect(g_game, { onGameEnd = offline })

    -- Close the panel if it's open
    if actualMinibuttonPanel then
        actualMinibuttonPanel:destroy()
        actualMinibuttonPanel = nil
    end
end

function onMiniWindowClose()
    movingPanelButton:setOn(false)
end

-- Function called when the game ends
function offline()
    -- Cleanup resources when the game ends
    terminate()
end

-- Custom googled random between function for sanity sake
function randomBetween(min, max)
    return min + math.random() * (max - min)
end

-- Function to continuously move the okButton
function moveButton()
    if actualMinibuttonPanel then
        if moveBtnElement then
            local currentMarginRight = moveBtnElement:getMarginRight()

            if currentMarginRight < actualMinibuttonPanel:getWidth() - (moveBtnElement:getWidth() * 2) then
                moveBtnElement:setMarginRight(currentMarginRight + moveStep)
            else
                moveBtnElement:setMarginBottom(randomBetween(moveBtnElement:getHeight(),
                    actualMinibuttonPanel:getHeight() - (moveBtnElement:getHeight() * 4)))
                moveBtnElement:setMarginRight(10)
            end
        end
        -- Schedule the next move
        scheduleEvent(moveButton, stepDelay)
    end
end
