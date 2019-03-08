//
//  TLSRouteTrafficItem.h
//  TLSLocusSynchro
//
//  Created by 薛程 on 2019/2/19.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 路线路况元素.
 */
@interface TLSRouteTrafficItem : NSObject

/**
 * @brief 该段路线起点在路线点串中的索引. 索引值从0开始.
 */
@property (nonatomic, assign) NSInteger from;

/**
 * @brief 该段路线终点在路线点串中的索引. 索引值从0开始.
 */
@property (nonatomic, assign) NSInteger to;

/**
 * @brief 该段路况状态. 0:通畅 1:缓行 2:堵塞 3:未知路况 4:严重堵塞.
 */
@property (nonatomic, assign) NSInteger color;

@end
