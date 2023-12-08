# Documentation
The FancyAssToolTipZ class allows you to create customizable colored tooltips in AutoHotkey. It offers features like:

- Customizable text color, font, and size
- Optional title section with separate formatting
- Background and border with adjustable color and opacity
- Smooth GDI+ rendering for high-quality appearance

## Requirements:
- AutoHotkey v1.1.33.02 or later
- Gdip_All.ahk library

## Usage:
Include the Gdip_All.ahk library in your script.
Create a new instance of the FancyAssToolTipZ class.
Use the available methods to set desired properties like text, colors, sizes, and background.
Call the A() method to display the tooltip.

## Methods:
- A(Msg, Title := "", Timeout := "", MsgColor := "", TitleColor := "") - Displays the tooltip with specified message, optional title, timeout, and colors.
- StartUp(CallSign) - Initializes the class with a specific call sign.
- GuiSetup(CallSign) - Creates the hidden GUI window for the tooltip.
- GuiDestroy() - Destroys the tooltip GUI window.
- Run(Timeout := "") - Displays the tooltip for a specific timeout.
- TotalWidth() - Returns the total width of the tooltip.
- TotalHeight() - Returns the total height of the tooltip.
- GraphicsRender(hwnd) - Renders the tooltip visuals using GDI+.
- MPOS_X(offset:="") - Returns the current mouse X position with an optional offset.
- MPOS_Y(offset:="") - Returns the current mouse Y position with an optional offset.

## Properties:
- CallSign - Unique identifier for the tooltip.
- Timeout - Duration in milliseconds for which the tooltip is displayed.
- Title - Text displayed in the title section.
- BackGround - Object containing background settings like color, opacity, and padding.
- Border - Object containing border settings like color, opacity, size, and padding.
- Running - Boolean flag indicating whether the tooltip is currently displayed.
- pToken - Pointer to the GDI+ library token.
- xOffset - Horizontal offset for the tooltip position relative to the mouse cursor.
- yOffset - Vertical offset for the tooltip position relative to the mouse cursor.

## Nested Classes:
- BackBox - Manages the background and border visuals of the tooltip.
- TxtBox - Handles the text content, formatting, and positioning within the tooltip.
- Further Customization:

You can further customize the behavior and appearance of the tooltip by modifying the properties and methods within the class definition. This includes adjusting string formatting options, background textures, animation effects, and other features.
