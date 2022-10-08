return function(RoactFlexbox)
    return function(component, props, children)
        -- Host components get re-routed to FlexItem components
        if type(component) == "string" then
            props = props and table.clone(props) or {}
            props._FlexboxComponentName = component
            component = RoactFlexbox.FlexComponent
        else
            -- TODO: Remove once we add support
            error(("createElement got component %s, but only host components are supported at the moment"):format(component))
        end

        -- TODO: Enforce that the component must be one of ours?

        return RoactFlexbox.Roact.createElement(component, props, children)
    end
end
