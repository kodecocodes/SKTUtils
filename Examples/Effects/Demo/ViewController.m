
#import "ViewController.h"
#import "MyScene.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet SKView *skView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

//  self.skView.showsFPS = YES;
//  self.skView.showsNodeCount = YES;
//  self.skView.showsDrawCount = YES;
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskLandscape;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  if (self.skView.scene == nil) {
    SKScene *scene = [MyScene sceneWithSize:self.skView.bounds.size];
    [self.skView presentScene:scene];
  }
}

@end
