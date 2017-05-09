//
//  NSObject+Runtime.m
//  linlin2
//
//  Created by LiliEhuu on 17/2/20.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "NSObject+Runtime.h"

@implementation NSObject (Runtime)

- (NSArray<ObjcProperty *> *)getPropertyList
{
    //属性个数
    unsigned int count = 0;
    NSMutableArray *list = [NSMutableArray new];
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList(self.class, &count);
    
    for (unsigned int i = 0; i < count; i++)
    {
        //创建属性类型
        ObjcProperty *objc_ppt = [ObjcProperty objcProperty:*(propertyList + i)];
        //获取属性值
        objc_ppt.value = [self valueForKey:objc_ppt.propertyName];
        //存入数组
        [list addObject:objc_ppt];
    }
    
    //释放属性列表
    free(propertyList);
    
    return [list copy];
}


@end




