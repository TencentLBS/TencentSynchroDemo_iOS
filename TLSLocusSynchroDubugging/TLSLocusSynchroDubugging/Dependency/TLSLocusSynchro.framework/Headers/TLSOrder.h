//
//  TLSOrder.h
//  TLSLocusSynchroDubugging
//
//  Created by 薛程 on 2018/11/8.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief  订单状态.
 */
typedef enum _TLSSynchroOrderStatus
{
    TLSSynchroOrderStatusNone        = 0,    ///< 未派单
    TLSSynchroOrderStatusSended      = 2,    ///< 已派单
    TLSSynchroOrderStatusCharging    = 3,    ///< 计费中
} TLSSynchroOrderStatus;

/**
 * @brief  司机状态.
 */
typedef enum _TLSSynchroDriverStatus
{
    TLSSynchroDriverStatusStopped        = 0,    ///< 停止听单
    TLSSynchroDriverStatusListening      = 1,    ///< 听单中
    TLSSynchroDriverStatusServing        = 2,    ///< 服务中
} TLSSynchroDriverStatus;

/**
 * @brief  订单信息基类.
 */
@interface TLSOrder : NSObject

/**
 * @brief  订单ID. 若当前未派单可不设置.
 */
@property (nonatomic, copy, nullable) NSString *orderID;

/**
 * @brief  订单状态.
 */
@property (nonatomic, assign) TLSSynchroOrderStatus orderStatus;

@end

/**
 * @brief  司机订单信息.
 */
@interface TLSDriverOrder : TLSOrder

/**
 * @brief  路线ID.
 */
@property (nonatomic, copy, nullable) NSString *routeID;

/**
 * @brief  司机听单状态.
 */
@property (nonatomic, assign) TLSSynchroDriverStatus status;

/**
 * @brief  剩余预估距离. 单位为米.
 */
@property (nonatomic, assign) NSUInteger leftDistance;

/**
 * @brief  剩余预估时间. 单位为分钟.
 */
@property (nonatomic, assign) NSUInteger leftTime;

@end

/**
 * @brief  乘客订单信息.
 */
@interface TLSPassengerOrder : TLSOrder

@end

/**
 * @brief  同步订单信息.
 */
@interface TLSSyncOrder : TLSOrder

/**
 * @brief  剩余预估距离. 单位为米.
 */
@property (nonatomic, assign, readonly) NSUInteger leftDistance;

/**
 * @brief  剩余预估时间. 单位为分钟.
 */
@property (nonatomic, assign, readonly) NSUInteger leftTime;

/**
 * @brief  已行驶距离. 单位为米.
 */
@property (nonatomic, assign, readonly) NSUInteger distance;

/**
 * @brief  已行驶时间. 单位为分钟.
 */
@property (nonatomic, assign, readonly) NSUInteger time;

@end
