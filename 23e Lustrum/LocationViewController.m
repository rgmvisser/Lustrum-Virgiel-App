//
//  LocationViewController.m
//  23e Lustrum
//
//  Created by Ruud Visser on 2/17/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "LocationViewController.h"
#define ZOOM_STEP 1.5

@interface LocationViewController (UtilityMethods) <UIScrollViewDelegate>
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation LocationViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.scrollView.bouncesZoom = YES;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = YES;
    self.image = [UIImage imageNamed:@"terrein.jpg"];
    if(self.image)
    {
        [self.imageView setImage:self.image];
    }
    self.imageView.userInteractionEnabled = YES;
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth );
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.contentSize = [self.imageView frame].size;
    
    // add gesture recognizers to the image view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    [self.imageView addGestureRecognizer:singleTap];
    [self.imageView addGestureRecognizer:doubleTap];
    [self.imageView addGestureRecognizer:twoFingerTap];
    
    
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = [self.scrollView frame].size.width  / [self.imageView frame].size.width;
    self.scrollView.maximumZoomScale = 8.0;
    self.scrollView.minimumZoomScale = minimumScale;
    self.scrollView.zoomScale = minimumScale;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
  	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
  	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    self.self.scrollView = nil;
    self.imageView = nil;
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // zoom in
    float newScale = [self.scrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [self.scrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the self.scrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollView frame].size.height / scale;
    zoomRect.size.width  = [self.scrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end
