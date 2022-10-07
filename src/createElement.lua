return function(RoactFlexbox)
    return function(component, props, children)
        props = props and table.clone(props) or {}
        props._FlexboxComponentName = component

        return RoactFlexbox.Roact.createElement(RoactFlexbox._FlexItem, props, children)
    end
end
