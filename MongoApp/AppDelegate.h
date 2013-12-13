//
//  AppDelegate.h
//  MongoApp
//
//  Created by Daniel Parnell on 23/11/2013.
//  Copyright (c) 2013 Daniel Parnell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) NSTask* mongodb;
@property (assign) IBOutlet NSMenu *the_menu;
@property (assign) IBOutlet NSWindow *window;
@property (readonly) BOOL mongo_running;

- (IBAction) showAdminInterface:(id)sender;
- (IBAction) startMongoDB:(id)sender;
- (IBAction) stopMongoDB:(id)sender;
- (IBAction) about:(id)sender;

@end
