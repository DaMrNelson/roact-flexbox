return function(RoactFlexbox)
    return function(component, props, children)
        props = props and table.clone(props) or {}
        props._FlexboxComponentName = component
        props._FlexboxItemIsContainer = true -- This is what makes it a container, not just another FlexItem

        return RoactFlexbox.Roact.createElement(RoactFlexbox._FlexItem, props, children)
    end
end
