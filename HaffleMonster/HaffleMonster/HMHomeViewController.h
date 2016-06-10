//
//  HMHomeViewController.h
//  HaffleMonster
//
//  Created by LKM on 2015. 6. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>



@interface HMHomeViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    GMSMapView *mapView;
    __weak IBOutlet UITableView *homeTableView;
    
}
@end
