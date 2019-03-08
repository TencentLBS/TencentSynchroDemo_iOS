//
//  TLSConfigPreference.h
//  TLSLocusSynchroDubugging
//
//  Created by 薛程 on 2018/11/5.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief  同步机的配置信息基类. 
 */
@interface TLSConfigPreference : NSObject

/**
 * @brief  key信息.
 */
@property (nonatomic, copy, nonnull) NSString *key;

/**
 * @brief  账户ID.
 */
@property (nonatomic, copy, nonnull) NSString *accountID;

@end

/**
 * @brief  同步机的乘客端配置信息.
 */
@interface TLSPassengerConfigPreference : TLSConfigPreference


@end

/**
 * @brief  同步机的司机端配置信息.
 */
@interface TLSDriverConfigPreference : TLSConfigPreference


@end
