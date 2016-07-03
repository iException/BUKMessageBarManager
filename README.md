# BUKMessageBarManager

[![CI Status](http://img.shields.io/travis/monzy613/BUKMessageBarManager.svg?style=flat)](https://travis-ci.org/monzy613/BUKMessageBarManager)
[![Version](https://img.shields.io/cocoapods/v/BUKMessageBarManager.svg?style=flat)](http://cocoapods.org/pods/BUKMessageBarManager)
[![License](https://img.shields.io/cocoapods/l/BUKMessageBarManager.svg?style=flat)](http://cocoapods.org/pods/BUKMessageBarManager)
[![Platform](https://img.shields.io/cocoapods/p/BUKMessageBarManager.svg?style=flat)](http://cocoapods.org/pods/BUKMessageBarManager)

## Snapshots
![img](http://o7b20it1b.bkt.clouddn.com/snapshot.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BUKMessageBarManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BUKMessageBarManager", :git => 'https://github.com/iException/BUKMessageBarManager.git'
```

## Quick use
```objc
// #import "BUKMessageBarManager.h"
// BUKMessageBarManager
+ (BUKMessageBar *)showMessageWithTitle:(NSString *)title
                                 detail:(NSString *)detail
                                buttons:(NSArray<BUKMessageBarButton *> *)buttons                         
                                   type:(BUKMessageBarType)type
                               duration:(NSTimeInterval)duration;

+ (BUKMessageBar *)showMessageWithTitle:(NSString *)title
                                 detail:(NSString *)detail
                                   type:(BUKMessageBarType)type
                               duration:(NSTimeInterval)duration;
// BUKMessageBarButton
+ (BUKMessageBarButton *)buttonWithTitle:(NSString *)title
                                    type:(BUKMessageBarButtonType)type
                                 handler:(void (^)(BUKMessageBarButton *button))block;

// enum
typedef NS_ENUM(NSInteger, BUKMessageBarType) {
    BUKMessageBarTypeSuccess,
    BUKMessageBarTypeFailed,
    BUKMessageBarTypeInfo
};

typedef NS_ENUM(NSInteger, BUKMessageBarButtonType) {
    BUKMessageBarButtonTypeDefault,
    BUKMessageBarButtonTypeOk,
    BUKMessageBarButtonTypeDestructive
};                                                               
```

## Author

monzy613, monzy613@gmail.com

## License

BUKMessageBarManager is available under the MIT license. See the LICENSE file for more info.
