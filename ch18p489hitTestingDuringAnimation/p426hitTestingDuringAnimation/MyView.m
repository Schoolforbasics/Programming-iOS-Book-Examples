

#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyView {
    IBOutlet UIView* v;
}

// the top-level (root) view is a MyView

- (void) awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self->v addGestureRecognizer:t];
    t.cancelsTouchesInView = NO;
    // uncomment next line to see how button, even if tappable, "swallows the touch" while animating
    //[self->v removeGestureRecognizer:t];
}

- (void) tap: (UIGestureRecognizer*) g {
    NSLog(@"tap! (gesture recognizer)");
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // comment out this next line to use our munged hit-testing
    // return [super hitTest:point withEvent:event];
    // v is the animated subview
    CALayer* lay = [self->v.layer presentationLayer];
    CALayer* hitLayer = [lay hitTest: point];
    if (hitLayer == lay || hitLayer.superlayer == lay)
        return self->v;
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView == self->v)
        return self;
    return hitView;
}


@end
