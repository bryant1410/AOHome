//
//  AOHomeViewController.m
//  AOHomeDemo
//
//  Created by Loïc GRIFFIE on 16/09/13.
//  Copyright (c) 2013 Appsido. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AOHomeViewController.h"

@implementation UIImage (AOImageCategory)

+ (UIImage *)generatePNGFromView:(UIView *)aView
{
    UIImage *image = nil;
    
    UIGraphicsBeginImageContextWithOptions(aView.frame.size, NO, [[UIScreen mainScreen] scale]);
    {
        [[aView layer] renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface AOMedallionView : AGMedallionView

@property (nonatomic, strong) UIButton *medallion;
@property (nonatomic, strong) NSString *profileName;

@end

@implementation AOMedallionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.medallion = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height, self.frame.size.width, 30.0f) ];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setShadowColor:[UIColor blackColor]];
    [name setShadowOffset:CGSizeMake(1, 1)];
    [name setTextAlignment:NSTextAlignmentCenter];
    [name setTextColor:[UIColor whiteColor]];
    [name setText:self.profileName];
    [self addSubview:name];
    
    [self.medallion setBackgroundColor:[UIColor clearColor]];
    [self.medallion setFrame:CGRectMake(0.0, 0.0f, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.medallion];
}

@end

@interface AOHomeViewController ()
{
    NSUInteger      _bgIndex;
    BOOL            _useDistantBackgroundImages;
}

@property (strong, nonatomic) IBOutlet UIScrollView *backgrounds;
@property (strong, nonatomic) IBOutlet UIScrollView *profils;

@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) NSMutableArray *bgImages;
@property (retain, nonatomic) NSMutableArray *placeholderImages;
@property (retain, nonatomic) NSMutableArray *medallions;

@property (assign, nonatomic) NSTimeInterval panDuration;
@property (assign, nonatomic) NSUInteger panSize;

@end

@implementation AOHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _bgIndex = 0;
        _useDistantBackgroundImages = NO;
        
        self.panDuration = 7.0f;
        self.panSize = 10;
    }
    return self;
}

- (instancetype)initWithPanDuration:(NSTimeInterval)panDuration withPanSize:(NSUInteger)panSize andBackgroundImages:(NSArray *)images
{
    self = [self init];
    if (self)
    {
        self.panDuration = panDuration;
        self.panSize = panSize;
        
        self.bgImages = [NSMutableArray arrayWithArray:images];
        self.medallions = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithPanDuration:(NSTimeInterval)panDuration withPanSize:(NSUInteger)panSize andDistantBackgroundImages:(NSArray *)images withPlaceholder:(NSArray *)placeholders
{
    self = [self initWithPanDuration:panDuration withPanSize:panSize andBackgroundImages:images];
    if (self)
    {
        _useDistantBackgroundImages = YES;
        
        self.placeholderImages = [NSMutableArray arrayWithArray:placeholders];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupBackgrounds];
    [self initProfils];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startBackgroundAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopBackgroundAnimation];
    [self setupBackgrounds];
    [self resetBackgroundImagePosition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getCurrentBackgroundImage
{
    CGRect frame = [[[self.backgrounds viewWithTag:(10 + _bgIndex)].layer presentationLayer] frame];
    [[self.backgrounds viewWithTag:(10 + _bgIndex)].layer removeAllAnimations];
    [[self.backgrounds viewWithTag:(10 + _bgIndex)] setFrame:frame];
   
    return [UIImage generatePNGFromView:[self.backgrounds viewWithTag:(10 + _bgIndex)]];
}

- (void)startBackgroundAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.panDuration + 1.0f) target:self selector:@selector(animateBackground:) userInfo:nil repeats:YES];
}

- (void)stopBackgroundAnimation
{
    [self.timer invalidate];
}

- (void)addMedallionWithImage:(UIImage *)anImage andTitle:(NSString *)aTitle newProfile:(BOOL)isNewProfile userInfo:(id)userInfo
{
    if (userInfo == nil) userInfo = [NSNull null];
    if (anImage == nil) anImage = [UIImage imageNamed:@"defaultProfil"];
        
    [self.medallions insertObject:@{@"image": anImage, @"title": aTitle, @"newProfil": [NSNumber numberWithBool:isNewProfile], @"userInfo": userInfo}
                          atIndex:0];
    
    [self setupProfils];
}

- (void)initProfils
{
    [self.medallions removeAllObjects];
}

- (void)setupProfils
{
    for (UIView *v in [self.profils subviews])
        [v removeFromSuperview];
    
    int n = 0;
    for (NSDictionary *m in self.medallions)
    {
        AOMedallionView *profil = [[AOMedallionView alloc] init];
        [profil setFrame:CGRectMake(((self.profils.bounds.size.width/2)-(profil.bounds.size.width/2)) + (n * self.view.frame.size.width),
                                    0.0f,
                                    profil.frame.size.width,
                                    profil.frame.size.height)];
        [profil setImage:[m valueForKey:@"image"]];
        [profil setProfileName:[m valueForKey:@"title"]];
        
        [profil.medallion setTag:(n + 20)];
        [profil.medallion addTarget:self
                             action:([[m valueForKey:@"newProfil"] boolValue] ? NSSelectorFromString(@"newProfileSelected:") : NSSelectorFromString(@"medallionSelected:"))
                   forControlEvents:UIControlEventTouchUpInside];
        
        [self.profils addSubview:profil];
        
        n++;
    }
    
    [self.profils setContentSize:CGSizeMake(n * self.view.frame.size.width, self.profils.frame.size.height)];
    [self.profils scrollRectToVisible:CGRectMake((n - 1) * self.profils.frame.size.width, 0.0f, self.profils.frame.size.width, self.profils.frame.size.height) animated:NO];
}

- (void)initBackgrounds
{
    [self.bgImages removeAllObjects];
}

- (void)setupBackgrounds
{
    _bgIndex = 0;
    
    for (id v in [self.backgrounds subviews])
        [v removeFromSuperview];
    
    int n = 0;
    for (NSString *i in self.bgImages)
    {
        EGOImageView *bg = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:[self.placeholderImages objectAtIndex:n]] delegate:self];
        
        if (_useDistantBackgroundImages) [bg setImageURL:[NSURL URLWithString:i]];
        else [bg setImage:[UIImage imageNamed:i]];
        
        [bg setBackgroundColor:[UIColor clearColor]];
        [bg setTag:10 + n];
        [bg setFrame:CGRectMake(0.0f + (self.view.frame.size.width * n) + (self.panSize * n), 0.0f, self.view.frame.size.width + self.panSize, self.view.frame.size.height)];
        [self.backgrounds addSubview:bg];
        
        n++;
    }
    
    [self.backgrounds setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    self.backgrounds.transform = transform;
    
    CGRect f = [self.profils frame];
    f.origin.y = self.view.frame.size.height;
    [self.profils setFrame:f];
    
    // Fade out background
    [UIView animateWithDuration:0.0 delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{ self.backgrounds.alpha = 0.0; }
                     completion:^(BOOL completed)
     {
         // Fade in background
         [UIView animateWithDuration:0.5 delay:0.0
                             options:UIViewAnimationOptionAllowUserInteraction
                          animations:^{
                              self.backgrounds.alpha = 1.0;
                              
                              // Scale background to 1.0
                              CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                              self.backgrounds.transform = transform;
                              
                              // Slide in from bottom Medallion
                              [UIView animateWithDuration:0.5 delay:0.0
                                                  options:UIViewAnimationOptionAllowUserInteraction
                                               animations:^{
                                                   
                                                   CGRect f = [self.profils frame];
                                                   f.origin.y = self.view.frame.size.height - self.profils.frame.size.height;
                                                   [self.profils setFrame:f];
                                               }
                                               completion:^(BOOL completed)
                               {
                                   // Force scroll profils to first medallion
                                   [self.profils scrollRectToVisible:CGRectMake(0.0f, 0.0f, self.profils.frame.size.width, self.profils.frame.size.height) animated:YES];
                               }];
                              
                          }
                          completion:^(BOOL completed) {
                          }];
         
         // Pan background image
         [UIView animateWithDuration:self.panDuration delay:0.0
                             options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                          animations:^{
                              
                              CGRect frame = [[self.backgrounds viewWithTag:10] frame];
                              frame.origin.x -= self.panSize;
                              [[self.backgrounds viewWithTag:10] setFrame:frame];
                              
                          }
          
                          completion:^(BOOL completed) {
                              
                              if (completed) _bgIndex++;
                          }];
     }];
    
    [self.backgrounds setContentSize:CGSizeMake((self.view.frame.size.width * [self.bgImages count]) + (self.panSize * [self.bgImages count]), self.view.frame.size.height)];
}

- (void)animateBackground:(id)sender
{
    if (_bgIndex >= [self.bgImages count]) _bgIndex = 0;
    
    [UIView animateWithDuration:0.25 delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{ self.backgrounds.alpha = 0.0; }
                     completion:^(BOOL completed)
     {
         if (completed)
         {
             [self resetBackgroundImagePosition];
             
             CGRect frame = [[self.backgrounds viewWithTag:(10 + _bgIndex)] frame];
             frame.origin.x = (self.view.frame.size.width + self.panSize) * _bgIndex;
             [[self.backgrounds viewWithTag:(10 + _bgIndex)] setFrame:frame];
             
             [self.backgrounds setContentOffset:CGPointMake((self.view.frame.size.width * _bgIndex) + (_bgIndex * self.panSize), 0.0f) animated:NO];
         }
         
         [UIView animateWithDuration:0.25 delay:0.0
                             options:UIViewAnimationOptionAllowUserInteraction
                          animations:^{ self.backgrounds.alpha = 1.0; }
                          completion:^(BOOL completed) {
                              
                              if (completed)
                              {
                                  
                              }
                          }];
         
         [UIView animateWithDuration:self.panDuration delay:0.0
                             options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                          animations:^{
                              
                              CGRect frame = [[self.backgrounds viewWithTag:(10 + _bgIndex)] frame];
                              frame.origin.x -= self.panSize;
                              [[self.backgrounds viewWithTag:(10 + _bgIndex)] setFrame:frame];
                              
                          }
          
                          completion:^(BOOL completed) {
                              
                              if (completed) _bgIndex++;
                          }];
     }];
}

- (void)resetBackgroundImagePosition
{
    for (int i = 0; i < [self.bgImages count]; i++)
    {
        CGRect frame = [[self.backgrounds viewWithTag:(10 + i)] frame];
        frame.origin.x = (self.view.frame.size.width * i) + (self.panSize * i);
        frame.size.width = self.view.frame.size.width + self.panSize;
        [[self.backgrounds viewWithTag:(10 + i)] setFrame:frame];
    }
}

- (void)hideProfilsWithDuration:(NSTimeInterval)aDuration afterDelay:(NSTimeInterval)aDelay
{
    [UIView animateWithDuration:aDuration delay:aDelay
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{ self.profils.alpha = 0.0; }
                     completion:^(BOOL completed)
     {
         
     }];
}

- (void)showProfilsWithDuration:(NSTimeInterval)aDuration afterDelay:(NSTimeInterval)aDelay
{
    [UIView animateWithDuration:aDuration delay:aDelay
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{ self.profils.alpha = 1.0; }
                     completion:^(BOOL completed)
     {
         
     }];
}

- (IBAction)medallionSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(medallionTappedWithUserInfo:)])
        [self.delegate performSelector:@selector(medallionTappedWithUserInfo:)
                            withObject:[[self.medallions objectAtIndex:([sender tag] - 20)] valueForKey:@"userInfo"]];
}

- (IBAction)newProfileSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newMedallionTapped)])
        [self.delegate performSelector:@selector(newMedallionTapped)];
}

#pragma mark - EGOImageView delegate

- (void)imageViewLoadedImage:(EGOImageView *)imageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backgroundImageDidLoad:)])
        [self.delegate performSelector:@selector(backgroundImageDidLoad:) withObject:self];
}

- (void)imageViewFailedToLoadImage:(EGOImageView *)imageView error:(NSError*)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backgroundImageDidFailLoad:withError:)])
        [self.delegate performSelector:@selector(backgroundImageDidFailLoad:withError:) withObject:self withObject:error];
}

@end