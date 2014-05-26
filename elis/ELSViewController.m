//
//  ELSViewController.m
//  elis
//
//  Created by geta6 on 5/26/14.
//  Copyright (c) 2014 geta6. All rights reserved.
//

#import "ELSViewController.h"

@interface ELSViewController ()

@property (nonatomic, readwrite) NSUUID *proximityUUID;
@property (nonatomic, readwrite) CLLocationManager *locationManager;
@property (nonatomic, readwrite) CLBeaconRegion *beaconRegion;
@property (nonatomic, readwrite) AVAudioPlayer *audioPlayer;

@end

@implementation ELSViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
    _locationManager = [CLLocationManager new];
    [_locationManager setDelegate:self];

    _proximityUUID = [[NSUUID alloc] initWithUUIDString:UUID];

    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID identifier:@"net.geta6.test.beacon"];
    [_beaconRegion setNotifyOnEntry: YES];
    [_beaconRegion setNotifyOnExit:YES];
    [_beaconRegion setNotifyEntryStateOnDisplay:NO];

    [_locationManager startMonitoringForRegion:_beaconRegion];
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
  }

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"おかえりなさい" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"いってらっしゃい" object:nil];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  [self sendNotification:@"おかえりなさい"];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  [self sendNotification:@"いってらっしゃい"];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
  if (0 < beacons.count) {
    CLBeacon *beacon = beacons.firstObject;
    switch (beacon.proximity) {
      case CLProximityImmediate:
        [self.view setBackgroundColor: [UIColor colorWithRed:0.44 green:0.56 blue:0.43 alpha:1.00]];
        break;
      case CLProximityNear:
        [self.view setBackgroundColor: [UIColor colorWithRed:0.44 green:0.56 blue:0.43 alpha:0.75]];
        break;
      case CLProximityFar:
        [self.view setBackgroundColor: [UIColor colorWithRed:0.44 green:0.56 blue:0.43 alpha:0.50]];
        break;
      case CLProximityUnknown:
        [self.view setBackgroundColor: [UIColor colorWithRed:0.44 green:0.56 blue:0.43 alpha:0.25]];
        break;
    }
  } else {
    self.view.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
  }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
  if (state == CLRegionStateInside) {
    [self playAudioPlayerWithSituation:@"おかえりなさい"];
  } else if (state == CLRegionStateOutside) {
    [self playAudioPlayerWithSituation:@"いってらっしゃい"];
  }
}

- (void)getNotification:(NSNotification *)notification
{
  [self playAudioPlayerWithSituation:[notification name]];
}

- (void)sendNotification:(NSString *)message
{
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  [notification setFireDate:[[NSDate date] init]];
  [notification setTimeZone:[NSTimeZone defaultTimeZone]];
  [notification setAlertBody:message];
  [notification setAlertAction:@"Open"];
  [notification setSoundName:UILocalNotificationDefaultSoundName];
  [notification setApplicationIconBadgeNumber:1];
  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)playAudioPlayerWithSituation:(NSString *)situation
{
  srand((unsigned)time(NULL));
  int charactor = random() % 5;
  NSString *name = [NSString stringWithFormat:@"%@_%i", situation, charactor];
  NSURL *uri = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
  SystemSoundID soundID;
  OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(uri), &soundID);
  if (!error) {
    AudioServicesPlaySystemSound(soundID);
  }
}

@end
