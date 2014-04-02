
#import "JAMAppDelegate.h"
#import "JAMMainViewController.h"

@implementation JAMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = JAMMainViewController.new;
    [self.window makeKeyAndVisible];
    return YES;
}
@end
