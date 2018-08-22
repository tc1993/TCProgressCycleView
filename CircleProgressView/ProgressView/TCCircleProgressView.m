//
//  TCCircleProgressView.m
//  Demo
//
//  Created by 唐超 on 8/10/18.
//  Copyright © 2018 KevinXu. All rights reserved.
//

#import "TCCircleProgressView.h"
@interface TCCircleProgressView()

///进度圆
@property (nonatomic, strong) CAShapeLayer * circleLayer;
///分数
@property (nonatomic, strong) UILabel * scoreLabel;
///评分等级
@property (nonatomic, strong) UILabel * stateLabel;
///圆点数组
@property (nonatomic, strong) NSMutableArray * pointLayerArray;
///三角形指示
@property (nonatomic, strong) CAShapeLayer * triangleLayer;

@property (nonatomic, assign) CGPoint customCenter;
///起点偏离角度 本来是以最右边为0开始顺时针到2PI的 如果startOffsetAngle=-0.5PI 则为从顶端开始 依次类推
@property (nonatomic, assign) CGFloat startOffsetAngle;
///三角形指示箭头的半径
@property (nonatomic, assign) CGFloat trangleRadius;

@end

@implementation TCCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor colorWithRed:31/255.0 green:172/255.0 blue:205/255.0 alpha:1];
    _startOffsetAngle = -1.25* M_PI;
    //圆的大小
    CGFloat rectWidth = 175;
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2;
    _customCenter = CGPointMake(centerX, centerY);
    CGFloat circleRadius = rectWidth/2.0;
    CGFloat lineWidth = 3;
    

    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.font = [UIFont boldSystemFontOfSize:70];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.text = @"50";
    [self addSubview:_scoreLabel];
    
    _scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    
    UILabel * unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.text = @"分";
    unitLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:unitLabel];
    unitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:unitLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scoreLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:unitLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_scoreLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];

    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_scoreLabel.frame), CGRectGetMaxY(_scoreLabel.frame), 20, 20)];
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.text = @"高";
    _stateLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_stateLabel];
    
    _stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_stateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scoreLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_stateLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_scoreLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    
    // 创建弧线路径对象

    UIBezierPath *fullCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:rectWidth/2 startAngle:_startOffsetAngle endAngle:2*M_PI + _startOffsetAngle clockwise:YES];
    fullCirclePath.lineCapStyle  = kCGLineCapRound;
    fullCirclePath.lineJoinStyle = kCGLineCapRound;
    
    //整个圆 底部半透明白圆
    CAShapeLayer * fullCirclelayer = [CAShapeLayer layer];
    fullCirclelayer.lineCap = kCALineCapButt;
    fullCirclelayer.fillColor = [UIColor clearColor].CGColor;
    fullCirclelayer.lineWidth = lineWidth;
    fullCirclelayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    fullCirclelayer.path = fullCirclePath.CGPath;
    [self.layer addSublayer:fullCirclelayer];

    //全白进度展示圆
    CAShapeLayer * progressLayer = [CAShapeLayer layer];
    progressLayer.lineCap = kCALineCapButt;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.lineWidth = lineWidth+1;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.path = fullCirclePath.CGPath;
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = 0.1;
    [self.layer addSublayer:progressLayer];
    self.circleLayer = progressLayer;
    
    _pointLayerArray = [NSMutableArray array];
    //外圈圆点 一般设置为进度的整数倍个数 不然会出现指针和圆点错位的情况 现在进度是只有4等分 0% 25% 50% 75% 100% 所以设为4的倍数 16
    int count = 16;
    for (int i = 0; i<count; i++) {
        CGFloat radius = circleRadius + 15.0;
        CGFloat width = 6;
        CGFloat angle = i/floorf(count) * 2.0 * M_PI + _startOffsetAngle;
        CGFloat pointCenterX = centerX + radius*cos(angle);
        CGFloat pointCenterY = centerY + radius*sin(angle);
        CALayer * pointLayer = [[CALayer alloc] init];
        pointLayer.frame = CGRectMake(0, 0, width, width);
        pointLayer.position = CGPointMake(pointCenterX, pointCenterY);
        pointLayer.backgroundColor = [UIColor whiteColor].CGColor;
        pointLayer.cornerRadius = width/2;
        pointLayer.masksToBounds = YES;
        [self.layer addSublayer:pointLayer];
        [_pointLayerArray addObject:pointLayer];
        pointLayer.hidden = YES;
    }
    
    //三角形指示标
    UIBezierPath * triangleBezierPath = [UIBezierPath bezierPath];
    CGFloat triangleLength = 8;
    [triangleBezierPath moveToPoint:CGPointMake(0, triangleLength/2)];
    [triangleBezierPath addLineToPoint:CGPointMake(triangleLength+2, 0)];
    [triangleBezierPath addLineToPoint:CGPointMake(0, -triangleLength/2)];
    [triangleBezierPath addLineToPoint:CGPointMake(0, triangleLength/2)];
    [triangleBezierPath closePath];
    
    _trangleRadius = circleRadius-triangleLength-15;
    CAShapeLayer * triangleLayer = [CAShapeLayer layer];
    triangleLayer.lineCap = kCALineCapSquare;
    triangleLayer.fillColor = [UIColor whiteColor].CGColor;
    triangleLayer.lineWidth = 2;
    triangleLayer.strokeColor = [UIColor whiteColor].CGColor;
    triangleLayer.path = triangleBezierPath.CGPath;
    triangleLayer.position = CGPointMake(centerX+_trangleRadius, centerY);
    [self.layer addSublayer:triangleLayer];
    _triangleLayer = triangleLayer;
}

- (void)setProgress:(CGFloat)progress {
    _progress  = progress;
    self.circleLayer.strokeEnd = progress;
    NSString * scoreText = [NSString stringWithFormat:@"%.0f",progress*100];
    _scoreLabel.text = scoreText;
    if (scoreText.length>2) {
        _scoreLabel.font = [UIFont boldSystemFontOfSize:55];
    }
    
    if (progress == 0) {
        _stateLabel.text = @"无";
    }
    else if (progress <=0.25){
        _stateLabel.text = @"低";
    }
    else if (progress == 0.5){
        _stateLabel.text = @"中";
    }
    else if (progress == 0.75){
        _stateLabel.text = @"高";
    }
    else if (progress == 1){
        _stateLabel.text = @"非常高";
    }
    __weak typeof(self) weakSelf = self;
    __block BOOL bigPoint = NO;
    [_pointLayerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer * pointLayer = obj;
        pointLayer.affineTransform = CGAffineTransformMakeScale(1, 1);
        if ((float)idx/weakSelf.pointLayerArray.count<=progress) {
            pointLayer.hidden = NO;
        }
        else {
            if (!bigPoint) {
                if (idx>=1) {
                    //最后一个圆点放大
                    CALayer * bigpointLayer = weakSelf.pointLayerArray[idx-1];
                    bigpointLayer.affineTransform = CGAffineTransformMakeScale(2.0, 2.0);
                }
                bigPoint = YES;
            }
            pointLayer.hidden = YES;
        }
    }];
    
    //三角指示器旋转和改变位置
    CGFloat angle = progress*2*M_PI+_startOffsetAngle;
    _triangleLayer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
    CGFloat triangleCenterX = _customCenter.x + _trangleRadius*cos(angle);
    CGFloat triangleCenterY = _customCenter.y + _trangleRadius*sin(angle);
    _triangleLayer.position = CGPointMake(triangleCenterX, triangleCenterY);
}
@end
