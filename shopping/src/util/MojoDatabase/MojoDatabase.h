//
//  MojoDatabase.h
//  MojoDB
//
//  Created by Craig Jolicoeur on 10/8/10.
//  Copyright 2010 Mojo Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define kMojoDatabaseForeignKeyPostfix          @"_id"
#define kMojoDatabaseDateFormat                 @"yyyy-MM-dd hh:mm:ss";
#define kMojoDatabaseBooleanFieldFormat         @"is[A-Z].+"
#define kMojoDatabaseForeignKeyFieldFormat      @"[A-Za-z0-9]+_id$"
#define kMojoDatabaseDateFieldFormat            @"[A-Za-z0-9]+Date$"

@interface MojoDatabase : NSObject {
	NSString *pathToDatabase;
	BOOL logging;
	sqlite3 *database;
}

@property (nonatomic, retain) NSString *pathToDatabase;
@property (nonatomic) BOOL logging;

- (id) initWithPath:(NSString *)filePath;
- (id) initWithFileName:(NSString *)fileName;

- (NSArray *)executeSql:(NSString *)sql withParameters:(NSArray *)parameters;
- (NSArray *)executeSql:(NSString *)sql withParameters:(NSArray *)parameters withClassForRow:(Class)rowClass;
- (NSArray *)executeSql:(NSString *)sql;
- (NSArray *)executeSqlWithParameters:(NSString *)sql, ...;
- (NSArray *)tableNames;
- (NSArray *)columnsForTableName:(NSString *)tableName;
- (NSUInteger)lastInsertRowId;

-(BOOL)contailsTable:(NSString *)tableName;
@end
