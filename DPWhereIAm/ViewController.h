//
//  ViewController.h
//  DPWhereIAm
//
//  Created by Divya Patil on 23/10/16.
//  Copyright © 2016 Divya Patil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;

@property (strong, nonatomic) IBOutlet UILabel *labelLatitude;

@property (strong, nonatomic) IBOutlet UILabel *labelLongitude;

@property (strong, nonatomic) IBOutlet UILabel *labelAltitude;

@property (strong, nonatomic) IBOutlet UILabel *labelSpeed;

@property (strong, nonatomic) IBOutlet UILabel *labelAddress;

- (IBAction)actionStartDetectingLocation:(id)sender;

- (IBAction)changeMapType:(id)sender;
@end

