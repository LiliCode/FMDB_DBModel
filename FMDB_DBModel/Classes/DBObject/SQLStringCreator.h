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



@end


