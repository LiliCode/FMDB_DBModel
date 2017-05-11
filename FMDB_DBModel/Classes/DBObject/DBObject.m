//
//  DBObject.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/8.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "DBObject.h"
#import "DBHelper.h"
#import "ObjcProperty/NSObject+Runtime.h"
#import "Sql/SQLStringCreator.h"

@implementation DBObject

- (instancetype)init
{
    if (self = [super init])
    {
        //创建表
        [self.class createTable];
    }
    
    return self;
}

+ (NSArray *)getAllProperty
{
    //过滤不需要的字段
    
    return [self.class getPropertyList];
}

+ (BOOL)createTable
{
    NSArray *columns = [self getAllProperty];  //获取实体类的属性列表
    return [self createTableIfNotExists:NSStringFromClass(self.class) parameter:columns];
}

+ (BOOL)createTableIfNotExists:(NSString *)tableName parameter:(NSArray <ObjcProperty *>*)parameter
{
    if (!tableName || !parameter.count)
    {
        NSAssert(tableName && parameter.count, @"创建表的参数不齐全!");
        return NO;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[DBHelper sharedInstance] databasePath]];
    if (![db open])
    {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    //创建SQL
    SQLStringCreator *sql = [SQLStringCreator creator];
    //执行SQL
    if (![db executeUpdate:[sql sql_createTable:tableName ifNotExists:YES columns:parameter]])
    {
        NSLog(@"%@ 表创建失败!", tableName);
        return NO;
    }
    
    //检测新增的字段，如果实体类新增了字段就在表中添加一个字段
    //获取scheme
    NSMutableArray *tableColumnList = [[NSMutableArray alloc] init];
    FMResultSet *result = [db getTableSchema:tableName];
    while ([result next])
    {
        [tableColumnList addObject:[result stringForColumn:@"name"]];    //获取表中的字段
    }
    
    //--提取实体类中的字段
    NSMutableArray *entityColumnList = [[NSMutableArray alloc] init];
    for (ObjcProperty *pro in parameter)
    {
        [entityColumnList addObject:pro.propertyName];
    }
    //--筛选
    NSPredicate *filterColumnPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", tableColumnList];
    NSArray *resultList = [entityColumnList filteredArrayUsingPredicate:filterColumnPredicate];
    //--新增字段
    for (NSString *column in resultList)
    {
        for (ObjcProperty *pro in parameter)
        {
            if ([pro.propertyName isEqualToString:column])
            {
                //执行SQL
                if (![db executeUpdate:[sql sql_alterTable:tableName addColumn:pro]])
                {
                    NSLog(@"%@ 新增字段失败!", tableName);
                    return NO;
                }
            }
            
            break;
        }
    }
    
    [db close];
    return YES;
}


+ (void)selectWithCompletion:(void (^)(NSArray *))completion
{
    [self selectByQuery:nil completion:completion];
}

+ (void)selectByQuery:(NSString *)query completion:(void (^)(NSArray *))completion
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    [[DBHelper sharedInstance].databaseQueue inDatabase:^(FMDatabase *db) {
        NSArray *propertys = [self getAllProperty];
        SQLStringCreator *sql = [SQLStringCreator creator];
        NSString *sql_sc = [sql sql_select:nil from:NSStringFromClass([self class]) where:query];
        FMResultSet *result = [db executeQuery:sql_sc];
        while ([result next])
        {
            //创建实体类
            DBObject *entity = [[[self class] alloc] init];
            for (ObjcProperty *pro in propertys)
            {
                [pro toSqliteType];
                if ([pro.sqlType isEqualToString:[SQL_TEXT copy]])
                {
                    [entity setValue:[result stringForColumn:pro.propertyName] forKey:pro.propertyName];
                }
                else if ([pro.sqlType isEqualToString:[SQL_INTEGER copy]])
                {
                    [entity setValue:@([result longLongIntForColumn:pro.propertyName]) forKey:pro.propertyName];
                }
                else if ([pro.sqlType isEqualToString:[SQL_REAL copy]])
                {
                    [entity setValue:@([result doubleForColumn:pro.propertyName]) forKey:pro.propertyName];
                }
                else if ([pro.sqlType isEqualToString:[SQL_BLOB copy]])
                {
                    // TODO...
                }
            }
            //添加到数组
            [resultList addObject:entity];
        }
        
        //获取完成回调
        if (completion)
        {
            completion(resultList);
        }
    }];
}

- (void)save
{
    [self saveWithCompletion:nil];
}

- (void)saveWithCompletion:(void (^)(NSError *))completion
{
    if ([self respondsToSelector:@selector(sql_primaryKey)] && [self sql_primaryKey])
    {
        ObjcProperty *pKey = [self sql_primaryKey];
        NSString *query = [NSString stringWithFormat:@"%@=%@", pKey.propertyName, pKey.value];
        [[DBHelper sharedInstance].databaseQueue inDatabase:^(FMDatabase *db) {
            SQLStringCreator *sql = [SQLStringCreator creator];
            //先查找是否有这条数据
            FMResultSet *result = [db executeQuery:[sql sql_select:@[pKey.propertyName] from:NSStringFromClass(self.class) where:query]];
            if ([result next])
            {
                //有这条数据 更新
                [self updateWithCompletion:completion];
            }
            else
            {
                //没有这条数据 保存
                [self insertWithCompletion:nil];
            }
        }];
    }
    else
    {
        //没有主键，直接保存
        [self insertWithCompletion:nil];
    }
}

+ (void)saveObjects:(NSArray *)objects completion:(void (^)(NSError *))completion
{
    for (DBObject *object in objects)
    {
        [object saveWithCompletion:^(NSError *error) {
            if (error)
            {
                NSLog(@"%@", error.description);
            }
        }];
    }
    
    if (completion)
    {
        completion(nil);
    }
}


- (void)insert
{
    [self insertWithCompletion:nil];
}

- (void)insertWithCompletion:(void (^)(NSError *error))completion
{
    NSArray *propertys = [self.class getAllProperty];
    [self setValues:propertys];
    [[DBHelper sharedInstance].databaseQueue inDatabase:^(FMDatabase *db) {
        SQLStringCreator *sql = [SQLStringCreator creator];
        NSString *sql_it = [sql sql_insertInto:NSStringFromClass(self.class) values:propertys];
        if (![db executeUpdate:sql_it])
        {
            if (completion)
            {
                completion([NSError errorWithDomain:sql_it code:0 userInfo:@{NSLocalizedDescriptionKey:@"数据插入失败"}]);
            }
        }
        else
        {
            if (completion)
            {
                completion(nil);
            }
        }
    }];
}

+ (void)insertObjects:(NSArray *)objects completion:(void (^)(NSError *error))completion
{
    for (DBObject *object in objects)
    {
        [object insertWithCompletion:^(NSError *error) {
            if (error)
            {
                NSLog(@"%@", error.description);
            }
        }];
    }
    
    if (completion)
    {
        completion(nil);
    }
}


- (void)update
{
    [self updateWithCompletion:nil];
}

- (void)updateWithCompletion:(void (^)(NSError *))completion
{
    NSArray *propertys = [self.class getAllProperty];
    [self setValues:propertys];
    [[DBHelper sharedInstance].databaseQueue inDatabase:^(FMDatabase *db) {
        SQLStringCreator *sql = [SQLStringCreator creator];
        //先查找是否有这条数据
        if ([self respondsToSelector:@selector(sql_primaryKey)] && [self sql_primaryKey])
        {
            ObjcProperty *pKey = [self sql_primaryKey];
            NSString *query = [NSString stringWithFormat:@"%@=%@", pKey.propertyName, [self valueForKey:pKey.propertyName]];
            //去除主键
            NSMutableArray *mPropertys = [propertys mutableCopy];
            for (ObjcProperty *pro in mPropertys)
            {
                if ([pro.propertyName isEqualToString:pKey.propertyName])
                {
                    [mPropertys removeObject:pro];
                    break;
                }
            }
            //执行SQL
            NSString *sql_ud = [sql sql_update:NSStringFromClass(self.class) set:propertys where:query];
            if (![db executeUpdate:sql_ud])
            {
                if (completion)
                {
                    completion([NSError errorWithDomain:sql_ud code:0 userInfo:@{NSLocalizedDescriptionKey:@"数据修改失败"}]);
                }
            }
            else
            {
                if (completion)
                {
                    completion(nil);
                }
            }
        }
    }];
}

+ (void)updateObjects:(NSArray *)objects completion:(void (^)(NSError *))completion
{
    for (DBObject *obj in objects)
    {
        [obj updateWithCompletion:^(NSError *error) {
            if (error)
            {
                NSLog(@"%@", error.description);
            }
        }];
    }
    
    if (completion)
    {
        completion(nil);
    }
}

- (void)deleteObject
{
    [self deleteObjectWithCompletion:nil];
}

- (void)deleteObjectWithCompletion:(void (^)(NSError *))completion
{
    [[DBHelper sharedInstance].databaseQueue inDatabase:^(FMDatabase *db) {
        SQLStringCreator *sql = [SQLStringCreator creator];
        ObjcProperty *pKey = [self sql_primaryKey];
        NSString *query = [NSString stringWithFormat:@"%@=%@", pKey.propertyName, [self valueForKey:pKey.propertyName]];
        NSString *sql_d = [sql sql_delete:NSStringFromClass(self.class) where:query];
        if (![db executeUpdate:sql_d])
        {
            if (completion)
            {
                completion([NSError errorWithDomain:sql_d code:0 userInfo:@{NSLocalizedDescriptionKey:@"删除数据失败"}]);
            }
        }
        else
        {
            if (completion)
            {
                completion(nil);
            }
        }
    }];
}

+ (void)deleteObjects:(NSArray *)objects completion:(void (^)(NSError *))completion
{
    for (DBObject *obj in objects)
    {
        [obj deleteObjectWithCompletion:^(NSError *error) {
            if (error)
            {
                NSLog(@"%@", error.description);
            }
        }];
    }
    
    if (completion)
    {
        completion(nil);
    }
}


@end








