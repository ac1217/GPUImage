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
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float length;
 
 void main()
 {
     
     
     lowp float pre = 1.0 / length;
     
     lowp float mx = mod(textureCoordinate.x, pre);
     lowp float my = mod(textureCoordinate.y, pre);
     
     
     
     
     gl_FragColor = texture2D(inputImageTexture, vec2(mx, my)*length);
 }
 );
@interface GPUImageGridFilter()

@end

@implementation GPUImageGridFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageGridFragmentShaderString];
    if (self) {
        
        lengthUniform = [filterProgram uniformIndex:@"length"];
        self.length = 2;
    }
    return self;
}

- (void)setLength:(NSInteger)length;
{
    _length = length;
    
    [self setFloat:(float)_length forUniform:lengthUniform program:filterProgram];
}
@end
