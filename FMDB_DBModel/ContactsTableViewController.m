//
//  ContactsTableViewController.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "AddContantViewController.h"
#import "Contacts.h"

@interface ContactsTableViewController ()
@property (strong , nonatomic) NSMutableArray *list;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Contacts selectWithCompletion:^(NSArray *result) {
        if (result.count)
        {
            self.list = [result mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)addContact:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"add" sender:@{@"style":@(ContactStyle_add)}];
}

- (IBAction)removeAllContact:(UIBarButtonItem *)sender
{
    if (!self.list.count)
    {
        return ;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:@"是否全部删除" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [Contacts deleteObjects:[self.list copy] completion:^(NSError *error) {
            if (error)
            {
                NSLog(@"%@", error);
            }
            else
            {
                [self.list removeAllObjects];
                [self.tableView reloadData];
            }
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Contacts *contact = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.tel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Contacts *contact = [self.list objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"add" sender:@{@"obj":contact, @"style":@(ContactStyle_edit)}];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        Contacts *contact = [self.list objectAtIndex:indexPath.row];
        [contact deleteObjectWithCompletion:^(NSError *error) {
            if (error)
            {
                NSLog(@"%@", error);
            }
            else
            {
                [self.list removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"add"])
    {
        AddContantViewController *contactViewController = [segue destinationViewController];
        contactViewController.mode = (ContactStyle)[[sender objectForKey:@"style"] unsignedIntegerValue];
        contactViewController.contact = [sender objectForKey:@"obj"];
    }
}


@end
