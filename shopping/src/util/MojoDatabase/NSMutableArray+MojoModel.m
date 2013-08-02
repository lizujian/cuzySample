//
//  NSArray+MojoModel.m
//  naturino
//
//  Created by Ирина Завилкина on 22.04.13.
//  Copyright (c) 2013 Traffic. All rights reserved.
//

#import "NSMutableArray+MojoModel.h"
#import "MojoModel.h"

@implementation NSMutableArray (MojoModel)

- (void)removeMojoObject:(id)object
{
    NSUInteger objectID = [(MojoModel *)object primaryKey];

    for (id subObject in self)
        if ([(MojoModel *)subObject primaryKey] == objectID)
        {
            [self removeObject:subObject];
            return;
        }
}

- (void)removeMojoObjects:(NSArray *)array
{
    for (id deletingObject in array)
    {
        [self removeMojoObject:deletingObject];
    }
}

@end
