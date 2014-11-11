//
//  ScrollerCollectionViewCell.m
//  DemoBeaconstac
//
//  Created by Neeraj Kumar on 08/11/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import "ScrollerCollectionViewCell.h"

@interface ScrollerCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ScrollerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)populateCellWithData:(NSDictionary *)data {
    self.bgImageView.image = [UIImage imageNamed:data[@"image"]];
    self.label.text = data[@"text"];
}





@end
