//
//  NSObject+Runtime.m
//  linlin2
//
//  Created by LiliEhuu on 17/2/20.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "NSObject+Runtime.h"

@implementation NSObject (Runtime)

+ (NSArray<ObjcProperty *> *)getPropertyList
{
    //属性个数
    unsigned int count = 0;
    NSMutableArray *list = [NSMutableArray new];
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    
    for (unsigned int i = 0; i < count; i++)
    {
        //创建属性类型
        ObjcProperty *objc_ppt = [ObjcProperty objcProperty:*(propertyList + i)];
        //获取属性值
//        objc_ppt.value = [self valueForKey:objc_ppt.propertyName];
        //存入数组
        [list addObject:objc_ppt];
    }
    
    //释放属性列表
    free(propertyList);
    
    return [list copy];
}

- (void)setValues:(NSArray<ObjcProperty *> *)values
{
    for (ObjcProperty *objc_ppt in values)
    {
        //获取属性值
        id value = [self valueForKey:objc_ppt.propertyName];
        if ([objc_ppt.objcType isEqualToString:ObjcTypeNSMutableDictionary] || [objc_ppt.objcType isEqualToString:ObjcTypeNSDictionary ] ||
            [objc_ppt.objcType isEqualToString:ObjcTypeNSArray] || [objc_ppt.objcType isEqualToString:ObjcTypeNSMutableArray])
        {
            objc_ppt.value = [NSKeyedArchiver archivedDataWithRootObject:value];    //归档成二进制文件
        }
        else if ([objc_ppt.objcType isEqualToString:ObjcTypeNSDate])
        {
            //日期类型转换成整型
            NSDate *date = value;
            objc_ppt.value = [NSNumber numberWithInteger:[date timeIntervalSince1970]];  //精确到毫秒
        }
        else
        {
            objc_ppt.value = [self valueForKey:objc_ppt.propertyName];
        }
    }
}


@end








