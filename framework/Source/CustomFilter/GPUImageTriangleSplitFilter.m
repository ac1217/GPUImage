//
//  GPUImageTriangleSplitFilter.m
//  LearnOpenGLESWithGPUImage
//
//  Created by 陈希哲 on 2018/9/1.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import "GPUImageTriangleSplitFilter.h"

NSString *const kGPUImageTriangleSplitFragmentShaderString =  SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform float split;
 uniform int type;
 
 void main()
 {
     vec4 c = texture2D(inputImageTexture, textureCoordinate);
     vec4 c1 = texture2D(inputImageTexture2, textureCoordinate2);
     if(type==0){
         
         if((textureCoordinate.x + textureCoordinate.y <= split) || ((1.0 - textureCoordinate.x) + (1.0 - textureCoordinate.y) <= split)){
             gl_FragColor = vec4(c.rgb*split+c1.rgb*(1.0-split),1.0);
         }else  gl_FragColor = c1;
     }else{
         
         if(((1.0 - textureCoordinate.x) + textureCoordinate.y <= split) || (textureCoordinate.x + (1.0 - textureCoordinate.y) <= split)){
             gl_FragColor = vec4(c.rgb*split+c1.rgb*(1.0-split),1.0);
         }else  gl_FragColor = c1;
     }
 }
 );

@implementation GPUImageTriangleSplitFilter
{
    
    GLuint glSplit;
    GLuint glType;
    GLuint array;
}

-(instancetype)init{
    
    self = [super initWithFragmentShaderFromString:kGPUImageTriangleSplitFragmentShaderString];
    if (self) {
        glSplit = [filterProgram uniformIndex:@"split"];
        glType = [filterProgram uniformIndex:@"type"];
    }
    return self;
}

-(void)setSplitOffset:(CGFloat)offset type:(TriangleSplitFilterType)type{
    
    [self setFloat:(GLfloat)offset forUniform:glSplit program:filterProgram];
    [self setInteger:(GLint)type forUniform:glType program:filterProgram];
}

-(void)setStep:(float)step{
    
    _step = step;
    [self setSplitOffset:1-step type:self.type];
}
@end
