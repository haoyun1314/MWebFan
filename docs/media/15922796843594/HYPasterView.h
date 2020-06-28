
#import <UIKit/UIKit.h>

@interface HYPasterView : UIView

@property (nonatomic, strong) UIImageView *pasterImageView;

@property (nonatomic, assign) BOOL isEditor;


@property (nonatomic, assign) BOOL isBord;


@property (nonatomic, assign) BOOL isRight;

@property(nonatomic,copy) void(^dragViewBlock)(UIView *dragView);



@property(nonatomic,copy) void(^changeBlock)(void);



/**图片，所要加成贴纸的图片*/
@property (nonatomic, strong) UIImage *pasterImage;

//缩放和清除按钮的显示和隐藏：YES显示 NO:隐藏
-(void)scale_clearBtnShow:(BOOL)isShow;

- (void)checkIsOut;


@end
