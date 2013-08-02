//
//  NSArray+MojoModel.h
//  naturino
//
//  Created by Ирина Завилкина on 24.04.13.
//  Copyright (c) 2013 Traffic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MojoModel)

- (BOOL)containsMojoObject:(id)anObject;
- (NSUInteger)indexOfMojoObject:(id)anObject;

@end
