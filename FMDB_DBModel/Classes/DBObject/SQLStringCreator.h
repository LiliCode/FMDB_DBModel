//
//  SQLStringCreator.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjcProperty;

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
 生成查询语句

 @param columns 需要查询的字段
 @param tableName 表名称
 @param query where条件，查询条件
 @return 返回完整的SQL
 */
- (NSString *)sql_select:(NSArray <NSString *>*)columns from:(NSString *)tableName where:(NSString *)query;

/**
 生成插入一行的语句

 @param tableName 表名称
 @param values 数值列表
 @return 返回完整的SQL
 */
- (NSString *)sql_insertInto:(NSString *)tableName values:(NSArray <ObjcProperty *>*)values;

@end





