//
//  NSArray+MojoModel.m
//  naturino
//
//  Created by Ирина Завилкина on 24.04.13.
//  Copyright (c) 2013 Traffic. All rights reserved.
//

#import "NSArray+MojoModel.h"
#import "MojoModel.h"

@implementation NSArray (MojoModel)

- (BOOL)containsMojoObject:(id)anObject
{
    return [self indexOfMojoObject:anObject] != NSNotFound;
}

- (NSUInteger)indexOfMojoObject:(id)anObject
{
    if (![anObject isKindOfClass:[MojoModel class]])
        return NSNotFound;
    
    NSUInteger objectID = [(MojoModel *)anObject primaryKey];
    
    for (id subObject in self)
    {
        NSUInteger secondID = [(MojoModel *)subObject primaryKey];
        if (objectID == secondID)
            return [self indexOfObject:subObject];
    }
    
    return NSNotFound;
}

@end
