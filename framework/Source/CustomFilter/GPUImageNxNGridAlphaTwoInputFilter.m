//
//  GPUImageNxNGridAlphaTwoInputFilter.m
//  KGSVideoUtilDemo
//
//  Created by 陈希哲 on 2018/9/12.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "GPUImageNxNGridAlphaTwoInputFilter.h"

NSString *const kGPUImageNxNGridAlphaTwoFragmentShaderString =  SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float xcount;
 uniform float ycount;
 uniform float alpha;
 uniform int isfirst;
 
 void main()
 {
     if(isfirst==1){
         float x = mod(textureCoordinate.x,(1.0/xcount));
         float y = mod(textureCoordinate.y,(1.0/ycount));
         vec2 newCorrdinate = vec2(x*xcount,y*ycount);
         vec4 c = texture2D(inputImageTexture, newCorrdinate);
         vec4 c1 = texture2D(inputImageTexture, textureCoordinate);
         gl_FragColor = vec4(c.rgb*(1.0-alpha)+c1.rgb*alpha,1.0);
     }else{
         float x = mod(textureCoordinate2.x,(1.0/xcount));
         float y = mod(textureCoordinate2.y,(1.0/ycount));
         vec2 newCorrdinate = vec2(x*xcount,y*ycount);
         vec4 c = texture2D(inputImageTexture2, newCorrdinate);
         vec4 c1 = texture2D(inputImageTexture2, textureCoordinate);
         gl_FragColor = vec4(c.rgb*(1.0-alpha)+c1.rgb*alpha,1.0);
     }
 }
 );
@implementation GPUImageNxNGridAlphaTwoInputFilter
{
    GLuint xcount;
    GLuint ycount;
    GLuint isfirst;
    GLuint alpha;
    NSInteger xCount;
    NSInteger yCount;
    BOOL isFirst;
}
-(instancetype)initWithGridX:(NSInteger)x y:(NSInteger)y isFirst:(BOOL)first{
    
    self = [super initWithFragmentShaderFromString:kGPUImageNxNGridAlphaTwoFragmentShaderString];
    if (self) {
        xcount = [filterProgram uniformIndex:@"xcount"];
        ycount = [filterProgram uniformIndex:@"ycount"];
        isfirst = [filterProgram uniformIndex:@"isfirst"];
        alpha = [filterProgram uniformIndex:@"alpha"];
        xCount = x;
        yCount = y;
        isFirst = first;
    }
    return self;
    
}

-(void)setGridX:(NSInteger)x y:(NSInteger)y isFirst:(BOOL)isFirst alpha:(float)a{
    
    
    [self setFloat:(GLfloat)x forUniform:xcount program:filterProgram];
    [self setFloat:(GLfloat)y forUniform:ycount program:filterProgram];
    isFirst?[self setInteger:1 forUniform:isfirst program:filterProgram]:[self setInteger:0 forUniform:isfirst program:filterProgram];
    [self setFloat:(GLfloat)a forUniform:alpha program:filterProgram];
    
}

-(void)setStep:(float)step{
    
    _step = step;
    [self setGridX:xCount y:yCount isFirst:isFirst alpha:step];
}

@end
