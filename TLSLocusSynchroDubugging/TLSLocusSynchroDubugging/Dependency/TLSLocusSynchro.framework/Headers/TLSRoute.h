//
//  TLSRoute.h
//  TLSLocusSynchroDubugging
//
//  Created by 薛程 on 2018/11/8.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TLSRouteTrafficItem.h"

/**
 * @brief  路线点协议. 用于定义路线点串中每个点的数据格式.
 */
@protocol TLSRoutePoint <NSObject>

@required

/**
 * @brief  路线点的经纬度数据. 路线点串中每个点必须有该属性, 用于标识该点的位置.
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

/**
 * @brief  路线信息.
 */
@interface TLSRoute : NSObject

/**
 * @brief  路线ID.
 */
@property (nonatomic, strong, nonnull) NSString *routeID;

/**
 * @brief  路线点串. 按照从起点到终点的顺序排序.
 */
@property (nonatomic, strong, nonnull) NSArray<id<TLSRoutePoint>> *routePoints;

/**
 * @brief  路线路况. 可为空.
 */
@property (nonatomic, strong, nullable) NSArray<TLSRouteTrafficItem *> *routeTraffic;

@end
