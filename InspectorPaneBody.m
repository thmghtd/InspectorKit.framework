//
//  InspectorPaneBody.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPaneBody.h"


@implementation InspectorPaneBody

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (void) drawRect:(NSRect)rect {
	NSDrawWindowBackground([self bounds]);
}

@end
