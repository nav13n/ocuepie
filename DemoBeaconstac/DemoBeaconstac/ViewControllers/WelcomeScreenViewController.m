//
//  WelcomeScreenViewController.m
//  DemoBeaconstac
//
//  Created by Neeraj Kumar on 08/11/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "BeaconStacWrapper.h"
#import "ScrollerCollectionViewCell.h"
#import "DataManager.h"
#import "GlobalConstants.h"
#import "MainViewController.h"

@interface WelcomeScreenViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIButton *topView;
@property (nonatomic, strong)UIButton *bottomView;
@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForNotifications];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [BeaconStacWrapper sharedInstance];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ScrollerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CellIdentifier"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self configureTopAndBottomView];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(justReachedNotification:) name:JUST_REACHED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredHallNotification:) name:ENTERED_HALL_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBathroomNotification:) name:ENTERED_BATHROOM_NOTIFICATION object:nil];
    
}

- (void)justReachedNotification:(NSNotification *)notification {
    self.data = [DataManager dataForJustReached][@"data"];
    [self.collectionView reloadData];
    if ([DataManager dataForJustReached][@"top"]) {
        [self showTopView:YES withText:[DataManager dataForJustReached][@"top"]];
    }
    if ([DataManager dataForJustReached][@"bottom"]) {
        [self showBottomView:YES withText:[DataManager dataForJustReached][@"bottom"]];
    }
}

- (void)enteredHallNotification:(NSNotification *)notification {
    
    
    [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.title = @"You are in Hall";
        self.data = [DataManager dataForHall][@"data"];
        [self.collectionView setContentOffset:CGPointZero];
        [self.collectionView reloadData];
        if ([DataManager dataForHall][@"top"]) {
            [self showTopView:YES withText:[DataManager dataForHall][@"top"]];
        }
        else {
            [self showTopView:NO withText:@""];
        }
        if ([DataManager dataForHall][@"bottom"]) {
            [self showBottomView:YES withText:[DataManager dataForHall][@"bottom"]];
        }
        else {
            [self showBottomView:NO withText:@""];
        }

    } completion:^(BOOL finished) {
    }];

 }

- (void)enteredBathroomNotification:(NSNotification *)notification {
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.title = @"You are in Kitchen";
        self.data = [DataManager dataForBathroom][@"data"];
        [self.collectionView setContentOffset:CGPointZero];
        [self.collectionView reloadData];
        if ([DataManager dataForBathroom][@"top"]) {
            [self showTopView:YES withText:[DataManager dataForBathroom][@"top"]];
        }
        else {
            [self showTopView:NO withText:@""];
        }
        if ([DataManager dataForBathroom][@"bottom"]) {
            [self showBottomView:YES withText:[DataManager dataForBathroom][@"bottom"]];
        }
        else {
            [self showBottomView:NO withText:@""];
        }

    } completion:^(BOOL finished) {
    }];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)configureTopAndBottomView {
    self.topView = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 50)];
    [self.topView setBackgroundColor:[UIColor grayColor]];
    self.topView.hidden = YES;
    [self.topView setTitle:@"Customize" forState:UIControlStateNormal];
    [self.topView addTarget:self action:@selector(topViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topView];
    
    
    self.bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
    self.bottomView.hidden = YES;
    [self.bottomView setTitle:@"Turn left to move to Kitchen" forState:UIControlStateNormal];
    [self.bottomView setBackgroundColor:[UIColor grayColor]];
    [self.bottomView addTarget:self action:@selector(bottomViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView];
    
}

- (void)topViewClicked {
    // Take to customize.
    MainViewController *viewCon = [[MainViewController alloc] init];
    [self presentViewController:viewCon animated:YES completion:nil];
}

- (void)bottomViewClicked {
    //do nothing.
}


- (void)showTopView:(BOOL)show withText:(NSString *)text {
    [self.topView setTitle:text forState:UIControlStateNormal];
    if (show) {
        self.topView.alpha = 0.0;
        self.topView.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.topView.alpha = 1.0;
        }];
    }
    else {
        self.topView.alpha = 1.0;
        [UIView animateWithDuration:0.4 animations:^{
            self.topView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.topView.hidden = YES;
        }];

    }
}

- (void)showBottomView:(BOOL)show withText:(NSString *)text {
    [self.bottomView setTitle:text forState:UIControlStateNormal];
    if (show) {
        self.bottomView.alpha = 0.0;
        self.bottomView.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.bottomView.alpha = 1.0;
        }];
    }
    else {
        self.bottomView.alpha = 1.0;
        [UIView animateWithDuration:0.4 animations:^{
            self.bottomView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.bottomView.hidden = YES;
        }];
    }
}

#pragma mark - UICollectionViewDataSource and Delegate.

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScrollerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    [cell populateCellWithData:self.data[indexPath.row]];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
