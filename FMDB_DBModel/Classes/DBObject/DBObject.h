//
//  DBObject.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/8.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sql/Core/ObjcProperty+SQL.h"

@protocol DBSQL <NSObject>

@required
/**
 设置主键

 @return 返回主键字符串
 */
+ (ObjcProperty *)sql_primaryKey;

@optional
/**
 过滤实体类中不需要持久化的字段

 @return 返回需要过滤的字段列表
 */
+ (NSArray *)sql_filterColumn;


@end


@interface DBObject : NSObject<DBSQL>


/**
 如果表不存在就创建表

 @param tableName 表名称
 @parameter 表的列名称列表
 @return 返回是否创建成功 YES:成功
 */
+ (BOOL)createTableIfNotExists:(NSString *)tableName parameter:(NSArray <ObjcProperty *>*)parameter;

/**
 创建表
 ----表名称就是模型类的类名

 @return 返回是否创建成功 YES:成功
 */
+ (BOOL)createTable;

#pragma mark - 查找数据


/**
 查找当前表中全部数据

 @param completion 查找完成的回调，返回结果
 */
+ (void)selectWithCompletion:(void (^)(NSArray *result))completion;

/**
 通过where条件查找当前表中的数据

 @param query query 条件表达式
 @param completion 返回符合query的数据
 */
+ (void)selectByQuery:(NSString *)query completion:(void (^)(NSArray *result))completion;

#pragma mark - 更新和保存数据

/**
 保存数据
 ----先在该表中查找是否存在这个主键，如果存在就执行更新，不存在就保存新数据
 */
- (void)save;

/**
 保存数据，功能同 -(void)save

 @param completion 保存完成的回调，error = nil 保存成功
 */
- (void)saveWithCompletion:(void (^)(NSError *error))completion;

/**
 批量保存数据

 @param objects 实体对象列表
 @param completion 保存完成回调
 */
+ (void)saveObjects:(NSArray *)objects completion:(void (^)(NSError *error))completion;

/**
 插入一条数据
 */
- (void)insert;

/**
 插入一条数据

 @param completion 插入完成的回调，error = nil 插入成功
 */
- (void)insertWithCompletion:(void (^)(NSError *error))completion;

/**
 批量插入数据

 @param objects DBObject子类对象
 @param completion 插入完成的回调，error = nil 插入成功
 */
+ (void)insertObjects:(NSArray *)objects completion:(void (^)(NSError *error))completion;


/**
 更新数据
 */
- (void)update;

/**
 更新数据

 @param completion 更新完成的回调，error = nil 更新成功
 */
- (void)updateWithCompletion:(void (^)(NSError *error))completion;

/**
 批量更新数据

 @param objects DBObject子类对象
 @param completion 更新完成的回调，error = nil 更新成功
 */
+ (void)updateObjects:(NSArray *)objects completion:(void (^)(NSError *error))completion;

#pragma mark - 删除数据

/**
 删除一条数据
 */
- (void)deleteObject;

/**
 删除一条数据

 @param completion 删除完成回调
 */
- (void)deleteObjectWithCompletion:(void (^)(NSError *error))completion;

/**
 批量删除数据

 @param objects 实体对象列表
 @param completion 删除完成回调
 */
+ (void)deleteObjects:(NSArray *)objects completion:(void (^)(NSError *error))completion;

@end






