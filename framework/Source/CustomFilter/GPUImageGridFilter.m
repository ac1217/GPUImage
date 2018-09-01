//
//  GPUImageGridFilter.m
//  SimpleVideoFilter
//
//  Created by Erica on 2018/8/21.
//  Copyright © 2018年 Cell Phone. All rights reserved.
//

#import "GPUImageGridFilter.h"
NSString *const kGPUImageGridFragmentShaderString = SHADER_STRING
(
 
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform vec2 size;
 
 uniform float transition;
 
 void main()
 {
     
     
      float p = 1.0/(size.x * size.y);
      float n = floor(transition/p + 1.0);
     float n1 = float(n-1.0);
      float alpha = (transition-n1*p) / p;
                  
     float xcount = size.x;
     float ycount = size.y;
     
     
     float x = mod(textureCoordinate.x,(1.0/xcount));
     float y = mod(textureCoordinate.y,(1.0/ycount));
     vec2 newCorrdinate = vec2(x*xcount,y*ycount);
     vec4 color = texture2D(inputImageTexture, textureCoordinate);
     if(n<=xcount){
         if(textureCoordinate.x<=(n/xcount)&&textureCoordinate.y<=(1.0/ycount)){
             vec4 c = texture2D(inputImageTexture, newCorrdinate);
             if(textureCoordinate.x<=(n/xcount)&&textureCoordinate.x>=((n-1.0)/xcount)){
                 gl_FragColor = vec4(c.rgb*alpha+color.rgb*(1.0-alpha),1.0);
             }else gl_FragColor = c;
             
         }
         else gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }else{
         int fy = int(n/xcount);
         int fx = int(mod(n,xcount));
         if(fx==0){
             fx= int(xcount);
         }else fy=fy+1;
         if((textureCoordinate.x<=(float(fx)/xcount)&&textureCoordinate.y<=(float(fy)/ycount)&&textureCoordinate.y>(float(fy-1)/ycount))||(textureCoordinate.y<=(float(fy-1)/ycount))){
             vec4 c = texture2D(inputImageTexture, newCorrdinate);
             if((textureCoordinate.y>(float(fy-1)/ycount))&&(textureCoordinate.x<=(float(fx)/xcount)&&textureCoordinate.x>=(float((fx-1))/xcount))){
                 gl_FragColor = vec4(c.rgb*alpha+color.rgb*(1.0-alpha),1.0);
             }else gl_FragColor = c;
             
         }
         else gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
     
     
     
 }
 );

     
     
@interface GPUImageGridFilter()

@end

@implementation GPUImageGridFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageGridFragmentShaderString];
    if (self) {
        
        sizeUniform = [filterProgram uniformIndex:@"size"];
        transitionUniform = [filterProgram uniformIndex:@"transition"];
        self.length = 2;
        self.transition = 1;
    }
    return self;
}

- (void)setLength:(NSInteger)length;
{
    _length = length;
    
    self.size = CGSizeMake(_length, _length);
}

- (void)setSize:(CGSize)size
{
    _size = size;
    [self setSize:size forUniform:sizeUniform program:filterProgram];
    
}

- (void)setTransition:(float)transition
{
    _transition = transition;
    
    [self setFloat:transition forUniform:transitionUniform program:filterProgram];
    
}

@end
