local Const = require(script.Parent.Const)

return function(RoactFlexbox)
    local Roact = RoactFlexbox.Roact
    local FlexItem = Roact.Component:extend("FlexItem")

    function FlexItem:init()
        self.ref = Roact.createRef()
    end

    function FlexItem:render()
        local renderedProps = table.clone(self.props) -- Shallow copy

        -- Remove FlexItem properties
        for _, propName in ipairs(Const.PRIVATE.FLEX_ITEM_PROPS) do
            renderedProps[propName] = nil
        end

        -- Render
        if self.props._FlexboxItemIsContainer then
            -- Wrap our FlexContainer
            -- See also: https://reactjs.org/docs/composition-vs-inheritance.html
            renderedProps._FlexboxComponentName = self.props._FlexboxComponentName
            renderedProps._FlexboxForwardRef = self.ref

            return Roact.createElement(
                RoactFlexbox._FlexContainer,
                renderedProps
            )
        else
            renderedProps[Roact.Ref] = self.ref -- TODO: This overrides the user's ref doesn't it? Can we do both??
            return Roact.createElement(
                self.props._FlexboxComponentName,
                renderedProps
            )
        end
    end

    function FlexItem:didMount()
        self:applyAttributes()
    end

    function FlexItem:didUpdate()
        self:applyAttributes()
    end

    function FlexItem:applyAttributes()
        local elm = self.ref:getValue()

        for key, val in pairs(self.props) do
            -- Prop must be in (FLEX_ITEM_PROPS or FLEX_CONTAINER_PROPS) and NOT in FLEX_PROPS_NOATTRIBUTE
            if (table.find(Const.PRIVATE.FLEX_ITEM_PROPS, key) == nil and table.find(Const.PRIVATE.FLEX_CONTAINER_PROPS, key) == nil) or table.find(Const.PRIVATE.FLEX_PROPS_NOATTRIBUTE, key) ~= nil then
                continue
            end

            elm:SetAttribute(key, val)
        end

        elm:SetAttribute("PropSize", self.props.Size)
    end

    -- Gets the given attribute, or returns the default from Const.PRIVATE.DEFAULTS if unset/nil.
    function FlexItem._getAttribute(item, prop)
        local val = item:GetAttribute(prop)

        if val == nil then
            return Const.PRIVATE.DEFAULTS[prop]
        else
            return val
        end
    end

    return FlexItem
end
