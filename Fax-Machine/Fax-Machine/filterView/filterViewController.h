//
//  filterViewController.h
//  
//
//  Created by Matthew Chang on 11/24/15.
//
//

#import <UIKit/UIKit.h>

@class Location;

@protocol FilterImageProtocol <NSObject>

- (void)filterImageWithDictionary:(NSMutableDictionary *)filterDict
                         withMood:(NSString *)mood
                      andLocation:(Location *)location;

@end



@interface filterViewController : UIViewController

@property (weak, nonatomic) id <FilterImageProtocol> delegate;

@end
