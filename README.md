#AOHome - Out of the box home application

AOHome is under MIT Licence so if you find it helpful just use it !

###**AOHomeDemo**

This project help create clean application home view controller with block based animation for background images. You can also choose between NSBundle images or distant images with placeholder while image being downloaded.

The AOMedallionView inherit from AGMedallionView library to add user interaction and delegate method.

https://github.com/arturgrigor/AGMedallionView

Distant background images is using the EGOImageLoader library.

https://github.com/enormego/EGOImageLoading

###**Screenshot:**
AOHomeDemo in the iphone simulator

![AOHomeDemo in the simulator](http://public.appsido.com/iPhone/public/AOHome/AOHome.gif)

##How To Use It

Sample project show a simple usage.

###Documentation

```objc

@protocol AOHomeViewControllerDelegate <NSObject>

@optional

/**
 * Called when a distant background image did load
 */

- (void)backgroundImageDidLoad:(AOHomeViewController *)bgImage;

/**
 * Called when a distant background image did fail load
 */

- (void)backgroundImageDidFailLoad:(AOHomeViewController *)bgImage withError:(NSError *)error;

@required

/**
 * Called when a new profile medallion is being tapped
 */

- (void)newMedallionTapped;

/**
 * Called when a medallion is being tapped
 */

- (void)medallionTappedWithUserInfo:(id)userInfo;

@end

/**
 * Custom init method to create a new AOHomeViewController object
 *
 * @param NSTimeInterval background image pan effect duration
 * @param NSUInteger background image pan effect size
 * @param NSArray collection of background images defined with images bundle name (ie. @[@"bg_1.jpg", @"bg_2.jpg", @"bg_3.jpg"])
 *
 * @return AOHomeViewController
 */

- (instancetype)initWithPanDuration:(NSTimeInterval)panDuration withPanSize:(NSUInteger)panSize andBackgroundImages:(NSArray *)images;

/**
 * Custom init method to create a new AOHomeViewController object
 *
 * @param NSTimeInterval background image pan effect duration
 * @param NSUInteger background image pan effect size
 * @param NSArray collection of distant background images NSURL (ie. @[@"http://www.flickr.com/photos/uberdogleg/10141188454/in/explore-2013-10-07", @"http://www.flickr.com/photos/johnhemphoto/10138801736/in/explore-2013-10-07", @"http://www.flickr.com/photos/cherco/10134978246/in/explore-2013-10-07"])
 * @param NSArray collection of plaholder images defined with images bundle name (ie. @[@"bg_1.jpg", @"bg_2.jpg", @"bg_3.jpg"])
 *
 * @return AOHomeViewController
 */

- (instancetype)initWithPanDuration:(NSTimeInterval)panDuration withPanSize:(NSUInteger)panSize andDistantBackgroundImages:(NSArray *)images withPlaceholder:(NSArray *)placeholders;

/**
 * Add a medallion 
 *
 * @param UIImage medallion image
 * @param NSString medallion title
 * @param BOOL new profile medallion
 * @param id some information to be used
 */

- (void)addMedallionWithImage:(UIImage *)anImage andTitle:(NSString *)aTitle newProfile:(BOOL)isNewProfile userInfo:(id)userInfo;

/**
 * Hide all medallion
 *
 * @param NSTimeInterval a duration for the fade out
 * @param NSTimeInterval a delay to start the fade out
 */

- (void)hideProfilsWithDuration:(NSTimeInterval)aDuration afterDelay:(NSTimeInterval)aDelay;

/**
 * Show all medallion
 *
 * @param NSTimeInterval a duration for the fade in
 * @param NSTimeInterval a delay to start the fade in
 */

- (void)showProfilsWithDuration:(NSTimeInterval)aDuration afterDelay:(NSTimeInterval)aDelay;

/**
 * Return the current background image being shown
 *
 * @return the UIImage current background image
 */

- (UIImage *)getCurrentBackgroundImage;
    
```

###Code snippet

```objc
// First create a new view controller class that inherit from AOHomeViewController class and define the new controller conform to AOHomeViewController delegate protocol. Do not forget to import the AOHomeViewController interface

#import "AOHomeViewController.h"

@interface AOHomeController : AOHomeViewController <AOHomeViewControllerDelegate>

@end

// Then in the .m file define itself as the delegate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setDelegate:self];
    }
    return self;
}

// Then add medallion. One to create a new profile the other one to access existing profile.

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Medallion to create new profile
    [self addMedallionWithImage:[UIImage imageNamed:@"defaultProfil"]
                       andTitle:NSLocalizedString(@"Add profile", @"")
                     newProfile:YES
                       userInfo:nil];
    
    // Medallion to access existing profile
    [self addMedallionWithImage:[UIImage imageNamed:@"tyrion.jpg"]
                       andTitle:@"Tyrion Lannister"
                     newProfile:NO
                       userInfo:@{@"image":[UIImage imageNamed:@"tyrion.jpg"], @"Name": @"Tyrion Lannister"}];
}

// Also implement the delegate methods

- (void)newMedallionTapped
{
    NSLog(@"New profile touched up!");
}

- (void)medallionTappedWithUserInfo:(id)userInfo
{
    NSLog(@"Medallion profile touched up! > %@", userInfo);
}

- (void)backgroundImageDidLoad:(AOHomeViewController *)bgImage
{
    NSLog(@"background image did load");
}

- (void)backgroundImageDidFailLoad:(AOHomeViewController *)bgImage withError:(NSError *)error
{
    NSLog(@"background image load did fail with error > %@", error);
}

// Finally load your Home view controller
// Using NSBundle background images
AOHomeController *vc = [[AOHomeController alloc] initWithPanDuration:7.0f
                                                             withPanSize:10
                                                     andBackgroundImages:@[@"bg_1.jpg", @"bg_2.jpg", @"bg_3.jpg", @"bg_4.jpg", @"bg_5.jpg"]];
    
// or using distant background images
AOHomeController *vc = [[AOHomeController alloc] initWithPanDuration:7.0f
                                                             withPanSize:10
                                                     andDistantBackgroundImages:@[@"http://www.hdwallpapersart.com/wp-content/uploads/2013/06/rainy-paris-iphone-5-wallpaper.jpg", @"http://cdn.crazyleafdesign.com/blog/wp-content/uploads/2012/10/iphone-5-wallpaper-rain-drops.jpg", @"http://blogigoldhouse.com/wp-content/uploads/2012/12/Abstract-iPhone-5-wallpaper-igoldhouse.com_.jpg"]
                                                            withPlaceholder:@[@"bg_1.jpg", @"bg_2.jpg", @"bg_3.jpg"]];
```

Any comments are welcomed

@Appsido
contact@appsido.com
