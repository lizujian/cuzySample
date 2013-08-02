//
//  MojoModel.h
//  MojoDB
//
//  Created by Craig Jolicoeur on 10/8/10.
//  Copyright 2010 Mojo Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSMutableArray+MojoModel.h"

#import "MojoDatabase.h"

@interface MojoModel : NSObject <NSCopying>
{
    
}

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, assign) NSUInteger primaryKey;
@property (nonatomic, assign) BOOL savedInDatabase;
@property (nonatomic, assign, readonly) BOOL isNew;

+ (BOOL)timestampOn;
+ (NSString *)tableName;

+ (void)setDatabase:(MojoDatabase *)newDatabase;
+ (MojoDatabase *)database;

+ (NSString *)sqlForRelashion:(NSString *)secondTableName hasMany:(BOOL)hasMany;
- (MojoModel *)belongsTo:(NSString *)mojoModelName;
- (NSArray *)hasMany:(NSString *)mojoModelName;
- (NSArray *)hasMany:(NSString *)mojoModelName withSQL:(NSString *)sql;
- (NSArray *)hasMany:(NSString *)mojoModelName through:(NSString *)intermediateModelName;
- (NSArray *)hasMany:(NSString *)mojoModelName through:(NSString *)intermediateModelName withSQL:(NSString *)sql;

+ (NSArray *)findAllWithSql:(NSString *)sql withParameters:(NSArray *)parameters;
+ (NSArray *)findAllWithSqlWithParameters:(NSString *)sql, ...;
+ (NSArray *)findAllWithSql:(NSString *)sql;
+ (NSArray *)findAllByColumn:(NSString *)column value:(id)value;
+ (NSArray *)findAllByColumn:(NSString *)column unsignedIntegerValue:(NSUInteger)value;
+ (NSArray *)findAllByColumn:(NSString *)column integerValue:(NSInteger)value;
+ (NSArray *)findAllByColumn:(NSString *)column doubleValue:(double)value;
+ (NSArray *)findAllSortedBy:(NSString *)column ascending:(BOOL)ascending;
+ (NSArray *)findAll;

+ (MojoModel *)findFirstWithSql:(NSString *)sql withParameters:(NSArray *)parameters;
+ (MojoModel *)findFirstWithSqlWithParameters:(NSString *)sql, ...;
+ (MojoModel *)findFirstWithSql:(NSString *)sql;
+ (MojoModel *)findFirstByColumn:(NSString *)column value:(id)value;
+ (MojoModel *)findFirstByColumn:(NSString *)column unsignedIntegerValue:(NSUInteger)value;
+ (MojoModel *)findFirstByColumn:(NSString *)column integerValue:(NSInteger)value;
+ (MojoModel *)findFirstByColumn:(NSString *)column doubleValue:(double)value;
+ (MojoModel *)findFirstSortedBy:(NSString *)column ascending:(BOOL)ascending;

+ (MojoModel *)find:(NSUInteger)primaryKey;
+ (MojoModel *)findFirst;
+ (MojoModel *)findLast;

+ (void)deleteAll;
+ (void)deleteObjects:(NSArray *)objects;

- (BOOL)save;
- (BOOL)delete;

- (void)beforeSave;
- (void)afterSave;
- (void)beforeDelete;

@end
