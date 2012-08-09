Veewee::Session.declare({
  :cpu_count => '1', :memory_size=> '384',
  :disk_size => '10140', :disk_format => 'VMDK', :hostiocache => 'off',
  :os_type_id => 'Ubuntu_64',
  :iso_file => "ubuntu-10.04.4-server-amd64.iso",
  :iso_src => "http://releases.ubuntu.com/10.04.4/ubuntu-10.04.4-server-amd64.iso",
  :iso_md5 => "9b218654cdcdf9722171648c52f8a088",
  :iso_download_timeout => "1000",
  :boot_wait => "5",
  # This convoluted command sequence somehow works.
  :boot_cmd_sequence => [
    '<Esc><Esc><Enter>', # esc->esc leads to answering whether to leave graphic installation
    '/install/vmlinuz noapic preseed/url=http://<ip_addr>/preseed.cfg ',
    'debian-installer=en_US auto locale=en_US kbd-chooser/method=us ',
    'hostname=ubuntu10.04server-amd64 ',
    'fb=false debconf/frontend=noninteractive ',
    'console-setup/ask_detect=false console-setup/modelcode=pc105 console-setup/layoutcode=us ',
    'initrd=/install/initrd.gz -- <Enter>'
   ],
  :kickstart_port => "7122", :kickstart_timeout => "10000", :kickstart_file => "preseed.cfg",
  :ssh_login_timeout => "10000", :ssh_user => "root", :ssh_password => "password", :ssh_key => "",
  :ssh_host_port => "7222", :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "shutdown -P now",
  :postinstall_files => [ "postinstall2.sh"], :postinstall_timeout => "10000"
})

# this definition worked (created ubuntu-test. preseed screwed it up 06/22/12)
