//
//  MojoModel.m
//  MojoDB
//
//  Created by Craig Jolicoeur on 10/8/10.
//  Copyright 2010 Mojo Tech, LLC. All rights reserved.
//

#import "MojoModel.h"

static MojoDatabase *database = nil;
static NSMutableDictionary *tableCache = nil;


@interface MojoModel(PrivateMethods)

+ (NSArray *)findAll:(BOOL)all byColumn:(NSString *)column value:(id)value;
+ (NSArray *)findAll:(BOOL)all withSql:(NSString *)sql withParameters:(NSArray *)parameters;

- (void)insert;
- (void)update;

- (NSString *)sqlForRelashion:(NSString *)secondTableName hasMany:(BOOL)hasMany;
- (NSString *)sqlForRelashion:(NSString *)secondTableName through:(NSString *)intermediateTableName;
- (NSString *)sqlForRelashionThroughDefaultIntermediateTableName:(NSString *)secondTableName;
- (NSDictionary *)valuesForColumns;

@end

@implementation MojoModel

#pragma makr - Copying

- (id)copyWithZone:(NSZone *)zone
{
    id newObject = [[[self class] allocWithZone:zone] init];
    
    if (newObject)
    {
        [newObject setPrimaryKey:self.primaryKey];
        [newObject setSavedInDatabase:self.savedInDatabase];
    }
    
    return newObject;
}

#pragma mark - Getters

- (BOOL)isNew
{
    return self.primaryKey == 0;
}

- (NSString *)description
{
    NSString *format = [NSString stringWithFormat:@"<%@ = %p tableName:%@ primaryKey:%u data:\n%@>", [self class], self, [[self class] tableName], _primaryKey, [self valuesForColumns]];
    return format;
}

#pragma mark - Relashionships

+ (NSString *)sqlForRelashion:(NSString *)secondTableName hasMany:(BOOL)hasMany
{
    NSString *selfTableName = [[self class] tableName];
    NSString *foreignKey = [(hasMany ? selfTableName : secondTableName) stringByAppendingString:kMojoDatabaseForeignKeyPostfix];
    
    NSString *sql = [NSString stringWithFormat:@"JOIN %@ ON %@.primaryKey = %@.%@", selfTableName, (hasMany ? selfTableName : secondTableName), (hasMany ? secondTableName : selfTableName), foreignKey];
    
    return sql;
}

- (NSString *)sqlForRelashion:(NSString *)secondTableName hasMany:(BOOL)hasMany
{
    NSString *selfTableName = [[self class] tableName];

    NSString *relashionSQL = [[self class] sqlForRelashion:secondTableName hasMany:hasMany];
    NSString *sql = [NSString stringWithFormat:@"%@ WHERE %@.primaryKey = %u", relashionSQL, selfTableName, self.primaryKey];
    
    return sql;
}

- (NSString *)sqlForRelashion:(NSString *)relashionTableName through:(NSString *)intermediateTableName
{
    NSString *selfTableName = [[self class] tableName];

    NSString *relashionForeignKey = [relashionTableName stringByAppendingString:kMojoDatabaseForeignKeyPostfix];
    NSString *selfForeignKey = [selfTableName stringByAppendingString:kMojoDatabaseForeignKeyPostfix];
    
    NSString *sql = [NSString stringWithFormat:@"JOIN %@ ON %@.primaryKey = %@.%@ JOIN %@ ON %@.primaryKey = %@.%@ WHERE %@.primaryKey = %u", intermediateTableName, relashionTableName, intermediateTableName, relashionForeignKey, selfTableName, selfTableName, intermediateTableName, selfForeignKey, selfTableName, self.primaryKey];
    
    return sql;
}

- (NSString *)sqlForRelashionThroughDefaultIntermediateTableName:(NSString *)secondTableName
{
    NSString *selfTableName = [[self class] tableName];
    
    NSString *intermediateTableName;
    
    NSComparisonResult compareTableNames = [selfTableName compare:secondTableName];
    if (compareTableNames == NSOrderedSame)
        return nil;
    else
        intermediateTableName = [NSString stringWithFormat:@"%@_%@", compareTableNames == NSOrderedAscending ? selfTableName : secondTableName, NSOrderedAscending ? secondTableName : selfTableName];

    return [self sqlForRelashion:secondTableName through:intermediateTableName];
}

- (MojoModel *)belongsTo:(NSString *)mojoModelName
{
    Class foreignClass = NSClassFromString(mojoModelName);
    NSString *sql = [self sqlForRelashion:mojoModelName hasMany:NO];
    
    return [foreignClass findFirstWithSql:sql];
}

- (NSArray *)hasMany:(NSString *)mojoModelName
{
    Class foreignClass = NSClassFromString(mojoModelName);
    NSString *sql = [self sqlForRelashion:mojoModelName hasMany:YES];

    return [foreignClass findAllWithSql:sql withParameters:nil];
}

- (NSArray *)hasMany:(NSString *)mojoModelName withSQL:(NSString *)sql
{
    Class foreignClass = NSClassFromString(mojoModelName);
    NSString *relashionSql = [[self sqlForRelashion:mojoModelName hasMany:YES] stringByAppendingFormat:@" AND %@", sql];
    
    return [foreignClass findAllWithSql:relashionSql withParameters:nil];
}

- (NSArray *)hasMany:(NSString *)mojoModelName through:(NSString *)intermediateModelName
{
    Class foreignClass = NSClassFromString(mojoModelName);
    NSString *sql = [self sqlForRelashion:mojoModelName through:intermediateModelName];

    return [foreignClass findAllWithSql:sql withParameters:nil];
}

- (NSArray *)hasMany:(NSString *)mojoModelName through:(NSString *)intermediateModelName withSQL:(NSString *)sql
{
    Class foreignClass = NSClassFromString(mojoModelName);
    NSString *relashionSQL = [[self sqlForRelashion:mojoModelName through:intermediateModelName] stringByAppendingFormat:@" AND %@", sql];

    return [foreignClass findAllWithSql:relashionSQL withParameters:nil];
}

#pragma mark - Class Methods - DB Handling

+ (BOOL)timestampOn
{
    return NO;
}

+ (void)setDatabase:(MojoDatabase *)newDatabase
{
    [database autorelease];
    database = [newDatabase retain];
}

+ (MojoDatabase *)database
{
    return database;
}

+ (void)assertDatabaseExists
{
    NSAssert1(database, @"Database not set. Set the database using [MojoModel setDatabase] before using Mojo Database methods.", @"");
}

#pragma mark - Class Methods - General

+ (NSString *)tableName
{
    return NSStringFromClass([self class]);
}

#pragma mark - DB Methods

- (NSArray *)columns
{
    if (tableCache == nil)
        tableCache = [[NSMutableDictionary dictionary] retain];

    NSString *tableName = [[self class] tableName];
    NSArray *columns = [tableCache objectForKey:tableName];

    if (columns == nil)
    {
        columns = [database columnsForTableName:tableName];
        [tableCache setObject:columns forKey:tableName];
    }

    return columns;
}

- (NSArray *)columnsWithoutPrimaryKey
{
    NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
    [columns removeObjectAtIndex:0];
    
    return columns;
}

- (NSArray *)propertyValues
{
    NSMutableArray *values = [NSMutableArray array];
    
    NSArray *columns = [self columnsWithoutPrimaryKey];

    for (NSString *column in columns)
    {
        id value = [self valueForKey:column];
        [values addObject:value != nil ? value : [NSNull null]];
    }

  return values;
}

- (NSDictionary *)valuesForColumns
{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    
    NSArray *columns = [self columnsWithoutPrimaryKey];
    
    for (NSString *column in columns) {
        id value = [self valueForKey:column];
        [values setObject:(value != nil ? value : [NSNull null]) forKey:column];
    }
    
    return values;
}

#pragma mark - ActiveRecord-like Methods

- (BOOL)save
{
    [[self class] assertDatabaseExists];

    @try
    {
        [self beforeSave];

        if (!self.savedInDatabase)
            [self insert];
        else
            [self update];

        [self afterSave];

        return YES;
    }
    @catch (NSException *exception)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Error of saving data", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
        return NO;
    }
}

-(void)insert
{
    NSMutableArray *columnsWithoutPrimaryKey = [[self columnsWithoutPrimaryKey] mutableCopy];

    NSMutableArray *parameterList = [NSMutableArray array];
    
    for (int i = 0; i < [columnsWithoutPrimaryKey count]; i++)
        [parameterList addObject:@"?"];
 
    if ([[self class] timestampOn])
    {
        self.createdAt = [NSDate date];
        self.updatedAt = self.createdAt;
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) values(%@)", [[self class] tableName], [columnsWithoutPrimaryKey componentsJoinedByString:@","], [parameterList componentsJoinedByString:@","]];
    [database executeSql:sql withParameters:[self propertyValues]];
    
    self.savedInDatabase = YES;
    self.primaryKey = [database lastInsertRowId];
}

- (void)update
{
    if ([[self class] timestampOn])
        self.updatedAt = [NSDate date];

    NSString *setValues = [[[self columnsWithoutPrimaryKey] componentsJoinedByString:@" = ?, "] stringByAppendingString:@" = ?"];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE primaryKey = ?", [[self class] tableName], setValues];
    NSArray *parameters = [[self propertyValues] arrayByAddingObject:[NSNumber numberWithUnsignedInt:self.primaryKey]];

    [database executeSql:sql withParameters:parameters];
    self.savedInDatabase = YES;
}

- (BOOL)delete
{
    [[self class] assertDatabaseExists];
    
    if (!self.savedInDatabase)
        return NO;

    @try
    {
        [self beforeDelete];

        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE primaryKey = ?", [[self class] tableName]];
        [database executeSql:sql withParameters:@[@(self.primaryKey)]];
        
        self.savedInDatabase = NO;
        self.primaryKey = 0;
        
        return YES;
    }
    @catch (NSException *exception)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Error of saving data", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
        return NO;
    }
}

+ (void)deleteAll
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [[self class] tableName]];
    [database executeSql:sql];
}

+ (void)deleteObjects:(NSArray *)objects
{
    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:objects.count];
    
    for (id object in objects)
    {
        [ids addObject:@([(MojoModel *)object primaryKey])];
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE primaryKey IN (%@)", [[self class] tableName], [ids componentsJoinedByString:@", "]];
    [database executeSql:sql];
}

#pragma mark - Private methods

+ (NSArray *)findAll:(BOOL)all byColumn:(NSString *)column value:(id)value
{
    return [self findAllWithSqlWithParameters:[NSString stringWithFormat:@"WHERE %@ = ?%@", column, all ? @"" : @" LIMIT 1"], value, nil];    
}

+ (NSArray *)findAll:(BOOL)all withSql:(NSString *)sql withParameters:(NSArray *)parameters
{
    [self assertDatabaseExists];
    
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT %@.* FROM %@ %@", [self tableName], [self tableName], sql];
    
    if (!all)
        selectSQL = [selectSQL stringByAppendingString:@" LIMIT 1"];
    
    NSArray *results = [database executeSql:selectSQL withParameters:parameters withClassForRow:[self class]];
    [results setValue:[NSNumber numberWithBool:YES] forKey:@"savedInDatabase"];
    
    return results;
}

+ (NSArray *)findAll:(BOOL)all sortedBy:(NSString *)column ascending:(BOOL)ascending
{
    return [self findAllWithSql:[NSString stringWithFormat:@"ORDER BY %@ %@%@", column, ascending ? @"ASC" : @"DESC", all ? @"" : @" LIMIT 1"]];
}

#pragma mark - Find All methods

+ (NSArray *)findAllWithSql:(NSString *)sql withParameters:(NSArray *)parameters
{
    return [self findAll:YES withSql:sql withParameters:parameters];
}

+ (NSArray *)findAllWithSqlWithParameters:(NSString *)sql, ...
{
    va_list argumentList;
    va_start(argumentList, sql);
    
    NSMutableArray *arguments = [NSMutableArray array];
    id argument;
    while ((argument = va_arg(argumentList, id)))
        [arguments addObject:argument];
    
    va_end(argumentList);
    
    return [self findAllWithSql:sql withParameters:arguments];
}

+ (NSArray *)findAllWithSql:(NSString *)sql
{
    return [self findAllWithSqlWithParameters:sql, nil];
}

+ (NSArray *)findAllByColumn:(NSString *)column value:(id)value
{
    return [self findAll:YES byColumn:column value:value];
}

+ (NSArray *)findAllByColumn:(NSString *)column unsignedIntegerValue:(NSUInteger)value
{
    return [self findAll:YES byColumn:column value:[NSNumber numberWithUnsignedInteger:value]];
}

+ (NSArray *)findAllByColumn:(NSString *)column integerValue:(NSInteger)value
{
    return [self findAll:YES byColumn:column value:[NSNumber numberWithInteger:value]];
}

+ (NSArray *)findAllByColumn:(NSString *)column doubleValue:(double)value
{
    return [self findAll:YES byColumn:column value:[NSNumber numberWithDouble:value]];
}

+ (NSArray *)findAll
{
    return [self findAllWithSql:@""];
}

+ (NSArray *)findAllSortedBy:(NSString *)column ascending:(BOOL)ascending
{
    return [self findAllWithSql:[NSString stringWithFormat:@"ORDER BY %@ %@", column, ascending ? @"ASC" : @"DESC"] withParameters:nil];
}

#pragma mark - Find First methods

+ (MojoModel *)findFirstWithSql:(NSString *)sql withParameters:(NSArray *)parameters
{
    return [[self findAll:NO withSql:sql withParameters:parameters] lastObject];
}

+ (MojoModel *)findFirstWithSqlWithParameters:(NSString *)sql, ...
{
    va_list argumentList;
    va_start(argumentList, sql);
    
    NSMutableArray *arguments = [NSMutableArray array];
    id argument;
    while ((argument = va_arg(argumentList, id)))
        [arguments addObject:argument];
    
    va_end(argumentList);
    
    return [self findFirstWithSql:sql withParameters:arguments];
}

+ (MojoModel *)findFirstWithSql:(NSString *)sql
{
    return [[self findAll:NO withSql:sql withParameters:nil] lastObject];
}

+ (MojoModel *)findFirstByColumn:(NSString *)column value:(id)value
{
    return [[self findAll:NO byColumn:column value:value] lastObject];
}

+ (MojoModel *)findFirstByColumn:(NSString *)column unsignedIntegerValue:(NSUInteger)value
{
    return [[self findAll:NO byColumn:column value:[NSNumber numberWithUnsignedInteger:value]] lastObject];
}

+ (MojoModel *)findFirstByColumn:(NSString *)column integerValue:(NSInteger)value
{
    return [[self findAll:NO byColumn:column value:[NSNumber numberWithInteger:value]] lastObject];
}

+ (MojoModel *)findFirstByColumn:(NSString *)column doubleValue:(double)value
{
    return [[self findAll:NO byColumn:column value:[NSNumber numberWithDouble:value]] lastObject];
}

+ (MojoModel *)findFirstSortedBy:(NSString *)column ascending:(BOOL)ascending
{
    return [[self findAll:NO sortedBy:column ascending:ascending] lastObject];
}

+ (MojoModel *)findFirst
{
    NSArray *allObjects = [self findAll];
    return allObjects.count > 0 ? [allObjects objectAtIndex:0] : nil;
}

+ (MojoModel *)findLast
{
    NSArray *allObjects = [self findAll];
    return allObjects.count > 0 ? [allObjects lastObject] : nil;
}

+ (id)find:(NSUInteger)primaryKey
{
    NSArray *results = [self findAllByColumn:@"primaryKey" unsignedIntegerValue:primaryKey];
    
    if ([results count] < 1)
        return nil;
    
    return [results objectAtIndex:0];
}

/*
 * AR-like Callbacks
 */

- (void)beforeSave {}
- (void)afterSave {}
- (void)beforeDelete {}


#pragma mark -
#pragma mark Debugging Methods

- (void)testProperties
{
    NSLog(@"column names: %@", [self columns]);
    NSLog(@"column names without primary key: %@", [self columnsWithoutPrimaryKey]);
    NSLog(@"propertyValues: %@", [self propertyValues]);
}

@end
