//
//  UIImage+JTAdditions.m
//
//  Created by Jakub Truhlar on 26.05.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import "UIImage+JTAdditions.h"

@implementation UIImage (JTAdditions)

+ (UIImage *)jt_imageWithView:(UIView *)view {
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)jt_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *createdImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return createdImage;
}

+ (UIImage *)jt_imageWithRadialGradientSize:(CGSize)size innerColor:(UIColor *)innerColor outerColor:(UIColor *)outerColor center:(CGPoint)center radius:(CGFloat)radius {
    UIGraphicsBeginImageContext(size);
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat sRed, sGreen, sBlue, sAlpha, eRed, eGreen, eBlue, eAlpha;
    [innerColor getRed:&sRed green:&sGreen blue:&sBlue alpha:&sAlpha];
    [outerColor getRed:&eRed green:&eGreen blue:&eBlue alpha:&eAlpha];
    CGFloat components[8] = { sRed, sGreen, sBlue, sAlpha, eRed, eGreen, eBlue, eAlpha};
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    center = CGPointMake(center.x * size.width, center.y * size.height);
    CGPoint startPoint = center;
    CGPoint endPoint = center;
    radius = MIN(size.width, size.height) * radius;
    CGFloat startRadius = 0;
    CGFloat endRadius = radius;
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, startPoint, startRadius, endPoint, endRadius, kCGGradientDrawsAfterEndLocation);
    UIImage *gradientImg;
    gradientImg = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    return gradientImg;
}

- (UIImage *)jt_filledWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(context, rect, self.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

- (UIImage *)jt_scaledProportionallyToHeight:(CGFloat)height {
    CGFloat finalScale = self.size.height / height;
    UIImage *scaledImage = [UIImage imageWithCGImage:[self CGImage] scale:(self.scale * finalScale) orientation:(self.imageOrientation)];
    return scaledImage;
}

- (UIImage *)jt_scaledProportionallyToWidth:(CGFloat)width {
    CGFloat finalScale = self.size.height / width;
    UIImage *scaledImage = [UIImage imageWithCGImage:[self CGImage] scale:(self.scale * finalScale) orientation:(self.imageOrientation)];
    return scaledImage;
}

- (UIImage *)jt_scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)jt_mergedWithImage:(UIImage *)anotherImage {
    CGSize newImageSize = CGSizeMake(MAX(self.size.width, anotherImage.size.width), MAX(self.size.height, anotherImage.size.height));
    UIGraphicsBeginImageContext(newImageSize);
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    }
    [anotherImage drawAtPoint:CGPointMake(roundf((newImageSize.width-anotherImage.size.width)/2),
                                         roundf((newImageSize.height-anotherImage.size.height)/2))];
    [self drawAtPoint:CGPointMake(roundf((newImageSize.width-self.size.width)/2),
                                        roundf((newImageSize.height-self.size.height)/2))];
    UIImage *mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergedImage;
}

- (UIImage *)jt_appliedAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end