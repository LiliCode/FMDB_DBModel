//
//  DBHelper.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/8.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "DBHelper.h"

static NSString *kDatabaseFolder = @"DBObjectFiles"; //数据库存的放文件夹
static NSString *kDatabaseName = @"db_file.sqlite";       //数据库名称

@interface DBHelper ()
@property (strong , nonatomic) FMDatabaseQueue *dbQueue;

@end

@implementation DBHelper

static DBHelper *helper = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    
    return helper;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t allocToken;
    dispatch_once(&allocToken, ^{
        helper = [super allocWithZone:zone];
    });
    
    return helper;
}

- (id)copyWithZone:(NSZone *)zone
{
    return helper;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return helper;
}

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue)
    {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self databasePath]];
    }
    
    return _dbQueue;
}

- (FMDatabaseQueue *)databaseQueue
{
    return self.dbQueue;
}

- (NSString *)databasePath
{
    //存储在沙盒的Docmuent中
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbFolder = [document stringByAppendingPathComponent:kDatabaseFolder];
    NSFileManager *fm = [NSFileManager defaultManager];
    //判断是否存在这个文件夹
    BOOL isFolder = NO;
    BOOL isDirExist = [fm fileExistsAtPath:dbFolder isDirectory:&isFolder];
    if(!(isFolder && isDirExist))
    {
        [fm createDirectoryAtPath:dbFolder withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return [dbFolder stringByAppendingPathComponent:kDatabaseName];
}

- (void)removeBufferWithCompletion:(void (^)(NSError *))completion
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [[document stringByAppendingPathComponent:kDatabaseFolder] stringByAppendingPathComponent:kDatabaseName];
    NSFileManager *fm = [NSFileManager defaultManager];
    //判断是否存在这个文件夹
    BOOL isFolder = NO;
    BOOL isDirExist = [fm fileExistsAtPath:dbPath isDirectory:&isFolder];
    if(isFolder && isDirExist)  //存在的时候就删除
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error = nil;
            [fm removeItemAtPath:dbPath error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion)
                {
                    completion(error);
                }
            });
        });
    }
    else
    {
        NSError *error = [NSError errorWithDomain:dbPath code:0 userInfo:@{NSLocalizedDescriptionKey : @"无缓存可以删除"}];
        if (completion)
        {
            completion(error);
        }
    }
}


@end




