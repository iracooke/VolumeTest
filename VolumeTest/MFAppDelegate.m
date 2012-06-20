//
//  MFAppDelegate.m
//  VolumeTest
//
//  Created by Ira Cooke on 30/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MFAppDelegate.h"

static NSString *const kRememberedBookmarkKey=@"kRememberedBookmarkKey";
static NSString *const kRememberedURLKey=@"kRememberedURLKey";

@implementation MFAppDelegate

@synthesize url=_url;
@synthesize window = _window;
@synthesize mountPath=_mountPath;
@synthesize dropFolderBox = _dropFolderBox;


- (void) awakeFromNib {
    [_dropFolderBox setDataDestination:self];
    _volumeRefNum=0;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
        
}

- (NSString*) appSupportDir {
    
//    return @"/Users/iracooke/Library/Application Support/VolumeTest"; // For testing when not sandboxed ... gives same results

    return NSHomeDirectory(); // When sandboxed;
    
}

- (IBAction) attemptMountAndReadInContainer:(id) sender {
    
    NSString *mpInContainer=[NSString stringWithFormat:@"%@/Volumes/myurlmount",[self appSupportDir]];
    BOOL exists= [[NSFileManager defaultManager] fileExistsAtPath:mpInContainer];
    if ( !exists )
        [[NSFileManager defaultManager] createDirectoryAtPath:mpInContainer withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSURL *mpURL = [NSURL fileURLWithPath:mpInContainer];
    
    
    NSLog(@"Attempting to mount in dir %@",mpInContainer);

    OSStatus mountStatus = FSMountServerVolumeSync((CFURLRef)[self url],(CFURLRef)mpURL , nil , NULL, &_volumeRefNum,kFSMountServerMarkDoNotDisplay);
    //    OSStatus mountStatus = FSMountServerVolumeSync((CFURLRef)[self url],(CFURLRef)mpURL , nil , NULL, &_volumeRefNum,0);
    
    if ( mountStatus!=noErr ){
        NSLog(@"Error attempting to mount");
    } else {
        NSLog(@"Success mounting volume");
        // Success to mountPath is known
        [self setMountPath:mpInContainer];
    }
    
}

- (IBAction)unmount:(id)sender {
    
    if ( !_volumeRefNum )
        return;
    
    OSStatus unmountStatus = FSUnmountVolumeSync(_volumeRefNum, 0, NULL);
    
    if ( unmountStatus!=noErr){
        NSLog(@"Failed unmount");
        [self setMountPath:nil];
        _volumeRefNum=0;
    } else {
        NSLog(@"Success unmounting");
    }
    
}

-(void) dropbox:(DSDropFolderBox*)box receivedDroppedURL:(NSURL*) droppedURL {
    [self setUrl:droppedURL];
}


@end
