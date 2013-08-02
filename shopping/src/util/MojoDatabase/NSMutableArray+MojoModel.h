//
//  NSArray+MojoModel.h
//  naturino
//
//  Created by Ирина Завилкина on 22.04.13.
//  Copyright (c) 2013 Traffic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+MojoModel.h"

@interface NSMutableArray (MojoModel)

- (void)removeMojoObject:(id)object;
- (void)removeMojoObjects:(NSArray *)array;

@end
