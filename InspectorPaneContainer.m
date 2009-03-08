//
//  InspectorContainer.m
//  InspectorPane
//
//  Created by Steven on 3/8/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPaneContainer.h"
#import "InspectorPane.h"

#import "NSWindow+Geometry.h"

@implementation InspectorPaneContainer

@synthesize autosaveName;

- (id)initWithFrame:(NSRect)frame {
	if (self = [super initWithFrame:frame]) {
		autosaveName = [@"Some_Inspector" retain];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder {
	if (self = [super initWithCoder:coder]) {
		autosaveName = [[coder decodeObjectForKey:@"autosaveName"] retain];
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	
	[coder encodeObject:autosaveName forKey:@"autosaveName"];
}

- (void) dealloc {
	for (NSView *subview in [self subviews]) {
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:NSViewFrameDidChangeNotification
													  object:subview];
	}
	
	[autosaveName release];
	
	[super dealloc];
}

- (void) awakeFromNib {
	if (SDIsInIB == NO) {
		for (NSView *subview in [self subviews]) {
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(adjustSubviewFrames:)
														 name:NSViewFrameDidChangeNotification
													   object:subview];
		}
		
		[self adjustActualWindowToFitContainer];
	}
}

// In IB only
- (void) adjustPaneFrames {
	NSDisableScreenUpdates();
	
	NSRect mainFrame = [self frame];
	
	float distanceFromTop = NSHeight([[self superview] frame]) - NSMaxY(mainFrame);
	
	float totalHeight = 20.0;
	
	for (NSView *subview in [self subviews])
		totalHeight += NSHeight([subview frame]);
	
	mainFrame.origin.y = NSHeight([[self superview] frame]) - distanceFromTop - totalHeight;
	mainFrame.size.height = totalHeight;
	[self setFrame:mainFrame];
	
	totalHeight = 20.0;
	
	for (NSView *subview in [[self subviews] reverseObjectEnumerator]) {
		NSRect frame = [subview frame];
		
		// testing
		frame.origin.y = totalHeight;
		
		frame.origin.x = 0;
		frame.size.width = mainFrame.size.width;
		
		[subview setFrame:frame];
		
		totalHeight += NSHeight(frame);
	}
	
	[self adjustIBWindowIfNeeded];
	
	NSEnableScreenUpdates();
}

// In IB only
- (void)didAddSubview:(NSView *)subview {
	[super didAddSubview:subview];
	[self performSelector:@selector(adjustPaneFrames) withObject:nil afterDelay:0.0];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(adjustSubviewFramesDuringDesignTime:)
												 name:NSViewFrameDidChangeNotification
											   object:subview];
}

// In IB only
- (void)willRemoveSubview:(NSView *)subview {
	// When designers drag around the container, this is called continuously, and falsely
	if ([[self subviews] containsObject:subview] == NO)
		return;
	
	[super willRemoveSubview:subview];
	[self performSelector:@selector(adjustPaneFrames) withObject:nil afterDelay:0.0];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSViewFrameDidChangeNotification
												  object:subview];
}

// In IB only
- (void) adjustSubviewFramesDuringDesignTime:(NSNotification*)notification {
	[self adjustPaneFrames];
	[self performSelector:@selector(adjustPaneFrames) withObject:nil afterDelay:0.0];
}

- (void) adjustSubviewFrames:(NSNotification*)notification {
	// place the code in here later that will do the same as SDInspector's container view
}

- (void)viewDidMoveToWindow {
	if (SDIsInIB && [self window])
		[self performSelector:@selector(adjustIBWindowIfNeeded) withObject:nil afterDelay:0.0];
}

- (void) adjustIBWindowIfNeeded {
	float bottomMargin = NSMinY([self frame]);
	
	if (bottomMargin < 0) {
		NSSize contentViewSize = [[[self window] contentView] frame].size;
		contentViewSize.height += 20 - bottomMargin;
		[[self window] setContentViewSize:contentViewSize display:YES animate:NO];
	}
	
	NSLog(@"wndow:%@", [self window]);
}

- (void) adjustActualWindowToFitContainer {
	float distanceFromTop = NSHeight([[self superview] frame]) - NSMaxY([self frame]);
	NSSize newContentViewSize = [self bounds].size;
	newContentViewSize.height += distanceFromTop - 20.0;
	[[self window] setContentViewSize:newContentViewSize display:YES animate:NO];
	
	NSRect frame = [self frame];
	frame.origin.x = 0;
	//frame.origin.y = 0;
	[self setFrame:frame];
}

@end
