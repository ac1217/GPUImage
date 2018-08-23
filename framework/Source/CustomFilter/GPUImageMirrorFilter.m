//
//  GPUImageMirrorFilter.m
//  SimpleVideoFilter
//
//  Created by Erica on 2018/8/21.
//  Copyright © 2018年 Cell Phone. All rights reserved.
//

#import "GPUImageMirrorFilter.h"

NSString *const kGPUImageMirrorFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform lowp float style;
 
 void main()
 {
     if(style == 4.0) {
         if(textureCoordinate.x < 0.5 && textureCoordinate.y < 0.5) {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(textureCoordinate.x, textureCoordinate.y)*2.0);
             
         }else if (textureCoordinate.x > 0.5 && textureCoordinate.y < 0.5) {
             
             
             gl_FragColor = texture2D(inputImageTexture, vec2(1.0 - textureCoordinate.x, textureCoordinate.y)*2.0);
             
         }else if (textureCoordinate.x < 0.5 && textureCoordinate.y > 0.5) {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(textureCoordinate.x, 1.0 - textureCoordinate.y)*2.0);
         }else if (textureCoordinate.x > 0.5 && textureCoordinate.y > 0.5) {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(1.0 - textureCoordinate.x, 1.0 - textureCoordinate.y)*2.0);
         }
         
     }else if (style == 0.0) {
         
         lowp float my = mod(textureCoordinate.y, 0.5);
         
         if(textureCoordinate.y > 0.5) {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(textureCoordinate.x, 1.0 - my - 0.25));
         }else {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(textureCoordinate.x, my + 0.25));
         }
         
       
         
     }else if (style == 1.0) {
         
         lowp float my = mod(textureCoordinate.y, 0.5);
         
         if(textureCoordinate.y > 0.5) {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(1.0 - textureCoordinate.x, 1.0 - my - 0.25));
         }else {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(textureCoordinate.x, my + 0.25));
         }
         
     }else if (style == 2.0) {
         
         lowp float mx = mod(textureCoordinate.x, 0.5);
         
         if(textureCoordinate.x > 0.5) {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(1.0 - mx - 0.25, textureCoordinate.y));
             
         }else {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(mx + 0.25, textureCoordinate.y));
         }
         
     }else if (style == 3.0) {
         
         lowp float mx = mod(textureCoordinate.x, 0.5);
         
         if(textureCoordinate.x > 0.5) {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(1.0 - mx - 0.25, 1.0 - textureCoordinate.y));
             
         }else {
             
             gl_FragColor = texture2D(inputImageTexture, vec2(mx + 0.25, textureCoordinate.y));
         }
         
     }
     
     
     
 }
 );
@implementation GPUImageMirrorFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageMirrorFragmentShaderString];
    if (self) {
        styleUniform = [filterProgram uniformIndex:@"style"];
        self.style = 0;
    }
    return self;
}


- (void)setStyle:(GPUImageMirrorStyle)style;
{
    _style = style;
    
    [self setFloat:(float)_style forUniform:styleUniform program:filterProgram];
}

@end
