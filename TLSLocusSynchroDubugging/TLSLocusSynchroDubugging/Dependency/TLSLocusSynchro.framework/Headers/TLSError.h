//
//  TLSError.h
//  TLSLocusSynchro
//
//  Created by 薛程 on 2018/11/29.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 路线上报错误码
 */
typedef enum _TLSErrorCode
{
    TLSErrorCodeNetworkError         = 1001,     ///< 网络错误
    TLSErrorCodeServerError          = 2001      ///< 服务内部错误
} TLSErrorCode;

/**
 * @brief 错误信息
 */
@interface TLSError : NSObject

/**
 * @brief 错误域.
 */
@property (nonatomic, strong) NSString *domain;

/**
 * @brief 错误码.
 */
@property (nonatomic, assign) TLSErrorCode code;

/**
 * @brief 错误详细信息.
 */
@property (nonatomic, strong, nullable) NSDictionary *userInfo;

@end
