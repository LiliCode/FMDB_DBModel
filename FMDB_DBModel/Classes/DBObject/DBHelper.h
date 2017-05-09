//
//  DBHelper.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/8.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface DBHelper : NSObject<NSCopying, NSMutableCopying>

@property (strong , nonatomic, readonly) FMDatabaseQueue *databaseQueue;


/**
 创建静态实例

 @return 返回当前实例
 */
+ (instancetype)sharedInstance;

/**
 获取数据库的路径

 @return 返回字符串
 */
- (NSString *)databasePath;

/**
 删除缓存的数据库

 @param completion 删除完成回调
 */
- (void)removeBufferWithCompletion:(void (^)(NSError *error))completion;


@end
