//
//  OverlayView.m
//  CameraOverlay
//
//  Created by Andreas Katzian on 12.05.10.
//  Copyright 2010 Blackwhale GmbH. All rights reserved.
//

#import "OverlayView.h"


@implementation OverlayView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)dealloc {
}


@end
