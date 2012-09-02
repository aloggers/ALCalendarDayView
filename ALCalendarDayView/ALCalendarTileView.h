#import <UIKit/UIKit.h>

@class ALCalendarEvent;

@interface ALCalendarTileView : UIView
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* descriptionLabel;
@property (nonatomic, strong) ALCalendarEvent* event;
@end