//
//  InspectorPaneContainerInspector.m
//  Inspector
//
//  Created by Steven on 3/8/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPaneContainerInspector.h"

@implementation InspectorPaneContainerInspector

- (NSString *)viewNibName {
    return @"InspectorPaneContainerInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects
	[super refresh];
}

+ (BOOL)supportsMultipleObjectInspection {
	return NO;
}

@end
