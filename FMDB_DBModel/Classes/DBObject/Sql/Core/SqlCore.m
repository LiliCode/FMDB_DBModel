//
//  SqlCore.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/10.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "SqlCore.h"

@implementation NSString (SqlCore)

- (NSString *)sql_and:(NSString *)value
{
    return [NSString stringWithFormat:@"%@ AND %@", self, value];
}

- (NSString *)sql_or:(NSString *)value
{
    return [NSString stringWithFormat:@"%@ OR %@", self, value];
}

@end


@implementation SqlCore


- (NSString *)operator_equal:(ObjcProperty *)objcPro
{
    NSString *keyValue = nil;
    if ([objcPro.objcType isEqualToString:ObjcTypeNSString])
    {
        keyValue = [NSString stringWithFormat:@"%@=\'%@\'", objcPro.propertyName, [[objcPro defaultValue] value]];
    }
    else
    {
        keyValue = [NSString stringWithFormat:@"%@=%@", objcPro.propertyName, [[objcPro defaultValue] value]];
    }
    
    return keyValue;
}


/* SELECT */

- (NSString *)select:(NSArray *)cols
{
    NSMutableString *sql_select = [[NSMutableString alloc] initWithString:@"SELECT "];
    [sql_select appendString:[cols componentsJoinedByString:@","]?:@"*"]; //拼接需要查询的字段
    
    return sql_select;
}

- (NSString *)select_distinct:(NSArray *)cols
{
    NSMutableString *sql_select = [[NSMutableString alloc] initWithString:@"SELECT DISTINCT "];
    [sql_select appendString:[cols componentsJoinedByString:@","]?:@"*"]; //拼接需要查询的字段
    
    return sql_select;
}

- (NSString *)from:(NSString *)tableName
{
    return [NSString stringWithFormat:@"FROM %@", tableName];
}

- (NSString *)where:(NSString *)query
{
    return [NSString stringWithFormat:@"WHERE %@", query];
}

/* INSERT INTO */

- (NSString *)values:(NSArray <ObjcProperty *>*)valueList
{
    NSMutableString *sql_values = [NSMutableString stringWithString:@"VALUES("];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (ObjcProperty *pro in valueList)
    {
        id tempObj = [[pro defaultValue] value];
        if ([pro.objcType isEqualToString:ObjcTypeNSString])
        {
            tempObj = [NSString stringWithFormat:@"\'%@\'", [[pro defaultValue] value]];
        }
        
        [values addObject:tempObj];
    }
    [sql_values appendString:[values componentsJoinedByString:@","]];   //拼接值
    [sql_values appendString:@")"];
    
    return [sql_values copy];
}


/* UPDATE */

- (NSString *)update:(NSString *)tableName
{
    return [NSString stringWithFormat:@"UPDATE %@", tableName];
}

- (NSString *)set:(NSArray <ObjcProperty *>*)columns
{
    NSMutableString *sql_set = [NSMutableString stringWithString:@"SET "];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (ObjcProperty *pro in columns)
    {
        [values addObject:[self operator_equal:pro]];
    }
    
    [sql_set appendString:[values componentsJoinedByString:@","]];
    
    return [sql_set copy];
}



@end





