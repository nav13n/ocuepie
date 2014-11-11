//
//  BeaconStacWrapper.m
//  DemoBeaconstac
//
//  Created by Neeraj Kumar on 08/11/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import "BeaconStacWrapper.h"
@import CoreLocation;
#import <Beaconstac_v_0_9_7/Beaconstac.h>
#import "VideoAndAudioViewController.h"
#import "GlobalConstants.h"

@interface BeaconStacWrapper()<CLLocationManagerDelegate, BeaconstacDelegate> {
     Beaconstac *beaconstac;
    BOOL doneOnce;
    BOOL doneOnce1;
    BOOL doneOnce2;
}
@property (nonatomic, strong)CLLocationManager *locationManager;
@end

@implementation BeaconStacWrapper

+ (BeaconStacWrapper *)sharedInstance {
    static BeaconStacWrapper *sharedInstance = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        sharedInstance = [[BeaconStacWrapper alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
         doneOnce = NO;
        // Make sure main thread!!!.
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.locationManager = [[CLLocationManager alloc] init];
               self.locationManager.delegate = self;
                
            });
        }
        else {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
    }
    
    // Change the log level here.
    [[MSLogger sharedInstance]setLoglevel:MSLogLevelNone];
    
    // Setup and initialize the Beaconstac SDK
    BOOL success = [Beaconstac setupOrganizationId:86
                                         userToken:@"ad635c7c235e18d1e2570c7cdc67e79edf99bfbc"
                                        beaconUUID:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
                                  beaconIdentifier:@"com.app.socialbeacon"];
    
    // Credentials end
    
    if (success) {
        NSLog(@"DemoApp:Successfully saved credentials.");
    }
    
    beaconstac = [[Beaconstac alloc]init];
    beaconstac.delegate = self;
    
    return self;
}

#pragma mark - Beaconstac delegate
// Tells the delegate a list of beacons in range.
- (void)beaconsRanged:(NSDictionary *)beaconsDictionary
{
    //NSLog(@"%@", beaconsDictionary);
}

// Tells the delegate about the camped on beacon among available beacons.
- (void)campedOnBeacon:(MSBeacon*)beacon amongstAvailableBeacons:(NSDictionary *)beaconsDictionary
{
    //    NSLog(@"DemoApp:Entered campedOnBeacon");
    //   NSLog(@"DemoApp:campedOnBeacon: %@", beacon.beaconKey);
    //   NSLog(@"DemoApp:facts Dict: %@", beaconstac.factsDictionary);
}

// Tells the delegate when the device exits from the camped on beacon range.
- (void)exitedBeacon:(MSBeacon*)beacon
{
    //   NSLog(@"DemoApp:Entered exitedBeacon");
    //   NSLog(@"DemoApp:exitedBeacon: %@", beacon.beaconKey);
    if ([beacon.beaconKey isEqualToString:NEERAJ_BEACON_KEY]) {
        [self exitedNeerajBeacon];
    }
    else if ([beacon.beaconKey isEqualToString:NAVEEN_BEACON_KEY]) {
        [self exitedNaveenBeacon];
    }
}

// Tells the delegate that a rule is triggered with corresponding list of actions.
- (void)ruleTriggeredWithRuleName:(NSString *)ruleName actionArray:(NSArray *)actionArray
{
    
    if ([ruleName isEqualToString:ENTER_NEERAJ_BEACON_RULE]) {
        [self enteredNeerajBeacon:actionArray];
        return;
    }
    else if ([ruleName isEqualToString:ENTER_NAVEEN_BEACON_RULE]) {
        [self enteredNaveenBeacon:actionArray];
        return;
    }
//    
//    NSLog(@"DemoApp:Action Array: %@", actionArray);
//    //
//    // actionArray contains the list of actions to trigger for the rule that matched.
//    //
//    for (NSDictionary *actionDict in actionArray) {
//        //
//        // meta.action_type can be "popup", "webpage", "media", or "custom"
//        //
//        if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"popup"]) {
//            //
//            // Show an alert
//            //
//            NSLog(@"DemoApp:Text Alert action type");
//            NSString *message = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"text"];
//            [[[UIAlertView alloc] initWithTitle:ruleName message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
//            
//        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"webpage"]) {
//            //
//            // Handle webpage by popping up a WebView
//            //
//            NSLog(@"DemoApp:Webpage action type");
//            CGRect screenRect = [[UIScreen mainScreen] bounds];
//            UIWebView *webview=[[UIWebView alloc]initWithFrame:screenRect];
//            NSString *url=[[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
//            NSURL *nsurl=[NSURL URLWithString:url];
//            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//            [webview loadRequest:nsrequest];
//            
//            [self.view addSubview:webview];
//            
//            // Setting title of the current View Controller
//            self.title = @"Webpage action";
//            
//        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"video"]) {
//            //
//            // Media type - video
//            //
//            NSLog(@"DemoApp:Media action type video");
//            mediaType = @"video";
//            mediaUrl = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
//            [self performSegueWithIdentifier:@"AudioAndVideoSegue" sender:self];
//            
//        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"audio"]) {
//            //
//            // Media type - audio
//            //
//            NSLog(@"DemoApp:Media action type audio");
//            mediaType = @"audio";
//            mediaUrl = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
//            
//            [self performSegueWithIdentifier:@"AudioAndVideoSegue" sender:self];
//            
//        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"custom"]) {
//            //
//            // Custom JSON converted to NSDictionary - it's up to you how you want to handle it
//            //
//            NSDictionary *params = [[actionDict objectForKey:@"meta"]objectForKey:@"params"];
//            NSLog(@"DemoApp:Received custom action_type: %@", params);
//            
//        }
//    }
}

// Notifies the view controller that a segue is about to be performed.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass media url and media type to the VideoAndAudioViewController.
    if ([segue.identifier isEqualToString:@"AudioAndVideoSegue"]) {
        VideoAndAudioViewController *videoAndAudioVC = segue.destinationViewController;
//        videoAndAudioVC.title = [NSString stringWithFormat:@"%@ action", mediaType];
//        videoAndAudioVC.mediaUrl = mediaUrl;
//        videoAndAudioVC.mediaType = mediaType;
    }
}






//////////////////// SocialBeacon team addition ////////////////////////


// Exit beacon handlers.

- (void)exitedNeerajBeacon {
    NSLog(@"Exited Neeraj Beacon.");
 //   [[[UIAlertView alloc] initWithTitle:@"Exited Neeraj Beacon." message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}
- (void)exitedNaveenBeacon {
    NSLog(@"Exited Naveen Beacon.");
//    [[[UIAlertView alloc] initWithTitle:@"Exited Naveen Beacon." message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

// Enter beacon handlers.

// Neeraj beacon - Outside beacon.
- (void)enteredNeerajBeacon:(NSArray *)actionArray {
    NSLog(@"Entered Neeraj Beacon");
   // [[[UIAlertView alloc] initWithTitle:@"Entered Neeraj Beacon" message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    // Local you have reached this home.
    // Notification to show that user reached outside.
    
    if (!doneOnce) {
        doneOnce = YES;
        UILocalNotification *notification = [[UILocalNotification alloc] init];
         notification.alertBody = @"Welcome you have reached the house x at location y.";
        // Registering for receiving local notifications when a user enters a beacon region for iOS 8
        // and previous versions respectively.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
        }
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
#else
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
#endif

        [[NSNotificationCenter defaultCenter] postNotificationName:JUST_REACHED_NOTIFICATION object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:ENTERED_HALL_NOTIFICATION object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ENTERED_HALL_NOTIFICATION object:nil];
        });
    }
}

- (void)enteredNaveenBeacon:(NSArray *)actionArray {
    NSLog(@"Entered Naveen Beacon");
    if (!doneOnce1) {
        doneOnce1 = YES;
         [[NSNotificationCenter defaultCenter] postNotificationName:ENTERED_BATHROOM_NOTIFICATION object:nil];
    }
   // [[[UIAlertView alloc] initWithTitle:@"Entered Naveen Beacon" message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

@end

