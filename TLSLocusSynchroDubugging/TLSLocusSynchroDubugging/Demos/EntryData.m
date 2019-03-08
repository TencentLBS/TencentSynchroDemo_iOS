//
//  EntryData.m
//  TLSLocusSynchroDubugging
//
//  Created by 薛程 on 2018/11/27.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "EntryData.h"

@implementation Cell

@end

@implementation Section

@end

@implementation EntryData

+ (instancetype)constructDefaultEntryData
{
    EntryData *entry = [[EntryData alloc] init];
    entry.title = @"Synchro Demo";
    
    NSMutableArray<Section *> *sectionArray = [NSMutableArray array];
    entry.sections = sectionArray;
    
    {
        Section *section = [[Section alloc] init];
        section.title = @"司乘同显";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 基础导航
        {
            Cell *cell = [[Cell alloc] init];
            cell.title = @"司机端";
            cell.controllerClassName = @"DriverSynchroViewController";
            [cellArray addObject:cell];
            
            cell = [[Cell alloc] init];
            cell.title = @"乘客端";
            cell.controllerClassName = @"PassengerSynchroViewController";
            [cellArray addObject:cell];
        }
    }
    
    return entry;
}

@end
