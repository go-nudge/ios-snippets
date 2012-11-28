//
//  MasterViewController.m
//  DataPickerExample
//
//  Created by Jose on 28.11.12.
//  Copyright (c) 2012 Nudge GmbH. All rights reserved.
//

#import "MasterViewController.h"

#define KEY_FILTER_PAIR         @"pair"
#define KEY_FILTER_TENMULT      @"tenMult"
#define KEY_FILTER_GREATER300   @"gr300"
#define KEY_FILTER_PRIME        @"prime"

@interface MasterViewController ()

@property (retain, nonatomic) NSMutableArray * allNumbers, * filteredNumbers;
@property (retain, nonatomic) NSArray * filters;           // Array of DataPickerRows
@property (retain, nonatomic) NSSet * currentFilterKeys; // Array of NSString (keys)
@property (retain, nonatomic) NudgeDataPickerController * dataPicker;

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Nudge DataPicker", @"DataPicker Example");
        self.allNumbers = [NSMutableArray array];
        self.filteredNumbers = [NSMutableArray array];
        
        self.currentFilterKeys = [NSSet set]; // No filters selected
        self.filters = @[
            [NudgeDataPickerRow key:KEY_FILTER_PAIR         title:@"Pair numbers"       subtitle:@"*2"],
            [NudgeDataPickerRow key:KEY_FILTER_TENMULT      title:@"Multiples of 10"    subtitle:@"*10"],
            [NudgeDataPickerRow key:KEY_FILTER_GREATER300   title:@"Greater than 300"   subtitle:@">300"],
            [NudgeDataPickerRow key:KEY_FILTER_PRIME        title:@"Prime numbers"      subtitle:@"0,1,2,3,5,7,11..."],
        ];         
        
        // Add some numbers
        for(int i=0; i<20; ++i) {
            [self addRandomNumber];
        }
        [self applyFilters];
        
        
        // Init filters and data picker
        self.dataPicker = [[NudgeDataPickerController alloc] initController];
        self.dataPicker.pickerDelegate = self;
        self.dataPicker.selectAllTitle = @"All numbers";
        self.dataPicker.values = self.filters; // can be set every time we show the picker (in showFilters for example)
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showFilters)];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void) addRandomNumber
{
    NSNumber * number = [NSNumber numberWithLong: abs(arc4random()%1000) ];
    [self.allNumbers insertObject:number
                          atIndex:0];
    [self applyFilters];
}


- (void)insertNewObject:(id)sender
{
    int prevCount = self.filteredNumbers.count;
    
    [self addRandomNumber];
    
    if(self.filteredNumbers.count > prevCount) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

BOOL isPrime(unsigned int number)
{
    if (number <= 1)
        return NO; // zero and one are not prime
    
    unsigned int i;
    for (i=2; i*i<=number; i++) {
        if (number % i == 0)
            return NO;
    }
    return YES;
}


- (void) applyFilters
{
    if(self.currentFilterKeys.count == 0 || self.currentFilterKeys.count == 4) {
        self.filteredNumbers = self.allNumbers;
    } else {
        NSMutableArray * filtered = [NSMutableArray array];
        
        BOOL pairs = [self.currentFilterKeys containsObject:KEY_FILTER_PAIR];
        BOOL multTen = [self.currentFilterKeys containsObject:KEY_FILTER_TENMULT];
        BOOL gr300  = [self.currentFilterKeys containsObject:KEY_FILTER_GREATER300];
        BOOL primes = [self.currentFilterKeys containsObject:KEY_FILTER_PRIME];
        
        for(NSNumber * n in self.allNumbers) {
            int v = n.intValue;
            if(
               (gr300   && v>300)   ||
               (pairs   && v%2==0)  ||
               (multTen && v%10==0) ||
               (primes  && isPrime(v)) ) {
                [filtered addObject:n];
            }
        }
        
        self.filteredNumbers = filtered;
    }
}

- (void) showFilters
{
    self.dataPicker.selectedKeys = self.currentFilterKeys;
    UINavigationController * ctrl = [[UINavigationController alloc] initWithRootViewController:self.dataPicker];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)dataPicker:(NudgeDataPickerController *)picker
 didFinishWithKeys:(NSSet *)keySet
{
    self.currentFilterKeys = keySet;
    [self applyFilters];
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.filteredNumbers.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }

    NSNumber * number = self.filteredNumbers[indexPath.row];
    cell.textLabel.text = [number stringValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.filteredNumbers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
