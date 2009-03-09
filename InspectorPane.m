//
//  InspectorPaneView.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPane.h"

#import "NSWindow+Geometry.h"

#import "InspectorPaneContainer.h"

#import <QuartzCore/QuartzCore.h>

@interface InspectorPane ( Private )
- (void) toggleCollapsedWithAnimation:(BOOL)animates;
- (NSRect) resizeHandleRect;
- (InspectorPaneContainer*) container;
- (void) addHeightToSize:(float)amount;
@end

@implementation InspectorPane

@synthesize resizable;
@synthesize minHeight;
@synthesize maxHeight;

- (id) initWithFrame:(NSRect)frame {
	if (self = [super initWithFrame:frame]) {
	}
	return self;
}

- (id) initWithCoder:(NSCoder*)coder {
	if (self = [super initWithCoder:coder]) {
		paneHead = [coder decodeObjectForKey:@"paneHead"];
		paneBody = [coder decodeObjectForKey:@"paneBody"];
		
		titleTextField = [coder decodeObjectForKey:@"titleTextField"];
		collapseButton = [coder decodeObjectForKey:@"collapseButton"];
		
		resizable = [coder decodeBoolForKey:@"resizable"];
		minHeight = [coder decodeFloatForKey:@"minHeight"];
		maxHeight = [coder decodeFloatForKey:@"maxHeight"];
		
		[self awakeFromNib];
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	
	[coder encodeObject:paneHead forKey:@"paneHead"];
	[coder encodeObject:paneBody forKey:@"paneBody"];
	
	[coder encodeObject:titleTextField forKey:@"titleTextField"];
	[coder encodeObject:collapseButton forKey:@"collapseButton"];
	
	[coder encodeBool:resizable forKey:@"resizable"];
	[coder encodeFloat:minHeight forKey:@"minHeight"];
	[coder encodeFloat:maxHeight forKey:@"maxHeight"];
}

- (void) awakeFromNib {
	uncollapsedHeight = NSHeight([self frame]);
	
	[[titleTextField cell] setBackgroundStyle:NSBackgroundStyleRaised];
}

- (void) setResizable:(BOOL)newResizable {
	resizable = newResizable;
	
	NSRect fullBodyFrame = [self bounds];
	NSRect headFrame = [paneHead frame];
	NSRect bodyFrame = [paneBody frame];
	NSRect resizingHandleFrame = [self resizeHandleRect];
	
	NSDivideRect(fullBodyFrame, &headFrame, &bodyFrame, NSHeight(headFrame), NSMaxYEdge);
	
	if (resizable)
		NSDivideRect(bodyFrame, &resizingHandleFrame, &bodyFrame, NSHeight(resizingHandleFrame) + 1, NSMinYEdge);
	
	NSLog(@"%@", NSStringFromRect(bodyFrame));
	
	[paneBody setFrame:bodyFrame];
	[self setNeedsDisplay:YES];
}

- (BOOL)mouseDownCanMoveWindow {
	return NO;
}

- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	[paneBody setAutoresizesSubviews:YES];
}

- (IBAction) toggleCollapsed:(id)sender {
	[self toggleCollapsedWithAnimation:YES];
}

- (void) toggleCollapsedWithAnimation:(BOOL)animate {
	if (SDIsInIB)
		return;
	
	[collapseButton setState:collapsed];
	
	collapsed = !collapsed;
	
	//[[self container] togglePane:self collapsed:collapsed];
	
	NSSize newSize = [paneHead frame].size;
	if (collapsed == NO)
		newSize.height = uncollapsedHeight;
	else
		newSize.height -= 1;
	
	NSRect newFrame = [self frame];
	newFrame.origin.y += newFrame.size.height - newSize.height;
	newFrame.size = newSize;
	
	id view = self;
	if (animate) {
		view = [self animator];
		
		BOOL slowMotion = ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) != 0;
		
		CABasicAnimation *animation = [CABasicAnimation animation];
		
		animation.duration = 0.15;
		if (slowMotion)
			animation.duration = animation.duration * 8.0;
		
		animation.delegate = self;
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		[view setAnimations:[NSDictionary dictionaryWithObject:animation forKey:@"frameSize"]];
	}
	
	[paneBody setAutoresizesSubviews:NO];
	
	[view setFrame:newFrame];
	
	// forgot what this code was for, or why its commented out.
	// dont care enough to uncomment it and test
	
//	if (animate == NO)
//		[[self bodyView] setAutoresizesSubviews:YES];
}

- (InspectorPaneContainer*) container {
	return (InspectorPaneContainer*)[self superview];
}

// MARK: -
// MARK: Resizable methods

- (void) drawRect:(NSRect)rect {
	//[[[NSColor purpleColor] colorWithAlphaComponent:0.5] drawSwatchInRect:[self bounds]];
	if (resizable == NO)
		return;
	
	NSColor *topColor = [NSColor colorWithCalibratedWhite:0.70 alpha:1.0];
	NSColor *fillColor = [NSColor colorWithCalibratedWhite:0.95 alpha:1.0];
	NSColor *handleColor = [NSColor colorWithCalibratedWhite:0.60 alpha:1.0];
	
	[fillColor setFill];
	[NSBezierPath fillRect:[self resizeHandleRect]];
	
	NSRect singlePixelRect = [self resizeHandleRect];
	singlePixelRect.origin.y = singlePixelRect.size.height - 0;
	singlePixelRect.size.height = 1;
	
	[topColor setFill];
	[NSBezierPath fillRect:singlePixelRect];
	
	singlePixelRect.origin.y = 0;
	
	NSRect middleHandleRect = singlePixelRect;
	middleHandleRect.origin.y = 2;
	middleHandleRect.size.width = NSWidth([self resizeHandleRect]) / 12.0;
	middleHandleRect.origin.x = NSMidX([self resizeHandleRect]) - (middleHandleRect.size.width / 2.0);
	
	[handleColor setFill];
	[NSBezierPath fillRect:middleHandleRect];
	
//	[[NSColor colorWithCalibratedWhite:0.0 alpha:0.03] setFill];
//	[NSBezierPath fillRect:[self resizeHandleRect]];
	
	if (pressed) {
		[[NSColor colorWithCalibratedWhite:0.0 alpha:0.07] setFill];
		[NSBezierPath fillRect:[self resizeHandleRect]];
	}
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	if (resizable) {
		NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
		return NSPointInRect(point, [self resizeHandleRect]);
	}
	else
		return [super acceptsFirstMouse:theEvent];
}

- (void) mouseDown:(NSEvent*)event {
	if (resizable == NO || SDIsInIB)
		return;
	
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	pressed = NSPointInRect(point, [self resizeHandleRect]);
	
	if (pressed)
		heightFromBottom = point.y;
	
	[self setNeedsDisplay:YES];
}

- (void) mouseDragged:(NSEvent*)event {
	if (resizable == NO || SDIsInIB)
		return;
	
	if (pressed == NO)
		return;
	
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	
	float growByAmount = heightFromBottom - point.y;
	[self addHeightToSize:growByAmount];
}

- (void) mouseUp:(NSEvent*)event {
	if (resizable == NO || SDIsInIB)
		return;
	
	if (pressed == NO)
		return;
	
	uncollapsedHeight = [self frame].size.height;
	pressed = NO;
	[self setNeedsDisplay:YES];
	
	//[[self container] setHeight:uncollapsedHeight forPane:self];
}

- (void) resetCursorRects {
	if (resizable)
		[self addCursorRect:[self resizeHandleRect] cursor:[NSCursor resizeUpDownCursor]];
}

- (NSRect) resizeHandleRect {
	if (resizable == NO)
		return NSZeroRect;
	
	NSRect rect = [self bounds];
	rect.size.height = 5;
	return rect;
}

- (void) addHeightToSize:(float)amount {
	if (resizable == NO)
		return;
	
	NSRect newFrame = [self frame];
	
	float margins = 17.0 + NSHeight([self resizeHandleRect]);
	
	if (newFrame.size.height + amount < margins + minHeight)
		amount = minHeight + margins - newFrame.size.height;
	else if ((maxHeight > 0) && newFrame.size.height + amount > margins + maxHeight)
		amount = maxHeight + margins - newFrame.size.height;
	
	newFrame.size.height += amount;
	newFrame.origin.y += amount;
	
	[self setFrame:newFrame];
}

@end
