# Final Project Submission

Our submission for CPSC 411-03, Section 03, What To Play Final Project

# Group Information

* Ai Chan Tran <aichantran@csu.fullerton.edu> 890644024
* Nicolas Vasquez <nickvas67@csu.fullerton.edu> 888869864
* Ryan Christopher L. Valenton <RCValenton@csu.fullerton.edu> 888601234
* Kristofer Calma <calmakris@csu.fullerton.edu> 891907263

# Instructions

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
