//
//  UIImage+Resize.m
//  Toolkit
//
//  Created by jack zhou on 12/25/13.
//  Copyright (c) 2013 JZ. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode
{
    CGRect drawRect;
    CGSize size = self.size;
    
    switch (contentMode)
    {
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleToFill:
        {
            // nothing to do
            [self drawInRect:rect];
            return;
        }
            
        case UIViewContentModeScaleAspectFit:
        {
            CGFloat factor;
            
            if (size.width<size.height)
            {
                factor = rect.size.height / size.height;
                
            }
            else
            {
                factor = rect.size.width / size.width;
            }
            
            
            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);
            
            // otherwise same as center
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            
            break;
        }
            
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat factor;
            
            if (size.width<size.height)
            {
                factor = rect.size.width / size.width;
                
            }
            else
            {
                factor = rect.size.height / size.height;
            }
            
            
            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);
            
            // otherwise same as center
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            
            break;
        }
            
        case UIViewContentModeCenter:
        {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTop:
        {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  rect.origin.y-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottom:
        {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  rect.origin.y-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeLeft:
        {
            drawRect = CGRectMake(rect.origin.x,
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeRight:
        {
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTopLeft:
        {
            drawRect = CGRectMake(rect.origin.x,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTopRight:
        {
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottomLeft:
        {
            drawRect = CGRectMake(rect.origin.x,
                                  CGRectGetMaxY(rect)-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottomRight:
        {
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  CGRectGetMaxY(rect)-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // clip to rect
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    // draw
    [self drawInRect:drawRect];
    
    CGContextRestoreGState(context);
}

@end
