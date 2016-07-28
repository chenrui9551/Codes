//
// Created by Rui Chen on 16/7/20.
// Copyright (c) 2016 fenbi. All rights reserved.
//

#import "TTLiveBallotNumberView.h"

@interface TTLiveBallotNumberView ()

@property (nonatomic, strong) NSMutableArray<UIView *> *backViews;
@property (nonatomic, strong) NSMutableArray<CALayer *> *scrollLayers;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *displayNumbers;

@end

@implementation TTLiveBallotNumberView {
    UIView* _xView;
}

- (instancetype)initWithNumber:(NSInteger)number {
    self = [super init];
    if (self) {
        [self clear];
        _number = number;
        [self update];
    }
    return self;
}

- (void)setNumber:(NSInteger)number {
    if (_number != number) {
        _number = number;
        [self update];
    }
}

- (void)clear {
    _number = 0;
    _backViews = [@[] mutableCopy];
    _displayNumbers = [@[] mutableCopy];
    _scrollLayers = [@[] mutableCopy];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self addSubview:self.xView];
    [self.xView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.top.equalTo(self);
        make.bottom.lessThanOrEqualTo(self);
        make.trailing.equalTo(self);
    }];
    self.number = 0;
}

- (void)update {
    UIView* lastView = self.xView;
    NSInteger tmpNum = _number;
    NSUInteger index = 0;

    do {
        UIView *view = nil;
        if (_backViews.count <= index) {
            view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.clipsToBounds = YES;
            [_backViews addObject: view];

            CALayer *layer = [[CALayer alloc] init];
            layer.frame = CGRectMake(0, 0, 13, 16);
            [_scrollLayers addObject:layer];

            [_displayNumbers addObject: @0];
            UIImageView *imageView = [self getNumber:0];
            [layer addSublayer:imageView.layer];

            [view.layer addSublayer:layer];
        } else {
            view = _backViews[index];
        }

        ///////////
        [_scrollLayers[index] removeFromSuperlayer];
        for (UIView *view in _backViews[index].subviews) {
            [view removeFromSuperview];
        }
        [_backViews[index] addSubview:[self getNumber:(NSUInteger) (tmpNum % 10)]];
        ///////////

        if (!view.superview) {
            [self addSubview:view];
        }
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.top.greaterThanOrEqualTo(self);
            make.bottom.lessThanOrEqualTo(self);
            make.trailing.equalTo(lastView.mas_leading);
            make.height.equalTo(@16);
            make.width.equalTo(@13);
        }];

        tmpNum /= 10;
        lastView = view;
        index += 1;
    } while (tmpNum > 0);

    [self.xView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(13 * _backViews.count);
    }];


    // [UIView animateWithDuration:0.25
    //                 animations:^{
    [self layoutIfNeeded];
    //                 }];
    return;

    tmpNum = _number;
    index = 0;
    do {
        if (![_displayNumbers[index] isEqualToNumber:@(tmpNum % 10)]) {
            [_scrollLayers[index] removeFromSuperlayer];
            CALayer *layer = [[CALayer alloc] init];
            layer.frame = CGRectMake(0, 0, 13, 16);
            _scrollLayers[index] = layer;

            UIImageView *oldNumber = [self getNumber:(NSUInteger) _displayNumbers[index].integerValue];
            UIImageView *newNumber = [self getNumber:(NSUInteger) (tmpNum % 10)];
            newNumber.frame = CGRectMake(0, 16, 13, 16);
            [layer addSublayer:oldNumber.layer];
            [layer addSublayer:newNumber.layer];

            CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.duration = 0.25;
            animation.fromValue = @0;
            animation.toValue = @-16;

            [layer addAnimation:animation
                         forKey:@"NumberScroll"];

            [_backViews[index].layer addSublayer:layer];

            _displayNumbers[index] = @(tmpNum % 10);
        }
        tmpNum /= 10;
        index += 1;
    } while (tmpNum > 0);
}

- (UIImageView* )getNumber:(NSUInteger)number {
    UIImage *image = [UIImage imageNamed: [NSString stringWithFormat:@"TTBallotNumber%d", number]];
    return [[UIImageView alloc] initWithImage:image];
}

// - MARK: Animation Methods
- (UIView *)xView {
    if (!_xView) {
        UIImage *image = TT_IMAGE(@"TTBallotNumberLabelMul");
        _xView = [[UIImageView alloc] initWithImage:image];
    }
    return _xView;
}

@end