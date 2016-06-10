//
//  HMMapPositionPickerViewController.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 13..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

/* 사용법:
 HMMapPositionPickerViewController *pp = [[HMMapPositionPickerViewController alloc] init];
 [self presentViewController:[pp pickerNavigationController] animated:YES completion:nil];
 델리게이트를 지정하세요 <HMMapPositionPickerDelegate>
*/

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "HMDoubleNavigationTitleView.h"

@class HMMapPositionPickerViewController;

@protocol HMMapPositionPickerDelegate <NSObject>
/**ㅏㅏ
 * 위치 피커로 위치를 선택하고 나서 '완료'버튼을 눌렀을때. 피커 뷰는 닫힘.
 */
-(void)positionPicker:(HMMapPositionPickerViewController*)picker didFinishPickingWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;
@optional;
/**
 * 취소버튼을 눌렀을 경우. 위치가 반영되지 않음. 옵션사항.
 */
-(void)positionPicker:(HMMapPositionPickerViewController*)picker didCancelWithAnimation:(BOOL)animate;
@end

@interface HMMapPositionPickerViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate> {
    GMSMapView *mapView;
    CLLocationCoordinate2D selectedCoordinate;
    CLLocationManager *mainLocationManager;
    HMDoubleNavigationTitleView *doubleTitleView;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *cancelButton;
}
@property (nonatomic) BOOL isCurrentLocated;
@property (nonatomic) BOOL blockCancelButton;

@property (nonatomic) id <HMMapPositionPickerDelegate> delegate;
/**
 * 이 값이 설정되면 초기 로딩되는 좌표가 변경됨.
 */
@property (nonatomic) CLLocationCoordinate2D initialCoordinate;
/**
 * Navigation Bar 사용을 위해서 UINavigationController 의 루트뷰로 만들어 리턴한다.
 */
- (UINavigationController*)pickerNavigationController;
@end
