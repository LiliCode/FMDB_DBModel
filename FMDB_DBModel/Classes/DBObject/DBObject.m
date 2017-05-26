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

+ (void)initialize
{
    if (self != [DBObject self])
    {
        //创建表
        [self.class createTable];
    }
}

+ (NSArray *)getAllProperty
{
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    //获取实体类全部字段
    NSArray *propertys = [self.class getPropertyList];
    //过滤不需要的字段
    if ([self.class respondsToSelector:@selector(sql_filterColumn)])
    {
        NSMutableArray *filterList = [[self.class sql_filterColumn] mutableCopy];
        if (filterList.count)
        {
            for (ObjcProperty *pro in propertys)
            {
                BOOL isExists = NO;
                for (NSString *filterColumn in filterList)
                {
                    if ([pro.propertyName isEqualToString:filterColumn])
                    {
                        isExists = YES;
                        [filterList removeObject:filterColumn];
                        break;
                    }
                }
                
                if (!isExists)
                {
                    [columns addObject:pro];
                }
            }
        }
        else
        {
            [columns addObjectsFromArray:propertys];
        }
    }
    else
    {
        [columns addObjectsFromArray:propertys];
    }
    
    return [columns copy];
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
    SQLStringCreator *sql = [SQLStringCreator sqlCreator];
    ObjcProperty *primaryKeyPro = nil;
    if ([self.class respondsToSelector:@selector(sql_primaryKey)])
    {
        primaryKeyPro = [self.class sql_primaryKey];    //获取主键
    }
    //组建参数
    NSMutableArray *columns = [NSMutableArray new];
    for (ObjcProperty *pro in parameter)
    {
        [pro toSqliteType];
        NSString *pKey = @"";
        if ([pro.propertyName isEqualToString:primaryKeyPro.propertyName])  pKey = @" PRIMARY KEY";
        
        NSString *pars = [NSString stringWithFormat:@"%@ %@%@", pro.propertyName, pro.sqlType, pKey];
        [columns addObject:pars];
    }
    
    //执行SQL
    if (![db executeUpdate:sql.create_table(YES, NSStringFromClass([self class]), [columns copy]).end().sql()])
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
                SQLStringCreator *sql_alter = [SQLStringCreator sqlCreator];
                if (![db executeUpdate:sql_alter.alter_table(tableName).space().add(pro.propertyName, pro.sqlType).end().sql()])
                {
                    NSLog(@"%@ 新增字段失败!", tableName);
                    return NO;
                }
                break;
            }
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
        SQLStringCreator *sql = [SQLStringCreator sqlCreator];
        NSString *sql_sc = sql.select(nil).space().from(NSStringFromClass([self class])).space().where(query).end().sql();
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
                    if ([pro.objcType isEqualToString:ObjcTypeNSDate])
                    {
                        //日期
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[result longLongIntForColumn:pro.propertyName]];
                        [entity setValue:date forKey:pro.propertyName];
                    }
                    else
                    {
                        [entity setValue:@([result longLongIntForColumn:pro.propertyName]) forKey:pro.propertyName];
                    }
                }
                else if ([pro.sqlType isEqualToString:[SQL_REAL copy]])
                {
                    [entity setValue:@([result doubleForColumn:pro.propertyName]) forKey:pro.propertyName];
                }
                else if ([pro.sqlType isEqualToString:[SQL_BLOB copy]])
                {
                    //解档
                    id blob = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:pro.propertyName]];
                    [entity setValue:blob forKey:pro.propertyName];
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
    if ([self.class respondsToSelector:@selector(sql_primaryKey)] && [self.class sql_primaryKey])
    {
        ObjcProperty *pKey = [self.class sql_primaryKey];
        pKey.value = [self valueForKey:pKey.propertyName];
        //查询条件
        NSString *query = [NSString stringWithFormat:@"%@=%@", pKey.propertyName, pKey.value];
        FMDatabaseQueue *saveQueue = [FMDatabaseQueue databaseQueueWithPath:[[DBHelper sharedInstance] databasePath]];
        [saveQueue inDatabase:^(FMDatabase *db) {
            SQLStringCreator *sql = [SQLStringCreator sqlCreator];
            //先查找是否有这条数据
            FMResultSet *result = [db executeQuery:sql.select(@[pKey.propertyName]).space().from(NSStringFromClass(self.class)).space().where(query).end().sql()];
            if ([result next])
            {
                [result close]; //关闭查询结果，否则保存出错
                
                //有这条数据就更新
                [self updateWithCompletion:completion];
            }
            else
            {
                //没有这条数据就保存
                [self insertWithCompletion:completion];
            }
        }];
    }
    else
    {
        //没有主键，直接保存
        [self insertWithCompletion:completion];
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
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *columnNames = [NSMutableArray new];
    for (ObjcProperty *pro in propertys)
    {
        [values addObject:[[pro defaultValue] value]];
        [columnNames addObject:pro.propertyName];
    }
    
    [[DBHelper sharedInstance].databaseQueue inDatabase:^(FMDatabase *db) {
        SQLStringCreator *sql = [SQLStringCreator sqlCreator];
        NSString *sql_it = sql.insert_into(NSStringFromClass(self.class), [columnNames copy]).space().values(values.count).end().sql();
        if (![db executeUpdate:sql_it withArgumentsInArray:[values copy]])
        {
            if (completion)
            {
                completion([db lastError]);
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
    [[DBHelper sharedInstance].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL err = NO;
        for (DBObject *entity in objects)
        {
            NSArray *propertys = [entity.class getAllProperty];
            [entity setValues:propertys];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            NSMutableArray *columnNames = [NSMutableArray new];
            for (ObjcProperty *pro in propertys)
            {
                [values addObject:[[pro defaultValue] value]];
                [columnNames addObject:pro.propertyName];
            }
            
            SQLStringCreator *sql = [SQLStringCreator sqlCreator];
            NSString *sql_it = sql.insert_into(NSStringFromClass(entity.class), [columnNames copy]).space().values(values.count).end().sql();
            if (![db executeUpdate:sql_it withArgumentsInArray:[values copy]])
            {
                NSLog(@"%@", [db lastError]);
                err = YES;
                *rollback = YES;
            }
        }
        
        if (completion)
        {
            if (err)
            {
                completion([db lastError]);
            }
            else
            {
                completion(nil);
            }
        }
    }];
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
        SQLStringCreator *sql = [SQLStringCreator sqlCreator];
        //先查找是否有这条数据
        if ([self.class respondsToSelector:@selector(sql_primaryKey)] && [self.class sql_primaryKey])
        {
            ObjcProperty *pKey = [self.class sql_primaryKey];
            pKey.value = [self valueForKey:pKey.propertyName];
//            SqlCore *sqlcore = [[SqlCore alloc] init];
            NSString *query = [NSString stringWithFormat:@"%@=%@", pKey.propertyName, pKey.value];
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
            //提取值
            NSMutableArray *values = [[NSMutableArray alloc] init];
            NSMutableArray *columnNames = [NSMutableArray new];
            for (ObjcProperty *pro in mPropertys)
            {
                [values addObject:[[pro defaultValue] value]];
                [columnNames addObject:pro.propertyName];
            }
            //执行SQL
            NSString *sql_ud = sql.update(NSStringFromClass(self.class)).space().set([columnNames copy]).where(query).end().sql();
            if (![db executeUpdate:sql_ud withArgumentsInArray:[values copy]])
            {
                if (completion)
                {
                    completion([db lastError]);
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
    [[DBHelper sharedInstance].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL err = NO;
        for (DBObject *entity in objects)
        {
            NSArray *propertys = [entity.class getAllProperty];
            [entity setValues:propertys];
            SQLStringCreator *sql = [SQLStringCreator sqlCreator];
            //先查找是否有这条数据
            if ([entity.class respondsToSelector:@selector(sql_primaryKey)] && [entity.class sql_primaryKey])
            {
                ObjcProperty *pKey = [self.class sql_primaryKey];
                pKey.value = [entity valueForKey:pKey.propertyName];
//                SqlCore *sqlcore = [[SqlCore alloc] init];
                NSString *query = [NSString stringWithFormat:@"%@=%@", pKey.propertyName, pKey.value];
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
                //提取值
                NSMutableArray *values = [[NSMutableArray alloc] init];
                NSMutableArray *columnNames = [NSMutableArray new];
                for (ObjcProperty *pro in mPropertys)
                {
                    [values addObject:[[pro defaultValue] value]];
                    [columnNames addObject:pro.propertyName];
                }
                //执行SQL
                NSString *sql_ud = sql.update(NSStringFromClass(entity.class)).space().set([columnNames copy]).where(query).end().sql();
                if (![db executeUpdate:sql_ud withArgumentsInArray:[values copy]])
                {
                    NSLog(@"%@", [db lastError]);
                    err = YES;
                    *rollback = YES;    //回滚事务
                }
            }
        }
        
        if (completion)
        {
            if (err)
            {
                completion([db lastError]);
            }
            else
            {
                completion(nil);
            }
        }
    }];
}

- (void)deleteObject
{
    [self deleteObjectWithCompletion:nil];
}

- (void)deleteObjectWithCompletion:(void (^)(NSError *))completion
{
    [[DBHelper sharedInstance].databaseQueue inDatabase:^(FMDatabase *db) {
        SQLStringCreator *sql = [SQLStringCreator sqlCreator];
        ObjcProperty *pKey = nil;
        if ([self.class respondsToSelector:@selector(sql_primaryKey)] && [self.class sql_primaryKey])
        {
            pKey = [self.class sql_primaryKey];
            pKey.value = [self valueForKey:pKey.propertyName];
        }
        
        NSString *query = [NSString stringWithFormat:@"%@=%@", pKey.propertyName, pKey.value];
//        NSString *sql_d = [sql sql_delete:NSStringFromClass(self.class) where:query];
        NSString *sql_d = sql.del().space().from(NSStringFromClass(self.class)).space().where(query).end().sql();
        if (![db executeUpdate:sql_d])
        {
            if (completion)
            {
                completion([db lastError]);
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
    [[DBHelper sharedInstance].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL err = NO;  //保存在sql执行中出错的状态
        for (DBObject *entity in objects)
        {
            SQLStringCreator *sql = [SQLStringCreator sqlCreator];
            ObjcProperty *pKey = nil;
            if ([entity.class respondsToSelector:@selector(sql_primaryKey)] && [entity.class sql_primaryKey])
            {
                pKey = [entity.class sql_primaryKey];
                pKey.value = [entity valueForKey:pKey.propertyName];
            }
            
            NSString *query = [NSString stringWithFormat:@"%@=%@", pKey.propertyName, pKey.value];
            NSString *sql_d = sql.del().space().from(NSStringFromClass(entity.class)).space().where(query).end().sql();
            if (![db executeUpdate:sql_d])
            {
                NSLog(@"%@", [db lastError]);
                err = YES;      //已经出错
                *rollback = YES;//事物回滚
                break;
            }
        }
        
        if (completion)
        {
            if (err)
            {
                completion([db lastError]);
            }
            else
            {
                completion(nil);
            }
        }
    }];
}


@end








