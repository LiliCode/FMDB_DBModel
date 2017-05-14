//
//  ObjcProperty+SQL.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "ObjcProperty.h"


/* SQLite 数据类型 SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL */
FOUNDATION_EXPORT const NSString *const SQL_TEXT;     //文本
FOUNDATION_EXPORT const NSString *const SQL_INTEGER;  //整数
FOUNDATION_EXPORT const NSString *const SQL_REAL;     //浮点数
FOUNDATION_EXPORT const NSString *const SQL_BLOB;     //大型对象 BLOB就是使用二进制保存数据
FOUNDATION_EXPORT const NSString *const SQL_NULL;     //空类型 空值

@interface ObjcProperty (SQL)

@property (copy , nonatomic) NSString *sqlType; //SQLite中的数据类型

/**
 转换成SQLite类型
 */
- (void)toSqliteType;


@end
