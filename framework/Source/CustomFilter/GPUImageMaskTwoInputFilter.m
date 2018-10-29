//
//  GPUImageMaskTwoInputFilter.m
//  KGSVideoUtil
//
//  Created by 陈希哲 on 2018/9/10.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "GPUImageMaskTwoInputFilter.h"

NSString *const kGPUImageMaskTwoFragmentShaderString =  SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 
 void main()
 {
     vec4 c = texture2D(inputImageTexture, textureCoordinate);
     vec4 c1 = texture2D(inputImageTexture2, textureCoordinate2);
     float a = 0.114*c1.b+ 0.299*c1.r+ 0.587*c1.g;
     gl_FragColor = vec4(c.rgb*(1.0-a)+c1.rgb*(a),1.0);
 }
 );

@implementation GPUImageMaskTwoInputFilter

-(instancetype)init{
    
    self = [super initWithFragmentShaderFromString:kGPUImageMaskTwoFragmentShaderString];
    if (self) {
      
    }
    return self;
}
@end
