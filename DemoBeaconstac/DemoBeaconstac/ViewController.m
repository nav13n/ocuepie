//
//  ViewController.m
//  DemoBeaconstac
//
//  Created by Garima Batra on 8/26/14.
//  Copyright (c) 2014 MobStac Inc. All rights reserved.
//

#import "ViewController.h"
#import "VideoAndAudioViewController.h"
#import "GlobalConstants.h"

@interface ViewController ()
{
    Beaconstac *beaconstac;
    NSString *mediaType;
    NSString *mediaUrl;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    self.title = @"Demo Beaconstac";
    
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

    // Demonstrates Custom Attributes functionality.
    [self customAttributeDemo];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
// This method explains how to use custom attributes through Beaconstac SDK. You can create a new Custom
// Attribute from Beaconstac developer portal. You can then create (or edit) a rule and add the Custom
// attribute to the rule. Then, you can define an action for the rule you just created (or edited).
// For eg. you created a custom attribute called "gender" of type "string". In the rule, you can add a
// custom attribute, gender matches female and associate an action with the rule, say "Text Alert" saying
// "Gender is female". Now, in the app, you can set the "gender" of the user by updating facts in the SDK.
// The rule gets triggered when the facts you update in the app satisfies the custom attribute condition.
//
- (void)customAttributeDemo
{
    [beaconstac updateFact:@"female" forKey:@"Gender"];
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
    
     NSLog(@"DemoApp:Action Array: %@", actionArray);
    //
    // actionArray contains the list of actions to trigger for the rule that matched.
    //
    for (NSDictionary *actionDict in actionArray) {
        //
        // meta.action_type can be "popup", "webpage", "media", or "custom"
        //
        if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"popup"]) {
            //
            // Show an alert
            //
            NSLog(@"DemoApp:Text Alert action type");
            NSString *message = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"text"];
            [[[UIAlertView alloc] initWithTitle:ruleName message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"webpage"]) {
            //
            // Handle webpage by popping up a WebView
            //
            NSLog(@"DemoApp:Webpage action type");
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            UIWebView *webview=[[UIWebView alloc]initWithFrame:screenRect];
            NSString *url=[[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            NSURL *nsurl=[NSURL URLWithString:url];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [webview loadRequest:nsrequest];
            
            [self.view addSubview:webview];
            
            // Setting title of the current View Controller
            self.title = @"Webpage action";
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"video"]) {
            //
            // Media type - video
            //
            NSLog(@"DemoApp:Media action type video");
            mediaType = @"video";
            mediaUrl = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            [self performSegueWithIdentifier:@"AudioAndVideoSegue" sender:self];
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"audio"]) {
            //
            // Media type - audio
            //
            NSLog(@"DemoApp:Media action type audio");
            mediaType = @"audio";
            mediaUrl = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            
            [self performSegueWithIdentifier:@"AudioAndVideoSegue" sender:self];
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"custom"]) {
            //
            // Custom JSON converted to NSDictionary - it's up to you how you want to handle it
            //
            NSDictionary *params = [[actionDict objectForKey:@"meta"]objectForKey:@"params"];
            NSLog(@"DemoApp:Received custom action_type: %@", params);
            
        }
    }
}

// Notifies the view controller that a segue is about to be performed.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass media url and media type to the VideoAndAudioViewController.
    if ([segue.identifier isEqualToString:@"AudioAndVideoSegue"]) {
        VideoAndAudioViewController *videoAndAudioVC = segue.destinationViewController;
        videoAndAudioVC.title = [NSString stringWithFormat:@"%@ action", mediaType];
        videoAndAudioVC.mediaUrl = mediaUrl;
        videoAndAudioVC.mediaType = mediaType;
    }
}






//////////////////// SocialBeacon team addition ////////////////////////


// Exit beacon handlers.

- (void)exitedNeerajBeacon {
    NSLog(@"Exited Neeraj Beacon.");
//  [[[UIAlertView alloc] initWithTitle:@"Exited Neeraj Beacon." message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}
- (void)exitedNaveenBeacon {
     NSLog(@"Exited Naveen Beacon.");
//     [[[UIAlertView alloc] initWithTitle:@"Exited Naveen Beacon." message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

// Enter beacon handlers.
- (void)enteredNeerajBeacon:(NSArray *)actionArray {
    NSLog(@"Entered Neeraj Beacon");
 //   [[[UIAlertView alloc] initWithTitle:@"Entered Neeraj Beacon" message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

- (void)enteredNaveenBeacon:(NSArray *)actionArray {
    NSLog(@"Entered Naveen Beacon");
//     [[[UIAlertView alloc] initWithTitle:@"Entered Naveen Beacon" message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

@end
