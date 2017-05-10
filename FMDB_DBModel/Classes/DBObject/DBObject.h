//
//  DBObject.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/8.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DBSQL <NSObject>

@optional

/**
 设置主键

 @return 返回主键字符串
 */
- (NSString *)sql_primaryKey;

@end


@interface DBObject : NSObject

@property (assign , nonatomic) unsigned long long pKey; // PRIMARY KEY


/**
 如果表不存在就创建表

 @param tableName 表名称
 @parameter 表的列名称列表
 @return 返回是否创建成功 YES:成功
 */
+ (BOOL)createTableIfNotExists:(NSString *)tableName parameter:(NSArray *)parameter;

/**
 创建表
 ----表名称就是模型类的类名

 @return 返回是否创建成功 YES:成功
 */
+ (BOOL)createTable;



@end
