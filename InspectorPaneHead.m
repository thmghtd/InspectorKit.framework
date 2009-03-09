//
//  InspectorPaneHead.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPaneHead.h"
#import "InspectorPane.h"

@implementation InspectorPaneHead

- (id)initWithFrame:(NSRect)frame {
	if (self = [super initWithFrame:frame]) {
	}
	return self;
}

- (id) initWithCoder:(NSCoder*)coder {
	if (self = [super initWithCoder:coder]) {
		pane = [coder decodeObjectForKey:@"pane"];
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	[coder encodeObject:pane forKey:@"pane"];
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

- (void) mouseDown:(NSEvent*)event {
	pressed = YES;
	[self setNeedsDisplay:YES];
}

- (void) mouseDragged:(NSEvent*)event {
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	pressed = NSPointInRect(point, [self bounds]);
	
	[self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent*)event {
	if (pressed)
		[pane toggleCollapsed:self];
	
	pressed = NO;
	[self setNeedsDisplay:YES];
}

@end
