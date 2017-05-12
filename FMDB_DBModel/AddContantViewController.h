//
//  AddContantViewController.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger , ContactStyle)
{
    ContactStyle_add,
    ContactStyle_edit
};

@class Contacts;

@interface AddContantViewController : UIViewController

@property (assign , nonatomic) ContactStyle mode;
@property (strong , nonatomic) Contacts *contact;



@end
