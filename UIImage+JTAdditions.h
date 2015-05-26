//
//  UIImage+JTAdditions.h
//
//  Created by Jakub Truhlar on 26.05.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JTAdditions)

+ (UIImage *)jt_imageWithView:(UIView *)view;
+ (UIImage *)jt_imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)jt_filledWithColor:(UIColor *)color;
- (UIImage *)jt_scaledProportionallyToHeight:(CGFloat)height;
- (UIImage *)jt_scaledProportionallyToWidth:(CGFloat)width;
- (UIImage *)jt_scaledToSize:(CGSize)newSize;
- (UIImage *)jt_mergedWithImage:(UIImage *)anotherImage;

@end