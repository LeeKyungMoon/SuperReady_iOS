//
//  UIImage+ThumbTools.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 27..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "UIImage+ThumbTools.h"

@implementation UIImage(HCUIThumbTools)

- (BOOL)isProductSingleShot{
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    BOOL isWhiteImage = YES;
    int pixelInfo;
    UInt8 red, green, blue;
    pixelInfo = 0;
    red = data[pixelInfo];
    green = data[pixelInfo + 1];
    blue = data[pixelInfo + 2];
    if(!(red >= 250 && green >= 250 && blue >= 250) && isWhiteImage) isWhiteImage = NO;
    pixelInfo = (self.size.width - 1) * 4;
    red = data[pixelInfo];
    green = data[pixelInfo + 1];
    blue = data[pixelInfo + 2];
    if(!(red >= 250 && green >= 250 && blue >= 250) && isWhiteImage) isWhiteImage = NO;
    pixelInfo = (self.size.width * (self.size.height - 1)) * 4;
    red = data[pixelInfo];
    green = data[pixelInfo + 1];
    blue = data[pixelInfo + 2];
    if(!(red >= 250 && green >= 250 && blue >= 250) && isWhiteImage) isWhiteImage = NO;
    pixelInfo = (self.size.width * self.size.height - 1) * 4;;
    red = data[pixelInfo];
    green = data[pixelInfo + 1];
    blue = data[pixelInfo + 2];
    if(!(red >= 250 && green >= 250 && blue >= 250) && isWhiteImage) isWhiteImage = NO;
    CFRelease(pixelData);
    return isWhiteImage;
}

- (UIColor*)averageCornerColors{
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    int pixelInfo;
    float averageR = 0, averageG = 0, averageB = 0;
    UInt8 red, green, blue;
    pixelInfo = 0;
    red = data[pixelInfo];
    green = data[pixelInfo + 1];
    blue = data[pixelInfo + 2];
    averageR += red;
    averageG += green;
    averageB += blue;
    pixelInfo = (self.size.width - 1) * 4;
    red = data[pixelInfo];
    green = data[pixelInfo + 1];
    blue = data[pixelInfo + 2];
    averageR += red;
    averageG += green;
    averageB += blue;
    pixelInfo = (self.size.width * (self.size.height - 1)) * 4;
    red = data[pixelInfo];
    green = data[pixelInfo + 1];
    blue = data[pixelInfo + 2];
    if(red >= 250 && green >= 250 && blue >= 250){
        averageR += red;
        averageG += green;
        averageB += blue;
    }
    pixelInfo = (self.size.width * self.size.height - 1) * 4;;
    red = data[pixelInfo];
    green = data[pixelInfo + 1];
    blue = data[pixelInfo + 2];
    averageR += red;
    averageG += green;
    averageB += blue;
    averageR /= 4 * 255;
    averageG /= 4 * 255;
    averageB /= 4 * 255;
    CFRelease(pixelData);
    return [UIColor colorWithRed:averageR green:averageG blue:averageB alpha:1];
}

@end
