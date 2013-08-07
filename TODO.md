This is TODO file of the LongOS project. Planned features will be listed here.
Currently there are 48 registered features.

TODO
========

For v 0.4
--------
- [ ] F28: Refactor components.
- [ ] F24: Create application for components testing.
- [ ] F45: Add Image resizing.
- [ ] F46: Refactor window title drawing.
- [ ] F47: Move wallpapers to the "Wallpapers" folder.
- [ ] F34: Rename Application to Process.
- [ ] F25: Separate configuration manager into single application.
- [X] F48: Add minimal window size.
- [ ] F33: Move errors catching from WindowsManager to the ApplicationsManager.
- [ ] F42: Change components layouts for better corner coordinates.
- [ ] F35: Add windows resizing.
- [X] F40: Add posibility to maximize window on double clicking the title.
- [ ] F41: Add window minimizing when trying to move maximized window.
- [ ] F44: Add Enabled property to the components.
- [ ] F16: Improve components ierarchy.
- [ ] #5 Edit's cursor isn't setted to the last position when opening window with text in edit
- [ ] #7 Cursor from back window's edit is visible on front window

For all versions
--------
- [ ] F7: Create class diagrams for all classes.
- [ ] F1: Make code refactoring.

Further features
--------
- [ ] F8: Add terminal programs support.
- [ ] F11: Add packets manager.
- [ ] F15: Improve PopupMenu to support submenues.
- [ ] F19: Add desktop icons.
- [ ] F19.1: Add Icon class.
- [ ] F19.2: Add DesktopIcon class.
- [ ] F20: Add program to draw icons.
- [ ] F43: Add ability to add programs to the startup



History
========

For v 0.3
--------
- [X] F26: Remove Timer class.
- [X] F27: Add Canvas class.
- [X] F23: Add real threads.
- [X] F29: Add Event class.
- [X] F30: Add drawing methods to the Image class.
- [X] F14: Add drag-n-drop support.
- [X] F31: Update components and system to use EventHandler.
- [X] F32: Update dialogs to use EventHandler.
- [X] F36: Add onResize event invoking on window maximizing/minimizing.
- [X] F37: Update ColorPicker dialog to use EventHandler.
- [X] F38: Add right and left mouse drag events instead of simple drag event.
- [X] F39: Remove GvinPaint and create BiriPaint.
- [X] #3 Getting mouse click event in window on left clicking the menu.
- [X] #4 Dragging outside the window.
- [X] #6 Wrong window is selected as current after closing subdialog.

For v0.2
--------

- [X] F2: Create Image class.
- [X] F3: Create ConfigurationManager class.
- [X] F4: Add XML support.
- [X] F5: Change configs extension to XML (Result of F4).
- [X] F5.1: Change color schema config extension to XML.
- [X] F5.2: Change interface config extension to XML.
- [X] F5.3: Change mouse config extension to XML.
- [X] F6: Create Pixel class.
- [X] F9: Create stringExtAPI.
- [X] F10: Rename all files to be equal with class names.
- [X] F12: Improve configuration acess.
- [X] F13: Add events manager.
- [X] F21: Add GetClassName function to all classes.
- [X] F22: Remove ModemMonitor.
- [X] #1: OS global error on right click on the desktop with any active window on the screen.
- [X] #2: Error when moving window to the right border of the screen.

Rejected
--------
- [X] F17: [REJECTED] Add TimersManager class.
- [X] F18: [REJECTED] Update GvinPaint.
- [X] F18.1: [REJECTED] Use Image class instead of direct file working.
- [X] F18.2: [REJECTED] Add more tools.
- [X] F18.3: [REJECTED] Add custom dialogs.