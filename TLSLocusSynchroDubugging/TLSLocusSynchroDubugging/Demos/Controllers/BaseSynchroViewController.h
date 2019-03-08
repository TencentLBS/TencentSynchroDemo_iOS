//
//  BaseSynchroViewController.h
//  TLSLocusSynchroDubugging
//
//  Created by 薛程 on 2018/11/27.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TLSLocusSynchro/TLSSynchro.h>

@interface BaseSynchroViewController : UIViewController
<TLSLocusSynchroDelegate,
TLSLocusSynchroDataSource>

@property (nonatomic, strong, nullable) TLSLocusSynchro *synchro;

@end
