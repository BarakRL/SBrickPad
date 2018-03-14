## Requirements

* iOS 10+ device with a paired MFI or iCade gamepad
* [SBrick+](https://www.sbrick.com/sbrick-plus.html)<sup>1</sup> and Lego PF accessories (motors, light etc.)
* [Xcode](https://developer.apple.com/xcode) 9.2
* [CocoaPods](https://cocoapods.org)

(<sup>1</sup>might work with a "non-plus" SBrick, but I don't have  one to test it.)

## Installation

SBrickPad uses SBrick-iOS which is available through [CocoaPods](http://cocoapods.org).<br/>
To install it run `pod install` from the project directory first.

## Usage

After installed the pods (see above), Use Xcode to install the app on your device (you might have to edit the signing and bundle identifiers to match your developer account).
<br/>
The app will automaticlly detect and connect to any SBrick+ (the app only supports a single SBrick at this time).
You can than assign actions to buttons or load existing action sets (the app comes with a `Simple Drive` example file).

![demo gif](https://github.com/barakrl/sbrickpad/blob/master/demo.gif)


Supported button actions:

* Drive (constant): port (1-4), power (0-255), toggle (yes/no), direction (cw/ccw)
* Drive (variable): port (1-4), min/max power (0-255), direction (cw/ccw)
* Stop: port (1-4)
* Play / Stop sounds


Remember to save you actions when you're done editing them.

Enjoy!

## tl;dr

To run the project: clone the repo, run `pod install` from the project directory, build and run in Xcode.

## Author

Barak Harel

## License

SBrickPad is for non-commercial use only.<br/>
(Note: SBrick-iOS is available under the MIT license, See the SBrick-iOS LICENSE file for more info.)
