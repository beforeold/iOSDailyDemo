//
//  ViewController.m
//  TestTableViewGrow
//
//  Created by dinglan on 2020/12/15.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

static NSInteger const count = 5;
static CGFloat const rowHeight = 44;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    __auto_type tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.expanded ? rowHeight : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __auto_type cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"...%ld", (long)indexPath.row];
    
    return cell;
}

- (IBAction)onRefreshClick:(id)sender {
    self.expanded = !self.expanded;
    
    CGFloat height = self.expanded ? count * rowHeight : 0;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, 64, UIScreen.mainScreen.bounds.size.width, height);
        self.tableView.frame = frame;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
}

@end
