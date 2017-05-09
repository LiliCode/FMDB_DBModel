//
//  DBObject.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/8.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "DBObject.h"
#import "DBHelper.h"
#import "ObjcProperty/NSObject+Runtime.h"
#import "ObjcProperty/ObjcProperty.h"

@implementation DBObject

+ (BOOL)createTable
{
    
    
    return [self createTableIfNotExists:NSStringFromClass(self.class) parameter:@[]];
}

+ (BOOL)createTableIfNotExists:(NSString *)tableName parameter:(NSArray *)parameter
{
    
    
    return NO;
}



@end
