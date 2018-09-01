//
//  GPUImageAstralProjectionFilter.m
//  GPUImage
//
//  Created by Erica on 2018/9/1.
//  Copyright © 2018年 Brad Larson. All rights reserved.
//

#import "GPUImageAstralProjectionFilter.h"

NSString *const kGPUImageAstralProjectionFragmentShaderString =  SHADER_STRING
(
 
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform float transition;
 
 void main()
 {
     
//     float t = transition + 1.0;
//
//     float x = textureCoordinate.x;
//     float y = textureCoordinate.y;
//
//     float k = 0.25*transition;
//
//     float fx = k * (x + 1.0);
//     float fy = k * (y + 1.0);
//
//     vec2 fCoordinate = vec2(fx,fy);
     vec2 fCoordinate = textureCoordinate.xy / (transition + 1.0);
     
     
     vec4 color = texture2D(inputImageTexture, textureCoordinate);
     vec4 fcolor = texture2D(inputImageTexture, fCoordinate);
     
     float alpha = transition;
     
     gl_FragColor = vec4(color.rgb*alpha+fcolor.rgb*(1.0-alpha),1.0);
     
 }
 );


@implementation GPUImageAstralProjectionFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageAstralProjectionFragmentShaderString];
    if (self) {
        
        transitionUniform = [filterProgram uniformIndex:@"transition"];
        
        self.transition = 1;
    }
    return self;
}

- (void)setTransition:(float)transition
{
    _transition = transition;
    
    [self setFloat:transition forUniform:transitionUniform program:filterProgram];
    
}

@end
