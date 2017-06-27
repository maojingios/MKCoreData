//
//  BasicUse.m
//  MKCoreData
//
//  Created by gw on 2017/6/27.
//  Copyright © 2017年 VS. All rights reserved.
//

#import "BasicUse.h"

@interface BasicUse ()

@end

@implementation BasicUse

static BasicUse * _manager;

+(__kindof BasicUse *)manager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manager = [super allocWithZone:NULL];
    });
    return _manager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [BasicUse manager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [BasicUse manager];
}

#pragma mark - lazy load

/*
 1、NSManagedObjectContext 数据上下文，负责数据的实际操作，如：插入数据、查询数据、删除数据、更新数据。
 2、NSPersistentStoreCoordinator 持久化存储助理。设置数据存储的名字、位置、存储方式和存储时机。
 3、NSManagedObjectModel数据模型。数据库所有表格和数据模型，包含各个实体定义信息，添加实体属性，建立属性之间的联系。可通过试图编辑器和代码进行编辑。
 4、NSManagedObject 被管理的数据。数据库中的表格记录。
 5、NSEntityDescription 实体结构。相当于表格结构。
 6、NSFetchRequest 数据请求。相当于查询语句。
 7、.xcdatamodeld 里面是.xcdatamodel文件，用数据模型编辑器编辑，编译后为.momd或者.mom文件。
 
 */

-(NSManagedObjectContext *)context{
    if (!_context) {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    }
    return _context;
}

/*
 准备
 */
-(void)prepare{
    
    NSManagedObjectModel * model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator * prs = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString * docPaths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL * urlPath = [NSURL fileURLWithPath:[docPaths stringByAppendingString:@"/Person.sqlite"]];
    
    NSError * error = nil;
    
    NSPersistentStore * prsStore = [prs addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:urlPath options:nil error:&error];
    
    if (prsStore ==nil) {
        [NSException raise:@"出错啦！" format:@"%@",[error localizedDescription]];
    }
    
    self.context.persistentStoreCoordinator = prs;
    
}

/*
 插入数据
 */
-(void)insert{
    
    NSManagedObject * obj1 = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.context];
    [obj1 setValue:@"李四" forKey:@"name"];
    [obj1 setValue:@"16" forKey:@"age"];
    [obj1 setValue:@"female" forKey:@"sex"];
    
    NSError * error = nil;
    BOOL success  = [self.context save:&error];
    
    if (!success) {
        
        [NSException raise:@"插入失败" format:@"%@",[error localizedDescription]];
    }else
        NSLog(@"插入成功");
}

/*
 查询
 */
-(void)query{
    
    //创建查询请求
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    //查询实体
    fetchRequest.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context];
    
    //设置查询条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name = %@",@"韩梅梅"];
    fetchRequest.predicate = predicate;
    
    //查询->结果
    NSError * error = nil;
    NSArray * array = [self.context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [NSException raise:@"查询失败" format:@"%@",[error localizedDescription]];
    }
    
    //打印结果
    for (NSManagedObject * obj in array) {
        
        NSLog(@"姓名=%@ 年龄=%@ 性别=%@",[obj valueForKey:@"name"],[obj valueForKey:@"age"],[obj valueForKey:@"sex"]);
    }
}

/*
 删除
 */
-(void)mkDelete{
    
    //创建查询请求
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    //查询实体
    fetchRequest.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context];
    
    //设置查询条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name = %@",@"韩梅梅"];
    fetchRequest.predicate = predicate;
    
    //查询
    NSError * error = nil;
    NSArray * array = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        [NSException raise:@"查询失败" format:@"%@",[error localizedDescription]];
    }
    
    //删除
    for (NSManagedObject * obj in array) {
        
        [self.context deleteObject:obj];
    }
    
    //保存
    BOOL ret = [self.context save:&error];
    
    if (ret) {
        NSLog(@"删除成功");
    }
}

/*
 修改
 */
-(void)update{
    
    //查询请求
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    //实体
    fetchRequest.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context];
    
    //查询条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name = %@",@"maoJing"];
    fetchRequest.predicate = predicate;
    
    //结果
    NSError * error = nil;
    NSArray * array = [self.context executeFetchRequest:fetchRequest error:&error];
    
    //修改
    for (NSManagedObject * obj in array) {
        [obj setValue:@"科比" forKey:@"name"];
    }
    
    //保存
    BOOL ret = [self.context save:&error];
    if (ret) {
        NSLog(@"修改成功");
    }
    
}



@end
