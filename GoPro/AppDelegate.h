//
//  AppDelegate.h
//  GoPro
//
//  Created by Paul Meinhardt on 11/13/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

// Interface elements (system status bar)
@property (nonatomic, retain) NSStatusItem *item;
@property (nonatomic, assign) IBOutlet NSMenu *menu;

// View actions
- (IBAction)openAbout:(id)sender;
- (IBAction)openDocumentation:(id)sender;
- (IBAction)newConnection:(id)sender;
- (IBAction)checkForUpdates:(id)sender;
- (IBAction)reportIssue:(id)sender;

@end
