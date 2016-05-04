//
//  QHSCustomPoint.h
//  QHSGobangGame
//
//  Created by Charles on 5/3/16.
//  Copyright © 2016 Charles.Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHSCustomPoint : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

- (instancetype)initPointWith:(NSInteger)x y:(NSInteger)y;

@end
