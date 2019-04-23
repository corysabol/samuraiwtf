# 📦 SamuraiWTF Container Hackery Edition
(ya that box is supposed to imply a container)

## What is this? And how does it relate to the main SamuraiWTF build?
This is my personal experimental fork. It exists for the sole purpose of integrating several container and cluster related
targets and tools into SamuraiWTF. Ideally this will eventually make it's way into the upstream project :)

**To download an OVA to import a full virtual machine, visit https://tiny.si/Samurai-Container-Hacker-Edition.zip. 

A [video tutorial](https://www.youtube.com/watch?v=3a3qOFubfGg) is available showing how to install from OVA.
**Want to Contribute? See section at the end of this readme**

## 📚 Prerequisites
- Vagrant - https://www.vagrantup.com/
- Virtualization Software - The base vagrant box used supports virtualbox, vmware, and parallels, but testing at this time has been solely on virtualbox - https://www.virtualbox.org/
- vagrant-vbguest plugin for vagrant (virtualbox only) - this automatically installs guest extensions which provide support for higher display resolutions, as well as other conveniences like clipboard sharing - https://github.com/dotless-de/vagrant-vbguest
- Disable Hyper-V (Windows and Virtualbox only) - follow the Resolution instructions provided by Microsoft to disable and enable Hyper-V (requires reboot) - https://support.microsoft.com/en-us/help/3204980/virtualization-applications-do-not-work-together-with-hyper-v-device-g

## 💿 Initial Install
1. Make sure you have the prereqs listed above. Webpwnized has made some helpful [YouTube video instructionals](https://www.youtube.com/watch?v=MCqpTpxNSlA&list=PLZOToVAK85Mru8ye3up3VR_jXms56OFE5) for getting Vagrant and VirtualBox  with vbguest plugin installed in case you have not done so before.
2. Clone this repository.
3. From a command-line terminal in the project directory, run the command `vagrant up`. Then sit back and wait for it to finish. NOTE: The Guest VM's window will open with the CLI while provisioning is still ongoing. It's best to leave it alone until the vagrant up command fully completes.
4. Immediately after the first time start up it is recommend you do a restart using vagrant reload.

**NOTE: The Guest VM's window will open with the CLI while provisioning is still ongoing. It's best to leave it alone until the `vagrant up` command fully completes.**

## 🏭 Production VM Notes:
Once you load the VM, the username and password are:

- Username: vagrant
- Password: vagrant

The menus are available via a right click on the desktop.

Once you log in the target systems need to be provisioned. (Working on doing this during the build!)

When the VM starts up the cluster target will need to provision, this will likely take a few minutes.
You can follow the log output of this process with `tail -f .kube_cluster/kube_cluster_cron.log`. If anything
fails you're encouraged to make an issue in this repository and inclued the `.kube_cluster/kube_cluster_cron.log` file.

## 📺 Virtualbox Display
- To automatically adjust the display resolution, do the following:
	- Select Virtualbox Menu -> View
	- Click Auto-Resize Guest Display
	- Resize Virtualbox window and display should change to fit window size.

# 👨‍💼 License
The scripts and resources belonging to this project itself are licensed under the GNU Public License version 3 (GPL3).
All software loaded into the VM, including the tools, targets, utilities, and operating system itself retain their original license agreements.

=======
1. Don't. This fork is not ready for general consumption. Refer to the upstream instead.

# 👷‍♀️ Contributors
Contributors are very welcome and the contribution process is standard:

  * fork this project
  * make your contribution
  * submit a pull request
  
Substantial or *Regular* contributors may also be brought in as full team members. This includes those who have made substantial contributions to previous versions of SamuraiWTF with the assumption they will continue to do so.
