//
//  AboutWindowWindowController.h
//  MongoApp
//
//  Created by Daniel Parnell on 25/11/2013.
//  Copyright (c) 2013 Daniel Parnell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AboutWindowWindowController : NSWindowController

@property (assign) IBOutlet WebView* web_view;

@end
