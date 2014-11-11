//
//  DataManager.m
//  DemoBeaconstac
//
//  Created by Neeraj Kumar on 08/11/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (NSDictionary *)dataForJustReached {
    return @{
             @"data":@[
                     @{
                        @"image":@"Garage.jpg",
                        @"text":@"You have got a big garage.",
                        },
                     @{
                         @"image":@"Gymansium.jpg",
                         @"text":@"You have got an awesome gymnasium.",
                         
                         
                      },
                     @{
                         @"image":@"Gymansium.jpg",
                         @"text":@"You have got an awesome gymnasium.",
                         
                         
                         },
                     @{
                         @"image":@"SwimmingPool.jpg",
                         @"text":@"Get drowned in the olypic size swimming pool of yours.",
                         
                         },
                     ],
                  @"bottom":@"Move straight to enter Hall",
             
             };
}

+ (NSDictionary *)dataForHall {
    return @{
             
             @"top":@"Customize",
             @"bottom":@"Turn left to move to bathroom.",
             @"data":@[
                     @{
                         @"image":@"Hall.jpg",
                         @"text":@"This hall has size 900 square feet.",
                         },
                     @{
                         @"image":@"Hall.jpg",
                         @"text":@"This hall has size 900 square feet.",
                         
                         
                         },
                     @{
                         @"image":@"Hall.jpg",
                         @"text":@"This hall has size 900 square feet.",
                         
                         
                         },
                     @{
                         @"image":@"Hall.jpg",
                         @"text":@"This hall has size 900 square feet.",
                         
                         
                         },
                     @{
                         @"image":@"Hall.jpg",
                         @"text":@"This hall has size 900 square feet.",
                         
                         
                         },
                     
                     ]
             
             
             };
}

+ (NSDictionary *)dataForBathroom {
    return @{             @"data":@[
                                  @{
                                      @"image":@"bathroom.jpg",
                                      @"text":@"Your bathroom sized 500 squarefeet.",
                                      },
                                  @{
                                      @"image":@"bathroom.jpg",
                                      @"text":@"Your bathroomware is from X company. ",
                                      
                                      
                                      },
                                  @{
                                      @"image":@"bathroom.jpg",
                                      @"text":@"You have six feet tub sized.",
                                      
                                      
                                      },
                                  ]
             
             };
}
@end
