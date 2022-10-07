local PROPERTIES = {
    -- Flexbox properties
    ROW = "row",
    ROW_REVERSE = "row-reverse",
    COLUMN = "column",
    COLUMN_REVERSE = "column-reverse",

    NOWRAP = "nowrap",
    WRAP = "wrap",
    WRAP_REVERSE = "wrap-reverse",

    FLEX_START = "flex-start",
    FLEX_END = "flex-end",
    CENTER = "center",
    SPACE_BETWEEN = "space-between",
    SPACE_AROUND = "space-around",
    SPACE_EVENLY = "space-evenly",
    -- TODO: Safe and unsafe options for justify-content?
    STRETCH = "stretch",
    BASELINE = "baseline",

    AUTO = "auto",
    UNDEFINED = "undefined",
    --NONE = "none",
}

local FLEX_ITEM_PROPS = {
    "_FlexboxComponentName",
    "_FlexboxItemIsContainer",

    "Order", -- number -- Uses LayoutOrder and respects
    "FlexGrow", -- number
    "FlexShrink", -- number
    "FlexBasis", -- UDim or PROPERTIES.AUTO
    --"Flex", -- TODO: This? (Combines FlexGrow, FlexShrink, and FlexBasis)
    "AlignSelf", -- auto | flex-start | flex-end | center | stretch
                 -- TODO: Also support: baseline

    "FlexAltBasis", -- UDim or PROPERTIES.AUTO. TODO: when is this used and ignored??

    "PropSize", -- UDim2, set by user
}
local FLEX_CONTAINER_PROPS = {
    "_FlexboxComponentName",
    "_FlexboxForwardRef",

    "FlexDirection", -- row | row-reverse | column | column-reverse
    "FlexWrap", -- nowrap | wrap | wrap-reverse
    -- "FlexFlow", -- TODO: This? (Combines FlexDirection and FlexWrap)
    "JustifyContent", -- flex-start | flex-end | center | space-between | space-around | space-evenly
    "AlignItems", -- stretch | flex-start | flex-end | center (also space-around | space-between, but those do nothing different from center on AlignItems which only applies to single lines)
                  -- TODO: Also support: baseline | first baseline | last baseline | start | end | self-start | self-end
    "AlignContent", -- flex-start | flex-end | center | space-between | space-around | space-evenly | stretch
                    -- TODO: Also support: start | end | baseline | first baseline | last baseline
    --"Gap", -- TODO: This? (Combines RowGap and ColumnGap)
    "RowGap", -- UDim
    "ColumnGap", -- UDim
}
local FLEX_PROPS_NOATTRIBUTE = {
    "_FlexboxComponentName",
    "_FlexboxForwardRef",
    "_FlexboxItemIsContainer",
}

local DEFAULTS = {
    FlexDirection = PROPERTIES.ROW,
    FlexWrap = PROPERTIES.NOWRAP,
    JustifyContent = PROPERTIES.FLEX_START,
    AlignItems = PROPERTIES.STRETCH,
    AlignContent = PROPERTIES.FLEX_START,
    RowGap = UDim.new(0, 0),
    ColumnGap = UDim.new(0, 0),
    Order = 0,
    FlexGrow = 0,
    FlexShrink = 1,
    FlexBasis = PROPERTIES.AUTO,
    AlignSelf = PROPERTIES.UNDEFINED,

    FlexAltBasis = PROPERTIES.AUTO,

    PropSize = UDim2.new(0, 0, 0, 0),
}

return {
    PUBLIC = {
        PROPERTIES = PROPERTIES,
        --PROPS = PROPERTIES, -- Shorthand :)
                              -- Edit: Shorthand can be confusing.
    },

    PRIVATE = {
        FLEX_ITEM_PROPS = FLEX_ITEM_PROPS,
        FLEX_CONTAINER_PROPS = FLEX_CONTAINER_PROPS,
        FLEX_PROPS_NOATTRIBUTE = FLEX_PROPS_NOATTRIBUTE,
        DEFAULTS = DEFAULTS,
    },
}
