#import "MainViewController.h"
#import "OverlayView.h"

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412

//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showCameraOverlay:nil];
    button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 80, 50)];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.overlayView addSubview:button];
}

- (void)cancelClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) showCameraOverlay:(id)sender {
	
	//create an overlay view instance
	OverlayView *overlay = [[OverlayView alloc]
							initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
	self.overlayView=overlay;
	//create a new image picker instance
	UIImagePickerController *picker =
	[[UIImagePickerController alloc] init];
	//set source to video!
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	//hide all controls
	picker.showsCameraControls = NO;
	picker.navigationBarHidden = YES;
	picker.toolbarHidden = YES;
	//make the video preview full size
//	picker.wantsFullScreenLayout = YES;
	picker.cameraViewTransform =
	CGAffineTransformScale(picker.cameraViewTransform,
						   CAMERA_TRANSFORM_X,
						   CAMERA_TRANSFORM_Y);
	//set our custom overlay view
    
    //Add a UICollectionView overlay to the overlay controller
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGTH-100,SCREEN_WIDTH, 100) collectionViewLayout:layout];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"OverlayViewCell"];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    [overlay addSubview:collectionView];
    
    //initialize overlay collection data
    NSMutableArray *collectionData= [[NSMutableArray alloc] init];
    [collectionData addObject:[UIImage imageNamed:@"HallObject1.jpg"]];
    [collectionData addObject:[UIImage imageNamed:@"HallObject2.jpg"]];
    [collectionData addObject:[UIImage imageNamed:@"HallObject3.jpg"]];
    self.overlayCollectionData=collectionData;
    
	picker.cameraOverlayView = overlay;
	
	//show picker
	//[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
	
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.overlayCollectionData count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"OverlayViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.overlayCollectionData objectAtIndex:indexPath.row]];
    imageView.frame = CGRectMake(0, 0, [(UIImage *)[self.overlayCollectionData objectAtIndex:indexPath.row] size].width, [(UIImage *)[self.overlayCollectionData objectAtIndex:indexPath.row] size].height);
    [cell.contentView addSubview:imageView];
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(100, 100);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5,5 , 5, 5);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image= [UIImage imageNamed:[NSString stringWithFormat:@"HallObject%ldFull.jpg",(long)indexPath.row + 1]];
    UIView *addedOverlay=[[UIView alloc] initWithFrame:CGRectMake(100, 200, 150, 150)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    imageView.image = image;
    [addedOverlay addSubview:imageView];
    addedOverlay.tag=indexPath.row;
    [self.overlayView addSubview:addedOverlay];
}
     
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
 //  [[self.overlayView viewWithTag:(indexPath.row)] removeFromSuperview];
}


- (void)dealloc {
    self.overlayCollectionData=nil;
    self.overlayView=nil;
}


@end
