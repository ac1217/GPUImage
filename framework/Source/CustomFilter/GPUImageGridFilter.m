//
//  GPUImageGridFilter.m
//  SimpleVideoFilter
//
//  Created by Erica on 2018/8/21.
//  Copyright © 2018年 Cell Phone. All rights reserved.
//

#import "GPUImageGridFilter.h"
NSString *const kGPUImageGridFragmentShaderString = SHADER_STRING
(
 
 precision highp float;
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform vec2 size;
 
 void main()
 {
     
     
     lowp float preX = 1.0 / size.x;
     lowp float preY = 1.0 / size.y;
     
     lowp float mx = mod(textureCoordinate.x, preX);
     lowp float my = mod(textureCoordinate.y, preY);
     
     gl_FragColor = texture2D(inputImageTexture, vec2(mx * size.x, my * size.y));
     
 }
 );
@interface GPUImageGridFilter()

@end

@implementation GPUImageGridFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageGridFragmentShaderString];
    if (self) {
        
        sizeUniform = [filterProgram uniformIndex:@"size"];
        self.length = 2;
    }
    return self;
}

- (void)setLength:(NSInteger)length;
{
    _length = length;
    
    self.size = CGSizeMake(_length, _length);
}

- (void)setSize:(CGSize)size
{
    _size = size;
    [self setSize:size forUniform:sizeUniform program:filterProgram];
    
}

@end
