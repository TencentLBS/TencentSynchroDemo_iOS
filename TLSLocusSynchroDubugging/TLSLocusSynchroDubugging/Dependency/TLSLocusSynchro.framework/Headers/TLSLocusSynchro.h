//
//  TLSLocusSynchro.h
//  TLSLocusSynchroDubugging
//
//  Created by 薛程 on 2018/11/2.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSConfigPreference.h"
#import "TLSSyncData.h"
#import "TLSError.h"

@class TLSLocusSynchro;

/**
 * @brief  司乘同显事件回调. 用于通知用户司乘同显中的事件.
 */
@protocol TLSLocusSynchroDelegate <NSObject>

@optional

/**
 * @brief  司乘同显数据信息同步的回调. 用于通知获取到的对方数据信息.
 * @param synchro synchro
 * @param data 获取同步到的数据信息
 */
- (void)locusSynchro:(TLSLocusSynchro *)synchro didUpdateSyncData:(TLSSyncData *)data;

/**
 * @brief  司乘同显位置上传成功的回调.
 * @param synchro synchro
 */
- (void)locusSynchroDidUploadLocationSuccess:(TLSLocusSynchro *)synchro;

/**
 * @brief  司乘同显位置上传失败的回调.
 * @param synchro synchro
 * @param error 失败信息
 */
- (void)locusSynchro:(TLSLocusSynchro *)synchro didUploadLocationFailWithError:(TLSError *)error;

/**
 * @brief  司乘同显路线上传成功的回调.
 * @param synchro synchro
 */
- (void)locusSynchroDidUploadRouteSuccess:(TLSLocusSynchro *)synchro;

/**
 * @brief  司乘同显路线上传失败的回调. 
 * @param synchro synchro
 * @param error 失败信息
 */
- (void)locusSynchro:(TLSLocusSynchro *)synchro didUploadRouteFailWithError:(TLSError *)error;

@end

/**
 * @brief  司乘同显数据源回调. 用于获取司乘同显中必须的数据信息.
 */
@protocol TLSLocusSynchroDataSource <NSObject>

@required

/**
 * @brief  获取当前订单信息. 用于司乘同显数据同步. 使用TLSOrder的子类定义订单额外信息. 
 * @param synchro synchro
 *
 * @return 当前订单信息
 */
- (TLSOrder *)orderForLocusSynchro:(TLSLocusSynchro *)synchro;

@end

/**
 * @brief  司乘同显同步机.
 */
@interface TLSLocusSynchro : NSObject

/**
 * @brief  司乘同显事件回调. 用于通知用户司乘同显中的事件.
 */
@property (nonatomic, weak) id<TLSLocusSynchroDelegate> delegate;

/**
 * @brief  司乘同显数据源回调. 用于获取司乘同显中必须的数据信息.
 */
@property (nonatomic, weak) id<TLSLocusSynchroDataSource> dataSource;

/**
 * @brief  同步机运行状态.
 */
@property (nonatomic, assign, readonly) BOOL isRunning;

/**
 * @brief  实例化同步机. 可使用TLSConfigPreference的子类指定配置类型. 若使用基类进行初始化, 则默认为乘客端配置信息.
 * @param configPreference 用于实例化同步机的配置信息
 *
 * @return 同步机实例
 */
- (instancetype)initWithConfigPreference:(TLSConfigPreference *)configPreference;

/**
 * @brief  同步机开始运行. 开启后可开始同步本端位置信息和获取对方数据.
 */
- (void)start;

/**
 * @brief  同步机结束运行. 结束后不可继续同步本端位置信息, 不可继续获取对方数据.
 */
- (void)stop;

/**
 * @brief  更新同步机本端位置信息.
 * @param location 位置信息
 */
- (void)updateLocation:(TLSLocation *)location;

/**
 * @brief  更新同步机本端路线信息.
 * @param route 路线信息
 */
- (void)updateRoute:(TLSRoute *)route;

/**
 * @brief  同步机是否开启同步对方数据. 默认开启, 同步数据结果由回调返回.
 */
@property (nonatomic, assign) BOOL syncEnabled;

/**
 * @brief  同步机同步对方数据的时间间隔. 同步默认时间间隔为5秒.
 */
@property (nonatomic, assign) NSTimeInterval syncTimeInterval;

/**
 * @brief  SDK版本号(1.0.1).
 */
@property (nonatomic, strong, readonly) NSString *sdkVersion;

@end
