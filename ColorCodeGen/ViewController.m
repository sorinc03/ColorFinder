//
//  ViewController.m
//  ColorCodeGen
//
//  Created by Sorin Cioban on 30/03/2013.
//  Copyright (c) 2013 Sorin Cioban. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"


@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong) UIView *testRedView;
@property (strong) UIView *testGreenView;
@property (strong) UIView *testBlueView;
@property (strong) UIView *resultRedView;
@property (strong) UIView *resultGreenView;
@property (strong) UIView *resultBlueView;
@property (strong) UIView *colorView;
@property (strong) UIImageView *imageView;
@property (strong) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.testRedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 290)];
    self.testRedView.backgroundColor = [UIColor redColor];
    
    self.testGreenView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 90, 290)];
    self.testGreenView.backgroundColor = [UIColor greenColor];
    
    self.testBlueView = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 90, 290)];
    self.testBlueView.backgroundColor = [UIColor blueColor];
    
    //[self.view addSubview:self.testRedView];
    //[self.view addSubview:self.testGreenView];
    //[self.view addSubview:self.testBlueView];

    
    //[self.view addSubview:[[MyView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCamera:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [picker setAllowsEditing:YES];
    
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self.navigationController presentViewController:picker animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        MyView *view = [[MyView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) andImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self.view addSubview:view];
        /*self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-164)];
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-150, 320, 150)];
        [self.imageView setUserInteractionEnabled:YES];
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.imageView.image = self.image;
        
        [self.view addSubview:self.imageView];
        [self.view addSubview:self.colorView];*/
    }];
    
}

@end
