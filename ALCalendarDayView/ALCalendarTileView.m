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
        self.backgroundColor = [UIColor redColor];
    }

    return self;
}


@end