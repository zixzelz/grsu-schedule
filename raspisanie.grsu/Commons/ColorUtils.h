//
//  ColorUtils.h
//  HelpBook
//
//  Created by Pavel Batashou on 9/30/13.
//  Copyright (c) 2013 HelpBook Inc. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ColorUtils : NSObject

@end
