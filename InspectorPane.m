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

- (void) drawRect:(NSRect)rect {
	//[[[NSColor purpleColor] colorWithAlphaComponent:0.5] drawSwatchInRect:[self bounds]];
}

- (InspectorPaneContainer*) container {
	return (InspectorPaneContainer*)[self superview];
}

@end
