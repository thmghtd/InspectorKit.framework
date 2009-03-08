//
//  InspectorPaneContainerIntegration.m
//  InspectorPane
//
//  Created by Steven on 3/8/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <Inspector/InspectorPaneContainer.h>
#import "InspectorPaneContainerInspector.h"

@implementation InspectorPaneContainer ( InspectorPaneContainer )

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
	[super ibPopulateKeyPaths:keyPaths];
	[[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:[NSArray arrayWithObjects:/* @"MyFirstProperty", @"MySecondProperty",*/ nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
	[super ibPopulateAttributeInspectorClasses:classes];
	[classes addObject:[InspectorPaneContainerInspector class]];
}

- (NSView *)ibDesignableContentView {
	return self;
}

- (void)drawRect:(NSRect)rect {
	NSRect frame = [self bounds];
	frame.origin.x += 0.5;
	frame.origin.y += 0.5;
	frame.size.width -= 1.0;
	frame.size.height -= 1.0;
	
	NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
	[paragraphStyle setAlignment:NSCenterTextAlignment];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								paragraphStyle, NSParagraphStyleAttributeName,
								nil];
	
	NSRect bottomRect;
	NSRect mainRect;
	NSDivideRect(frame, &bottomRect, &mainRect, 20.0, NSMinYEdge);
	
	NSRect textRect = bottomRect;
	textRect.origin.y -= 3.0;
	[@"Click here to select Inspector Container" drawInRect:textRect withAttributes:attributes];
	
	[[NSColor blueColor] setStroke];
	[NSBezierPath strokeRect:mainRect];
	
	bottomRect.size.height = 17.0;
	float r = 7.0;
	
	[[NSColor blueColor] setStroke];
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:bottomRect xRadius:r yRadius:r];
	[path stroke];
}

@end
