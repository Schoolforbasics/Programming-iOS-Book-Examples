

#import "ViewController.h"

@implementation ViewController {
    BOOL _viewInitializationDone;
}

#define which 1 // and "2" and "3" for the correct way;
                // however, there's an argument that "4" is now even better
                // (use updateViewConstraints to initiate layout)
                // finally, "5" does it with constraints alone

/* The big change here is that the rotation callbacks are no longer called on rotational launch.
 viewDidLoad is still too early, though (we have not yet rotated).
 The solution is now to use viewWillLayoutSubviews or updateViewConstraints.
 Or use constraints, so that layout will work right through rotation!
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (which) {
        case 1: // wrong result because it's too soon
        {
            UIView* square = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
            square.backgroundColor = [UIColor blackColor];
            square.center = CGPointMake(CGRectGetMidX(self.view.bounds),5); // top center?
            [self.view addSubview:square];
            // of course this problem wouldn't matter if we were using autolayout and constraints!
            break;
        }
        case 2: // works, but probably not the right thing to do
        {
            [self performSelector:@selector(finishViewDidLoad) 
                       withObject:nil afterDelay:0.0];
            break;
        }
        case 3: // works, probably a right way
        {
            break;
        }
        case 4: // works, probably an even righter way
        {
            [self.view setNeedsUpdateConstraints]; // so that updateViewConstraints will be called
            // not very well documented, but it looks as if calling this once
            // causes us to get rotation-related updateViewConstraints ever after
            break;
        }
        case 5: // best way if you can do it, just set it and forget it
        {
            UIView* square = [[UIView alloc] init];
            square.backgroundColor = [UIColor blackColor];
            [self.view addSubview:square];
            square.translatesAutoresizingMaskIntoConstraints = NO;
            NSArray* cons;
            cons = [NSLayoutConstraint
                    constraintsWithVisualFormat:@"V:|-0-[square(10)]"
                    options:0 metrics:nil
                    views:@{@"square":square}];
            [self.view addConstraints:cons];
            cons = [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:[square(10)]"
                    options:0 metrics:nil
                    views:@{@"square":square}];
            [self.view addConstraints:cons];
            [self.view addConstraint:
             [NSLayoutConstraint
              constraintWithItem:square
              attribute:NSLayoutAttributeCenterX
              relatedBy:NSLayoutRelationEqual
              toItem:self.view
              attribute:NSLayoutAttributeCenterX
              multiplier:1 constant:0]];
            NSLog(@"%@", self.view.constraints);
            break;
        }
    }
}

- (void) finishViewDidLoad {
    UIView* square = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
    square.backgroundColor = [UIColor blackColor];
    square.center = CGPointMake(CGRectGetMidX(self.view.bounds),5);
    [self.view addSubview:square];
}

- (void) finishInitializingView {
    if (_viewInitializationDone)
        return;
    _viewInitializationDone = YES;
    NSLog(@"finish initializing");
    UIView* square = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
    square.backgroundColor = [UIColor blackColor];
    square.center = CGPointMake(CGRectGetMidX(self.view.bounds),5);
    [self.view addSubview:square];
}

-(BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate %i", self.interfaceOrientation);
    // [self finishInitializingView]; // too soon! and called too often anyway
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"didrotate"); // no longer called on launch!
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willrotate %i",toInterfaceOrientation); // no longer called on launch!
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willanim %i",toInterfaceOrientation); // no longer called on launch!
}

-(void)viewWillLayoutSubviews {
    NSLog(@"willlay");
    switch (which) {
        case 1:
        case 2: {
            break;
        }
        case 3: {
            [self finishInitializingView];
            break;
        }
        case 4: {
            break;
        }
        case 5: {
            break;
        }
    }
}

-(void)updateViewConstraints {
    NSLog(@"updateviewconstraints");
    switch (which) {
        case 1:
        case 2: {
            break;
        }
        case 3: {
            break;
        }
        case 4: {
            [self finishInitializingView];
            break;
        }
        case 5: {
            break;
        }
    }
    [super updateViewConstraints];
}


@end
