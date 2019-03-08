//
//  TLSLocation.h
//  TLSLocusSynchroDubugging
//
//  Created by 薛程 on 2018/11/6.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * @brief  位置信息.
 */
@interface TLSLocation : NSObject

/**
 * @brief  未吸附到路线上的定位信息. 不可为空.
 */
@property (nonatomic, strong, nonnull)  CLLocation *location;

/**
 * @brief  吸附到路线上的经纬度信息. 若未成功吸附到路线上为kCLLocationCoordinate2DInvalid.
 */
@property (nonatomic, assign) CLLocationCoordinate2D matchedCoordinate;

/**
 * @brief  吸附到导航路线上的角度信息. 若未成功吸附到路线上为-1.
 */
@property (nonatomic, assign) CLLocationDirection matchedCourse;

/**
 * @brief  吸附到导航路线上的位置索引. 若未成功吸附到路线上为-1.
 */
@property (nonatomic, assign) NSInteger matchedIndex;

@end
