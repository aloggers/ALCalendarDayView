#import "ALCalendarTileView.h"
#import "ALCalendarEvent.h"


@implementation ALCalendarTileView {

@private
    ALCalendarEvent* _event;
}
@synthesize event = _event;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }

    return self;
}

- (void)layoutSubviews {
    if (self.event.color) {
        self.backgroundColor = self.event.color;
    }
    else {
        self.backgroundColor = [UIColor darkGrayColor];
    }
}

@end