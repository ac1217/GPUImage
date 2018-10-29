//
//  GPUImage4x4Filter.m
//  KGSVideoUtilDemo
//
//  Created by 陈希哲 on 2018/9/11.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "GPUImage4x4Filter.h"

NSString *const kGPUImage4x4GridFragmentShaderString =  SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float xcount;
 uniform float ycount;
 uniform float array[4];
 uniform float alpha;
 uniform int n;
 uniform int reverse;
 
 void main()
 {
     
     float x = mod(textureCoordinate.x,(1.0/xcount));
     float y = mod(textureCoordinate.y,(1.0/ycount));
     vec2 newCorrdinate = vec2(x*xcount,y*ycount);
     vec4 c = texture2D(inputImageTexture, newCorrdinate);
     vec4 c1 = texture2D(inputImageTexture2,textureCoordinate2);
     for(int i=0;i<n;i++){
         float a=array[i];
         int fy=int((a-1.0)/xcount)+1;
         int fx=int(mod(a+0.1,xcount));
         if(fx==0) fx=int(xcount);
         if(textureCoordinate.x>=(float(fx-1))*(1.0/xcount)&&textureCoordinate.x<=float(fx)*(1.0/xcount)&&textureCoordinate.y>=(float(fy-1))*(1.0/ycount)&&textureCoordinate.y<=float(fy)*(1.0/ycount)){
             if(reverse==0){
                 if(i==(n-1)) gl_FragColor = vec4(c.rgb*alpha+c1.rgb*(1.0-alpha),1.0);
                 else gl_FragColor = c;
             }else{
                 if(i==0) gl_FragColor = vec4(c.rgb*(1.0-alpha)+c1.rgb*(alpha),1.0);
                 else gl_FragColor = c;
             }
            
             break;
         }else{
             gl_FragColor = c1;
         }
     }
 }
 );

@implementation GPUImage4x4Filter
{
    GLuint a;
    GLuint xcount;
    GLuint ycount;
    GLuint n;
    GLuint reverse;
    GLuint array;
    NSInteger length;
    NSInteger xCount;
    NSInteger yCount;
    float alpha;
    
    
}

-(instancetype)init{
    
    self = [super initWithFragmentShaderFromString:kGPUImage4x4GridFragmentShaderString];
    if (self) {
        a = [filterProgram uniformIndex:@"alpha"];
        n = [filterProgram uniformIndex:@"n"];
        xcount = [filterProgram uniformIndex:@"xcount"];
        ycount = [filterProgram uniformIndex:@"ycount"];
        array = [filterProgram uniformIndex:@"array"];
        reverse = [filterProgram uniformIndex:@"reverse"];
        xCount = 2;
        yCount = 2;
    }
    return self;
}

-(void)setUniforms:(NSInteger)r{
    
    [self setFloat:xCount forUniform:xcount program:filterProgram];
    [self setFloat:yCount forUniform:ycount program:filterProgram];
    [self setFloat:(GLfloat)alpha forUniform:a program:filterProgram];
    [self setInteger:(GLint)length forUniform:n program:filterProgram];
    [self setInteger:(GLint)r forUniform:reverse program:filterProgram];
}

-(void)setStep:(float)step{
    
    _step = step;
    NSTimeInterval p = 0.5/(xCount*yCount);
    NSInteger n = _step<0.5 ? _step/p + 1:(1.0-_step)/p + 1;
    alpha = _step<0.5?(_step-(n-1)*p)/p:((_step-0.5)-(xCount*yCount-n-1)*p)/p - 1.0;
    length = n;
    switch (self.style) {
        case GPUImage4x4FliterStyle1:
        {
            _step<0.5?[self processStyle1:n]:[self processStyle2:n];
        }
           
            break;
     
        default:
            break;
    }
}

-(void)processStyle1:(NSInteger)n{
    
    [self setUniforms:0];
    switch (n) {
        case 1:
        {
            GLfloat a[4] = {1};
            [self setFloatArray:a length:4 forUniform:array program:filterProgram];
        }
            break;
        case 2:
        {
            GLfloat a[4] = {1,2};
            [self setFloatArray:a length:4 forUniform:array program:filterProgram];
        }
            break;
        case 3:
        {
            GLfloat a[4] = {1,2,4};
            [self setFloatArray:a length:4 forUniform:array program:filterProgram];
        }
            break;
        case 4:
        {
            GLfloat a[4] = {1,2,4,3};
            [self setFloatArray:a length:4 forUniform:array program:filterProgram];
        }
            break;
        default:
            break;
    
    }
    
}

-(void)processStyle2:(NSInteger)n{
 
    [self setUniforms:1];
    switch (n) {
        case 1:
        {
            GLfloat a[4] = {3};
            [self setFloatArray:a length:4 forUniform:array program:filterProgram];
        }
            break;
        case 2:
        {
            GLfloat a[4] = {4,3};
            [self setFloatArray:a length:4 forUniform:array program:filterProgram];
        }
            break;
        case 3:
        {
            GLfloat a[4] = {2,4,3};
            [self setFloatArray:a length:4 forUniform:array program:filterProgram];
        }
            break;
        case 4:
        {
            GLfloat a[4] = {1,2,4,3};
            [self setFloatArray:a length:4 forUniform:array program:filterProgram];
        }
            break;
        default:
            break;
            
    }
    
}
@end
