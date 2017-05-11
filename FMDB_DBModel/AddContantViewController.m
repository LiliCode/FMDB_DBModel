//
//  AddContantViewController.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "AddContantViewController.h"
#import "Contacts.h"

@interface AddContantViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;

@end

@implementation AddContantViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (IBAction)save:(UIBarButtonItem *)sender
{
    if (self.nameTextField.text.length && self.telTextField.text.length)
    {
        Contacts *contact = [[Contacts alloc] init];
        contact.name = self.nameTextField.text;
        contact.tel = self.telTextField.text;
        
        [contact insertWithCompletion:^(NSError *error) {
            if (error)
            {
                NSLog(@"%@", error);
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else
    {
        NSLog(@"请完善信息");
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
