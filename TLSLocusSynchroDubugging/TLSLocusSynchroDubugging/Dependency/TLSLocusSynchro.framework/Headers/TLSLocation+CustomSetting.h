//
//  TLSLocation+CustomSetting.h
//  TLSLocusSynchro
//
//  Created by 薛程 on 2019/2/22.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import "TLSLocation.h"

/**
 * @brief  位置信息自定义配置扩展类.
 */
@interface TLSLocation (CustomSetting)

/**
 * @brief  位置补充信息. 可上传业务信息, 配合服务端使用.
 */
@property (nonatomic, strong, nullable) NSString *extraInfo;

@end
