
#HORIZIONS V.1.0
##By:Flatiron School Students


#WELCOME!!
Thanks for checking out Horizons

##Discription:
Horizons App - iOS native application allowing people to share travel experiences through posting scenery pictures, pictures are displayed in a UICollectionView, Users can view individual pictures which are displayed in a separate UIView where users may add comments and likes, share on social media, save pictures, and filter search results by location and predefined mood.

##DEMO:





##DETAILS:
Language: Objective-C, Swift
Libraries/APIs: CocoaPods, CoreLocation API, Parse, Twitter API, Facebook API
Tools: Sublime Text, vi Editor, Xcode, Git, Sketch
Storage: Amazon 3S for data storage, Parse for metadata storage and search.

##ClASSES IN CODE:

ImagesCustomCell: to allow users interaction
ImagesViewController: Displays images in UICollectionView
ImagesDetails Class: Displays full images and textfield allowing users to add comments, like, follow, or report an image.
APIConstants Class: Includes API keys
ParseAPIClient Class: Connect to Parse
AWSUploadManager Class: Connect to Amazon S3 for upload
AWSDownloadManager Class: Connect to Amazon S3 for download
BaseLoginViewController Class: Checks if user is logged in and send it to appropriate UIView, either login screen or app main menu
LoginViewController Class:Displays Login UIView
SignUpViewController Class:Displays SignUp UIView 
UIImage+fixOrientation Class: to auto orientation of images
DataStore Class: Includes shareddata across the app
SideMenu Class: Displays main menu of the app
filterViewController Class: Displays UIView which will allow users to filter search results
ChooseUploadViewController Class: Enable users to upload pictures
ImageUploadViewController Class: Enable users to take picture to upload
LocationData Class: Enable GeoLocation
Reachability Class: Check network availability




##Acknowledgement:





