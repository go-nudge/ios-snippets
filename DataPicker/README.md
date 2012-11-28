NudgeDataPickerController
-------------------------

A simple data picker which allows to make a multiple selection among a list of options. Every option (represented by the class NudgeDataPickerRow) has a key, a title and a small description.

The user selection will be returned in the method dataPicker:didFinishWithKeys: of the protocol NudgeDataPickerDelegate, which has to be implemented in the view controllers that  want to work this component.

To show the controller, remember to place it inside a UINavigationViewController, so that the navigation bar is visible.