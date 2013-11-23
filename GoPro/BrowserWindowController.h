//
//  BrowserWindowController.h
//  GoPro
//
//  Created by Paul Meinhardt on 11/23/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface BrowserWindowController : NSWindowController

// Window controls
@property (nonatomic, assign) IBOutlet WebView *webview;

@end
