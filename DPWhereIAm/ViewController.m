//
//  ViewController.m
//  DPWhereIAm
//
//  Created by Divya Patil on 23/10/16.
//  Copyright © 2016 Divya Patil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startLocating];
    
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    
    longPress.minimumPressDuration = 2;
    
    [self.myMapView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    
    CLLocationCoordinate2D pressedCoordinate;
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pressLocation = [gesture locationInView:gesture.view];
        
        pressedCoordinate = [self.myMapView convertPoint:pressLocation toCoordinateFromView:gesture.view];
        
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
        
        myAnnotation.coordinate = pressedCoordinate;
        
        CLGeocoder *myGeocoder = [[CLGeocoder alloc]init];
        
        CLLocation *myLocation = [[CLLocation alloc]initWithLatitude:pressedCoordinate.latitude longitude:pressedCoordinate.longitude];
        
        [myGeocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if(error) {
                
                NSLog(@"%@",error.localizedDescription);
                myAnnotation.title = @"Unknown Place";
                
                [self.myMapView addAnnotation:myAnnotation];
            }
            else {
                
                if(placemarks.count > 0) {
                    
                    CLPlacemark *myPlacemark = placemarks.lastObject;
                    
                    NSString *title = [myPlacemark.subThoroughfare stringByAppendingString:myPlacemark.thoroughfare];
                    NSString *subTitle = myPlacemark.locality;
                    
                    myAnnotation.title = title;
                    myAnnotation.subtitle = subTitle;
                    
                    _labelAddress.text = [NSString stringWithFormat:@"%@",myPlacemark.locality];
                    [self.myMapView addAnnotation:myAnnotation];
                    
                }
                else {
                    
                    myAnnotation.title = @"Unknown Place";
                    [self.myMapView addAnnotation:myAnnotation];
                }
            }
        }];
    }
    else if(gesture.state == UIGestureRecognizerStateEnded) {
    }
}

/*-(MKAnnotationView *)myMapView:(MKAnnotationView *)myMapView viewForAnnotation:(id<MKAnnotation>)myAnnotation {
 
 MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:myAnnotation reuseIdentifier:@"pin"];
 annotationView.pinTintColor = [UIColor yellowColor];
 
 annotationView.canShowCallout = YES;
 
 return annotationView;
 
 } */

-(void)startLocating {
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}

//delegate methods of cllocationmanager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    _labelLatitude.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    _labelLongitude.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    _labelAltitude.text = [NSString stringWithFormat:@"%f",currentLocation.altitude];
    _labelSpeed.text = [NSString stringWithFormat:@"%f",currentLocation.speed];
    
    NSLog(@"latitude : %f",currentLocation.coordinate.latitude);
    NSLog(@"longitude : %f",currentLocation.coordinate.longitude);
    
    
    MKCoordinateSpan mySpan = MKCoordinateSpanMake(0.001, 0.001);
    
    MKCoordinateRegion myRegion = MKCoordinateRegionMake(currentLocation.coordinate, mySpan);
    
    [self.myMapView setRegion:myRegion animated:YES];
}


- (IBAction)actionStartDetectingLocation:(id)sender {
    
     [self startLocating];
}

- (IBAction)changeMapType:(id)sender {
    
    UISegmentedControl *segment = sender;
    
    if(segment.selectedSegmentIndex == 0) {
        [self.myMapView setMapType:MKMapTypeStandard];
    }
    else if(segment.selectedSegmentIndex == 1) {
        [self.myMapView setMapType:MKMapTypeSatellite];
    }
    
    else if(segment.selectedSegmentIndex == 2) {
        [self.myMapView setMapType:MKMapTypeHybrid];
    }
}
@end
