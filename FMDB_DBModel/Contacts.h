//
//  Contacts.h
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "DBObject.h"

@interface Contacts : DBObject

@property (assign , nonatomic) NSUInteger uid;  //primary key
@property (copy , nonatomic) NSString *name;    //姓名
@property (copy , nonatomic) NSString *tel;




@end
