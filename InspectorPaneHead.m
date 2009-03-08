//
//  InspectorPaneHead.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPaneHead.h"


@implementation InspectorPaneHead

- (id)initWithFrame:(NSRect)frame {
	if (self = [super initWithFrame:frame]) {
	}
	return self;
}

- (BOOL)mouseDownCanMoveWindow {
	return NO;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (void) drawRect:(NSRect)rect {
	NSColor *startColor = [NSColor colorWithCalibratedWhite:0.880 alpha:1.0];
	NSColor *endColor = [NSColor colorWithCalibratedWhite:0.773 alpha:1.0];
	NSGradient *gradient = [[[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor] autorelease];
	
	NSColor *topBorderColorAbove = [NSColor colorWithCalibratedWhite:0.659 alpha:1.0];
	NSColor *topBorderColorBelow = [NSColor colorWithCalibratedWhite:0.925 alpha:1.0];
	NSColor *bottomBorderColor = [NSColor colorWithCalibratedWhite:0.612 alpha:1.0];
	
	NSRect singlePixelRect = [self bounds];
	singlePixelRect.size.height = 1;
	
	NSRect headerRect = [self bounds];
	[gradient drawInRect:headerRect angle:270];
	
	singlePixelRect.origin.y = 0;
	[bottomBorderColor setFill];
	[NSBezierPath fillRect:singlePixelRect];
	
	singlePixelRect.origin.y = [self bounds].size.height - 1;
	[topBorderColorAbove setFill];
	[NSBezierPath fillRect:singlePixelRect];
	
	singlePixelRect.origin.y -= 1;
	[topBorderColorBelow setFill];
	[NSBezierPath fillRect:singlePixelRect];
	
	[[NSColor colorWithCalibratedWhite:0.0 alpha:0.03] setFill];
	[NSBezierPath fillRect:[self bounds]];
	
	if (pressed) {
		[[NSColor colorWithCalibratedWhite:0.0 alpha:0.07] setFill];
		[NSBezierPath fillRect:[self bounds]];
	}
}

@end
