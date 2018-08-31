//
//  MYFilter.m
//  LearnOpenGLESWithGPUImage
//
//  Created by 陈希哲 on 2018/8/24.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import "GPUImageNxNGridFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageNxNGridFragmentShaderString =  SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform float xcount;
 uniform float ycount;
 uniform float n;
 void main()
 {
     
     float x = mod(textureCoordinate.x,(1.0/xcount));
     float y = mod(textureCoordinate.y,(1.0/ycount));
     vec2 newCorrdinate = vec2(x*xcount,y*ycount);
     vec4 c = texture2D(inputImageTexture, textureCoordinate);
     if(n<=xcount){
         if(textureCoordinate.x<=(n/xcount)&&textureCoordinate.y<=(1.0/ycount)){
             vec4 color = texture2D(inputImageTexture, newCorrdinate);
             gl_FragColor = vec4(color.rgb*0.5+c.rgb*0.5,1.0);}
         else gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }else{
         int fy = int(n/xcount);
         int fx = int(mod(n,xcount));
         if(fx==0){
            fx= int(xcount);
         }else fy=fy+1;
         if((textureCoordinate.x<=(float(fx)/xcount)&&textureCoordinate.y<=(float(fy)/ycount)&&textureCoordinate.y>(float(fy-1)/ycount))||(textureCoordinate.y<=(float(fy-1)/ycount))){
             vec4 color = texture2D(inputImageTexture, newCorrdinate);
             gl_FragColor = vec4(color.rgb*0.5+c.rgb*0.5,1);}
         else gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
    
 }
 );
#else
NSString *const kGPUImageNxNGridFragmentShaderString =  SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform float xcount;
 uniform float ycount;
 uniform float n;
 void main()
 {
     
     float x = mod(textureCoordinate.x,(1.0/xcount));
     float y = mod(textureCoordinate.y,(1.0/ycount));
     vec2 newCorrdinate = vec2(x*xcount,y*ycount);
     if(n<=xcount){
         if(textureCoordinate.x<=(n/xcount)&&textureCoordinate.y<=(1.0/ycount))
             vec4 color = texture2D(inputImageTexture, newCorrdinate);
         
         gl_FragColor = vec4(1.0,0.0,0.0,0.5);
         else gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }else{
         int fy = int(n/xcount);
         int fx = int(mod(n,xcount));
         if(fx==0){
             fx= int(xcount);
         }else fy=fy+1;
         if((textureCoordinate.x<=(float(fx)/xcount)&&textureCoordinate.y<=(float(fy)/ycount)&&textureCoordinate.y>(float(fy-1)/ycount))||(textureCoordinate.y<=(float(fy-1)/ycount))) vec4 color = texture2D(inputImageTexture, newCorrdinate);
         gl_FragColor = vec4(1.0,0.0,0.0,0.5);
         else gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
     
 }
 );
#endif


@implementation GPUImageNxNGridFilter
{
    GLuint xcount;
    GLuint ycount;
    GLuint n;
    NSInteger xCount;
    NSInteger yCount;
}
-(instancetype)initWithGridX:(NSInteger)x y:(NSInteger)y{
    
    self = [super initWithFragmentShaderFromString:kGPUImageNxNGridFragmentShaderString];
    if (self) {
        [self setGridX:x y:y count:0];
        xCount = x;
        yCount = y;
    }
    return self;
}

//- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates
//{
//    glEnable(GL_DEPTH_TEST);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//    [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
//}


-(void)setGridX:(NSInteger)x y:(NSInteger)y count:(NSInteger)count{
    
    xcount = [filterProgram uniformIndex:@"xcount"];
    ycount = [filterProgram uniformIndex:@"ycount"];
    n = [filterProgram uniformIndex:@"n"];
    [self setFloat:(GLfloat)x forUniform:xcount program:filterProgram];
    [self setFloat:(GLfloat)y forUniform:ycount program:filterProgram];
    [self setFloat:(GLfloat)count forUniform:n program:filterProgram];
}

-(void)setStep:(float)step{
    
    _step = step;
    
    float t  = 1.0/(xCount*yCount);
    NSInteger n = step/t + 1;
    
    [self setGridX:xCount y:yCount count:n];
    
}
@end
