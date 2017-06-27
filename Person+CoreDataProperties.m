//
//  Person+CoreDataProperties.m
//  MKCoreData
//
//  Created by gw on 2017/6/27.
//  Copyright © 2017年 VS. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic sex;
@dynamic name;
@dynamic age;

@end
