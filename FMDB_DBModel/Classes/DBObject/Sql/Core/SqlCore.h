//
//  SqlCore.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/10.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjcProperty+SQL.h"

@interface NSString (SqlCore)

- (NSString *)sql_and:(NSString *)value;

- (NSString *)sql_or:(NSString *)value;

@end

@interface SqlCore : NSObject

/* 操作符 */

- (NSString *)operator_equal:(ObjcProperty *)objcPro;

/* SELECT */

- (NSString *)select:(NSArray *)cols;

- (NSString *)select_distinct:(NSArray *)cols;

- (NSString *)from:(NSString *)tableName;

- (NSString *)where:(NSString *)query;

/* INSERT INTO */

- (NSString *)values:(NSArray <ObjcProperty *>*)valueList;


/* UPDATE */

- (NSString *)update:(NSString *)tableName;

- (NSString *)set:(NSArray <ObjcProperty *>*)columns;

@end




