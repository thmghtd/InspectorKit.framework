//
//  InspectorPaneInspector.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPaneInspector.h"

@implementation InspectorPaneInspector

- (NSString *)viewNibName {
	return @"InspectorPaneInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects.
	[super refresh];
}

@end
