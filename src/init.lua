-- A flexbox implementation for Roact
-- Docs: TODO

local RoactFlexboxFactory = function(Roact)
    Roact.setGlobalConfig({
        elementTracing = true -- TODO: REMOVE; TESTING!
     })

    local RoactFlexbox = table.clone(require(script.Const).PUBLIC) -- Shallow copy

    RoactFlexbox.Roact = Roact
    RoactFlexbox._FlexItem = require(script.FlexItem)(RoactFlexbox)
    RoactFlexbox._FlexContainer = require(script.FlexContainer)(RoactFlexbox)
    RoactFlexbox.createContainer = require(script.createContainer)(RoactFlexbox)
    RoactFlexbox.createElement = require(script.createElement)(RoactFlexbox)

    return RoactFlexbox
end

return RoactFlexboxFactory
