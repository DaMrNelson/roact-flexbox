local Roact = require(game.ReplicatedStorage.Roact)
local RoactFlexbox = require(game.ReplicatedStorage.RoactFlexbox)(Roact)

-- Hide CoreGuis
-- "Fine, I'll do it myself"
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- Create test GUI
local root = Roact.createElement("ScreenGui", {
    ResetOnSpawn = false,
}, {
    TestContainer = RoactFlexbox.createContainer("Frame", {
        Size = UDim2.new(0.8, 0, 0.8, 0),
        Position = UDim2.new(0.1, 0, 0.1, 0),
        --RowGap = UDim.new(0, 25),
        --ColumnGap = UDim.new(0, 25),
        --JustifyContent = "flex-start",
        --JustifyContent = "flex-end",
        --JustifyContent = "center",
        --JustifyContent = "space-between",
        --JustifyContent = "space-around"
        JustifyContent = "center",
        --AlignContent = "space-evenly",
        AlignContent = "stretch",
        AlignItems = "stretch",
        --AlignItems = "flex-start",

        FlexFlow = { "row", "nowrap" },
        --FlexDirection = "row",
        FlexWrap = "wrap",

        --Gap = UDim2.new(0, 10, 0, 50),
        Gap = { UDim.new(0, 10), UDim.new(0, 50) },
        --RowGap = UDim.new(0, 50),
        --ColumnGap = UDim.new(0, 100),
    }, {
        --[[TestElm1 = RoactFlexbox.createElement("Frame", {
            Order = 1,
            FlexBasis = UDim.new(0.2, 0),
            FlexGrow = 2,
            BackgroundColor3 = Color3.new(1, 0, 0),
        }),
        TestElm2 = RoactFlexbox.createElement("Frame", {
            Order = 2,
            FlexGrow = 7,
            --Size = UDim2.new(0, 0, 0, 1000),
            BackgroundColor3 = Color3.new(0, 0, 1),
        }),]]
        --[[TestElm1 = RoactFlexbox.createElement("Frame", {
            Order = 1,
            FlexShrink = 4,
            FlexBasis = UDim.new(0.7, 0),
            BackgroundColor3 = Color3.new(1, 0, 0),
        }),
        TestElm2 = RoactFlexbox.createElement("Frame", {
            Order = 2,
            FlexShrink = 2,
            FlexBasis = UDim.new(0.7, 0),
            BackgroundColor3 = Color3.new(0, 0, 1),
        }),]]
        --[[TestElm1 = RoactFlexbox.createElement("Frame", {
            Order = 1,
            FlexBasis = UDim.new(0.2, 0),
            BackgroundColor3 = Color3.new(1, 0, 0),
        }),
        TestElm2 = RoactFlexbox.createElement("Frame", {
            Order = 2,
            FlexBasis = UDim.new(0.3, 0),
            BackgroundColor3 = Color3.new(0, 0, 1),
        }),]]
        --[[TestElm1 = RoactFlexbox.createElement("Frame", {
            Order = 1,
            FlexBasis = UDim.new(0.7, 0),
            BackgroundColor3 = Color3.new(1, 0, 0),
        }),
        TestElm2 = RoactFlexbox.createElement("Frame", {
            Order = 2,
            FlexBasis = UDim.new(0.7, 0),
            BackgroundColor3 = Color3.new(0, 0, 1),
        }),]]
        TestElm1 = RoactFlexbox.createElement("Frame", {
            Order = 1,
            FlexBasis = UDim.new(0.2, 0),
            FlexAltBasis = UDim.new(0, 200),
            BackgroundColor3 = Color3.new(1, 0, 0),
            BorderSizePixel = 0,
        }),
        TestElm2 = RoactFlexbox.createElement("Frame", {
            Order = 2,
            FlexBasis = UDim.new(0.2, 0),
            FlexAltBasis = UDim.new(0, 100),
            AlignSelf = "center",
            BackgroundColor3 = Color3.new(0, 0, 1),
            BorderSizePixel = 0,
        }),
        TestElm3 = RoactFlexbox.createElement("Frame", {
            Order = 3,
            FlexBasis = UDim.new(0.2, 0),
            --FlexAltBasis = UDim.new(0.8, 0),
            FlexAltBasis = UDim.new(0, 100),
            --FlexGrow = 1,
            --Flex = { 1, 0, UDim.new(0.9, 0) },
            BackgroundColor3 = Color3.new(0, 1, 0),
            BorderSizePixel = 0,
        }),
        TestElm3_1 = RoactFlexbox.createElement("Frame", {
            Order = 3.1,
            FlexBasis = UDim.new(0.41, 3),
            --FlexAltBasis = UDim.new(0.8, 0),
            FlexAltBasis = UDim.new(0, 100),
            FlexGrow = 1,
            BackgroundColor3 = Color3.new(0, 1, 0),
            BorderSizePixel = 0,
        }),
        RandomElm = Roact.createElement("Frame", { -- Random non-flex element
            BackgroundColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0.25, 0, 0.5, 0),
            Position = UDim2.new(0.25, 0, 0.25, 0),
            Transparency = 0.5,
        }),
        DisabledElm = RoactFlexbox.createElement("Frame", {
            FlexDisabled = true,
            BackgroundColor3 = Color3.new(1, 1, 1),
            Size = UDim2.new(0.25, 0, 0.5, 0),
            Position = UDim2.new(0.5, 0, 0.25, 0),
            Transparency = 0.5,
        }),
        --TestElm4 = RoactFlexbox.createContainer("Frame", {
        TestElm4 = RoactFlexbox.createElement("Frame", {
            Order = 4,
            FlexBasis = UDim.new(0.5, 0),
            FlexAltBasis = UDim.new(0, 100),
            BackgroundColor3 = Color3.new(1, 1, 0),
            BorderSizePixel = 0,
        }, {
            --[[TestElm1 = RoactFlexbox.createElement("Frame", {
                Order = 1,
                FlexBasis = UDim.new(0.3, 0),
                FlexAltBasis = UDim.new(0, 50),
                BackgroundColor3 = Color3.new(1, 0, 0),
            }),
            TestElm2 = RoactFlexbox.createElement("Frame", {
                Order = 2,
                FlexBasis = UDim.new(0.3, 0),
                FlexAltBasis = UDim.new(0, 60),
                BackgroundColor3 = Color3.new(0, 0, 1),
            }),
            TestElm3 = RoactFlexbox.createElement("Frame", {
                Order = 3,
                FlexBasis = UDim.new(0.3, 0),
                FlexGrow = 1,
                --FlexAltBasis = UDim.new(0.8, 0),
                FlexAltBasis = UDim.new(0, 90),
                BackgroundColor3 = Color3.new(0, 1, 0),
            }),]]
        }),
        TestElm5 = RoactFlexbox.createElement("Frame", {
            Order = 5,
            FlexBasis = UDim.new(0.9, 0),
            --FlexAltBasis = UDim.new(0.8, 0),
            FlexAltBasis = UDim.new(0, 100),
            FlexGrow = 0,
            BackgroundColor3 = Color3.new(0, 1, 1),
            BorderSizePixel = 0,
        }),
    })
})
Roact.mount(root, game.Players.LocalPlayer.PlayerGui, "RoactFlexboxTest")
