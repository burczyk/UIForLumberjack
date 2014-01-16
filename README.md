UIForLumberjack
===============

iOS UI library to display CocoaLumberjack logs on iOS device

All you have to do is to add new logger:
```objective-c
[DDLog addLogger:[UIForLumberjack sharedInstance]];
```

and then just use generated UITableView with logs by adding it to whatever view you like:

```objective-c
[[UIForLumberjack sharedInstance] showLogInView:self.view];
```

UIForLumberjack uses autolayout to fill whole parent view, so you can easily configure it to look like one of these:

![Fullscreen log console](https://raw.github.com/burczyk/UIForLumberjack/master/UIForLumberjackExample/github-assets/UIForLumberjack-full.png)

![Fullscreen log console with selectors and line numbers](https://raw.github.com/burczyk/UIForLumberjack/master/UIForLumberjackExample/github-assets/UIForLumberjack-full-selectors.png)

![Log console in small view](https://raw.github.com/burczyk/UIForLumberjack/master/UIForLumberjackExample/github-assets/UIForLumberjack-small.png)

Open `UIForLumberjackExample` to see how it works although it is really that simple :)
