//
//  GPUImageTranslationFilter.m
//  KGSVideoUtil
//
//  Created by Erica on 2018/10/25.
//  Copyright © 2018 Erica. All rights reserved.
//

#import "GPUImageTranslationFilter.h"

NSString *const kGPUImageTranslationFragmentShaderString =  SHADER_STRING
(

 precision highp float;

 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;

 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;

 uniform lowp float direction;
 uniform lowp float ratio;
 
 void main()
 {

     if(direction==0.0){
         
         if(textureCoordinate.x > 1.0-ratio) {
             
             vec2 newCorrdinate2 = vec2(textureCoordinate2.x - 1.0 + ratio
                                        ,textureCoordinate2.y);
             vec4 color2 = texture2D(inputImageTexture2, newCorrdinate2);
             
             gl_FragColor = color2;
             
         }else {
             
             vec2 newCorrdinate = vec2(textureCoordinate.x + ratio
                                        ,textureCoordinate.y);
             
             vec4 color = texture2D(inputImageTexture, newCorrdinate);
             gl_FragColor = color;
         }
         
     }else if(direction==1.0){
         
         if(textureCoordinate.x < ratio) {
             
             vec2 newCorrdinate2 = vec2(1.0 - ratio + textureCoordinate2.x
                                        ,textureCoordinate2.y);
             vec4 color2 = texture2D(inputImageTexture2, newCorrdinate2);
             
             gl_FragColor = color2;
             
         }else {
             
             vec2 newCorrdinate = vec2(textureCoordinate.x - ratio
                                       ,textureCoordinate.y);
             
             vec4 color = texture2D(inputImageTexture, newCorrdinate);
             gl_FragColor = color;
         }
         
         
     }else if(direction==2.0){
         
       
         if(textureCoordinate.y > 1.0-ratio) {
             
             vec2 newCorrdinate2 = vec2(textureCoordinate2.x
                                        ,textureCoordinate2.y - 1.0 + ratio);
             vec4 color2 = texture2D(inputImageTexture2, newCorrdinate2);
             
             gl_FragColor = color2;
             
         }else {
             
             vec2 newCorrdinate = vec2(textureCoordinate.x
                                       ,textureCoordinate.y + ratio);
             
             vec4 color = texture2D(inputImageTexture, newCorrdinate);
             gl_FragColor = color;
         }
         
         
     }else if (direction==3.0){
         
       
         if(textureCoordinate.y < ratio) {
             
             vec2 newCorrdinate2 = vec2(textureCoordinate2.x
                                        ,1.0 - ratio + textureCoordinate2.y);
             vec4 color2 = texture2D(inputImageTexture2, newCorrdinate2);
             
             gl_FragColor = color2;
             
         }else {
             
             vec2 newCorrdinate = vec2(textureCoordinate.x
                                       ,textureCoordinate.y - ratio);
             
             vec4 color = texture2D(inputImageTexture, newCorrdinate);
             gl_FragColor = color;
         }
         
     }
 }
 );


@implementation GPUImageTranslationFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageTranslationFragmentShaderString];
    if (self) {

        directionUniform = [filterProgram uniformIndex:@"direction"];
        ratioUniform = [filterProgram uniformIndex:@"ratio"];

        self.direction = 0;
        self.ratio = 0.5;
    }
    return self;
}


- (void)setDirection:(GPUImageTranslationDirection)direction
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

