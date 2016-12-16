# ScratchCard
<img src="https://raw.githubusercontent.com/joehour/ScratchCard/master/ScratchCard/result.jpg" width="400" height="800" />

Requirements
----------

- iOS 8.0+
- Xcode 8.0+ Swift 3


## Installation

#### CocoaPods

Check out [Get Started](https://guides.cocoapods.org/using/getting-started.html) tab on [cocoapods.org](http://cocoapods.org/).

To use ScratchCard in your project add the following 'Podfile' to your project

	source 'https://github.com/joehour/ScratchCard.git'
	platform :ios, '8.0'
	use_frameworks!

	pod 'ScratchCard', '~> 1.0.9’

Then run:

    pod install

#### Source Code

Copy the ScratchView.swift and ScratchUIView.swift to your project.

Go ahead and import ScratchCard to your file.


Example
----------

####Please check out the Example project included.


Usage
----------

* Sample:
```swift
    import ScratchCard
    
    class ViewController: UIViewController {

    var scratchCard: ScratchUIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scratchCard  = ScratchUIView(frame: CGRect(x:50, y:80, width:320, height:480),Coupon: "image", MaskImage: "mask", ScratchWidth: CGFloat(40))
        
        self.view.addSubview(scratchCard)
        }
    }
```

Scratched Percent
----------

It is easy to get the scratched percent.
 
* Sample:
```swift
   let scratchPercent: Double = scratchCard.getScratchPercent()
```

Handle Scratch Event
----------
 
It is easy to handle the scratch event(ScratchBegan, ScratchMoved, and ScratchEnded).
Please set the ScratchUIViewDelegate in your code.
 
* Sample:
```swift
class ViewController: UIViewController, ScratchUIViewDelegate {
    
    var scratchCard: ScratchUIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        scratchCard = ScratchUIView(frame: CGRect(x:50, y:80, width:320, height:480), Coupon: "image", MaskImage: "mask", ScratchWidth: CGFloat(40))
        scratchCard.delegate = self
        
        self.view.addSubview(scratchCard)
    }
    
    //Scratch Began event(optional function)
    func scratchBegan(_ view: ScratchUIView) {
        print("scratchBegan")
    }
    
    //Scratch Moved event(optional function)
    func scratchMoved(_ view: ScratchUIView) {
        print("scratchMoved")
    }
    
    //Scratch Ended event(optional function)
    func scratchEnded(_ view: ScratchUIView) {
        print("scratchEnded")
    }
}
```

##License
ScratchCard is available under the MIT License.

Copyright © 2016 Joe.
