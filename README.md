vagrant-multi
=============

Create multiple VMs with Vagrant, and manage their hosts files through puppet for hostname resolution.

It is easy to spin up custom multi VM environments using Vagrant. Vagrant also lets you assign friendly 'names' which you can use to ssh to the VMs from the host. This is convenient, but is not useful inside the guests.

What if you want the VMs to talk to each other using hostnames? You could run your own DHCP/DNS servers, but maintaining additional tools can become a chore. You could be using Foreman or Cobbler for this, but then, this is post about Vagrant.

One other way is to maintain an /etc/hosts file with each VMs name and IP.
One simple solution for this task, is to symlink /etc/hosts to a file on the shared folder that vagrant can create for you.

So you can have this line inside your Vagranfile, which is applied to each VM:

`vm_name.vm.provision :shell, :inline => "sudo ln -fs /vagrant/etc-hosts /etc/hosts"`

The nice thing is, you can read this etc-hosts file inside your Vagrantfile, and use it to create your Multi-VM setup. You can do this before the `Vagrant::Config.run do`
loop inside the Vagrantfile.

Now what if you wanted additional customization for each VM, say different memory sizes, or even operating systems? You could add special comments/lines in the file for that. But this is how I chose to solve this, when creating a multi-VM setup for the ambari environment:

* Create a "hosts.yaml" file with a list of your hosts, and their attributes, like name, memory, ip address. Should be easy to extend with more attributes.
* Get this puppet module for managing hosts files. 
* Read the "hosts.yaml" file through your Vagrantfile, and create another file called "common.yaml", which the puppet module can use through hiera.
* Use the attributes you added in "hosts.yaml" to create your multi-VM setup.

The resulting setup is available on github here.

There are some Ambari related things in the puppet code, most of which I have commented out. Without the Ambari related code, this is one way to manage hosts files in your multi-VM setup.
