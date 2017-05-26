//
//  SQLStringCreator.h
//  SQLStringCreator-Reactive
//
//  Created by LiliEhuu on 17/5/25.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLStringCreator : NSObject


/**
 SQL 实例构建

 @return 返回当前对象
 */
+ (instancetype)sqlCreator;

/**
 构建任意的SQL

 @param makeBlock 回调，构建
 @return 返回SQL字符串
 */
+ (NSString *)makeSqlString:(void (^)(SQLStringCreator *makeSql))makeBlock;


/**
 创建表：ifNotExists：如果不存在就创建 tableName：表名称 columns：列名称和数据类型
 */
- (SQLStringCreator *(^)(BOOL ifNotExists, NSString *tableName, NSArray *columns))create_table;

/**
 删除表：ifExists：如果存在 tableName：表名称
 */
- (SQLStringCreator *(^)(BOOL ifExists, NSString *tableName))drop_table;


/**
 更改表结构 tableName：表名称
 */
- (SQLStringCreator *(^)(NSString *tableName))alter_table;

/**
 添加一列：columnName：列名称 dataType：数据类型
 */
- (SQLStringCreator *(^)(NSString *columnName, NSString *dataType))add;


/**
 查询，传入需要查询的字段
 */
- (SQLStringCreator *(^)(NSArray *columns))select;

/**
 查询-返回唯一不同的值
 */
- (SQLStringCreator *(^)(NSArray *columns))select_distinct;

- (SQLStringCreator *(^)(NSString *tableName))from;

- (SQLStringCreator *(^)(NSString *query))where;


/**
 插入一条数据，tableName:表名称 columns:设置的字段
 */
- (SQLStringCreator *(^)(NSString *tableName, NSArray *columns))insert_into;

/**
 插入值，传入需要插入的字段个数，按"?"拼接，方便FMDB框架自动赋值
 */
- (SQLStringCreator *(^)(NSInteger numberOfCols))values;


/**
 修改数据，传入表名称
 */
- (SQLStringCreator *(^)(NSString *tableName))update;

/**
 设置数据,格式 uid=?,name=? NSArray *
 */
- (SQLStringCreator *(^)(NSArray *columns))set;


/**
 删除数据
 */
- (SQLStringCreator *(^)())del;


/**
 占位符，传入字符串
 */
- (SQLStringCreator *(^)(NSString *placeholder))p;

/**
 空格字符
 */
- (SQLStringCreator *(^)())space;

/**
 结束响应链
 */
- (SQLStringCreator *(^)())end;

/**
 获取sql
 */
- (NSString *(^)())sql;

@end



