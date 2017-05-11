//
//  SQLStringCreator.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqlCore.h"

@class ObjcProperty;


#define DBTableName(object) NSStringFromClass([object class])


@interface SQLStringCreator : NSObject

/**
 创造器

 @return 返回当前实例
 */
+ (instancetype)creator;


/**
 生成创建表的SQL语句

 @param tableName 表名称
 @param ine 如果没有这个表就创建的语句
 @param columns 列参数
 @return 返回完整语句
 */
- (NSString *)sql_createTable:(NSString *)tableName ifNotExists:(BOOL)ine columns:(NSArray <ObjcProperty *>*)columns;

/**
 生成删除表的SQL语句

 @param tableName 表名称
 @param ifExists 是否插入判断表是否存在的语句
 @return 返回完整的语句
 */
- (NSString *)sql_dropTable:(NSString *)tableName ifExists:(BOOL)ifExists;

/**
 生成增加列的SQL语句

 @param tableName 表名称
 @param column 新增的列，类型：ObjcProperty *
 @return 返回完整的SQL
 */
- (NSString *)sql_alterTable:(NSString *)tableName addColumn:(ObjcProperty *)column;


/**
 生成查询语句

 @param columns 需要查询的字段
 @param tableName 表名称
 @param query where条件，查询条件
 @return 返回完整的SQL
 */
- (NSString *)sql_select:(NSArray <NSString *>*)columns from:(NSString *)tableName where:(NSString *)query;

/**
 生成查询语句
 ----不会查找重复的数据

 @param columns 需要查询的字段
 @param tableName 表名称
 @param query where条件，查询条件
 @return 返回完整的SQL
 */
- (NSString *)sql_select_distinct:(NSArray <NSString *>*)columns from:(NSString *)tableName where:(NSString *)query;

/**
 生成插入一行的语句

 @param tableName 表名称
 @param values 数值列表
 @return 返回完整的SQL
 */
- (NSString *)sql_insertInto:(NSString *)tableName values:(NSArray <ObjcProperty *>*)values;

/**
 生成修改数据的语句

 @param tableName 表名称
 @param columns 列名称+数值，name='EHUU'
 @param query where子句
 @return 返回完整的SQL
 */
- (NSString *)sql_update:(NSString *)tableName set:(NSArray <ObjcProperty *>*)columns where:(NSString *)query;

/**
 生成删除行的语句

 @param tableName 表名称
 @param query 条件语句
 @return 返回完整的SQL
 */
- (NSString *)sql_delete:(NSString *)tableName where:(NSString *)query;


@end





