//
//  MFAppDelegate.h
//  VolumeTest
//
//  Created by Ira Cooke on 30/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Test application to demonstrate bugs in various api's related to mounting afp URL's under sandbox
//
// The app presents a drop target.  Dropping an afp mounted folder onto the drop target should grant access to its contents.
//


#import <Cocoa/Cocoa.h>
#import "DSDropFolderBox.h"

@class DSDropFolderBox;

@interface MFAppDelegate : NSObject <NSApplicationDelegate,DSDropBoxDataDestination> {
    NSURL *_url;
    NSString *_mountPath;
    
    FSVolumeRefNum _volumeRefNum;
}

@property (copy) NSString *mountPath;
@property (retain) NSURL *url;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet DSDropFolderBox *dropFolderBox;

-(void) dropbox:(DSDropFolderBox*)box receivedDroppedURL:(NSURL*) droppedURL;

@end
