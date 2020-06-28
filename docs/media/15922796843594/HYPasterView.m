

#import "HYPasterView.h"

/**默认删除和缩放按钮的大小*/
#define btnW_H 60
/**默认的图片宽高*/
#define defaultImageViewW_H self.frame.size.width - btnW_H
/**缩放和删除按钮与图片的间隔距离*/
#define paster_insert_space btnW_H/2
/**总高度*/
#define PASTER_SLIDE 250
/**安全边框*/
#define SECURITY_LENGTH PASTER_SLIDE/2


@interface HYPasterView ()
{
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
    CGRect  bgRect ;
}

/**删除按钮*/
@property (nonatomic, strong) UIImageView *delegateImageView;
/**缩放和旋转按钮*/
@property (nonatomic, strong) UIImageView *scaleImageView;
/**贴纸图片*/


@property (nonatomic, assign) BOOL isScale;


@end


@implementation HYPasterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.isScale = NO;
        self.isBord = NO;
        [self setupUI];
    }
    return self;
}




-(void)scale_clearBtnShow:(BOOL)isShow
{
    if (isShow)
    {
        [UIView animateWithDuration:0.1 animations:^{
             self.delegateImageView.alpha = 1.0;
             self.scaleImageView.alpha = 1.0;
             self.delegateImageView.hidden = !isShow;
             self.scaleImageView.hidden = !isShow;
         }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
               self.delegateImageView.alpha = 0.0;
               self.scaleImageView.alpha = 0.0;
               self.scaleImageView.hidden = !isShow;
                self.delegateImageView.hidden = !isShow;
           }];
    }
}


/**
 *  设置UI
 */
- (void)setupUI
{
//    self.backgroundColor = [UIColor lightGrayColor];
    
    minWidth = self.bounds.size.width * 0.5;
    minHeight = self.bounds.size.height * 0.5;
    
//    NSLog(@"= %@",minWidth);
//    NSLog(@"= %@",minWidth);

    
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y, self.frame.origin.x+self.frame.size.width - self.center.x);
    
    UIPanGestureRecognizer *dragResizeGestrue = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragPasterView:)];
    [self addGestureRecognizer:dragResizeGestrue];
    
    
    UITapGestureRecognizer * tapGesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pasterImageViewTap:)];
    [self addGestureRecognizer:tapGesure];
    
    
    //UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] ;
    //[self addGestureRecognizer:rotateGesture] ;
//    [self addTapGestureWithTarget:self selector:@selector(pasterImageViewTap:)];

    UIImageView *pasterImageView = [[UIImageView alloc]init];
    pasterImageView.userInteractionEnabled = YES;
    pasterImageView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    if (_isBord == YES) {
        pasterImageView.layer.borderWidth = 4.0;
    }
    else{
        pasterImageView.layer.borderWidth = 0;
    }

    [self addSubview:pasterImageView];
    self.pasterImageView = pasterImageView;
    
    UIImageView *delegateImageView = [[UIImageView alloc]init];
    [delegateImageView setImage:[UIImage imageNamed:@"JZB_Delete_Icon"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btDeletePressed:)];
    [delegateImageView addGestureRecognizer:tap];

    delegateImageView.userInteractionEnabled = YES;
    delegateImageView.hidden = YES;
    [self addSubview:delegateImageView];
    self.delegateImageView = delegateImageView;
    
    UIImageView *scaleImageView = [[UIImageView alloc]init];
    [scaleImageView setImage:[UIImage imageNamed:@"JZB_Scale_Icon"]];
    UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeTranslate:)] ;
    scaleImageView.userInteractionEnabled = YES;
    [scaleImageView addGestureRecognizer:panResizeGesture] ;
    scaleImageView.hidden = YES;
    [self addSubview:scaleImageView];
    self.scaleImageView = scaleImageView;
    
    self.pasterImageView.frame = CGRectMake(paster_insert_space, paster_insert_space, defaultImageViewW_H, defaultImageViewW_H);
    
    self.delegateImageView.frame = CGRectMake(0, 0, btnW_H, btnW_H);
    self.scaleImageView.frame = CGRectMake(CGRectGetMaxX(self.pasterImageView.frame) - btnW_H/2, CGRectGetMaxY(self.pasterImageView.frame) - btnW_H/2, btnW_H, btnW_H);
}


-(void)pasterImageViewTap:(UITapGestureRecognizer *)tapGesture
{
    if (self.isEditor ==NO) {
        return;
    }
    if (self.dragViewBlock) {
        self.dragViewBlock(tapGesture.view);
    }
}




-(void)setIsBord:(BOOL)isBord
{
    _isBord = isBord;
    if (_isBord == YES)
    {
        self.pasterImageView.layer.borderWidth = 4.0;
     }
     else{
         self.pasterImageView.layer.borderWidth = 0;
     }
}

/**
 *  旋转手势
 */
- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}

/**
 *  拖动手势
 */
- (void)dragPasterView:(UIPanGestureRecognizer *)dragPasterView
{
    
    if (self.isEditor == NO) {
       return;
    }
    switch (dragPasterView.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            if (self.changeBlock) {
                self.changeBlock();
            }
            
            if (self.dragViewBlock) {
                self.dragViewBlock(dragPasterView.view);
            }
        }
            break;
            
        default:
            break;
    }
    
    
//    - (CGPoint)translationInView:(nullable UIView *)view;                        // translation in the coordinate system of the specified view
//    - (void)setTranslation:(CGPoint)translation inView:(nullable UIView *)view;
//
//    - (CGPoint)velocityInView:(nullable UIView *)view;                           // velocity of the pan in points/second in the coordinate system of the specified view

    
    CGPoint transPoint = [dragPasterView translationInView:dragPasterView.view];
    CGPoint veloPoint  = [dragPasterView velocityInView:dragPasterView.view];
    
    NSLog(@"transPoint = %@",NSStringFromCGPoint(transPoint));
    NSLog(@"veloPoint = %@",NSStringFromCGPoint(veloPoint));

    
    
    
    
    CGPoint point = [dragPasterView translationInView:dragPasterView.view];
    self.center = CGPointMake(self.center.x + point.x, self.center.y + point.y);
    [dragPasterView setTranslation:CGPointZero inView:dragPasterView.view];
    [self checkIsOut];
    
}

/**
 *  右下角的缩放和旋转手势
 */
- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    
    self.isScale = YES;
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        if (self.changeBlock) {
            self.changeBlock();
        }
                
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, minWidth + 1 , minHeight + 1);
            self.scaleImageView.frame =CGRectMake(self.bounds.size.width-btnW_H,self.bounds.size.height-btnW_H,btnW_H,btnW_H);
            prevPoint = [recognizer locationInView:self];
        }
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            wChange = (point.x - prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);
            hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            CGFloat finalWidth  = self.bounds.size.width + (wChange) ;
            CGFloat finalHeight = self.bounds.size.height + (wChange) ;
            if (finalWidth > PASTER_SLIDE*(1+0.5))
            {
                finalWidth = PASTER_SLIDE*(1+0.5);
            }
            if (finalWidth < PASTER_SLIDE*(1-0.5))
            {
                finalWidth = PASTER_SLIDE*(1-0.5) ;
            }
            if (finalHeight > PASTER_SLIDE*(1+0.5))
            {
                finalHeight = PASTER_SLIDE*(1+0.5) ;
            }
            if (finalHeight < PASTER_SLIDE*(1-0.5))
            {
                finalHeight = PASTER_SLIDE*(1-0.5) ;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, finalWidth, finalHeight);
            self.scaleImageView.frame = CGRectMake(self.bounds.size.width-btnW_H, self.bounds.size.height-btnW_H, btnW_H, btnW_H);
            self.pasterImageView.frame = CGRectMake(paster_insert_space, paster_insert_space, self.bounds.size.width - paster_insert_space*2, self.bounds.size.height - paster_insert_space*2);
            
            prevPoint = [recognizer locationOfTouch:0 inView:self];
        }
        
        /* 旋转 */
//        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y, [recognizer locationInView:self.superview].x - self.center.x) ;
//        float angleDiff = deltaAngle - ang ;
//        self.transform = CGAffineTransformMakeRotation(-angleDiff);
        [self setNeedsDisplay];
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    
    //检查旋转和缩放是否出界
    [self checkIsOut];
}

/**
 *  左上角的删除点击手势
 */
- (void)btDeletePressed:(UITapGestureRecognizer *)recognizer
{
    
    NSInteger isRight = self.isRight ? 0:2;
    if (self.changeBlock) {
        self.changeBlock();
    }
    [self removeFromSuperview];
}

/**
 *  重写pasterImage的set方法
 */
- (void)setPasterImage:(UIImage *)pasterImage
{
    _pasterImage = pasterImage;
    if (pasterImage) {
        self.pasterImageView.image = pasterImage;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

/**
  *  检查在添加tag的时候是否超出了显示范围，如果超出，移动进显示范围内
  */
- (void)checkIsOut
{
    CGPoint point = self.center;
    
//    NSLog(@"%@",NSStringFromCGPoint(point));
//    NSLog(@"self.frame%@",NSStringFromCGRect(self.frame));
//    NSLog(@"self.superview.frame)=%@",NSStringFromCGRect(self.superview.frame));

    
    CGFloat top;
    CGFloat left;
    CGFloat bottom;
    CGFloat right;
    top = point.y - self.frame.size.height/2;
    bottom = (self.superview.frame.size.height - point.y) - self.frame.size.height/2;
    
    if (point.y < self.superview.frame.size.height/2)//中心在上半部分
    {
        if (top < 0)//顶部超过范围
        {
            point.y += ABS(top);
        }
    }
    else//否则中心在下半部分
    {
        if (bottom < 0)//如果底部超出
        {
            point.y -= ABS(bottom);
        }
    }
    
    left = point.x - self.frame.size.width/2;
    
    right =(self.superview.frame.size.width - point.x) - self.frame.size.width/2;
    
    
    if (point.x < self.superview.frame.size.width/2)//左半部分
    {
        if (left < 0)//左边超出范围
        {
            point.x += ABS(left);
        }
    }
    else//中心在右半部分
    {
        if (right < 0) //右边超出范围
        {
            point.x -= ABS(right);
        }
    }
    
    if (point.x == self.center.x && point.y == self.center.y)
    {
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.center = point;
        }];
    }
}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject] ;
//    touchStart = [touch locationInView:self.superview] ;//开始的位置
//}
//
///**
// *  移动
// */
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint touchLocation = [[touches anyObject] locationInView:self];
//    if (CGRectContainsPoint(self.scaleImageView.frame, touchLocation)) {
//        return;
//    }
//    CGPoint touch = [[touches anyObject] locationInView:self.superview];//移动的位置
//    [self translateUsingTouchLocation:touch];
//    [self checkIsOut];
//    touchStart = touch;
//}

/**
 *  确保移动时不超出屏幕
 */
- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y) ;//移动完成新的中心
    
    // Ensure the translation won't cause the view to move offscreen. BEGIN
    CGFloat midPointX = CGRectGetMidX(self.bounds) ;
    if (newCenter.x > self.superview.bounds.size.width - midPointX + SECURITY_LENGTH)
    {
        newCenter.x = self.superview.bounds.size.width - midPointX + SECURITY_LENGTH;
    }
    if (newCenter.x < midPointX - SECURITY_LENGTH)
    {
        newCenter.x = midPointX - SECURITY_LENGTH;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    if (newCenter.y > self.superview.bounds.size.height - midPointY + SECURITY_LENGTH)
    {
        newCenter.y = self.superview.bounds.size.height - midPointY + SECURITY_LENGTH;
    }
    if (newCenter.y < midPointY - SECURITY_LENGTH)
    {
        newCenter.y = midPointY - SECURITY_LENGTH;
    }
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
