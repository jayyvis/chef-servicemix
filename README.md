servicemix Cookbook
=================
Pulls down the latest servicemix code, builds the code, installs the dependencies, and then starts the evm processes.

Requirements
------------
### Platforms
Tested on RHEL 6.5 and CentOS 6.5. Should work on any Red Hat family distributions.

### Cookbooks
- yum
- yum-epel
- java
- iptables

Attributes
----------
- `default["java"]["install_flavor"]` = We are installing openjdk
- `default["java"]["jdk_version"]` = servicemix uses version 7
- `default["java"]["set_etc_environment"]` = This is set to true
- `default["servicemix"]["download_link"]` = This is the download link for the servicemix software
- `default["servicemix"]["file_name"]` = The name of the download file
- `default["servicemix"]["file_type"]` = The type of download file
- `default["servicemix"]["user_name"]` = The name of the user that will login to servicemix
- `default["servicemix"]["user_password"]` = The password for the user
- `default["servicemix"]["code_url"]` = The download link for the Custom Code
- `default["servicemix"]["code_file_name"]` = The name of code file

Usage
-----
Simply add the cookbook to your runlist or add the cookbook to a role you have created.


Deploying a servicemix Server
-----------
This section details "quick deployment" steps.

1. Install Chef Client


          $ curl -L https://www.opscode.com/chef/install.sh | sudo bash

2. Create a Chef repo folder and a cookbooks folder under the /tmp directory


          $ mkdir -p /tmp/chef/cookbooks
          $ cd /tmp/chef/

3. Create a solo.rb file


          $ vi /tmp/chef/solo.rb
         
               file_cache_path "/tmp/chef"
               cookbook_path "/tmp/chef/cookbooks"

4. Create a servicemix.json file, this will be the attributes file and contains the run_list


          $ vi /tmp/chef/servicemix.json
        
                {
                  "run_list": [
                  "recipe[chef-servicemix]"
                 ]
                }

5. Download and extract the cookbook dependencies:


          $ cd /tmp/chef/cookbooks
          $ knife cookbook site download ntp
          $ tar xvfz ntp-*.tar.gz
          $ rm -f ntp-*.tar.gz
          $ knife cookbook site download iptables
          $ tar xvfz iptables-*.tar.gz
          $ rm -f iptables-*.tar.gz
          $ knife cookbook site download java
          $ tar xvfz java-*.tar.gz
          $ rm -f java-*.tar.gz
          $ knife cookbook site download yum
          $ tar xvfz yum-*.tar.gz
          $ rm -f yum-*.tar.gz
          $ knife cookbook site download yum-epel
          $ tar xvfz yum-epel-*.tar.gz
          $ rm -f yum-epel-*.tar.gz


6. Download and extract the cookbook:


          $ cd /tmp/chef/cookbooks
          $ knife cookbook site download chef-servicemix
          $ tar xvfz chef-servicemix-*.tar.gz
          $ rm -f chef-servicemix-*.tar.gz
    
7. Run Chef-solo:


          $ cd /tmp/chef
          $ chef-solo -c solo.rb -j servicemix.json



License & Authors
-----------------
- Author:: Chris Kacerguis
- Author:: Mandeep Bal

```text
Copyright:: 2014, Booz Allen Hamilton

For more information on the license, please refer to the LICENSE.txt file in the repo
```
