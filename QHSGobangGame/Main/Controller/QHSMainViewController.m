//
//  ViewController.m
//  QHSGobangGame
//
//  Created by Charles on 5/3/16.
//  Copyright © 2016 Charles.Qiu. All rights reserved.
//

#import "QHSMainViewController.h"
#import "QHSGobangView.h"

@interface QHSMainViewController ()

@end

@implementation QHSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIColor *backgroundColor = [UIColor colorWithRed:230.0 / 255.0 green:192.0 / 255.0 blue:148.0 / 255.0 alpha:1.0];
    
    QHSGobangView *gobangView = [[QHSGobangView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
    gobangView.backgroundColor = backgroundColor;
    gobangView.center = self.view.center;
    [self.view addSubview:gobangView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
