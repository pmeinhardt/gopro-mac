//
//  BrowserWindowController.h
//  GoPro
//
//  Created by Paul Meinhardt on 11/23/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface BrowserWindowController : NSWindowController <NSToolbarDelegate, NSURLDownloadDelegate>

// Window controls
@property (nonatomic, assign) IBOutlet WebView *webView;
@property (nonatomic, assign) IBOutlet NSToolbar *toolbar;
@property (nonatomic, assign) IBOutlet NSView *navbar;

// Other properties
@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, assign) BOOL loading;

// Actions
- (IBAction)goForward:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)reload:(id)sender;

@end
