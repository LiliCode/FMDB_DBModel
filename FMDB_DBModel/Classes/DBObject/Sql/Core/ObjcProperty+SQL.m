//
//  ObjcProperty+SQL.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "ObjcProperty+SQL.h"


const NSString *const SQL_TEXT = @"TEXT";       //文本
const NSString *const SQL_INTEGER = @"INTEGER"; //整数
const NSString *const SQL_REAL = @"REAL";       //浮点数
const NSString *const SQL_BLOB = @"BLOB";       //大型对象 BLOB就是使用二进制保存数据
const NSString *const SQL_NULL = @"NULL";       //空类型 空值


static char *kSqliteTypeKey = "kSqliteTypeKey";

@implementation ObjcProperty (SQL)

- (void)setSqlType:(NSString *)sqlType
{
    objc_setAssociatedObject(self, kSqliteTypeKey, sqlType, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)sqlType
{
    return objc_getAssociatedObject(self, kSqliteTypeKey);
}

- (void)toSqliteType
{
    if ([self.objcType isEqualToString:ObjcTypeInt] || [self.objcType isEqualToString:ObjcTypeUnsignedInt] ||
        [self.objcType isEqualToString:ObjcTypeShort] || [self.objcType isEqualToString:ObjcTypeUnsignedShort] ||
        [self.objcType isEqualToString:ObjcTypeLong] || [self.objcType isEqualToString:ObjcTypeUnsigendLong] ||
        [self.objcType isEqualToString:ObjcTypeNSNumber] || [self.objcType isEqualToString:ObjcTypeChar] ||
        [self.objcType isEqualToString:ObjcTypeUnsigendChar] || [self.objcType isEqualToString:ObjcTypeBool])
    {
        self.sqlType = [SQL_INTEGER copy];
    }
    else if ([self.objcType isEqualToString:ObjcTypeFloat] || [self.objcType isEqualToString:ObjcTypeDouble] ||
             [self.objcType isEqualToString:ObjcTypeLongDouble])
    {
        self.sqlType = [SQL_REAL copy];
    }
    else if ([self.objcType isEqualToString:ObjcTypeNSString])
    {
        self.sqlType = [SQL_TEXT copy];
    }
    else if ([self.objcType isEqualToString:ObjcTypeNSArray] || [self.objcType isEqualToString:ObjcTypeNSMutableArray])
    {
        self.sqlType = [SQL_BLOB copy];
    }
    else
    {
        NSLog(@"%s: Sqlite不支持的类型%@", __func__, self.objcType);
    }
}


@end




