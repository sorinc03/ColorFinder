//
//  MyView.m
//  ColorCodeGen
//
//  Created by Sorin Cioban on 20/04/2013.
//  Copyright (c) 2013 Sorin Cioban. All rights reserved.
//

#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@interface MyView () <UIGestureRecognizerDelegate>

@property (strong) UIView *colorView;
@property (strong) UILabel *redLabel, *blueLabel, *greenLabel, *alphaLabel;

@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        self.testColor = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 250)];
        self.testColor.image = image;
        self.testColor.contentMode = UIViewContentModeScaleAspectFit;
        [self.testColor setUserInteractionEnabled:YES];
        
        self.redLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 200, 15)];
        self.blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 380, 200, 15)];
        self.greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 400, 200, 15)];
        self.alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 420, 200, 15)];
        
        [self addSubview:self.redLabel];
        [self addSubview:self.greenLabel];
        [self addSubview:self.blueLabel];
        [self addSubview:self.alphaLabel];
        [self addSubview:self.colorView];
        [self addSubview:self.testColor];
        
        [self addGestureRec];
    }
    
    
    return self;
}

- (void)addGestureRec {
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    
    [self.testColor addGestureRecognizer:pinch];
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
    static CGRect initialBounds;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = self.testColor.bounds;
    }
    CGFloat factor = [(UIPinchGestureRecognizer *)recognizer scale];
    
    CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
    self.testColor.bounds = CGRectApplyAffineTransform(initialBounds, zt);
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }

    return self;
}

UIImage *image;
UIImage *croppedImage;
CGImageRef imageRef;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self];
        
        UIGraphicsBeginImageContext(self.bounds.size);
        [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        CGRect contentRectToCrop = CGRectMake(location.x, location.y+64, 1, 1);
        imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
        croppedImage = [UIImage imageWithCGImage:imageRef];
        UIGraphicsEndImageContext();
        //UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
        [self getRGBAsFromImage:croppedImage atX:0 andY:0];
        CGImageRelease(imageRef);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self];
        
        UIGraphicsBeginImageContext(self.bounds.size);
        [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        CGRect contentRectToCrop = CGRectMake(location.x, location.y+64, 1, 1);
        imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
        croppedImage = [UIImage imageWithCGImage:imageRef];
        UIGraphicsEndImageContext();
        //UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
        [self getRGBAsFromImage:croppedImage atX:0 andY:0];
        CGImageRelease(imageRef);
    }}

-(void)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy
{
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    byteIndex += 4;
    
    self.colorView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    NSLog(@"the vale of the rbg of red is %f, green %f, blue %f",red*255, green*255, blue*255);
    
    self.redLabel.text = [NSString stringWithFormat:@"%.f", red*255];
    self.greenLabel.text = [NSString stringWithFormat:@"%.f", green*255];
    self.blueLabel.text = [NSString stringWithFormat:@"%.f", blue*255];
    self.alphaLabel.text = [NSString stringWithFormat:@"%.f", alpha];
    
    free(rawData);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
