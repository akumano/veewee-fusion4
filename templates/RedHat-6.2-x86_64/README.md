Template for CentOS installation using CentOS-6.2-x86_64-bin-DVD1.iso.

[jedi4ever's veewee](https://github.com/jedi4ever/veewee) is not compatible with VMware Fusion 4. Following modifications were made :

- The paths to 'vmrun', 'isoimages', etc. are fixed. It works for both Fusion 3 and 4.
- It does not start a web server, since a kickstart file is fetched via http (see web.rb).
- ks.cfg and definition.rb from other CentOS templates do not work. See comments in the files.

Note on the paths: veewee looks into ~/.fissionrc and learns where VMware resource is. It is recommended that you define variables here especially if you don't use default locaitons. See fissionrc.example.
The code was confirmed to successfully build a CentOS-6.2-x86_64 box and Ubuntu 10.04 Server x86_64.

