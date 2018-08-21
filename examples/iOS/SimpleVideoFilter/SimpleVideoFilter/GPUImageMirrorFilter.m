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
 
 
 void main()
 {
     if(textureCoordinate.x < 0.5 && textureCoordinate.y < 0.5) {
         
         gl_FragColor = texture2D(inputImageTexture, vec2(textureCoordinate.x, textureCoordinate.y)*2.0);
         
     }else if (textureCoordinate.x > 0.5 && textureCoordinate.y < 0.5) {
         
         
         gl_FragColor = texture2D(inputImageTexture, vec2(1.0 - textureCoordinate.x, textureCoordinate.y)*2.0);
         
     }else if (textureCoordinate.x < 0.5 && textureCoordinate.y > 0.5) {
         
         gl_FragColor = texture2D(inputImageTexture, vec2(textureCoordinate.x, 1.0 - textureCoordinate.y)*2.0);
     }else if (textureCoordinate.x > 0.5 && textureCoordinate.y > 0.5) {
         
         gl_FragColor = texture2D(inputImageTexture, vec2(1.0 - textureCoordinate.x, 1.0 - textureCoordinate.y)*2.0);
     }
     
 }
 );
@implementation GPUImageMirrorFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageMirrorFragmentShaderString];
    if (self) {
        
    }
    return self;
}
@end
