//
//  InspectorContainer.h
//  InspectorPane
//
//  Created by Steven on 3/8/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface InspectorPaneContainer : NSView {
	NSString *autosaveName;
}

@property (retain) NSString *autosaveName;

- (void) adjustIBWindowIfNeeded;
- (void) adjustActualWindowToFitContainer;

@end
