//
//  DSDropFolderBox.m
//  VolumeTest
//
//  Created by Ira Cooke on 8/08/10.
//  Copyright 2010 Mudflat Software. All rights reserved.
//

#import "DSDropFolderBox.h"

@implementation DSDropFolderBox
@synthesize dataDestination;

- (NSArray*) preferredTypes {    
    _preferredTypes=[[NSArray arrayWithObjects: (NSString*)kUTTypeDirectory,(NSString*)kUTTypeURL,nil] retain];
    return _preferredTypes;
}

- (void)awakeFromNib
{
    [self registerForDraggedTypes:[self preferredTypes]];
}

- (void) dealloc {
    [_preferredTypes release];
    [super dealloc];
}

- (NSURL*) URLFromPasteBoardItem:(NSPasteboardItem*) item {
    NSString *availableType = [item availableTypeFromArray:[self preferredTypes]]; 
    
    if ( UTTypeConformsTo((CFStringRef)availableType,kUTTypeURL)) { // Already a URL string
        NSString *urlString=[item stringForType:availableType];
        return [NSURL URLWithString:urlString];
    } else {
        NSAssert(UTTypeConformsTo((CFStringRef)availableType, kUTTypeFolder),@"Accepted pasteboard items should be URL's or Folders only");
        return [NSURL fileURLWithPath:[item stringForType:availableType]];
    }
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard=[sender draggingPasteboard];
	NSArray *files = [pboard pasteboardItems];
    if ( [files count]!=1 ) // Can't accept more than 1 path
        return NSDragOperationNone;
        
    return NSDragOperationCopy;
}

-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard=[sender draggingPasteboard];
    
	NSArray *items = [pboard pasteboardItems];    
    
    NSURL *droppedURL = [self URLFromPasteBoardItem:[items objectAtIndex:0]];
    
    [dataDestination dropbox:self receivedDroppedURL:droppedURL];
    
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect {

	[self lockFocus];
	
	CGFloat lineDash[2] = {20.0, 7.0};
	
	NSBezierPath *bp=[NSBezierPath bezierPathWithRoundedRect:NSInsetRect([self bounds],5.0,5.0) xRadius:15.0 yRadius:15.0];
	
	[bp setLineDash:lineDash count:2 phase:0.0];

	[bp setLineWidth:5];
	[[NSColor darkGrayColor] set];
	[bp stroke];
	[[NSColor clearColor] set];
	[bp fill];
	
	[self unlockFocus];
}


@end
