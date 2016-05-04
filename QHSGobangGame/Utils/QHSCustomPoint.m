//
//  QHSCustomPoint.m
//  QHSGobangGame
//
//  Created by Charles on 5/3/16.
//  Copyright © 2016 Charles.Qiu. All rights reserved.
//

#import "QHSCustomPoint.h"

@implementation QHSCustomPoint

- (instancetype)initPointWith:(NSInteger)x y:(NSInteger)y {
    
    self = [self init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.x = -1;
        self.y = -1;
    }
    
    return self;
}

@end
