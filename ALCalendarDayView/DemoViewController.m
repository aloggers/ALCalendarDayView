#import "DemoViewController.h"
#import "DefaultStylesViewController.h"
#import "CustomTileViewController.h"

@interface DemoViewController ()
@end

@implementation DemoViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
    }
    if (indexPath.row == 0) {
        tableViewCell.textLabel.text = @"Default styles";
    }
    else if (indexPath.row == 1) {
        tableViewCell.textLabel.text = @"Custom tiles";
    }
    else if (indexPath.row == 2) {
        tableViewCell.textLabel.text = @"More customizations";
    }
    else if (indexPath.row == 3) {
        tableViewCell.textLabel.text = @"2 days and more";
    }
    return tableViewCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0) {
        DefaultStylesViewController* defaultStylesViewController = [[DefaultStylesViewController alloc] init];
        [self.navigationController pushViewController:defaultStylesViewController animated:YES];
    }
    else if (indexPath.row == 1) {
        CustomTileViewController* customTileViewController = [[CustomTileViewController alloc] init];
        [self.navigationController pushViewController:customTileViewController animated:YES];
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Not implemented" message:@"Planned but not implemented" delegate:nil
                                                  cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertView show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


@end