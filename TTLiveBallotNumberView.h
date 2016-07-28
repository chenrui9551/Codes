//
// Created by Rui Chen on 16/7/20.
// Copyright (c) 2016 fenbi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTLiveBallotNumberView : UIView

@property (nonatomic) NSInteger number;
- (instancetype)initWithNumber:(NSInteger)number;
- (void)update;
- (void)clear;

@end