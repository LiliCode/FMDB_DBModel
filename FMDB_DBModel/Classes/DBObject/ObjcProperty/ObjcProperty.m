//
//  ObjcProperty.m
//  linlin2
//
//  Created by LiliEhuu on 17/2/20.
//  Copyright © 2017年 LiliEhuu. All rights reserved.
//

#import "ObjcProperty.h"

NSString *const TypeChar = @"c";         //字符、布尔
NSString *const TypeUnsigendChar = @"C";
NSString *const TypeInt = @"i";
NSString *const TypeUnsignedInt = @"I";
NSString *const TypeLong = @"q";         //long、long long
NSString *const TypeUnsigendLong = @"Q"; //unsigend long、unsigend long long
NSString *const TypeFloat = @"f";
NSString *const TypeDouble = @"d";
NSString *const TypePointer = @"*";      //指针类型



@interface ObjcProperty ()

@end

@implementation ObjcProperty

+ (instancetype)objcProperty:(objc_property_t)property
{
    return [[self alloc] initWithProperty:property];
}

- (instancetype)initWithProperty:(objc_property_t)property
{
    if (self = [super init])
    {
        [self parse_objc_property_t:property];
    }
    
    return self;
}

- (void)parse_objc_property_t:(objc_property_t)property
{
    //属性名称
    self.propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    //类型名称
    self.typeName = [NSString stringWithCString:property_getType(property) encoding:NSUTF8StringEncoding];
    
    unsigned int outCount = 0;
    objc_property_attribute_t *attri_list = property_copyAttributeList(property, &outCount);
    for (unsigned int count = 0; count < outCount; count++)
    {
        objc_property_attribute_t attribute_t = *(attri_list + count);
        
        if (!strcmp(attribute_t.name, "&"))
        {
            self.referenceMode = ObjcPropertyReferenceModeStrong;   //强引用
        }
        else if (!strcmp(attribute_t.name, "C"))
        {
            self.referenceMode = ObjcPropertyReferenceModeCopy; //赋值方式-copy
        }
        else if (!strcmp(attribute_t.name, "W"))
        {
            self.referenceMode = ObjcPropertyReferenceModeWeak; //弱引用
        }
        else if (!strcmp(attribute_t.name, "N"))
        {
            self.isNonatomic = YES; //非原子
        }
        else if (!strcmp(attribute_t.name, "R"))
        {
            self.isReadonly = YES;  //只读
        }
        else if ('S' == attribute_t.name[0])
        {
            //指定setter方法
            self.setterMethod = [NSString stringWithCString:attribute_t.value encoding:NSUTF8StringEncoding];
        }
        else if ('G' == attribute_t.name[0])
        {
            //指定getter方法
            self.getterMethod = [NSString stringWithCString:attribute_t.value encoding:NSUTF8StringEncoding];
        }
    }
}

//获取属性的方法
static const char *property_getType(objc_property_t property)
{
    //获取属性
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL)
    {
        if (attribute[0] == 'T' && attribute[1] != '@')
        {
            // it's a C primitive type:
            
            // if you want a list of what will be returned for these primitives, search online for
            // "objective-c" "Property Attribute Description Examples"
            // apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
            
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2)
        {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@')
        {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    
    return "";
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"pptName:%@ typeName:%@ isNonatomic:%d isReadonly:%d get:%@ set:%@ reference:%lu", self.propertyName, self.typeName, self.isNonatomic, self.isReadonly, self.getterMethod, self.setterMethod, self.referenceMode];
}


@end





