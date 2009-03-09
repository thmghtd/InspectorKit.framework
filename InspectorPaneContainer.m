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

@interface InspectorPaneContainer ( Private )
- (void) adjustActualWindowToFitContainer;
- (void) togglePane:(InspectorPane*)pane collapsed:(BOOL)collapsed;
- (void) repositionViewsIgnoringView:(NSView*)viewToIgnore;
@end

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
		autosaveName = [[coder decodeObjectForKey:@"SDAutosaveName"] retain];
		
		NSArray *subviews = [coder decodeObjectForKey:@"SDSubviews"];
		[self setSubviews:subviews];
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder {
	[super encodeWithCoder:coder];
	
	[coder encodeObject:autosaveName forKey:@"SDAutosaveName"];
	[coder encodeObject:[self subviews] forKey:@"SDSubviews"];
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
	topMargin = NSHeight([[self superview] frame]) - NSMaxY([self frame]);
	
	if (SDIsInIB == NO) {
		[self adjustActualWindowToFitContainer];
		
		[[self window] setShowsResizeIndicator:NO];
		[[self window] setMovableByWindowBackground:YES];
		
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetWindowSize:) name:NSApplicationWillTerminateNotification object:NSApp];
		
		for (NSView *subview in [self subviews]) {
			if ([subview isHidden])
				continue;
			
			[subview setPostsFrameChangedNotifications:YES];
			
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(adjustSubviewFrames:)
														 name:NSViewFrameDidChangeNotification
													   object:subview];
		}
		
		[self repositionViewsIgnoringView:nil];
	}
}

- (void) adjustSubviewFrames:(NSNotification*)notification {
	[self repositionViewsIgnoringView:[notification object]];
}

- (void) adjustActualWindowToFitContainer {
	float distanceFromTop = NSHeight([[self superview] frame]) - NSMaxY([self frame]);
	NSRect selfFrame = [self frame];
	
	selfFrame.size.height -= 20.0;
	
	NSSize newContentViewSize = selfFrame.size;
	newContentViewSize.height += distanceFromTop;
	[[self window] setContentViewSize:newContentViewSize display:YES animate:NO];
	
	selfFrame.origin.x = 0;
	selfFrame.origin.y = 0;
	[self setFrame:selfFrame];
}

// this apparently is only here for persistence.. its thus horribly named :/
- (void) togglePane:(InspectorPane*)pane collapsed:(BOOL)collapsed {
	//int index = [[self subviews] indexOfObject:view];
	//[collapsedSubviewIndexes replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:collapsed]];
}

- (void) repositionViewsIgnoringView:(NSView*)viewToIgnore {
	float top = 0.0;
	for (NSView *view in [[self subviews] objectEnumerator]) {
		NSRect newFrame = [view frame];
		newFrame.origin.y = [self frame].size.height - (newFrame.size.height + top);
		
		if (view == viewToIgnore)
			[view setPostsFrameChangedNotifications:NO];
		
		[view setFrame:newFrame];
		
		if (view == viewToIgnore)
			[view setPostsFrameChangedNotifications:YES];
		
		top += newFrame.size.height;
	}
	
	NSView *contentView = [self superview];
	
	NSRect newMainFrame = [self bounds];
	newMainFrame.origin.y = [contentView frame].size.height - newMainFrame.size.height - topMargin;
	newMainFrame.size.height = top;
	[self setFrame:newMainFrame];
	
	NSSize contentViewSize = newMainFrame.size;
	contentViewSize.height += topMargin;
	NSRect newWindowFrame = [[self window] windowFrameForNewContentViewSize:contentViewSize];
	[[self window] setFrame:newWindowFrame display:YES];
}

@end
