

![alt tag](https://github.com/learn-co-students/ios-0915-team-fax-machine/blob/master/Fax-Machine/Fax-Machine/Assets.xcassets/AppIcon.appiconset/Icon-76%402x.png)
#HORIZIONS V.1.0 
##By:Flatiron School Students

#WELCOME!!
Thanks for checking out Horizons<br />

##DISCRIPTION:
Horizons is an iOS native scenery application, where people share travel experiences through posting scenery pictures.
###Features Available:
1- Users could add comments,like and report/flag pictures<br />
2- Save and share pictures<br />
3- Follow other users<br />
4- Filter search results by location and predefined mood<br />

##CONTRIBUTORS:
Selma Boudjemaa<br />
Matt Chang<br />
Clair Davis<br />
Kevin Lin<br />

##DEMO:
Click to watch demo ---ENJOY!

[![ScreenShot](http://img.youtube.com/vi/xpbN7gi4oqo/hqdefault.jpg)](https://youtu.be/xpbN7gi4oqo)




##DETAILS:
Language: Objective-C, Swift<br />
Libraries/APIs: CocoaPods, CoreLocation API, Parse, Twitter API, Facebook API<br />
Tools: Sublime Text, vi Editor, Xcode, Git, Sketch<br />
Storage: Amazon 3S for data storage, Parse for metadata storage and search<br />

##CUSTOM CLASSES OVERVIEW:

ImagesCustomCell: Allow users interaction<br />
ImagesViewController: Displays images in UICollectionView<br />
ImagesDetails Class: Displays full images and textfield allowing users to add comments, like, follow, or report an image<br />
APIConstants Class: Includes API keys<br />
ParseAPIClient Class: Connect to Parse<br />
AWSUploadManager Class: Connect to Amazon S3 for upload<br />
AWSDownloadManager Class: Connect to Amazon S3 for download<br />
BaseLoginViewController Class: Checks if user is logged in and send it to appropriate UIView, either login screen or app main menu<br />
LoginViewController Class:</b>Displays Login UIView<br />
SignUpViewController Class:Displays SignUp UIView<br />
UIImage+fixOrientation Class: to auto orientation of images<br />
DataStore Class: Includes shareddata across the app<br />
SideMenu Class: Displays main menu of the app<br />
FilterViewController Class: Displays UIView which will allow users to filter search results<br />
ChooseUploadViewController Class: Enable users to upload pictures<br />
ImageUploadViewController Class: Enable users to take picture to upload<br />
LocationData Class: Enable GeoLocation<br />
Reachability Class: Check network availability<br />


##LICENSE
The MIT License (MIT)

Copyright (c) [year] [fullname]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

##ACKNOWLEDGEMENT:
Some of the features in this product is using third party frameworks listed below:  
Parse
ParseUI
ParseTwitterUtils
FBSDKCoreKit
FBSDKLoginKit
ParseFacebookUtilsV4
RESideMenu
FontAwesomeKit
FCCurrentLocationGeocoder
MBProgressHUD
YYWebImage
SCLAlertView-Objective-C
PullToRefreshCoreText
AWSCore
AWSS3







