//
//  InspectorPaneView.h
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define SDIsInIB (NSClassFromString(@"IBDocument") != Nil)

@class InspectorPaneContainer;
@class InspectorPaneHead;
@class InspectorPaneBody;

@interface InspectorPane : NSView {
	IBOutlet InspectorPaneHead *paneHead;
	IBOutlet InspectorPaneBody *paneBody;
	
	IBOutlet NSTextField *titleTextField;
	IBOutlet NSButton *collapseButton;
	
	BOOL resizable;
	float minHeight;
	float maxHeight;
	
	BOOL collapsed;
	float uncollapsedHeight;
	float distanceFromTop;
	
	// for resizing
	BOOL pressed;
	float heightFromBottom;
}

@property BOOL resizable;
@property float minHeight;
@property float maxHeight;

- (IBAction) toggleCollapsed:(id)sender;

@end
