# Group Information

* Ai Chan Tran <aichantran@csu.fullerton.edu>
* Nicolas Vasquez <nickvas67@csu.fullerton.edu>
* Ryan Christopher L. Valenton <RCValenton@csu.fullerton.edu>
* Kristofer Calma <calmakris@csu.fullerton.edu>

##### WHAT WE LEARNED
* 


##### HOW TO RUN THE PROJECT
* The application runs through the XCode 14.0.1 environment
1. Download the 'WhatToPlay' folder from the repository
2. With XCode, open the 'WhatToPlay' folder
3a. For the best viewing experience, set the ios simulator on the top-middle to be iphone11/iphone pro max (App can still be viewed via iPad if desired)
3b. On the top-left click the play button
4. Navigate to the application on the simulated iphone and have fun!

### Incase of error, please see below

Make sure to open WhatToPlay.xcworkspace instead of WhatToPlay.xcodeproj<br />
If cocoapods installation and set up is require, then run:<br />
-Brew install cocoapods<br />
while in the project's folder, run:<br />
-pod init<br />
then, run:<br />
-open Podfile<br />
^ before the last 'end', add in:<br />
-pod 'DropDown'<br />
close text, then:<br />
-pod install<br />
now run WhatToPlay.xcworkspace<br />
<br />
if you encountererrors while trying to do pod init:<br />
-Make sure you have ruby installed (check for version using 'ruby -v')<br />
run:<br />
-echo 'export 
PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"'>> 
~/.zshrc <br />
replace the version number with the one you have, then do:<br />
-source ~/.zshrc<br />
then run:<br />
-sudo gem install -n /usr/local/bin cocoapods<br />
<br />
For detailed instructions, visit:
https://stackoverflow.com/questions/51126403/you-dont-have-write-permissions-for-the-library-ruby-gems-2-3-0-directory-ma 
<br />
