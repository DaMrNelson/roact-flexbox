local Const = require(script.Parent.Const)
local PROPERTIES = Const.PUBLIC.PROPERTIES

return function(RoactFlexbox)
    local Roact = RoactFlexbox.Roact
    local FlexItem = RoactFlexbox._FlexItem
    local FlexContainer = Roact.Component:extend("FlexContainer")

    function FlexContainer:init()
        self.ref = self.props._FlexboxForwardRef
    end

    function FlexContainer:render()
        local renderedProps = table.clone(self.props) -- Shallow copy

        -- Remove FlexContainer properties
        for _, propName in ipairs(Const.PRIVATE.FLEX_CONTAINER_PROPS) do
            renderedProps[propName] = nil
        end

        -- Size change listener
        renderedProps[Roact.Change.AbsoluteSize] = function(...)
            self:containerUpdate()

            -- Re-invoke existing change listener
            for propName, prop in pairs(self.props) do
                -- Hacky, but imo its more reliable than trying to blindly compare `.name` or importing private components of Roact
                if tostring(propName) == "RoactHostChangeEvent(AbsoluteSize)" then
                    prop(...)
                end
            end
        end

        -- TODO: Does this update when children are added??
        -- TODO: Don't forget to nest an update that calls the original event listeners on any ones we overwrite!!

        -- Forward ref
        renderedProps[Roact.Ref] = self.ref

        -- Render our component! (We should already be wrapped by FlexItem)
        return Roact.createElement(
            self.props._FlexboxComponentName,
            renderedProps
        )
    end

    -- TODO: Think through when I ACTUALLY need to do trigger flex updates
    -- Right now I'm kind of just throwing updates everywhere until I get the core functionality down.
    -- Ie will children update themselves? Is there a cleaner way to make them update?

    function FlexContainer:didMount()
        self:containerUpdate()
    end

    function FlexContainer:didUpdate()
        self:containerUpdate()
    end

    function FlexContainer:_flexDisplay(containerProps, containerSize, items, primaryAxisOnly)
        --[[ -- THIS REQUIRES:
            containerProps: TODO: just search manually
            items[i]: TODO: just search manually
        ]]

        -- TODO: Prop doc, especially items
        -- items = {{...item properties}, ...}
        -- primaryAxisOnly=false (bool): If true, this only calculates the primary axis (FlexDirection) and doesn't change the secondary axis.
        --                               This exists because this function actually uses itself to calculate the alternate/non-major/secondary axis.
        -- RETURNS
        -- state: { [index varies after sorting] = { Instance = [items[].Instance], Position = Vector2(X, Y), Size = Vector2(X, Y) }, ... }
        -- TODO: Props as dict or something probably

        local states = {}

        -- Sort items by Order
        table.sort(items, function(item1, item2) return item1.Properties.Order < item2.Properties.Order end)

        -- Get axis
        local flexDirection = containerProps.FlexDirection
        local majorIsX = flexDirection == PROPERTIES.ROW or flexDirection == PROPERTIES.ROW_REVERSE
        local gapX = self:_scaleToPx(containerSize.X, containerProps.ColumnGap) -- Is always the gap between rows
        local gapY = self:_scaleToPx(containerSize.Y, containerProps.RowGap) -- Is always the gap between columns
        local majorSize, minorSize
        local gapMajor, gapMinor

        if majorIsX then
            majorSize = containerSize.X
            minorSize = containerSize.Y
            gapMajor = gapX
            gapMinor = gapY
        else
            majorSize = containerSize.Y
            minorSize = containerSize.X
            gapMajor = gapY
            gapMinor = gapX
        end

        -- Begin building line(s)
        local canWrap = table.find({ PROPERTIES.WRAP, PROPERTIES.WRAP_REVERSE }, containerProps.FlexWrap)
        local lines = {}
        local currentLine = {}
        local currentSize = 0

        for _, item in ipairs(items) do
            -- Calculate this item's basis in pixels
            local basis = item.Properties.FlexBasis

            if basis == PROPERTIES.AUTO then
                if majorIsX then
                    basis = item.Properties.PropSize.X
                else
                    basis = item.Properties.PropSize.Y
                end
            end

            local basisPx = self:_scaleToPx(majorSize, basis)
            local state = {
                SizeMajor = basisPx,
                Instance = item.Instance,
                Properties = item.Properties,
            }
            table.insert(states, state)
            currentSize += basisPx

            -- Check if we should wrap to a new line
            -- Wrapping must be enabled, the line must not be empty, and its size when this element is added must exceed the maximum
            if canWrap and #currentLine and currentSize >= majorSize then
                table.insert(lines, currentLine)
                currentLine = {}
                currentSize = basisPx
            end

            -- Ok, now we can add our element to the line safely!
            table.insert(currentLine, state)
        end

        if #currentLine then -- Clean up the last line
            table.insert(lines, currentLine)
        end

        -- Fill out each line
        for _, line in ipairs(lines) do
            -- Reduce available space by gap
            local minGapSpace = gapMajor * (#line - 1)
            local remainingSpace = majorSize - minGapSpace

            for _, state in ipairs(line) do
                remainingSpace -= state.SizeMajor
            end

            -- Factor in growth (takes up remaining space) or shrink (fill into to allowed space)
            -- The math to this turned out so beautiful!
            if remainingSpace > 0 then
                remainingSpace = self:_applyWeightedAdjustment(remainingSpace, "FlexGrow", "SizeMajor", line)
            elseif remainingSpace < 0 then
                remainingSpace = self:_applyWeightedAdjustment(remainingSpace, "FlexShrink", "SizeMajor", line)
            end

            -- Major axis positioning
            local posMajor = 0
            local justifyGapMajor = 0

            if remainingSpace > 0 then
                posMajor, justifyGapMajor = self:_calculateFirstSpacing(containerProps.JustifyContent, remainingSpace, #line)
            end

            -- Adjust element positions
            for _, item in ipairs(line) do
                item.PositionMajor = posMajor
                posMajor += item.SizeMajor + gapMajor + justifyGapMajor
            end
        end

        -- TODO: Update for _REVERSE (ie ROW vs ROW_REVERSE)
        -- TODO: Consider align-self? This comment is randomly placed btw, I don't know where this should go

        -- Calculate columns
        if not primaryAxisOnly then
            -- Determine each line's largest basis (FlexAltBasis)
            -- Then store it in line.MaxMinor
            for i, line in ipairs(lines) do
                local largestBasisPx = 0
                local mine

                for _, item in ipairs(line) do
                    local basis = item.Properties.FlexAltBasis

                    if basis == PROPERTIES.AUTO then
                        if not majorIsX then -- We flip this now
                            basis = item.Properties.PropSize.X
                        else
                            basis = item.Properties.PropSize.Y
                        end
                    end

                    local basisPx = self:_scaleToPx(minorSize, basis)

                    if basisPx > largestBasisPx then
                        largestBasisPx = basisPx
                    end

                    item.BasisPx = basisPx
                end

                line.MaxMinor = largestBasisPx
            end

            -- Create a vertical flexbox and fit the lines within it
            -- Doing this allows an even greater control of vertical positioning over the web's flexbox.
            -- TODO: I dig it, but would it be better to stick to the standard?
            local linesFlexable = {}

            for i, line in ipairs(lines) do
                table.insert(linesFlexable, {
                    Instance = line,
                    Properties = {
                        Order = i,
                        FlexGrow = containerProps.AlignContent == PROPERTIES.STRETCH and 1 or 0,
                        FlexShrink = 0,
                        FlexBasis = UDim.new(0, line.MaxMinor),
                    }
                })
            end

            -- Opposite of current FlexDirection
            local flexDirection

            if containerProps.FlexDirection == PROPERTIES.ROW or containerProps.FlexDirection == PROPERTIES.ROW_REVERSE then
                flexDirection = PROPERTIES.COLUMN -- TODO: Can this ever be COLUMN_REVERSE?
            else -- COLUMN, COLUMN_REVERSE
                flexDirection = PROPERTIES.ROW -- TODO: Can this ever be ROW_REVERSE?
            end

            -- Finish alt container properties
            local altContainerProps = {
                FlexDirection = flexDirection,
                JustifyContent = containerProps.AlignContent,
                RowGap = containerProps.RowGap,
                ColumnGap = containerProps.ColumnGap,
                FlexWrap = PROPERTIES.NOWRAP,
            }

            -- Position and size each line
            local altStates = self:_flexDisplay(altContainerProps, containerSize, linesFlexable, true)

            for _, flexLine in ipairs(altStates) do
                for _, item in ipairs(flexLine.Instance) do
                    local posInLine, _ = self:_calculateFirstSpacing(containerProps.AlignItems, flexLine.SizeMajor - item.BasisPx, 1)

                    item.PositionMinor = flexLine.PositionMajor + posInLine

                    if containerProps.AlignItems == PROPERTIES.STRETCH then
                        item.SizeMinor = flexLine.SizeMajor
                    else
                        item.SizeMinor = item.BasisPx
                    end
                end
            end
        end

        -- Normalize states
        for _, state in ipairs(states) do
            if majorIsX then state.X = state.PositionMajor else state.X = state.PositionMinor end
            if majorIsX then state.Y = state.PositionMinor else state.Y = state.PositionMajor end
            if majorIsX then state.Width = state.SizeMajor else state.Width = state.SizeMinor end
            if majorIsX then state.Height = state.SizeMinor else state.Height = state.SizeMajor end
        end

        return states
    end

    function FlexContainer:_calculateFirstSpacing(justifyContent, remainingSpace, numLines)
        local posMajor, justifyGapMajor = 0, 0

        if justifyContent == PROPERTIES.FLEX_END then
            posMajor = remainingSpace
        elseif justifyContent == PROPERTIES.CENTER then
            posMajor = remainingSpace / 2
        elseif justifyContent == PROPERTIES.SPACE_BETWEEN then
            justifyGapMajor = remainingSpace / (numLines - 1)
        elseif justifyContent == PROPERTIES.SPACE_AROUND then
            justifyGapMajor = remainingSpace / numLines
            posMajor += justifyGapMajor / 2
        elseif justifyContent == PROPERTIES.SPACE_EVENLY then
            justifyGapMajor = remainingSpace / (numLines + 1)
            posMajor += justifyGapMajor
        end
        -- No change from 0,0 on: PROPERTIES.FLEX_START, PROPERTIES.STRETCH

        return posMajor, justifyGapMajor
    end

    function FlexContainer:_calculateLineSize(line, gap)
        local totalElmSize = 0

        for _, line in ipairs(line) do
            totalElmSize += line.SizeMajor
        end

        totalElmSize += gap * (#line - 1)
        return totalElmSize
    end

    function FlexContainer:containerUpdate()
        local selfObj = self.ref:getValue()
        local children = selfObj:GetChildren()

        if not #children then -- TODO: Is there ever anything we need to do even if we have no children?
            return
        end

        local states = self:_flexDisplay(self:_getProps(selfObj, Const.PRIVATE.FLEX_CONTAINER_PROPS), selfObj.AbsoluteSize, self:_getChildrenAndProps(children, Const.PRIVATE.FLEX_ITEM_PROPS))

        for _, state in ipairs(states) do
            state.Instance.Position = UDim2.new(0, state.X, 0, state.Y)
            state.Instance.Size = UDim2.new(0, state.Width, 0, state.Height)
        end
    end

    function FlexContainer:_getProps(obj, propList)
        local props = {}

        for _, prop in ipairs(propList) do
            props[prop] = FlexItem._getAttribute(obj, prop)
        end

        return props
    end

    function FlexContainer:_getChildrenAndProps(children, propList)
        local props = {}

        for _, child in ipairs(children) do
            table.insert(props, { Instance = child, Properties = self:_getProps(child, propList) })
        end

        return props
    end

    function FlexContainer:_applyWeightedAdjustment(remainingSpace, weightedProp, setProp, states)
        -- Calculate weights for growing
        local weightSum = 0

        for _, state in ipairs(states) do
            weightSum += state.Properties[weightedProp]
        end

        -- Apply growth or shrinkage (or do nothing if all elements have FlexGrow/FlexShrink = 0)
        if weightSum ~= 0 then
            for _, state in ipairs(states) do
                -- The math actually turns out so with the same equation
                -- regardless of whether its growth or shrink.
                -- How nice!
                state[setProp] += remainingSpace * state.Properties[weightedProp] / weightSum
            end

            return 0 -- Return new remaining space (0, we're exactly at capacity!)
        else
            return remainingSpace -- We've done nothing
        end
    end

    function FlexContainer:_scaleToPx(total, udim)
        return udim.Scale * total + udim.Offset
    end

    return FlexContainer
end
