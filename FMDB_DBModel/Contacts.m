//
//  Contacts.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "Contacts.h"

@interface Contacts ()
@property (copy , nonatomic) NSString *school;
@property (copy , nonatomic) NSString *birthday;
@property (copy , nonatomic) NSString *enterprise;

@end

@implementation Contacts

- (instancetype)init
{
    if (self = [super init])
    {
        self.updateDate = [NSDate date];
        self.books = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (ObjcProperty *)sql_primaryKey
{
    return [ObjcProperty objcPropertyName:@"tel" objcType:ObjcTypeNSString value:nil];
}

+ (NSArray *)sql_filterColumn
{
    return @[@"school", @"birthday", @"enterprise"];
}


@end

