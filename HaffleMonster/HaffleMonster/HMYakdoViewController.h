//
//  HMYakdoViewController.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 25..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SRLoads.h"

@interface HMYakdoViewController : UIViewController {
    GMSMapView *mainMapView;
}
/**
 * 지도를 표시할 마트객체입니다. (필수)
 */
@property (nonatomic) SRMarket *market;
/**
 * 마트 객체를 이용해서 초기화합니다.
 */
- (id)initWithMarket:(SRMarket*)market;

/**
 *마커 이미지 크기 조절
 */
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@property float selfLatitude;
@property float selfLongitude;
@end
