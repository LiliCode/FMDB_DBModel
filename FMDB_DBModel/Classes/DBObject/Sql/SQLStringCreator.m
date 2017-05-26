//
//  SQLStringCreator.m
//  SQLStringCreator-Reactive
//
//  Created by LiliEhuu on 17/5/25.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "SQLStringCreator.h"

@interface SQLStringCreator ()
@property (strong , nonatomic) NSMutableString *resultSql;

@end

@implementation SQLStringCreator

- (instancetype)init
{
    if (self = [super init])
    {
        self.resultSql = [[NSMutableString alloc] init];
    }
    
    return self;
}

+ (instancetype)sqlCreator
{
    return [[[self class] alloc] init];
}

+ (NSString *)makeSqlString:(void (^)(SQLStringCreator *))makeBlock
{
    SQLStringCreator *sqlC = [[SQLStringCreator alloc] init];
    if (makeBlock)
    {
        makeBlock(sqlC);
    }
    
    return [sqlC.resultSql copy];
}


- (SQLStringCreator *(^)(BOOL, NSString *, NSArray *))create_table
{
    return ^SQLStringCreator *(BOOL ifNotExists, NSString *tableName, NSArray *columns) {
        [self.resultSql appendString:@"CREATE TABLE "];
        if (ifNotExists) [self.resultSql appendString:@"IF NOT EXISTS "];
        [self.resultSql appendFormat:@"%@(", tableName];
        
        [self.resultSql appendString:[columns componentsJoinedByString:@","]];
        
        [self.resultSql appendString:@")"];
        
        return self;
    };
}

- (SQLStringCreator *(^)(BOOL, NSString *))drop_table
{
    return ^SQLStringCreator *(BOOL ifExists, NSString *tableName) {
        [self.resultSql appendString:@"DROP TABLE "];
        if (ifExists) [self.resultSql appendString:@"IF EXISTS "];
        [self.resultSql appendString:tableName];
        
        return self;
    };
}


- (SQLStringCreator *(^)(NSString *))alter_table
{
    return ^SQLStringCreator *(NSString *tableName) {
        [self.resultSql appendFormat:@"ALTER TABLE %@",tableName];
        
        return self;
    };
}

- (SQLStringCreator *(^)(NSString *, NSString *))add
{
    return ^SQLStringCreator *(NSString *column, NSString *type) {
        [self.resultSql appendFormat:@"ADD COLUMN %@ %@", column, type];
        
        return self;
    };
}


- (SQLStringCreator *(^)(NSArray *))select
{
    return ^SQLStringCreator *(NSArray *columns) {
        NSString *cols = [columns componentsJoinedByString:@","]?:@"*";
        [self.resultSql appendString:@"SELECT "];
        [self.resultSql appendString:cols];
        
        return self;
    };
}

- (SQLStringCreator *(^)(NSArray *))select_distinct
{
    return ^SQLStringCreator *(NSArray *columns) {
        NSString *cols = [columns componentsJoinedByString:@","]?:@"*";
        [self.resultSql appendString:@"SELECT DISTINCT "];
        [self.resultSql appendString:cols];
        
        return self;
    };
}


- (SQLStringCreator *(^)(NSString *))from
{
    return ^SQLStringCreator *(NSString *tableName) {
        [self.resultSql appendString:@"FROM "];
        [self.resultSql appendString:tableName];
        
        return self;
    };
}

- (SQLStringCreator *(^)(NSString *))where
{
    return ^SQLStringCreator *(NSString *query) {
        if (query.length)
        {
            [self.resultSql appendString:@"WHERE "];
            [self.resultSql appendString:query];
        }
        
        return self;
    };
}

- (SQLStringCreator *(^)(NSString *, NSArray *columns))insert_into
{
    return ^SQLStringCreator *(NSString *tableName, NSArray *columns) {
        [self.resultSql appendString:@"INSERT INTO "];
        [self.resultSql appendFormat:@"%@(", tableName];
        NSString *saveColumn = [columns componentsJoinedByString:@","];
        [self.resultSql appendFormat:@"%@)", saveColumn];
        
        return self;
    };
}

- (SQLStringCreator *(^)(NSInteger))values
{
    return ^SQLStringCreator *(NSInteger numberOfCols) {
        NSMutableArray *valueList = [NSMutableArray new];
        for (NSInteger count = 0; count < numberOfCols; count++)
        {
            [valueList addObject:@"?"];
        }
        
        [self.resultSql appendFormat:@"VALUES(%@)", [valueList componentsJoinedByString:@","]];
        
        return self;
    };
}


- (SQLStringCreator *(^)(NSString *))update
{
    return ^SQLStringCreator *(NSString *tableName) {
        [self.resultSql appendFormat:@"UPDATE %@", tableName];
        
        return self;
    };
}

- (SQLStringCreator *(^)(NSArray *))set
{
    return ^SQLStringCreator *(NSArray *columns) {
        NSMutableArray *keyValues = [NSMutableArray new];
        for (NSString *col in columns)
        {
            NSString *keyValueStr = [NSString stringWithFormat:@"%@=?", col];
            [keyValues addObject:keyValueStr];
        }
        
        [self.resultSql appendFormat:@"SET %@", [keyValues componentsJoinedByString:@","]];
        
        return self;
    };
}


- (SQLStringCreator *(^)())del
{
    return ^SQLStringCreator *() {
        [self.resultSql appendString:@"DELETE"];
        
        return self;
    };
}


- (SQLStringCreator *(^)(NSString *))p
{
    return ^SQLStringCreator *(NSString *placeholder) {
        [self.resultSql appendString:placeholder];
        
        return self;
    };
}

- (SQLStringCreator *(^)())space
{
    return ^SQLStringCreator *() {
        [self.resultSql appendString:@" "];
        
        return self;
    };
}

- (SQLStringCreator *(^)())end
{
    return ^SQLStringCreator *() {
        [self.resultSql appendString:@";"];
        return self;
    };
}

- (NSString *(^)())sql
{
    return ^NSString *() {
        return [self.resultSql copy];
    };
}




@end


