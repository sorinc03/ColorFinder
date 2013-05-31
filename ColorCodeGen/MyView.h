//
//  MyView.h
//  ColorCodeGen
//
//  Created by Sorin Cioban on 20/04/2013.
//  Copyright (c) 2013 Sorin Cioban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIView

@property (strong) UIImageView *testColor;
- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

@end
