//
//  QHSSimpleAI.h
//  QHSGobangGame
//
//  Created by Charles on 5/3/16.
//  Copyright © 2016 Charles.Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QHSCustomPoint;

typedef NS_ENUM (NSInteger, OccupyType) {
    OccupyTypeEmpty = 0,
    OccupyTypeUser,
    OccupyTypeAI,
    OccupyTypeUnknown,
};

@interface QHSPointData : NSObject

@property (nonatomic, strong) QHSCustomPoint *p;
@property (nonatomic, assign) int            count;

- (id)initWithPoint:(QHSCustomPoint *)point count:(int)count;

@end

@interface QHSOmni : NSObject

@property (nonatomic, strong) NSMutableArray *curBoard;
@property (nonatomic, assign) OccupyType     oppoType;
@property (nonatomic, assign) OccupyType     myType;

- (id)initWithArr:(NSMutableArray *)arr opp:(OccupyType)opp my:(OccupyType)my;
- (BOOL)isStepEmergent:(QHSCustomPoint *)pp Num:(int)num type:(OccupyType)xType;

@end

@interface QHSSimpleAI : NSObject

+ (QHSCustomPoint *)geablog:(NSMutableArray *)board type:(OccupyType)type;
+ (QHSCustomPoint *)SeraphTheGreat:(NSMutableArray *)board type:(OccupyType)type;

@end
