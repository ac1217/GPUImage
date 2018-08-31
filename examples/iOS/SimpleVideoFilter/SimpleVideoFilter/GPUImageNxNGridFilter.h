//
//  MYFilter.h
//  LearnOpenGLESWithGPUImage
//
//  Created by 陈希哲 on 2018/8/24.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import <GPUImage/GPUImageFramework.h>

@interface GPUImageNxNGridFilter : GPUImageFilter
@property(nonatomic,assign)float step;
-(instancetype)initWithGridX:(NSInteger)x y:(NSInteger)y;
-(void)setGridX:(NSInteger)x y:(NSInteger)y count:(NSInteger)count alpha:(float)alpha;
@end
