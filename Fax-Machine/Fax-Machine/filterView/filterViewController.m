//
//  filterViewController.m
//  
//
//  Created by Matthew Chang on 11/24/15.
//
//

#import "filterViewController.h"
#import "ParseAPIClient.h"

@interface filterViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *filterPicker;
@property (strong, nonatomic) NSString *chosenCountry;

@end

@implementation filterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPickerView *filterPicker = [[UIPickerView alloc] init];
    _filterPicker.delegate = self;
    _filterPicker.dataSource = self;
    self.moodsArray = @[@"Happy",
                        @"Gloomy",
                        @"Snowy?",
                        @"Autumn"];
    //get arrays for countries and cities in viewDidLoad
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//number of rows for each component is dependent on the previous filter...First is an array of countries
//second is the cities in selected country
//third will be moods, which is a pre-defined array
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    NSArray *queryArray = [query findObjects];
    
    if (component == 0)
    {
        //get count of countries from parse
        NSMutableArray *countriesArray = [[NSMutableArray alloc] init];
        for (PFObject *object in queryArray)
        {
            NSString *countryOfObject = object[@"country"];
            if (![countriesArray containsObject:countryOfObject])
            {
                [countriesArray addObject:countryOfObject];
            }
        }
        return countriesArray.count;
        
    }
    else if (component == 1)
    {
        //get count of cities of chosen country from parse
        NSMutableArray *citiesArray = [[NSMutableArray alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", self.chosenCountry];
        NSArray *objectsWithMatchingCountry = [queryArray filteredArrayUsingPredicate:predicate];
        for (PFObject *object in objectsWithMatchingCountry)
        {
            NSString *cityOfObject = object[@"city"];
            if (![citiesArray containsObject:cityOfObject])
            {
                [citiesArray addObject:cityOfObject];
            }
        }
        return citiesArray.count;
    }
    else
    {
        //moods
        return [self.moodsArray count];
    }

}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}

@end
