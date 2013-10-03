//
//  AOHomeViewController.h
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

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"

@interface UIImage (AOImageCategory)

+ (UIImage *)generatePNGFromView:(UIView *)aView;

@end

@protocol AOHomeViewControllerDelegate <NSObject>

/**
 * Called when a new profile medallion is being tapped
 */

- (void)newMedallionTapped;

/**
 * Called when a medallion is being tapped
 */

- (void)medallionTappedWithUserInfo:(id)userInfo;

@end

@interface AOHomeViewController : UIViewController

/**
 * Scroll view that hold all defined background images
 */

@property (weak, nonatomic) id <AOHomeViewControllerDelegate> delegate;

/**
 * Custom init method to create a new AOHomeViewController object
 *
 * @param NSTimeInterval background image pan effect duration
 * @param NSUInteger background image pan effect size
 * @param NSArray collection of background images defined with images bundle name (ie. @[@"bg_1.jpg", @"bg_2.jpg", @"bg_3.jpg"])
 *
 * @return AOHomeViewController
 */

- (id)initWithPanDuration:(NSTimeInterval)panDuration withPanSize:(NSUInteger)panSize andBackgroundImages:(NSArray *)images;

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

@end
