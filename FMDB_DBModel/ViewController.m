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
@property (weak, nonatomic) IBOutlet UITextView *consoleView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if 0
    Contacts *contacts = [[Contacts alloc] init];
    contacts.uid = 6;
    contacts.name = @"EHUU";
    contacts.tel = @"028-65770888";
//    contacts.logo = @"/user/EhuuLogo.jpg";
    
    SQLStringCreator *sqlCreator = [SQLStringCreator creator];
    
    NSString *sql_createTable = [sqlCreator sql_createTable:NSStringFromClass(contacts.class) ifNotExists:YES columns:[contacts.class getPropertyList]];
    NSLog(@"%@", sql_createTable);
    
    NSString *sql_dropTable = [sqlCreator sql_dropTable:NSStringFromClass(contacts.class) ifExists:YES];
    NSLog(@"%@", sql_dropTable);
    
    NSString *sql_selectTable = [sqlCreator sql_select_distinct:@[@"uid", @"tel"] from:NSStringFromClass(contacts.class) where:@"uid >= 1 AND uid < 3"];
    NSLog(@"%@", sql_selectTable);
    
    NSString *sql_insertTable = [sqlCreator sql_insertInto:NSStringFromClass(contacts.class) values:[contacts.class getPropertyList]];
    NSLog(@"%@", sql_insertTable);
    
    NSString *sql_updateTable = [sqlCreator sql_update:NSStringFromClass(contacts.class) set:[contacts.class getPropertyList] where:@"uid = 6"];
    NSLog(@"%@", sql_updateTable);
    
    NSString *sql_deleteTable = [sqlCreator sql_delete:DBTableName(contacts) where:@"uid = 6"];
    NSLog(@"%@", sql_deleteTable);
    
    NSString *sql_alter = [sqlCreator sql_alterTable:DBTableName(contacts) addColumn:[[contacts.class getPropertyList] lastObject]];
    NSLog(@"%@", sql_alter);
#endif
    
}

- (IBAction)insertList:(UIButton *)sender
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++)
    {
        Contacts *contact = [[Contacts alloc] init];
        contact.name = [NSString stringWithFormat:@"User-%u", arc4random() % 1000];
        contact.tel = [NSString stringWithFormat:@"1828185%u%u%u%u", arc4random() % 9, arc4random() % 9, arc4random() % 9, arc4random() % 9];
        contact.address = @"九重天";
        
        [list addObject:contact];
    }
    
    [Contacts insertObjects:[list copy] completion:^(NSError *error) {
        if (error)
        {
            self.consoleView.text = error.description;
        }
        else
        {
            self.consoleView.text = @"批量插入contact成功!";
        }
    }];
}

- (IBAction)updateList:(UIButton *)sender
{
    //查询全部数据
    __block NSMutableArray *mResult = [[NSMutableArray alloc] init];
    [Contacts selectWithCompletion:^(NSArray *result) {
        [mResult addObjectsFromArray:result];
    }];
    
    for (Contacts *contact in mResult)
    {
        contact.name = [NSString stringWithFormat:@"User-%u", arc4random() % 1000];
    }
    
    [Contacts updateObjects:mResult completion:^(NSError *error) {
        if (error)
        {
            self.consoleView.text = error.description;
        }
        else
        {
            self.consoleView.text = @"批量更改数据成功";
        }
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end




