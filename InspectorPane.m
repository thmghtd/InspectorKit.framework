//
//  InspectorPaneView.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "InspectorPane.h"

#import "NSWindow+Geometry.h"

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
//	distanceFromTop = NSHeight([[self superview] frame]) - NSMaxY([self frame]);
	//NSLog(@"awaking! %f , %f", NSHeight([[self superview] frame]), NSMaxY([self frame]));
	
	[[titleTextField cell] setBackgroundStyle:NSBackgroundStyleRaised];
	
	if (SDIsInIB) {
//		[titleTextField setSelectable:YES];
//		[titleTextField setEditable:YES];
	}
}

- (IBAction) toggleCollapsed:(id)sender {
	[self toggleCollapsedWithAnimation:YES];
}

- (void) toggleCollapsedWithAnimation:(BOOL)animates {
	NSRect newFrame = [self frame];
	
	if (collapsed) {
		newFrame.origin.y = NSHeight([[self superview] frame]) - distanceFromTop - uncollapsedHeight;
		newFrame.size.height = uncollapsedHeight;
	}
	else {
		uncollapsedHeight = [self frame].size.height;
		newFrame.origin.y = NSHeight([[self superview] frame]) - distanceFromTop - 17.0;
		newFrame.size.height = 17.0;
	}
	
	id view = (animates ? [self animator] : self);
	
	[view setFrame:newFrame];
	
	collapsed = !collapsed;
	
	//	NSSize size = [[[self window] contentView] frame].size;
	//	size.height += 20;
	//	[[self window] setContentViewSize:size display:YES animate:YES];
}

- (void) drawRect:(NSRect)rect {
	return;
	
	if (SDIsInIB) {
		NSRect frame = [self bounds];
		//frame.origin.x += 0.5;
		//frame.origin.y += 0.5;
		
		[[[NSColor blueColor] colorWithAlphaComponent:0.5] setStroke];
		[NSBezierPath strokeRect:frame];
	}
}

@end
