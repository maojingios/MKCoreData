//
//  BasicUse.h
//  MKCoreData
//
//  Created by gw on 2017/6/27.
//  Copyright © 2017年 VS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Person+CoreDataClass.h"

@interface BasicUse : NSObject

@property (nonatomic, readwrite, strong)NSManagedObjectContext * context;

+(__kindof BasicUse *)manager;

/*
 准备
 */
-(void)prepare;

/*
 插入数据
 */
-(void)insert;

/*
 查询
 */
-(void)query;

/*
 删除
 */
-(void)mkDelete;

/*
 修改
 */
-(void)update;

@end
