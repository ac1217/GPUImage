//
//  GPUImageSplitScreenFilter.m
//  GPUImage
//
//  Created by Erica on 2018/8/31.
//  Copyright © 2018年 Brad Larson. All rights reserved.
//

#import "GPUImageSplitScreenFilter.h"

NSString *const kGPUImageSplitScreenFragmentShaderString =  SHADER_STRING
(
 
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform lowp float direction;
 uniform lowp float ratio;
 
 void main()
 {
     
     if(direction==0.0){
         if(textureCoordinate.x<ratio){
             vec2 newCorrdinate = vec2((1.0-ratio)/2.0+textureCoordinate.x
                                       ,textureCoordinate.y);
             gl_FragColor = texture2D(inputImageTexture, newCorrdinate);
         }else{
             vec2 newCorrdinate = vec2(ratio/2.0+(textureCoordinate.x-ratio),textureCoordinate.y);
             gl_FragColor = texture2D(inputImageTexture, newCorrdinate);
         }
         
     }else{
         if(textureCoordinate.y<ratio){
             vec2 newCorrdinate = vec2(textureCoordinate.x,(1.0-ratio)/2.0+textureCoordinate.y);
             gl_FragColor = texture2D(inputImageTexture, newCorrdinate);
         }else{
             vec2 newCorrdinate = vec2(textureCoordinate.x,ratio/2.0+(textureCoordinate.y-ratio));
             gl_FragColor = texture2D(inputImageTexture, newCorrdinate);
         }
     }
 }
 );


@implementation GPUImageSplitScreenFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageSplitScreenFragmentShaderString];
    if (self) {
        directionUniform = [filterProgram uniformIndex:@"direction"];
        ratioUniform = [filterProgram uniformIndex:@"ratio"];
        self.direction = 0;
        self.ratio = 0.5;
    }
    return self;
}


- (void)setDirection:(GPUImageSplitScreenDirection)direction
{
    _direction = direction;
    
    [self setFloat:(float)_direction forUniform:directionUniform program:filterProgram];
}
- (void)setRatio:(CGFloat)ratio
{
    _ratio = ratio;
    
    [self setFloat:(float)_ratio forUniform:ratioUniform program:filterProgram];
}

@end
