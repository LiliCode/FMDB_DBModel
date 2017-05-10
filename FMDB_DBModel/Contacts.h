//
//  Contacts.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "DBObject.h"
#import <CoreGraphics/CGBase.h>

@interface Contacts : DBObject

@property (assign , nonatomic) NSUInteger uid;  //primary key
@property (copy , nonatomic) NSString *name;    //姓名
@property (copy , nonatomic) NSString *tel;
@property (copy , nonatomic) NSString *logo;
@property (copy , nonatomic) NSString *address; //地址
@property (strong , nonatomic) NSNumber *sex;
@property (assign , nonatomic) CGFloat point;




@end
