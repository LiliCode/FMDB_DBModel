//
//  SQLStringCreator.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "SQLStringCreator.h"
#import "NSObject+Runtime.h"
#import "SqlCore.h"

@implementation SQLStringCreator

+ (instancetype)creator
{
    return [[self alloc] init];
}

- (NSString *)sql_createTable:(NSString *)tableName ifNotExists:(BOOL)ine columns:(NSArray <ObjcProperty *>*)columns
{
    if (!tableName || !columns)
    {
        NSLog(@"%s:表名称:%@ 参数:%@", __func__, tableName, columns);
        return nil;
    }
    
    NSMutableString *sql = [[NSMutableString alloc] initWithString:@"CREATE TABLE "];
    if (ine)
    {
        [sql appendString:@"IF NOT EXISTS "];
    }
    
    //拼接表名称
    [sql appendString:tableName];
    
    //拼接参数
    [sql appendString:@"("];
    //将参数和类型的字符串放在数组中：uid INEGETER, name TEXT
    NSMutableArray *argsList = [[NSMutableArray alloc] init];
    for (ObjcProperty *pro in columns)
    {
        [pro toSqliteType]; //属性数据类型转换成Sqlite数据类型
        [argsList addObject:[NSString stringWithFormat:@"%@ %@", pro.propertyName, pro.sqlType]];
    }
    //拼接参数
    [sql appendString:[argsList componentsJoinedByString:@","]];
    //拼接最后的一个括号
    [sql appendString:@");"];
    
    return [sql copy];
}

- (NSString *)sql_dropTable:(NSString *)tableName ifExists:(BOOL)ifExists
{
    if (!tableName)
    {
        NSLog(@"%s:表名称:%@", __func__, tableName);
        return nil;
    }
    
    NSMutableString *sql = [[NSMutableString alloc] initWithString:@"DROP TABLE "];
    if (ifExists)
    {
        [sql appendString:@"IF EXISTS "];
    }
    
    [sql appendString:tableName];
    [sql appendString:@";"];
    
    return [sql copy];
}

- (NSString *)sql_select:(NSArray <NSString *>*)columns from:(NSString *)tableName where:(NSString *)query
{
    if (!tableName)
    {
        NSLog(@"%s:表名称:%@", __func__, tableName);
        return nil;
    }
    
    SqlCore *sqlCore = [[SqlCore alloc] init];
    
    return [NSString stringWithFormat:@"%@ %@ %@;", [sqlCore select:columns], [sqlCore from:tableName], [sqlCore where:query]];
}

- (NSString *)sql_select_distinct:(NSArray<NSString *> *)columns from:(NSString *)tableName where:(NSString *)query
{
    if (!tableName)
    {
        NSLog(@"%s:表名称:%@", __func__, tableName);
        return nil;
    }
    
    SqlCore *sqlCore = [[SqlCore alloc] init];
    
    return [NSString stringWithFormat:@"%@ %@ %@;", [sqlCore select_distinct:columns], [sqlCore from:tableName], [sqlCore where:query]];
}

- (NSString *)sql_insertInto:(NSString *)tableName values:(NSArray<ObjcProperty *> *)values
{
    if (!tableName || !values.count)
    {
        NSLog(@"%s:表名称:%@ values:%@", __func__, tableName, values);
        return nil;
    }
    
    SqlCore *sql = [[SqlCore alloc] init];
    
    return [NSString stringWithFormat:@"INSERT INTO %@ %@;", tableName, [sql values:values]];
}


@end








