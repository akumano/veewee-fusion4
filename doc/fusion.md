## Define a new box
Let's define a  CentOS 6.2 x86_64 called mycentosbox
this is essentially making a copy based on the templates provided above.

    $ veewee fusion define 'mycentosbox' 'CentOS-6.2-x86_64'
    The basebox 'mycentosbox' has been succesfully created from the template ''CentOS-6.2-x86_64'
    You can now edit the definition files stored in definitions/mycentosbox
    or build the box with:
    veewee fusion build 'mycentosbox'

-> This copies over the templates/CentOS-6.2-x86_64 to definition/mycentosbox

    $ ls definitions/mycentosbox
    definition.rb	postinstall.sh	postinstall2.sh	ks.cfg

## Optionally modify the definition.rb , postinstall.sh or ks.cfg

    Veewee::Definition.declare( {
    :cpu_count => '1', :memory_size=> '392', 
    :disk_size => '10140', :disk_format => 'VMDK',
    :hostiocache => 'off', :ioapic => 'on', :pae => 'on',
    :os_type_id => 'Centos_64',
    :iso_file => "CentOS-6.2-x86_64-bin-DVD1.iso", 
    :iso_src => "http://mirrors.cat.pdx.edu/centos/6.2/isos/x86_64/CentOS-6.2-x86_64-bin-DVD1.iso",
    :iso_md5 => "26fdf8c5a787a674f3219a3554b131ca",
    :iso_download_timeout => "1000",
    :boot_wait => "8",
    :boot_cmd_sequence => [ '<Tab> text ks=http://$(your webserver)/ks.cfg <Enter>' ],
    :kickstart_port => "7122", :kickstart_timeout => "10000",:kickstart_file => "ks.cfg",
    :ssh_login_timeout => "10000",:ssh_user => "fission", :ssh_password => "fission",:ssh_key => "",
    :ssh_host_port => "7222", :ssh_guest_port => "22",
    :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
    :shutdown_cmd => "/sbin/halt -h -p",
    :postinstall_files => [ "postinstall.sh"],:postinstall_timeout => "10000"
     }
    )

If you need to change values in the templates, be sure to run the rake undefine, the rake define again to copy the changes across.

## Getting the cdrom file in place
Put your isofile inside the 'currentdir'/iso directory

    $ veewee fusion build 'mycentosbox'

- the build assumes your iso files are in 'currentdir'/iso
- if it can not find it will suggest to download the iso for you
- use '--force' to overwrite an existing install
- use '-n' to suppress Fusion GUI

## Build the new box:

    $ veewee fusion build 'mycentosbox'

- This will create a machine + disk according to the definition.rb
- Note: :os_type_id = The internal Name VMware uses for that Distribution
- Mount the ISO File :iso_file
- Boot up the machine and wait for :boot_time
- Send the keystrokes in :boot_cmd_sequence
- It DOES NOT startup a webserver on :kickstart_port to wait for a request for the :kickstart_file (don't navigate to the file in your browser or the server will stop and the installer will not be able to find your kickstart)!! 'definition.rb' in this template tries to fetch kickstart file via http.
- Wait for ssh login to work with :ssh_user , :ssh_password
- Sudo execute the :postinstall_files

## Validate the vm 

    $ veewee fusion validate 'mycentosbox'

this will run some cucumber test against the box to see if it has the necessary bits and pieces for fission to work

## Use it in fission

To use it:

    $ fission start --headless 'mycentosbox'
    $ ssh user@hostip	       #  information necessary for ssh is issued when the box successfully builds.


## How to add a new OS/installation (needs some love)

Start off an existing one

    $ veewee fusion define 'mynewos' 'centos...'

- Do changes in the currentdir/definitions/mynewos
- When it builds ok, move the definition/mynewos to a sensible directory under templates
- commit the changes (git commit -a)
- push the changes to github (git push)
- go to the github gui and issue a pull request for it

## Kickstart reference
[Fedora Anaconda/Kickstart](http://fedoraproject.org/wiki/Anaconda/Kickstart#services)
