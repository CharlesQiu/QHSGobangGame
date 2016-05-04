//
//  QHSGobangView.m
//  QHSGobangGame
//
//  Created by Charles on 5/3/16.
//  Copyright © 2016 Charles.Qiu. All rights reserved.
//

#import "QHSGobangView.h"
#import "QHSSimpleAI.h"
#import "QHSCustomPoint.h"

static NSInteger const kBoardSize       = 15;
static NSInteger const kRedDotBoardSize = 10;

@interface QHSGobangView ()

@property (nonatomic, assign) BOOL           isPlayerPlaying; // 标志为，标志是否是玩家正在下棋
@property (nonatomic, strong) NSMutableArray *places; // 记录所有的位置状态
@property (nonatomic, strong) NSMutableArray *chesses; // 记录所有在棋盘上的棋子
@property (nonatomic, strong) NSMutableArray *holders; // 记录五子连珠后对应的五个棋子
@property (nonatomic, strong) UIView         *redDot; // 指示AI最新一步所在的位置

@end

@implementation QHSGobangView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.redDot                    = [UIView new];
        self.redDot.backgroundColor    = [UIColor redColor];
        self.redDot.frame = CGRectMake(0, 0, kRedDotBoardSize, kRedDotBoardSize);
        self.redDot.layer.cornerRadius = kRedDotBoardSize / 2;
        
        for (NSInteger i = 0; i < kBoardSize + 2; i++) {
            CALayer *horizentalLayer = [CALayer new];
            horizentalLayer.frame           = CGRectMake(0, i * frame.size.height / (kBoardSize + 1), frame.size.width, 0.5);
            horizentalLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.layer addSublayer:horizentalLayer];
        }
        
        for (NSInteger i = 0; i < kBoardSize + 2; i++) {
            CALayer *verticalLayer = [CALayer new];
            verticalLayer.frame           = CGRectMake(i * frame.size.width / (kBoardSize + 1), 0, 0.5, frame.size.width);
            verticalLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.layer addSublayer:verticalLayer];
        }
        
        self.places = [NSMutableArray array];
        for (int i = 0; i < kBoardSize; i++) {
            NSMutableArray *chil = [NSMutableArray array];
            for (int j = 0; j < kBoardSize; j++) {
                [chil addObject:@(OccupyTypeEmpty)];
            }
            [self.places addObject:chil];
        }
        self.chesses = [NSMutableArray array];
        self.holders = [NSMutableArray array];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.userInteractionEnabled = NO;
    
    self.isPlayerPlaying = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    
    NSUInteger h = 0;
    NSUInteger v = 0;
    
    for (NSUInteger i = 0; i <= kBoardSize; i++) {
        
        if (i * self.frame.size.width / (kBoardSize + 1) <= point.x && point.x < (i + 1) * self.frame.size.width / (kBoardSize + 1)) {
            
            if (i == 0) {
                h = 0;
                
                break;
            }
            
            if (i == kBoardSize) {
                h = kBoardSize - 1;
                
                break;
            }
            
            if (fabs(i * self.frame.size.width / (kBoardSize + 1) - point.x) >= fabs((i + 1) * self.frame.size.width / (kBoardSize + 1) - point.x)) {
                h = i;
                
                break;
            } else {
                
                h = i - 1;
                break;
            }
        }
        
        NSLog(@"got you h!");
    }
    
    for (NSUInteger i = 0; i <= kBoardSize; i++) {
        if (i * self.frame.size.width / (kBoardSize + 1) <= point.y && point.y < (i + 1) * self.frame.size.width / (kBoardSize + 1)) {
            if (i == 0) {
                v = 0;
                break;
            }
            
            if (i == kBoardSize) {
                v = kBoardSize - 1;
                break;
            }
            
            if (fabs(i * self.frame.size.width / (kBoardSize + 1) - point.y) >= fabs((i + 1) * self.frame.size.width / (kBoardSize + 1) - point.y)) {
                v = i;
                
                break;
            } else {
                
                v = i - 1;
                
                break;
            }
        }
        
        NSLog(@"got you V!");
    }
    
    if (h >= kBoardSize || v >= kBoardSize) {
        
        NSLog(@"failed!");
        self.userInteractionEnabled = YES;
        return;
    }
    
    if ([self.places[h][v] integerValue] == 0) {
        
    } else {
        
        self.userInteractionEnabled = YES;
        return;
    }
    
    QHSCustomPoint *p;
    p = [[QHSCustomPoint alloc] initPointWith:h y:v];
    
    if ([self move:p] == FALSE) {
        [self win:OccupyTypeAI];
        return;
    }
    if ([self checkVictory:OccupyTypeUser] == OccupyTypeUser) {
        [self win:OccupyTypeUser];
        return;
    }
    
    p = [QHSSimpleAI geablog:self.places type:OccupyTypeAI];
    
    if ([self move:p] == FALSE) {
        [self win:OccupyTypeUser];
        return;
    }
    if ([self checkVictory:OccupyTypeAI] == OccupyTypeAI) {
        [self win:OccupyTypeAI];
        return;
    }
    
    self.userInteractionEnabled = YES;
}

- (OccupyType)getType:(CGPoint)point {
    
    if ((point.x >= 0 && point.x < kBoardSize) && (point.y >= 0 && point.y < kBoardSize)) {
        NSInteger      x    = (int)point.x;
        NSMutableArray *arr = self.places[x];
        NSInteger      y    = (int)point.y;
        return [arr[y] integerValue];
    }
    
    return OccupyTypeUnknown;
}

- (OccupyType)checkNode:(CGPoint)point { //对个给定的点向四周遍历 看是否能形成5子连珠
    
    OccupyType curType = [self getType:point];
    BOOL       vic     = TRUE;
    for (int i = 1; i < 5; i++) {
        CGPoint nextP = CGPointMake(point.x + i, point.y);
        if (point.x + i >= kBoardSize || [self getType:nextP] != curType) {
            vic = FALSE;
            break;
        }
    }
    
    if (vic == TRUE) {
        return curType;
    }
    vic = TRUE;
    for (int i = 1; i < 5; i++) {
        CGPoint nextP = CGPointMake(point.x, point.y + i);
        if (point.y + i >= kBoardSize || [self getType:nextP] != curType) {
            vic = false;
            break;
        }
    }
    
    if (vic == TRUE) {
        return curType;
    }
    vic = TRUE;
    for (int i = 1; i < 5; i++) {
        CGPoint nextP = CGPointMake(point.x + i, point.y + i);
        if (point.x + i >= kBoardSize || point.y + i >= kBoardSize || [self getType:nextP] != curType) {
            vic = false;
            break;
        }
    }
    
    if (vic == TRUE) {
        return curType;
    }
    vic = TRUE;
    for (int i = 1; i < 5; i++) {
        CGPoint nextP = CGPointMake(point.x - i, point.y + i);
        if (point.x - i < 0 || point.y + i >= kBoardSize || [self getType:nextP] != curType) {
            vic = false;
            break;
        }
    }
    
    if (vic == TRUE) {
        return curType;
    }
    
    return OccupyTypeEmpty;
}

- (OccupyType)checkVictory:(OccupyType)type { // 检查是否type方胜利了的方法
    
    BOOL isFull = TRUE;
    for (int i = 0; i < kBoardSize; i++) {
        for (int j = 0; j < kBoardSize; j++) {
            CGPoint    p       = CGPointMake(i, j);
            OccupyType winType = [self checkNode:p]; // 检查是否形成5子连珠
            if (winType == OccupyTypeUser) {
                return OccupyTypeUser;
            } else if (winType == OccupyTypeAI) {
                return OccupyTypeAI;
            }
            NSMutableArray *arr = self.places[i];
            OccupyType     ty   = [arr[j] integerValue];
            if (ty == OccupyTypeEmpty) {
                isFull = false;
            }
        }
    }
    
    if (isFull == TRUE) {
        return type;
    }
    
    return OccupyTypeEmpty;
}

- (BOOL)move:(QHSCustomPoint *)p { // 向p点进行落子并绘制的方法
    if (p.x < 0 || p.x >= kBoardSize ||
        p.y < 0 || p.y >= kBoardSize) {
        return false;
    }
    
    NSInteger      x    = p.x;
    NSMutableArray *arr = self.places[x];
    NSInteger      y    = p.y;
    OccupyType     ty   = [arr[y] integerValue];
    if (ty == OccupyTypeEmpty) {
        if (self.isPlayerPlaying) {
            [arr replaceObjectAtIndex:y withObject:@(OccupyTypeUser)];
            
            UIImageView *black = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black"]];
            black.backgroundColor    = [UIColor clearColor];
            black.layer.cornerRadius = 5;
            black.clipsToBounds      = YES;
            [self addSubview:black];
            black.center = CGPointMake((x + 1) * self.frame.size.width / (kBoardSize + 1), (y + 1) * self.frame.size.height / (kBoardSize + 1));
            
            [self.chesses addObject:black];
            
        } else {
            [arr replaceObjectAtIndex:y withObject:@(OccupyTypeAI)];
            
            UIImageView *black = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white"]];
            black.backgroundColor    = [UIColor clearColor];
            black.layer.cornerRadius = 5;
            black.clipsToBounds      = YES;
            [self addSubview:black];
            black.center = CGPointMake((x + 1) * self.frame.size.width / (kBoardSize + 1), (y + 1) * self.frame.size.height / (kBoardSize + 1));
            [self.chesses addObject:black];
            
            [self.redDot removeFromSuperview];
            [black addSubview:self.redDot];
            self.redDot.center = CGPointMake(black.frame.size.width / 2.0, black.frame.size.width / 2.0);
        }
        self.isPlayerPlaying = !self.isPlayerPlaying;
        return TRUE;
    } else {
        return FALSE;
    }
}

- (void)reset { // 重新开始的方法
    
    self.userInteractionEnabled = YES;
    
    for (UIView *view in self.chesses) {
        [view removeFromSuperview];
    }
    
    [self.chesses removeAllObjects];
    
    self.places = [NSMutableArray array];
    for (int i = 0; i < kBoardSize; i++) {
        NSMutableArray *chil = [NSMutableArray array];
        for (int j = 0; j < kBoardSize; j++) {
            [chil addObject:@(OccupyTypeEmpty)];
        }
        [self.places addObject:chil];
    }
}

- (void)win:(OccupyType)type { // type方获得胜利时出现动画的效果
    self.userInteractionEnabled = NO;
    
    UILabel *gameResult = [UILabel new];
    gameResult.font               = [UIFont systemFontOfSize:40.0];
    gameResult.layer.cornerRadius = 5.0;
    gameResult.layer.borderWidth  = 2.0;
    if (OccupyTypeAI == type) {
        gameResult.text              = @" You Lost ";
        gameResult.textColor         = [UIColor redColor];
        gameResult.layer.borderColor = [UIColor redColor].CGColor;
    } else if (OccupyTypeUser == type) {
        gameResult.text              = @" You Win ";
        gameResult.textColor         = [UIColor greenColor];
        gameResult.layer.borderColor = [UIColor greenColor].CGColor;
    }
    [gameResult sizeToFit];
    [self addSubview:gameResult];
    gameResult.center = CGPointMake(self.frame.size.width / 2, self.frame.size.width + 30.0);
    
    [UIView animateWithDuration:0.5 animations:^{
        gameResult.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            gameResult.alpha = 0;
        } completion:^(BOOL finished) {
            [self reset];
            [gameResult removeFromSuperview];
            self.userInteractionEnabled = YES;
        }];
    }];
}

@end
