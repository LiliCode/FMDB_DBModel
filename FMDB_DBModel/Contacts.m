//
//  Contacts.m
//  FMDB_DBModel
//
//  Created by LiliEhuu on 17/5/9.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "Contacts.h"

@implementation Contacts


+ (ObjcProperty *)sql_primaryKey
{
    ObjcProperty *pKey = [[ObjcProperty alloc] init];
    pKey.propertyName = @"tel";
    pKey.objcType = ObjcTypeNSString;
    
    return pKey;
}


@end

