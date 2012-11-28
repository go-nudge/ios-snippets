//
//  DataPicker.h
//
//  Created by nudge GmbH on 24.10.12.
//  LGPL nudge GmbH.
//

#import <UIKit/UIKit.h>

@interface NudgeDataPickerRow : NSObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * title, * subtitle;

+ (NudgeDataPickerRow*) key:(NSString*)key
                 title:(NSString*)title;
+ (NudgeDataPickerRow*) key:(NSString*)key
                 title:(NSString*)title
              subtitle:(NSString*)subtitle;

-(NSComparisonResult) compare:(NudgeDataPickerRow*)p;
-(NSComparisonResult) compareKey:(NSString*)k;

@end

@protocol NudgeDataPickerDelegate;
@interface NudgeDataPickerController : UITableViewController
{
}

@property (retain, nonatomic) NSString * pickerTitle;

@property (nonatomic, retain) NSArray * values;
@property (nonatomic, retain) NSSet * selectedKeys;

@property (nonatomic, assign) int tag;
@property (nonatomic, assign) id <NudgeDataPickerDelegate> pickerDelegate;
@property (nonatomic, retain) NSString * selectAllTitle;

- (id)initController;

@end

@protocol NudgeDataPickerDelegate
- (void) dataPicker:(NudgeDataPickerController*)picker
  didFinishWithKeys:(NSSet*)keySet;
@end
