//
//  GPUImageTwoInputGridFilter.m
//  GPUImage
//
//  Created by Erica on 2018/8/29.
//  Copyright © 2018年 Brad Larson. All rights reserved.
//

#import "GPUImageTwoInputGridFilter.h"

NSString *const kGPUImageTwoInputGridFragmentShaderString = SHADER_STRING
(
 
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform vec2 size;
 uniform int invert;
 
 void main()
 {
     float xcount = size.x;
     float ycount = size.y;
     float x = mod(textureCoordinate.x,(1.0/xcount));
     float y = mod(textureCoordinate.y,(1.0/ycount));
     vec2 newCorrdinate = vec2(x*xcount,y*ycount);
     int fx = int(textureCoordinate.x/(1.0/xcount));
     int mx = int(mod(float(fx+1),2.0));
     int fy = int(textureCoordinate.y/(1.0/ycount));
     int my = int(mod(float(fy+1),2.0));
     if(invert==1){
         if(mx==0&&my==0) gl_FragColor = texture2D(inputImageTexture, newCorrdinate);
         else if(mx!=0&&my==0||mx==0&&my!=0) gl_FragColor = texture2D(inputImageTexture2, newCorrdinate);
         else gl_FragColor = texture2D(inputImageTexture, newCorrdinate);
     }else{
         if(mx==0&&my==0) gl_FragColor = texture2D(inputImageTexture2, newCorrdinate);
         else if(mx!=0&&my==0||mx==0&&my!=0) gl_FragColor = texture2D(inputImageTexture, newCorrdinate);
         else gl_FragColor = texture2D(inputImageTexture2, newCorrdinate);
     }
     
 }
 );
@interface GPUImageTwoInputGridFilter()

@end

@implementation GPUImageTwoInputGridFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageTwoInputGridFragmentShaderString];
    if (self) {
        
        sizeUniform = [filterProgram uniformIndex:@"size"];
        invertUniform = [filterProgram uniformIndex:@"invert"];
        self.length = 2;
        self.invert = YES;
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

- (void)setInvert:(BOOL)invert
{
    _invert = invert;
    
    [self setInteger:(_invert ? 1 : 0) forUniform:invertUniform program:filterProgram];
}

@end

