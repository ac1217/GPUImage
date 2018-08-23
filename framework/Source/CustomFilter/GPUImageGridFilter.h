//
//  GPUImageGridFilter.h
//  SimpleVideoFilter
//
//  Created by Erica on 2018/8/21.
//  Copyright © 2018年 Cell Phone. All rights reserved.
//
#import "GPUImageFilter.h"

@interface GPUImageGridFilter : GPUImageFilter
{
    GLint lengthUniform;
}

// length x length 网格滤镜，边长
@property(readwrite, nonatomic) NSInteger length;


@end
