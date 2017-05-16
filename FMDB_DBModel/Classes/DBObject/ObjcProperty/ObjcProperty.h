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

FOUNDATION_EXPORT NSString *const ObjcTypeChar;         //字符、布尔
FOUNDATION_EXPORT NSString *const ObjcTypeBool;         //布尔类型
FOUNDATION_EXPORT NSString *const ObjcTypeUnsigendChar;
FOUNDATION_EXPORT NSString *const ObjcTypeInt;
FOUNDATION_EXPORT NSString *const ObjcTypeUnsignedInt;
FOUNDATION_EXPORT NSString *const ObjcTypeShort;
FOUNDATION_EXPORT NSString *const ObjcTypeUnsignedShort;
FOUNDATION_EXPORT NSString *const ObjcTypeLong;         //long、long long
FOUNDATION_EXPORT NSString *const ObjcTypeUnsigendLong; //unsigend long、unsigend long long
FOUNDATION_EXPORT NSString *const ObjcTypeFloat;
FOUNDATION_EXPORT NSString *const ObjcTypeDouble;
FOUNDATION_EXPORT NSString *const ObjcTypeLongDouble;
FOUNDATION_EXPORT NSString *const ObjcTypePointer;      //指针类型
/* Objc对象 */
FOUNDATION_EXPORT NSString *const ObjcTypeAnyObject;    //任意类型 id
FOUNDATION_EXPORT NSString *const ObjcTypeNSNumber;
FOUNDATION_EXPORT NSString *const ObjcTypeNSString;
FOUNDATION_EXPORT NSString *const ObjcTypeNSArray;
FOUNDATION_EXPORT NSString *const ObjcTypeNSMutableArray;



@interface ObjcProperty : NSObject

@property (strong , nonatomic) id value;                //属性值

@property (copy , nonatomic) NSString *propertyName;    //属性名称
@property (copy , nonatomic) NSString *objcType;        //类型名称

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

/**
 利用字符串构造属性对象

 @param proStr 属性名称
 @param type 属性类型
 @param value 属性值
 @return 返回构造成功的对象
 */
+ (instancetype)objcPropertyName:(NSString *)proStr objcType:(NSString *)type value:(id)value;

/**
 默认值

 @return 如果value = nil返回默认值
 */
- (id)defaultValue;

@end





