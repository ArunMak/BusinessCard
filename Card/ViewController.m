

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize create,cards;
- (void)viewDidLoad
{
    [super viewDidLoad];
     [create setBackgroundImage:[UIImage imageNamed:@"Create-Biz-Card-Button-Normal.png"] forState:UIControlStateNormal];
     [create setBackgroundImage:[UIImage imageNamed:@"Create-Biz-Card-Button-Hover.png"] forState:UIControlStateHighlighted];
    [cards setBackgroundImage:[UIImage imageNamed:@"My-Biz-Card-Button-Normal.png"] forState:UIControlStateNormal];
     [cards setBackgroundImage:[UIImage imageNamed:@"My-Biz-Card-Button-Hover.png"] forState:UIControlStateHighlighted];
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.trackedViewName = @"DashBoard Screen";
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
