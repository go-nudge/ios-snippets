//
//  DatePicker.m
//  RiskEraser
//
//  Created by HSA on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NudgeDataPickerController.h"

#define ALL_SECTION     0
#define VALUES_SECTION  1

#define PICKERCELL_NOSUBTITLE   @"DPCell"
#define PICKERCELL_SUBTITLE     @"DPCellS"

@interface NudgeDataPickerController ()

@property (retain, nonatomic) NSMutableSet * mutableKeys;

@end

@implementation NudgeDataPickerController
@synthesize pickerTitle;

@synthesize values, selectedKeys, tag, pickerDelegate, selectAllTitle;

- (id)initController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        values = [NSMutableArray array];
        self.mutableKeys = [NSMutableSet set];
        self.selectAllTitle = NSLocalizedString(@"All elements", @"All elements");
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                          target:self 
                                                                                          action:@selector(dismissModalViewControllerAnimated:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(done)];
    
    self.navigationItem.title = self.pickerTitle;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void) setValues:(NSArray *)v
{
    values = v;
    [self.tableView reloadData];
}

- (void) setSelectedKeys:(NSSet *)k
{
    selectedKeys = k;
    self.mutableKeys = [NSMutableSet setWithSet:k];
    [self.tableView reloadData];
}

-(void)done
{
    NSSet * keys = self.mutableKeys.copy;
    [self.pickerDelegate dataPicker:self
                  didFinishWithKeys:keys];
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case ALL_SECTION:
            return 1;
        case VALUES_SECTION:
            return values.count;
        default:
            return 0;
    }
}

- (void)        tableView:(UITableView *)tv
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row     = indexPath.row;
    switch(section) {
        case ALL_SECTION:
            [self.mutableKeys removeAllObjects];
            break;
        case VALUES_SECTION:
        {
            NudgeDataPickerRow * rowInfo = [values objectAtIndex:row];
            if([self.mutableKeys containsObject:rowInfo.key]) {
                [self.mutableKeys removeObject:rowInfo.key];
            } else {
                [self.mutableKeys addObject:rowInfo.key];
            }

        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell*) cellWithIdentifier:(NSString*)identifier
{
    UITableViewCell * c = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if(c == nil) {
        UITableViewCellStyle style = UITableViewCellStyleDefault;
        if([identifier isEqualToString:PICKERCELL_SUBTITLE])
            style = UITableViewCellStyleValue1;
        
        c = [[UITableViewCell alloc] initWithStyle:style
                                   reuseIdentifier:identifier];
        c.selectionStyle = UITableViewCellSelectionStyleBlue;
        //c.detailTextLabel.font = [UIFont boldSystemFontOfSize:18.0];
        //c.detailTextLabel.textColor = [UIColor blackColor];
    }
    return c;
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    int section = indexPath.section;
    int row     = indexPath.row;
    switch(section) {
        case ALL_SECTION:
            cell = [self cellWithIdentifier:PICKERCELL_NOSUBTITLE];
            cell.textLabel.text = self.selectAllTitle;
            if(self.mutableKeys.count == 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
                
            break;
        case VALUES_SECTION:
        {
            NudgeDataPickerRow * rowInfo = [values objectAtIndex:row];
            if(rowInfo.subtitle.length > 0) {
                cell = [self cellWithIdentifier:PICKERCELL_SUBTITLE];
                cell.detailTextLabel.text = rowInfo.subtitle;
            } else {
                cell = [self cellWithIdentifier:PICKERCELL_NOSUBTITLE];
            }
            cell.textLabel.text = rowInfo.title;
            
            if( [self.mutableKeys containsObject:rowInfo.key]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        default:
            
            break;
    }
    
    return cell;
}

#pragma pickerDelegate

@end

@implementation NudgeDataPickerRow

- (id) initKey:(NSString*)k
         title:(NSString*)t
       subtitle:(NSString*)s
{
    self = [super init];
    if(self) {
        self.key = k;
        self.title = t;
        self.subtitle = s;
    }
    return self;
}

+ (NudgeDataPickerRow*) key:(NSString *)key title:(NSString *)title
{
    return [[NudgeDataPickerRow alloc] initKey:key title:title subtitle:nil];
}

+ (NudgeDataPickerRow *)key:(NSString *)key
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
{
    return [[NudgeDataPickerRow alloc] initKey:key title:title subtitle:subtitle];
}

-(NSComparisonResult) compare:(NudgeDataPickerRow*)o
{
    return [self.title compare:o.title];
}

-(NSComparisonResult) compareKey:(NSString *)k
{
    return [self.key compare:k];
}

@end