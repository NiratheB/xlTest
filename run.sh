gem list | grep -q roo 
if [ $? -eq 0 ] ; then
         echo  "Roo Already Installed"
else 
	echo "Roo needs to be installed"
         sudo gem install roo
fi
cd lib
ruby test.rb
