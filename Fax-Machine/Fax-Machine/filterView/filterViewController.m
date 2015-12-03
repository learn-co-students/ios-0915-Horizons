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
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mountains_hd"]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mountains_hd"]]];
    UIPickerView *filterPicker = [[UIPickerView alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    NSArray *queryArray = [query findObjects];
    
    PFQuery *moodQuery = [PFQuery queryWithClassName:@"Image"];
    NSArray *moodsArray = [moodQuery findObjects];
    
    self.moodArrayFromQuery = moodsArray;
    self.arrayFromQuery = queryArray;
    
    //need to set it up
    
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
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (component == 0)
    {
        NSMutableArray *arrayOfCountries = [self gettingAnArrayOfCountries:self.arrayFromQuery];
        return arrayOfCountries[row];
    }
    else if (component == 1)
    {
        NSMutableArray *arrayOfCities = [self gettingAnArrayOfCitiesWithMatchingCountry:self.arrayFromQuery];
        return arrayOfCities[row];
    }
    else
    {
        NSMutableArray *arrayOfMoods = [self gettingAnArrayOfMoods:self.moodArrayFromQuery];
        return arrayOfMoods[row];
    }
    
    return nil;
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
//    [self.filterPicker reloadComponent:1];
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

-(void)gettingChosenCountry:(UIPickerView *)pickerView
{
    NSInteger selectedRowForCountry = [pickerView selectedRowInComponent:0];
    NSMutableArray *arrayOfCountries = [self gettingAnArrayOfCountries:self.arrayFromQuery];
    self.chosenCountry = arrayOfCountries[selectedRowForCountry];
}
//- (IBAction)filterButtonTapped:(id)sender
//{
////    NSMutableArray *arrayOfCountries = [[NSMutableArray alloc] init];
////    NSMutableArray *arrayOfCities = [[NSMutableArray alloc] init];
////    arrayOfCountries = [self gettingAnArrayOfCountries:self.arrayFromQuery];
////    arrayOfCities = [self gettingAnArrayOfCitiesWithMatchingCountry:self.arrayFromQuery];
////    NSInteger countrySelection = [self.filterPicker selectedRowInComponent:0];
////    NSInteger citySelection = [self.filterPicker selectedRowInComponent:1];
////    NSInteger moodSelection = [self.filterPicker selectedRowInComponent:2];
////    
////    
////    NSDictionary *filterParameters = @{
////                                       @"country" : arrayOfCountries[countrySelection],
////                                       @"city" : arrayOfCities[citySelection],
////                                       @"mood" : self.moodsArray[moodSelection]
////                                        };
////    self.filtering = [filterParameters mutableCopy];
//    
//    //got a dictionary of filter parameters, but what if a user doesn't want to use all of the filters?
//}

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
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
    
    
    NSDictionary *filterParameters = @{
                                       @"country" : arrayOfCountries[countrySelection],
                                       @"city" : arrayOfCities[citySelection],
                                       @"mood" : arrayOfMoods[moodSelection]
                                       };
    self.filtering = [filterParameters mutableCopy];

    NSLog(@"Segue method!!!");
    ImagesViewController *imagesVC = segue.destinationViewController;
    imagesVC.filterParameters = [filterParameters mutableCopy];
    imagesVC.isFiltered = YES;
    [self.dataStore.downloadedPictures removeAllObjects];
    //[imagesVC.imagesCollectionViewController reloadData];
    
    Location *locationForPredicate = [[Location alloc] init];
    locationForPredicate.city = arrayOfCities[citySelection];
    locationForPredicate.country = arrayOfCountries[countrySelection];
    
    if ([filterParameters[@"mood"] isEqualToString:@"Default Mood"])
    {
        NSPredicate *countryPredicate = [NSPredicate predicateWithFormat:@"(mood != %@) OR (mood = %@)", @"", @""];
        
        [self.dataStore downloadPicturesToDisplayWithPredicate:countryPredicate andLocation:locationForPredicate numberOfImages:20 WithCompletion:^(BOOL complete)
         {
             if (complete)
             {
                 [imagesVC filteringImagesCountryLevel:filterParameters];
             }
         }];
    }
    
    else
    {
        NSPredicate *countryPredicate = [NSPredicate predicateWithFormat:@"mood = %@",filterParameters[@"mood"]];
        [self.dataStore downloadPicturesToDisplayWithPredicate:countryPredicate andLocation:locationForPredicate numberOfImages:20 WithCompletion:^(BOOL complete)
         {
             if (complete)
             {
                 [imagesVC filteringImagesCountryLevel:filterParameters];
             }
         }];
    }
    
    self.dataStore.filterDictionary = self.filtering;
//    [self.dataStore downloadPicturesToDisplayWithPredicate:countryPredicate numberOfImages:20 WithCompletion:^(BOOL complete)
//     {
//         if (complete)
//         {
//            [imagesVC filteringImagesCountryLevel:filterParameters];
//         }
//         
//     }];
    
//    self.dataStore.filterDictionary = self.filtering;
    
}

@end
