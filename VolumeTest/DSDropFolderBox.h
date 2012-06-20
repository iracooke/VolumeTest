//
//  DSDropFolderBox.h
//  VolumeTest
//
//  Created by Ira Cooke on 8/08/10.
//  Copyright 2010 Mudflat Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DSDropBoxDataDestination;

/*! @abstract A subclass of NSBox that accepts a single dropped url or folder */
@interface DSDropFolderBox : NSBox {
	id <DSDropBoxDataDestination> dataDestination;

@private    
    NSArray *_preferredTypes;
}

@property (nonatomic,assign) id <DSDropBoxDataDestination> dataDestination;

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender;
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender;

@end

@protocol DSDropBoxDataDestination 

-(void) dropbox:(DSDropFolderBox*)box receivedDroppedURL:(NSURL*) droppedURL;

@end
