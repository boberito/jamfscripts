#!/bin/sh

curl http://downloads.apple.com/static/gb/gb11bc/GarageBandBasicContent.pkg > /GarageBandBasicContent.pkg
curl http://audiocontentdownload.apple.com/lp9_ms2_content_2011/MGBContentCompatibility.pkg > /MGBContentCompatibility.pkg

installer -pkg /GarageBandBasicContent.pkg -target /
installer -pkg /MGBContentCompatibility.pkg -target /

#rm -rf /GarageBandBasicContent.pkg
#rm -rf //MGBContentCompatibility.pkg