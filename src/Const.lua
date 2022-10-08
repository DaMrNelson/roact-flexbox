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
local ATTRIBUTE_NAMESPACE = "RoactFlexbox" -- Namespace applied to any attribute this script sets
local USE_ATTRIBUTE_NAMESPACE = false -- Toggle for attribute namespace for those who are annoyed by it
                                      -- TODO: Re-enable?

local FLEX_ITEM_PROPS = {
    "_FlexboxComponentName",
    "_FlexboxItemIsContainer",

    "Order", -- number -- Uses LayoutOrder and respects
    "FlexGrow", -- number
    "FlexShrink", -- number
    "FlexBasis", -- UDim or PROPERTIES.AUTO
    "Flex", -- Shorthand: UNDEFINED | { FlexGrow, FlexShrink?, FlexBasis? }
    "AlignSelf", -- auto | flex-start | flex-end | center | stretch

    "FlexAltBasis", -- UDim or PROPERTIES.AUTO. TODO: when is this used and ignored??

    "FlexDisabled",
    "PropSize", -- UDim2, set by user
}
local FLEX_CONTAINER_PROPS = {
    "_FlexboxComponentName",
    "_FlexboxForwardRef",

    "FlexDirection", -- row | row-reverse | column | column-reverse
    "FlexWrap", -- nowrap | wrap | wrap-reverse
    "FlexFlow", -- Shorthand: UNDEFINED | { FlexDirection, FlexWrap? }
    "JustifyContent", -- flex-start | flex-end | center | space-between | space-around | space-evenly
    "AlignItems", -- stretch | flex-start | flex-end | center (also space-around | space-between, but those do nothing different from center on AlignItems which only applies to single lines)
    "AlignContent", -- flex-start | flex-end | center | space-between | space-around | space-evenly | stretch
    "Gap", -- Shorthand: UNDFINED | { RowGap, ColumnGap } | UDim2([RowGap...], [ColumnGap...])
    "RowGap", -- UDim
    "ColumnGap", -- UDim
}
local FLEX_PROPS_NOATTRIBUTE = {
    "_FlexboxComponentName",
    "_FlexboxForwardRef",
    "_FlexboxItemIsContainer",
}
local FLEX_PROPS_SHORTHAND = {
    Flex = { "FlexGrow", "FlexShrink", "FlexBasis" },
    FlexFlow = { "FlexDirection", "FlexWrap" },
    Gap = { "RowGap", "ColumnGap" }, -- SURPRISE: there is a hardcoded allowance for this to be a UDim2
}

local DEFAULTS = {
    FlexDirection = PROPERTIES.ROW,
    FlexWrap = PROPERTIES.NOWRAP,
    FlexFlow = PROPERTIES.UNDEFINED,
    JustifyContent = PROPERTIES.FLEX_START,
    AlignItems = PROPERTIES.STRETCH,
    AlignContent = PROPERTIES.FLEX_START,
    Gap = PROPERTIES.UNDEFINED,
    RowGap = UDim.new(0, 0),
    ColumnGap = UDim.new(0, 0),
    Order = 0,
    FlexGrow = 0,
    FlexShrink = 1,
    FlexBasis = PROPERTIES.AUTO,
    Flex = PROPERTIES.UNDEFINED,
    AlignSelf = PROPERTIES.UNDEFINED,

    FlexAltBasis = PROPERTIES.AUTO,

    FlexDisabled = true, -- All FlexItems have this manually set to `false` unless otherwise set.
                         -- So really this default really only applies to non-FlexItems.
                         -- TODO: Make this less hacky
    PropSize = UDim2.new(0, 0, 0, 0),
}

return {
    PUBLIC = {
        PROPERTIES = PROPERTIES,
        --PROPS = PROPERTIES, -- Shorthand :)
                              -- Edit: Shorthand can be confusing.
        ATTRIBUTE_NAMESPACE = ATTRIBUTE_NAMESPACE,
        USE_ATTRIBUTE_NAMESPACE = USE_ATTRIBUTE_NAMESPACE,
    },

    PRIVATE = {
        FLEX_ITEM_PROPS = FLEX_ITEM_PROPS,
        FLEX_CONTAINER_PROPS = FLEX_CONTAINER_PROPS,
        FLEX_PROPS_NOATTRIBUTE = FLEX_PROPS_NOATTRIBUTE,
        FLEX_PROPS_SHORTHAND = FLEX_PROPS_SHORTHAND,
        DEFAULTS = DEFAULTS,
    },
}
