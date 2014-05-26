//
//  ELSViewController.h
//  elis
//
//  Created by geta6 on 5/26/14.
//  Copyright (c) 2014 geta6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELSViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, readonly) NSUUID *proximityUUID;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic, readonly) CLBeaconRegion *beaconRegion;
@property (nonatomic, readonly) AVAudioPlayer *audioPlayer;

@end
