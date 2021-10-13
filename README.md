MethodNotificationCenter
========
Objective-C Runtime Injection

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d30d31c29f17449481b97a04610ff5b9)](https://app.codacy.com/app/SomeRandomiOSDev/MethodNotificationCenter?utm_source=github.com&utm_medium=referral&utm_content=SomeRandomiOSDev/MethodNotificationCenter&utm_campaign=Badge_Grade_Dashboard)
[![License MIT](https://img.shields.io/cocoapods/l/MethodNotificationCenter.svg)](https://cocoapods.org/pods/MethodNotificationCenter)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MethodNotificationCenter.svg)](https://cocoapods.org/pods/MethodNotificationCenter) 
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Platform](https://img.shields.io/cocoapods/p/MethodNotificationCenter.svg)](https://cocoapods.org/pods/MethodNotificationCenter)
[![Code Coverage](https://codecov.io/gh/SomeRandomiOSDev/MethodNotificationCenter/branch/master/graph/badge.svg)](https://codecov.io/gh/SomeRandomiOSDev/MethodNotificationCenter)

![Swift Package](https://github.com/SomeRandomiOSDev/MethodNotificationCenter/workflows/Swift%20Package/badge.svg)
![Xcode Project](https://github.com/SomeRandomiOSDev/MethodNotificationCenter/workflows/Xcode%20Project/badge.svg)
![Cocoapods](https://github.com/SomeRandomiOSDev/MethodNotificationCenter/workflows/Cocoapods/badge.svg)
![Carthage](https://github.com/SomeRandomiOSDev/MethodNotificationCenter/workflows/Carthage/badge.svg)

**MethodNotificationCenter** is a lightweight framework for performing Objective-C runtime method injection for iOS, macOS, and tvOS.

Purpose
--------

The purpose of this library is for being able to explore and understand the intricacies of the Objective-C runtime and the methods/APIs provided by Apple's libraries. 

This library allows one to be notified, in a fashion very similar to Foundation's own `NSNotificationCenter`, before and after a given method is called on a particular object.

It should be noted that this library is for _educational purposes_ only. The way in which this library operates not only makes it volatile and unsuitable to production releases, but use of it would likely not pass Apple's App Store review (untested).

Installation
--------

**MethodNotificationCenter** is available through [CocoaPods](https://cocoapods.org), [Carthage](https://github.com/Carthage/Carthage) and the [Swift Package Manager](https://swift.org/package-manager/). 

To install via CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'MethodNotificationCenter'
```

To install via Carthage, simply add the following line to your Cartfile:

```ruby
github "SomeRandomiOSDev/MethodNotificationCenter"
```

To install via the Swift Package Manager add the following line to your `Package.swift` file's `dependencies`:

```swift
.package(url: "https://github.com/SomeRandomiOSDev/MethodNotificationCenter.git", from: "1.0.0")
```

Usage
--------

First import **MethodNotificationCenter** at the top of your source file:

Objective-C:

```objc
@import MethodNotificationCenter;
```

Swift: 

```swift
import MethodNotificationCenter
```

After importing, simply use `+[MethodNotificationCenter addObserverForSelector:object:callback:]` to register a block handler for snooping in on Objective-C method calls:

Objective-C:

```objc
...
id observable = [MethodNotificationCenter addObserverForSelector:@selector(objectAtIndex:) object:array callback:^(MethodNotification *notification) {
    NSLog(@"NSArray's `objectAtIndex:` method was called");
}];
```

Swift:

```swift
...
let observable = MethodNotificationCenter.addObserver(for: #selector(NSArray.objectAtIndex(_:)), object:nsarray) { notification in
    print("NSArray's `objectAtIndex:` method was called")
}
```

Now your callback block will be called before and after each time the given selector is called on the object that you specified. When you are done snooping, simply pass the returned value from the registration method to `+[MethodNotificationCenter removeObserver:]`

Objective-C:

```objc 
...
[MethodNotificationCenter removeObserver:observable];
```

Swift:

```swift 
...
MethodNotificationCenter.removeObserver(observable)
```

Limitations
--------

There are some notable limitations to the capabilities of this library:

* Method notifications aren't sent recursively. That is, you'll receive a notification for the "top-level" call of the given method, but if the method (or any of its internal method calls) calls the same method a notification will _not_ be sent for that.
* Due to optimizations made by the Swift compiler, Swift calls to methods written in Swift (but annotated with the `@objc` attribute) are usually hard-coded by the compiler and don't use the Objective-C runtime, which prevent notifications from being sent. Classes written in Objective-C and called from Swift (or vice-versa) shouldn't have this issue. See `Tests/MethodNotificationCenterTests/MethodNotificationCenterSwiftTests/MethodNotificationCenterTests.swift` for examples.

Contributing
--------

If you have need for a specific feature or you encounter a bug, please open an issue. If you extend the functionality of **MethodNotificationCenter** yourself or you feel like fixing a bug yourself, please submit a pull request.

Author
--------

Joe Newton, somerandomiosdev@gmail.com

License
--------

**MethodNotificationCenter** is available under the MIT license. See the `LICENSE` file for more info.
