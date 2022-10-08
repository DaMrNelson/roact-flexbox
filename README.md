<h1 align="center">RoactFlexbox</h1>

<div align="center">
    A flexbox implementation for <a href="https://github.com/Roblox/roact">Roact</a>.
</div>

<div>&nbsp;</div>

## Installation
TODO: This

## Usage
TODO: Link to docs + give a short example

## TODO
- [X] Get a POC flexbox implementation off the ground
- [X] Set up the repo with Rojo (was previously built into another project)
- [X] Proper branch system
- [X] Support reverse (FlexDirection, FlexWrap)
- [X] Support align-self
- [X] Support for shorthand properties: Flex, FlexFlow, and Gap
- [X] Update pixel math to fill to actual outer edge
- [X] Allow for non-flex children within the flexbox
- [ ] Optimize when renders are performed (I placed a whole bunch to start for testing's sake)
- [X] Scope attributes to "RoactFlexbox" namespace (ie RoactFlexbox.IsFlexItem)
- [X] Support for AutomaticSize
- [X] Respect SizeConstraint for basis = "auto"
- [ ] Investigate whether or not changes are needed based on BorderMode
- [ ] Create documentation (github.io)
- [ ] Pretty up the README (cool GitHub button things, short gif of the plugin in action, code example)
- [ ] Unit tests (TextEz?)
- [ ] Typechecking
- [ ] Update unit tests with typechecking
- [ ] Support MaxSize and MinSize properties
- [ ] Clean up TODO list to only include features, not my own notes
- [ ] Investigate integration with Roblox LSP
- [ ] Create as a model on Roblox
- [ ] Post to DevForum

### Descoped
- [ ] Support self-start, self-end, start, end, baseline, first baseline, etc
    - Not a priority for RC1.
- [ ] Support for SizeConstraint for internal properties like FlexBasis (_scaleToPx)
    - Not a priority for RC1. Can be in RC2.
