//
//  ViewController.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/8.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "ViewController.h"
#import "SQLStringCreator.h"
#import "Contacts.h"
#import "NSObject+Runtime.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Contacts *contacts = [[Contacts alloc] init];
    
    SQLStringCreator *sqlCreator = [SQLStringCreator creator];
    
    NSString *sql_createTable = [sqlCreator sql_createTable:NSStringFromClass(contacts.class) ifNotExists:YES columns:[contacts getPropertyList]];
    NSLog(@"%@", sql_createTable);
    
    NSString *sql_dropTable = [sqlCreator sql_dropTable:NSStringFromClass(contacts.class) ifExists:YES];
    NSLog(@"%@", sql_dropTable);
    
    NSString *sql_selectTable = [sqlCreator sql_select:@[@"uid", @"tel"] from:NSStringFromClass(contacts.class) where:@"uid >= 1 AND uid < 3"];
    NSLog(@"%@", sql_selectTable);
    
    NSString *sql_insertTable = [sqlCreator sql_insertInto:NSStringFromClass(contacts.class) values:[contacts getPropertyList]];
    NSLog(@"%@", sql_insertTable);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end




