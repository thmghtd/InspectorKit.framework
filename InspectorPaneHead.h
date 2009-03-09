//
//  InspectorPaneHead.h
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class InspectorPane;

@interface InspectorPaneHead : NSView {
	IBOutlet InspectorPane *pane;
	BOOL pressed;
}

@end
