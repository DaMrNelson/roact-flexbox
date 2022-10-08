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

        -- Enforce special FlexDisabled default = false for FlexItems.
        -- That way when we encounter a real instance with this unset we can assume that we shouldn't adjust it.
        elm:SetAttribute(self._applyNamespace("FlexDisabled"), false) -- Will be overwritten below if set

        -- Expand shorthand properties
        -- Explicitly defined props always overwrite shorthand props
        for key, mappedProps in pairs(Const.PRIVATE.FLEX_PROPS_SHORTHAND) do
            local vals = self.props[key]

            if vals ~= nil then
                -- Hardcoded exception: Gap can be UDim2
                if key == "Gap" and typeof(vals) == "UDim2" then
                    vals = { vals.X, vals.Y }
                end

                -- All other props work the same (Gap uses this too)
                for i = 1, math.min(#vals, #mappedProps) do
                    elm:SetAttribute(self._applyNamespace(mappedProps[i]), vals[i])
                end
            end
        end

        -- Apply other props overtop of shorthand properties
        for key, val in pairs(self.props) do
            -- Prop must be in (FLEX_ITEM_PROPS or FLEX_CONTAINER_PROPS) and NOT in FLEX_PROPS_NOATTRIBUTE
            if (table.find(Const.PRIVATE.FLEX_ITEM_PROPS, key) == nil and table.find(Const.PRIVATE.FLEX_CONTAINER_PROPS, key) == nil) or table.find(Const.PRIVATE.FLEX_PROPS_NOATTRIBUTE, key) ~= nil then
                continue
            end

            -- Cannot save shorthand props (so they were derived first)
            if Const.PRIVATE.FLEX_PROPS_SHORTHAND[key] ~= nil then
                continue
            end

            -- Prop is safe to add
            elm:SetAttribute(self._applyNamespace(key), val)
        end

        -- Derived attributes
        elm:SetAttribute(self._applyNamespace("PropSize"), self.props.Size) -- Original component size (used for basis = "auto")
    end

    -- Gets the given attribute, or returns the default from Const.PRIVATE.DEFAULTS if unset/nil.
    function FlexItem._getAttribute(item, prop)
        local val = item:GetAttribute(FlexItem._applyNamespace(prop))

        if val == nil then
            return Const.PRIVATE.DEFAULTS[prop]
        else
            return val
        end
    end

    -- Applies our namespace to the given attribute name
    function FlexItem._applyNamespace(name)
        if Const.PUBLIC.USE_ATTRIBUTE_NAMESPACE then
            return Const.PUBLIC.ATTRIBUTE_NAMESPACE .. "_" .. name
        else
            return name
        end
    end

    return FlexItem
end
