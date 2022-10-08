local Const = require(script.Parent.Const)

local Util = {}

-- Given a list of possible properties, returns the properties of a component from its attributes (or defaults).
-- Returns: { key = value, ... }
function Util.getProps(obj, propList)
    local props = {}

    for _, prop in ipairs(propList) do
        props[prop] = Util.getAttribute(obj, prop)
    end

    return props
end

-- Given a list of possible properties, returns all properties of a instances from their attributes (or defaults).
-- Returns: { [i] = { Instance = children[i], Properties = { key = value, ... }, ... }
function Util.getChildrenAndProps(children, propList)
    local props = {}

    for _, child in ipairs(children) do
        table.insert(props, { Instance = child, Properties = Util.getProps(child, propList) })
    end

    return props
end

-- Gets the given attribute, or returns the default from Const.PRIVATE.DEFAULTS if unset/nil.
function Util.getAttribute(item, prop)
    local val = item:GetAttribute(Util.applyNamespace(prop))

    if val == nil then
        return Const.PRIVATE.DEFAULTS[prop]
    else
        return val
    end
end

-- Applies our namespace to the given attribute name
function Util.applyNamespace(name)
    if Const.PUBLIC.USE_ATTRIBUTE_NAMESPACE then
        return Const.PUBLIC.ATTRIBUTE_NAMESPACE .. "_" .. name
    else
        return name
    end
end

-- Scales the given UDim to pixels based on its container's size.
-- DOES NOT RESPECT THE SizeConstraint PROPERTY AUTOMATICALLY!
-- You should manage that property by adjusting the `total` argument if desired.
function Util.scaleToPx(total, udim)
    return udim.Scale * total + udim.Offset
end

-- Gets the border inset for a given GUI based on BorderSizePixel and BorderMode.
-- Returns the amount amount of inset from any corner in pixels: number
function Util.getBorderInset(inst)
    local borderSize = inst.BorderSizePixel

    if borderSize == 0 or inst.BorderMode == Enum.BorderMode.Outline then
        return 0
    elseif inst.BorderMode == Enum.BorderMode.Middle then
        return borderSize / 2
    elseif inst.BorderMode == Enum.BorderMode.Inset then
        return borderSize
    end
end

return Util
