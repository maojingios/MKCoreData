//
//  Person+CoreDataProperties.h
//  MKCoreData
//
//  Created by gw on 2017/6/27.
//  Copyright © 2017年 VS. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *age;

@end

NS_ASSUME_NONNULL_END
