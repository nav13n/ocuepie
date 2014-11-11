//
//  MainViewController.h
//  CameraOverlay
//
//  Created by Andreas Katzian on 12.05.10.
//  Copyright 2010 Blackwhale GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"


@interface MainViewController : UIViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource> {

    UIButton *button;
   
    
}
@property (nonatomic,retain) NSArray *overlayCollectionData;
@property (nonatomic,retain) OverlayView *overlayView;

- (IBAction) showCameraOverlay:(id)sender;


@end
