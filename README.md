
#HORIZIONS V.1.0
##By:Flatiron School Students
##//<3
![alt text][]

#WELCOME!!
Thanks for checking out Horizons<br />

##Discription:
Horizons is an iOS native scenery application, where people share travel experiences through posting scenery pictures.
###Features Availble:
1- Users could add comments,like and report/flag pictures<br />
2- Save and share pictures<br />
3- Follow other users<br />
4- Filter search results by location and predefined mood<br />

##Contributors:
Selma Boudjemaa<br />
Matt Chang<br />
Clair Davis<br />
Kevin Lin<br />

##DEMO:





##DETAILS:
Language: Objective-C, Swift<br />
Libraries/APIs: CocoaPods, CoreLocation API, Parse, Twitter API, Facebook API<br />
Tools: Sublime Text, vi Editor, Xcode, Git, Sketch<br />
Storage: Amazon 3S for data storage, Parse for metadata storage and search<br />

##CLASSES IN CODE:

ImagesCustomCell: Allow users interaction<br />
ImagesViewController: Displays images in UICollectionView<br />
ImagesDetails Class: Displays full images and textfield allowing users to add comments, like, follow, or report an image<br />
APIConstants Class: Includes API keys<br />
ParseAPIClient Class: Connect to Parse<br />
######AWSUploadManager Class: Connect to Amazon S3 for upload
######AWSDownloadManager Class: Connect to Amazon S3 for download
######BaseLoginViewController Class: Checks if user is logged in and send it to appropriate UIView, either login screen or app main menu
######<b>LoginViewController Class:</b>Displays Login UIView
######SignUpViewController Class:Displays SignUp UIView
######UIImage+fixOrientation Class: to auto orientation of images
######DataStore Class: Includes shareddata across the app
######SideMenu Class: Displays main menu of the app
######filterViewController Class: Displays UIView which will allow users to filter search results
#####ChooseUploadViewController Class: Enable users to upload pictures
######ImageUploadViewController Class: Enable users to take picture to upload
######LocationData Class: Enable GeoLocation
######Reachability Class: Check network availability




##Acknowledgement:





