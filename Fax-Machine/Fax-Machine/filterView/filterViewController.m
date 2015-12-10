//
//  filterViewController.m
//  
//
//  Created by Matthew Chang on 11/24/15.
//
//

#import "filterViewController.h"
#import "ParseAPIClient.h"
#import "ImagesViewController.h"
#import "DataStore.h"

@interface filterViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *filterPicker;
@property (strong, nonatomic) NSString *chosenCountry;
@property (strong, nonatomic) NSArray *arrayFromQuery;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) NSMutableDictionary *filtering;
@property (strong, nonatomic) DataStore *dataStore;
@property (strong, nonatomic) NSArray *moodArrayFromQuery;

@end

@implementation filterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mountains_hd"]]];
    UIPickerView *filterPicker = [[UIPickerView alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    NSArray *queryArray = [query findObjects];
    
    PFQuery *moodQuery = [PFQuery queryWithClassName:@"Image"];
    NSArray *moodsArray = [moodQuery findObjects];
    
    self.moodArrayFromQuery = moodsArray;
    self.arrayFromQuery = queryArray;
    
  
    _filterPicker.delegate = self;
    _filterPicker.dataSource = self;
    
    [self setupPickerView:filterPicker];
    
    self.filterButton.accessibilityLabel = @"Filter";
    
    self.dataStore = [DataStore sharedDataStore];
    //get arrays for countries and cities in viewDidLoad
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    

    if (component == 0)
    {
        //get count of countries from parse
        NSMutableArray *countriesArray = [self gettingAnArrayOfCountries:self.arrayFromQuery];
        return countriesArray.count;
        
    }
    else if (component == 1)
    {
        //get count of cities of chosen country from parse
        NSMutableArray *citiesArray = [self gettingAnArrayOfCitiesWithMatchingCountry:self.arrayFromQuery];
        return citiesArray.count;
    }
    else
    {
        //moods
        NSMutableArray *moodsArray = [self gettingAnArrayOfMoods:self.moodArrayFromQuery];
        return moodsArray.count;
    }

}
//
//
//Two lines per component in pickerview

-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view
{
    if (component == 0)
    {
        NSMutableArray *arrayOfCountries = [self gettingAnArrayOfCountries:self.arrayFromQuery];
        UILabel *pickerLabel = (UILabel *)view;
        
        if (pickerLabel == nil)
        {
            CGRect frame = CGRectMake(0.0, 0.0, 100, 32);
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
            
            pickerLabel.lineBreakMode = NSLineBreakByWordWrapping;
            pickerLabel.numberOfLines = 2;
            
        }
        [pickerLabel setText:arrayOfCountries[row]];
         return pickerLabel;
    }
    else if (component == 1)
    {
        NSMutableArray *arrayOfCities = [self gettingAnArrayOfCitiesWithMatchingCountry:self.arrayFromQuery];
        UILabel *pickerLabel = (UILabel *)view;
        
        if (pickerLabel == nil)
        {
            CGRect frame = CGRectMake(0.0, 0.0, 100, 32);
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
            
            pickerLabel.lineBreakMode = NSLineBreakByWordWrapping;
            pickerLabel.numberOfLines = 2;
            
        }
        [pickerLabel setText:arrayOfCities[row]];
        return pickerLabel;
    }
    else if (component == 2)
    {
        NSMutableArray *arrayOfMoods = [self gettingAnArrayOfMoods:self.moodArrayFromQuery];
        UILabel *pickerLabel = (UILabel *)view;
        
        if (pickerLabel == nil)
        {
            CGRect frame = CGRectMake(0.0, 0.0, 100, 32);
            pickerLabel = [[UILabel alloc] initWithFrame:frame];
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
            
            pickerLabel.lineBreakMode = NSLineBreakByWordWrapping;
            pickerLabel.numberOfLines = 2;
            
        }
        [pickerLabel setText:arrayOfMoods[row]];
        return pickerLabel;
    }
    else
    {
        return nil;
    }
}

-(NSMutableArray *)gettingAnArrayOfCountries:(NSArray *)arrayOfPFObjects
{
    NSMutableArray *arrayOfCountries = [[NSMutableArray alloc] init];
    for (PFObject *object in arrayOfPFObjects)
    {
        NSString *countryOfObject = object[@"country"];
        if (![arrayOfCountries containsObject:countryOfObject])
        {
            [arrayOfCountries addObject:countryOfObject];
        }
    }
    return arrayOfCountries;
}

-(NSMutableArray *)gettingAnArrayOfCitiesWithMatchingCountry:(NSArray *)arrayOfPFObjects
{
    [self gettingChosenCountry:self.filterPicker];
    NSMutableArray *arrayOfCities = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", self.chosenCountry];
    NSArray *predicatedArrayOfPFObjects= [arrayOfPFObjects filteredArrayUsingPredicate:predicate];
    
    for (PFObject *object in predicatedArrayOfPFObjects)
    {
        NSString *cityOfObject = object[@"city"];
        if (![arrayOfCities containsObject:cityOfObject])
        {
            [arrayOfCities addObject:cityOfObject];
        }
    }
    return arrayOfCities;
}

-(NSMutableArray *)gettingAnArrayOfMoods:(NSArray *)arrayOfPFObjects
{
    NSMutableArray *arrayOfMoods = [[NSMutableArray alloc] init];
    for (PFObject *object in arrayOfPFObjects)
    {
        NSString *moodOfObject = object[@"mood"];
        if (![arrayOfMoods containsObject:moodOfObject])
        {
            [arrayOfMoods addObject:moodOfObject];
        }
    }
    return arrayOfMoods;
}
- (IBAction)filterButtonTapped:(id)sender {
    
    [self filterTheThing];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)gettingChosenCountry:(UIPickerView *)pickerView
{
    NSInteger selectedRowForCountry = [pickerView selectedRowInComponent:0];
    NSMutableArray *arrayOfCountries = [self gettingAnArrayOfCountries:self.arrayFromQuery];
    self.chosenCountry = arrayOfCountries[selectedRowForCountry];
}

-(void)setupPickerView:(UIPickerView *)pickerView
{
    [self numberOfComponentsInPickerView:pickerView];
    for (NSUInteger i = 0; i < pickerView.numberOfComponents; i++)
    {
        [pickerView numberOfRowsInComponent:i];
        for (NSUInteger x = 0; x < ([self.filterPicker numberOfRowsInComponent:i]); x++)
        {
            [self pickerView:pickerView titleForRow:x forComponent:i];
        }
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [self gettingAnArrayOfCitiesWithMatchingCountry:self.arrayFromQuery];
        [pickerView reloadComponent:1];
    }
}



-(void)filterTheThing
{
    NSMutableArray *arrayOfCountries = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfCities = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfMoods = [[NSMutableArray alloc] init];
    
    arrayOfMoods = [self gettingAnArrayOfMoods:self.moodArrayFromQuery];
    arrayOfCountries = [self gettingAnArrayOfCountries:self.arrayFromQuery];
    arrayOfCities = [self gettingAnArrayOfCitiesWithMatchingCountry:self.arrayFromQuery];
    
    NSInteger countrySelection = [self.filterPicker selectedRowInComponent:0];
    NSInteger citySelection = [self.filterPicker selectedRowInComponent:1];
    NSInteger moodSelection = [self.filterPicker selectedRowInComponent:2];
    
    
    NSMutableDictionary *filterParameters = [@{
                                       @"country" : arrayOfCountries[countrySelection],
                                       @"city" : arrayOfCities[citySelection],
                                       @"mood" : arrayOfMoods[moodSelection]
                                       } mutableCopy];
    
    [self.filtering removeAllObjects];
    [self.dataStore.filteredImageList removeAllObjects];
    
    Location *locationForPredicate = [[Location alloc] init];
    locationForPredicate.city = arrayOfCities[citySelection];
    locationForPredicate.country = arrayOfCountries[countrySelection];
    
    if ([filterParameters[@"mood"] isEqualToString:@"Default Mood"]) {
        filterParameters[@"mood"] = @"";
    }
    
    self.filtering = [filterParameters mutableCopy];
    [self.delegate filterImageWithDictionary:filterParameters
                                 andLocation:locationForPredicate];
    
}

@end
