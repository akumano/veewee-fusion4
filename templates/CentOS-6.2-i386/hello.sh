echo "hi there. i'm just testing the postinstall script thingy."
echo "I'm leaving a junkfile here to make sure it's doing something inside the box."
touch junkfile
echo "this is a junk file" > junkfile
echo "using yum"
yum clean expire-cache && yum check-update
#yum install -y --disableplugin=fastestmirror elinks