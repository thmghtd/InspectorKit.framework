//
//  InspectorPaneView.m
//  InspectorPane
//
//  Created by Steven on 3/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <Inspector/InspectorPane.h>
#import "InspectorPaneInspector.h"

@implementation InspectorPane ( InspectorPane )

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
    [super ibPopulateKeyPaths:keyPaths];
	
    [[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:
	 [NSArray arrayWithObjects:@"resizable", @"minHeight", @"maxHeight", @"titleTextField.stringValue", nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
    [super ibPopulateAttributeInspectorClasses:classes];
    [classes addObject:[InspectorPaneInspector class]];
}

- (NSView *)ibDesignableContentView {
	return (NSView*)paneBody;
}

- (id) init {
	NSArray *topLevelObjects;
	
	NSNib *nib = [[[NSNib alloc] initWithNibNamed:@"InspectorLibrary" bundle:[NSBundle bundleForClass:[InspectorPaneInspector class]]] autorelease];
	[nib instantiateNibWithOwner:nil topLevelObjects:&topLevelObjects];
	
	for (id object in topLevelObjects) {
		if ([object isKindOfClass:[NSView class]]) {
			for (NSView *subview in [object subviews]) {
				if ([subview isKindOfClass:[InspectorPane class]]) {
					NSData *viewData = [NSKeyedArchiver archivedDataWithRootObject:subview];
					InspectorPane *pane = [NSKeyedUnarchiver unarchiveObjectWithData:viewData];
					NSLog(@"%@", pane);
					
					[pane setFrame:NSMakeRect(0, 0, 100, 100)];
					
					return [pane retain];
				}
			}
		}
	}
	
	return nil;
}

// no idea what this is

//- (IBDirection) ibPreferredResizeDirection {
//	return IBMaxYDirection;
//}

@end
