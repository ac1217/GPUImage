//
//  GPUImageGridFilter.h
//  SimpleVideoFilter
//
//  Created by Erica on 2018/8/21.
//  Copyright © 2018年 Cell Phone. All rights reserved.
//

#import <GPUImage/GPUImageFramework.h>

@interface GPUImageGridFilter : GPUImageFilter
{
    GLint lengthUniform;
}

// Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
@property(readwrite, nonatomic) NSInteger length;


@end
