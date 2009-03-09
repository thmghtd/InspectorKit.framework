//
//  InspectorContainer.h
//  InspectorPane
//
//  Created by Steven on 3/8/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class InspectorPane;

@interface InspectorPaneContainer : NSView {
	NSString *autosaveName;
	
	float topMargin;
}

@property (retain) NSString *autosaveName;

@end
