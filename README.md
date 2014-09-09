UIForLumberjack
===============

[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) is probably the best logging system for iOS and OS X systems. With it's asynchronous logging, log levels and support for XcodeColors it's the ultimate solution for most projects.

**UIForLumberjack** is the iOS UI library to display CocoaLumberjack logs on iOS device.

![Fullscreen log console](https://raw.github.com/burczyk/UIForLumberjack/master/UIForLumberjackExample/github-assets/UIForLumberjack-full.png)

How to use it?
--------------

Install from cocoapods: 

`pod UIForLumberjack` 

or just drag&drop `UIForLumberjack.h` and `UIForLumberjack.m` to your project.

In your code all you have to do is to add a new logger:
```objective-c
[DDLog addLogger:[UIForLumberjack sharedInstance]];
```

and then just use generated UITableView with logs by adding it to whatever view you like:

```objective-c
[[UIForLumberjack sharedInstance] showLogInView:self.view];
```

UIForLumberjack uses autolayout to fill whole parent view, so you can easily configure it to be a fullscreen console:

![Fullscreen log console](https://raw.github.com/burczyk/UIForLumberjack/master/UIForLumberjackExample/github-assets/UIForLumberjack-full.png)

or just occupy small view:

![Log console in small view](https://raw.github.com/burczyk/UIForLumberjack/master/UIForLumberjackExample/github-assets/UIForLumberjack-small.png)

Extra features:
---------------

After selecting row (method `tableView:didSelectRowAtIndexPath:`) log text changes to show you filename, selector and line from which log was called:

![Fullscreen log console with selectors and line numbers](https://raw.github.com/burczyk/UIForLumberjack/master/UIForLumberjackExample/github-assets/UIForLumberjack-full-selectors.png)

`UITableView` section header contains green button `Hide Log` which performs `removeFromSuperview` action when tapped, so you can easily hide log view when not needed.

Inspiration
-----------

I was inspired by [LumberjackConsole](https://github.com/PTEz/LumberjackConsole) but when I tried to use it it had some issues with screen rotation and showed it's own status bar below system Status Bar which my client didn't want. My implementation is very simple (2 files total and just 177 lines in `.m` file!) but if you need more advanced solution you should definitely check [LumberjackConsole](https://github.com/PTEz/LumberjackConsole).

Example
-------
Open `UIForLumberjackExample` to see how it works although it is really that simple :)

License
-------
`UIForLumberjack` is available under the MIT license. See the LICENSE file for more info.
