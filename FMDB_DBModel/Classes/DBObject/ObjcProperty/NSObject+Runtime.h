//
//  NSObject+Runtime.h
//  linlin2
//
//  Created by LiliEhuu on 17/2/20.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjcProperty.h"

@interface NSObject (Runtime)

/**
 获取属性列表

 @return 返回ObjcProperty对象的列表
 */
+ (NSArray <ObjcProperty *>*)getPropertyList;

/**
 设置属性值

 @param values ObjcProperty对象列表
 */
- (void)setValues:(NSArray <ObjcProperty *>*)values;

@end


