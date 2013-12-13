//
//  AppDelegate.m
//  MongoApp
//
//  Created by Daniel Parnell on 23/11/2013.
//  Copyright (c) 2013 Daniel Parnell. All rights reserved.
//

#import "AppDelegate.h"
#import "AboutWindowWindowController.h"

@implementation AppDelegate {
    __strong NSStatusItem* status_item;
    __strong AboutWindowWindowController* about;
}

- (NSURL*)applicationDirectory {
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager*fm = [NSFileManager defaultManager];
    NSURL*    dirPath = nil;
    
    // Find the application support directory in the home directory.
    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                        inDomains:NSUserDomainMask];
    if ([appSupportDir count] > 0)
    {
        // Append the bundle ID to the URL for the
        // Application Support directory
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        // If the directory does not exist, this method creates it.
        // This method call works in OS X 10.7 and later only.
        NSError*    theError = nil;
        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                           attributes:nil error:&theError])
        {
            // Handle the error.
            
            return nil;
        }
    }
    
    return dirPath;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	status_item = [[NSStatusBar systemStatusBar] statusItemWithLength: NSSquareStatusItemLength];
	NSImage* icon = [NSImage imageNamed:@"BlackIcon"];
	[status_item setImage: icon];
	[status_item setHighlightMode:YES];
	[status_item setMenu: _the_menu];
    
    [self startMongoDB: self];
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    [self stopMongoDB: self];
}

#pragma mark -
#pragma mark Actions

- (IBAction) showAdminInterface:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: @"http://localhost:28017/"]];
}

- (IBAction)startMongoDB:(id)sender {
    if(!_mongodb) {
        __block AppDelegate* this = self;
        NSString* resource_path = [[NSBundle mainBundle] resourcePath];
        NSString* data_path = [[self applicationDirectory] path];
        
        _mongodb = [[NSTask alloc] init];
        _mongodb.launchPath = [resource_path stringByAppendingPathComponent: @"bin/mongod"];
        _mongodb.arguments = [NSArray arrayWithObjects: @"--rest", @"--nounixsocket", @"--dbpath", data_path, nil];
        
        [_mongodb setTerminationHandler:^(NSTask *task) {
            [this willChangeValueForKey: @"mongo_running"];
            this.mongodb = nil;
            [this didChangeValueForKey: @"mongo_running"];
        }];
        
        [self willChangeValueForKey: @"mongo_running"];
        [_mongodb launch];
        [self didChangeValueForKey: @"mongo_running"];
    }
}

- (IBAction)stopMongoDB:(id)sender {
    [_mongodb terminate];
    _mongodb = nil;
}

- (IBAction) about:(id)sender {
    if(!about) {
        about = [[AboutWindowWindowController alloc] initWithWindowNibName: @"AboutWindow"];
    }

    NSWindow* window = [about window];
    [window center];
    [window makeKeyAndOrderFront: self];
    [window setLevel: NSModalPanelWindowLevel];
    [[NSApplication sharedApplication] activateIgnoringOtherApps: YES];
}

#pragma mark -
#pragma mark Properties

- (BOOL) mongo_running {
    if(_mongodb) {
        if([_mongodb isRunning]) {
            [status_item setToolTip: NSLocalizedString(@"MongoDB is running", @"MongoDB is running")];
            [status_item setImage: [NSImage imageNamed: @"GreenIcon"]];
            
            return YES;
        }
    }
    
    [status_item setImage: [NSImage imageNamed: @"BlackIcon"]];
    [status_item setToolTip: NSLocalizedString(@"MongoDB is not running", @"MongoDB is not running")];
    return NO;
}

@end
