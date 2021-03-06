//
//  MapBaseView.m
//  AdvancedMap.Objective-C
//
//  Created by Aare Undo on 15/09/2017.
//  Copyright © 2017 Nutiteq. All rights reserved.
//

#import "MapBaseView.h"

@implementation MapBaseView

- (id) init {
    self = [super init];
    
    self.banner = [[Banner alloc] init];
    [self addSubview:self.banner];
    
    self.mapView = [[NTMapView alloc] init];
    [[self.mapView getOptions] setZoomGestures:YES];
    [self addSubview:self.mapView];
    
    self.popup = [[SlideInPopup alloc] init];
    [self addSubview:self.popup];
    [self sendSubviewToBack:self.popup];
    
    self.buttons = [NSMutableArray array];
    
    self.bannerHeight = 45;
    self.bottomLabelHeight = 40;
    self.smallPadding = 5;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.mapView setFrame:self.bounds];
    [self.popup setFrame:self.bounds];
    
    int count = [self.buttons count];
    
    CGFloat buttonWidth = 60;
    CGFloat innerPadding = 25;
    
    CGFloat totalArea = buttonWidth * count + (innerPadding * (count - 1));
    
    CGFloat w = buttonWidth;
    CGFloat h = w;
    CGFloat y = [self frame].size.height - (_bottomLabelHeight + h + _smallPadding);
    CGFloat x = [self frame].size.width / 2 - totalArea / 2;
    
    for (int i = 0; i < [self.buttons count]; i++) {
        PopupButton *button = [self.buttons objectAtIndex:i];
        [button setFrame:CGRectMake(x, y, w, h)];
        
        x += w + innerPadding;
    }
    
    [_banner setFrame:CGRectMake(0, [Device trueY0], [self frame].size.width, _bannerHeight)];
}

- (void)addButton:(PopupButton *)button {
    [self.buttons addObject:button];
    [self addSubview:button];
}

- (void)addRecognizer:(UIViewController *)sender view:(UIView *)view action: (nullable SEL)action {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:sender action:action];
    [view addGestureRecognizer:recognizer];
}

- (void)removeRecognizerFrom:(UIView *)view {
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}

- (void)addBaseLayer: (NTCartoBaseMapStyle)style {
    NTCartoOnlineVectorTileLayer* layer = [[NTCartoOnlineVectorTileLayer alloc] initWithStyle:style];
    [[self.mapView getLayers] add:layer];
}

- (void)setContent: (UIView *)content {
    
    if (self.previousContentView != nil) {
        [self.previousContentView removeFromSuperview];
    }
    
    [self.popup.popup addSubview:content];
    
    CGFloat x = 0;
    CGFloat y = self.popup.popup.header.height;
    CGFloat w = [self.popup.popup frame].size.width;
    CGFloat h = [self.popup.popup frame].size.height - y;
    
    [content setFrame:CGRectMake(x, y, w, h)];
    
    self.previousContentView = content;
}

@end




