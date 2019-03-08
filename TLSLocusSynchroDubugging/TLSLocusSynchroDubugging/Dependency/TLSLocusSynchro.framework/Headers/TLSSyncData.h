//
//  TLSSyncData.h
//  TLSLocusSynchro
//
//  Created by 薛程 on 2018/11/23.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSLocation.h"
#import "TLSRoute.h"
#import "TLSOrder.h"

/**
 * @brief  同步数据信息.
 */
@interface TLSSyncData : NSObject

/**
 * @brief  同步订单信息.
 */
@property (nonatomic, strong) TLSSyncOrder *order;

/**
 * @brief  同步位置信息.
 */
@property (nonatomic, strong) NSArray <TLSLocation *> *locations;

/**
 * @brief  同步路线信息.
 */
@property (nonatomic, strong) TLSRoute *route;

@end
