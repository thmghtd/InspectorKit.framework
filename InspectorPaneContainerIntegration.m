//
//  InspectorPaneContainerIntegration.m
//  InspectorPane
//
//  Created by Steven on 3/8/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <InspectorKit/InspectorPaneContainer.h>
#import "InspectorPaneContainerInspector.h"

#import "NSWindow+Geometry.h"
#import "NSBezierPath+StrokeExtensions.h"

@interface InspectorPaneContainer ( InspectorPaneContainer )
- (void) adjustIBWindowFrame;
- (void) adjustPaneFrames;
@end

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
								[NSFont fontWithName:@"Geneva" size:10.0], NSFontAttributeName,
//								[NSColor whiteColor], NSForegroundColorAttributeName,
								paragraphStyle, NSParagraphStyleAttributeName,
								nil];
	
	NSRect bottomRect;
	NSRect mainRect;
	NSDivideRect(frame, &bottomRect, &mainRect, 20.0, NSMinYEdge);
	
	[[NSColor lightGrayColor] setStroke];
	float mainRadius = 12.0;
	
	mainRect = NSInsetRect(mainRect, 2.0, 2.0);
	
	CGFloat dashArray[] = { 15.0, 7.0 };
	
	NSBezierPath *containerPath = [NSBezierPath bezierPathWithRoundedRect:mainRect xRadius:mainRadius yRadius:mainRadius];
	[containerPath setLineWidth:3.0];
	[containerPath setLineDash:dashArray count:2 phase:0.0];
	[containerPath strokeInside];
	
	bottomRect.size.height = 17.0;
	
	bottomRect = NSInsetRect(bottomRect, -1.0, -1.0);
	
	[[NSColor lightGrayColor] setFill];
	NSRectFill(bottomRect);
	
	NSRect bottomBorderRect = bottomRect;
	bottomBorderRect.origin.y = bottomBorderRect.size.height;
	bottomBorderRect.size.height = 1.0;
	
	[[NSColor darkGrayColor] setFill];
	NSRectFill(bottomBorderRect);
	
	NSRect textRect = bottomRect;
	textRect.origin.y -= 1.0;
	[@"Click here to select Inspector Container" drawInRect:textRect withAttributes:attributes];
	
	//	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:bottomRect xRadius:r yRadius:r];
//	[path setLineWidth:1.0];
//	[path setLineDash:dashArray count:2 phase:0.0];
//	[path strokeInside];
}

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
	
	//[self adjustIBWindowFrame];
	
	NSEnableScreenUpdates();
}

- (void)didAddSubview:(NSView *)subview {
	[super didAddSubview:subview];
	[self performSelector:@selector(adjustPaneFrames) withObject:nil afterDelay:0.0];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(adjustSubviewFramesDuringDesignTime:)
												 name:NSViewFrameDidChangeNotification
											   object:subview];
}

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

- (void) adjustSubviewFramesDuringDesignTime:(NSNotification*)notification {
	[self adjustPaneFrames];
	[self performSelector:@selector(adjustPaneFrames) withObject:nil afterDelay:0.0];
}

- (void) setFrame:(NSRect)newFrame {
	[super setFrame:newFrame];
	
	if ([self window])
		[self performSelector:@selector(adjustIBWindowFrame) withObject:nil afterDelay:0.0];
}

- (void)viewDidMoveToWindow {
	if ([self window])
		[self performSelector:@selector(adjustIBWindowFrame) withObject:nil afterDelay:0.0];
}

- (void) adjustIBWindowFrame {
	NSPoint origin = [self frame].origin;
	origin.x = 0;
	[self setFrameOrigin:origin];
	
//	float bottomMargin = NSMinY([self frame]);
	
	topMargin = NSHeight([[self superview] frame]) - NSMaxY([self frame]);
	
//	if (bottomMargin < 0) {
		NSSize contentViewSize = [[[self window] contentView] frame].size;
		contentViewSize.width = NSWidth([self frame]);
//		contentViewSize.height += (0.0 - bottomMargin);
		contentViewSize.height = NSHeight([self frame]) + topMargin;
		[[self window] setContentViewSize:contentViewSize display:YES animate:NO];
//	}
}

@end
