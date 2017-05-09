//
//  SQLStringCreator.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "SQLStringCreator.h"
#import "ObjcProperty+SQL.h"

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
        [pro toSqliteType];
        [argsList addObject:[NSString stringWithFormat:@"%@ %@", pro.propertyName, pro.sqlType]];
    }
    //拼接参数
    [sql appendString:[argsList componentsJoinedByString:@","]];
    //拼接最后的一个括号
    [sql appendString:@");"];
    
    return [sql copy];
}




@end








