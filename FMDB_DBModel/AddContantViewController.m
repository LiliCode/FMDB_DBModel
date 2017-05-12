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
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end

@implementation AddContantViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.mode == ContactStyle_edit)
    {
        self.nameTextField.text = self.contact.name;
        self.telTextField.text = self.contact.tel;
        self.addressTextField.text = self.contact.address;
        self.telTextField.enabled = NO;
    }
}

- (IBAction)save:(UIBarButtonItem *)sender
{
    if (self.nameTextField.text.length && self.telTextField.text.length)
    {
        if (self.mode == ContactStyle_add)
        {
            Contacts *contact = [[Contacts alloc] init];
            contact.name = self.nameTextField.text;
            contact.tel = self.telTextField.text;
            contact.address = self.addressTextField.text;
            
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
            self.contact.name = self.nameTextField.text;
            self.contact.address = self.addressTextField.text;
            [self.contact updateWithCompletion:^(NSError *error) {
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
    }
    else
    {
        NSLog(@"请完善信息");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
