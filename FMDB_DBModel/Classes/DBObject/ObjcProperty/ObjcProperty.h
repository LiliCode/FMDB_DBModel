//
//  ObjcProperty.h
//  linlin2
//
//  Created by LiliEhuu on 17/2/20.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 Objc属性的赋值和引用方式

 - ObjcPropertyReferenceModeAssign: 直接赋值-基本数据类型，MRC代理
 - ObjcPropertyReferenceModeStrong: 强引用（引用计数加一）- 一般都是除字符串类之外的对象
 - ObjcPropertyReferenceModeWeak: 弱引用（不增加引用计数）- 一般都是代理模式
 - ObjcPropertyReferenceModeCopy: 产生一个新的副本 - NSString 类型
 */
typedef NS_ENUM(NSUInteger , ObjcPropertyReferenceMode)
{
    ObjcPropertyReferenceModeAssign,
    ObjcPropertyReferenceModeStrong,
    ObjcPropertyReferenceModeWeak,
    ObjcPropertyReferenceModeCopy
};

/* Objc基本数据类型 */

FOUNDATION_EXPORT NSString *const TypeChar;         //字符、布尔
FOUNDATION_EXPORT NSString *const TYpeUnsigendChar;
FOUNDATION_EXPORT NSString *const TypeInt;
FOUNDATION_EXPORT NSString *const TypeUnsignedInt;
FOUNDATION_EXPORT NSString *const TypeLong;         //long、long long
FOUNDATION_EXPORT NSString *const TypeUnsigendLong; //unsigend long、unsigend long long
FOUNDATION_EXPORT NSString *const TypeFloat;
FOUNDATION_EXPORT NSString *const TypeDouble;
FOUNDATION_EXPORT NSString *const TypePointer;      //指针类型


@interface ObjcProperty : NSObject

@property (copy , nonatomic) NSString *propertyName;    //属性名称
@property (copy , nonatomic) NSString *typeName;        //类型名称

@property (assign , nonatomic) BOOL isNonatomic;        //是否非原子
@property (assign , nonatomic) BOOL isReadonly;         //是否只读
@property (copy , nonatomic) NSString *setterMethod;    //set方法
@property (copy , nonatomic) NSString *getterMethod;    //get方法
@property (assign , nonatomic) ObjcPropertyReferenceMode referenceMode; //引用模式




/**
 创建一个属性Objc对象，非C的结构体

 @param property property C 结构体
 @return 返回objc对象
 */
+ (instancetype)objcProperty:(objc_property_t)property;


@end





