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
Simply add `role[esb]` to a run list.


Deploying a servicemix Server
-----------
This section details "quick deployment" steps.

1. Clone this repository from GitHub:

        $ git clone git@github.com:booz-allen-hamilton/servicemix.git

2. Change directory to the repo folder

        $ cd servicemix-cookbook

3. Create a solo.rb file

    $ vim solo.rb

      file_cache_path "/root/chef-repo"
      cookbook_path "/root/chef-repo/cookbooks"


3. Install dependencies:

        Download the dependent cookbooks from Chef Supermarket

4. Install Chef Client

    $ curl -L https://www.opscode.com/chef/install.sh | sudo bash

5. Run Chef-solo:

    $ chef-solo -c solo.rb -j roles/esb.json


License & Authors
-----------------
- Author:: Chris Kacerguis
- Author:: Mandeep Bal

```text
Copyright:: 2014, Booz Allen Hamilton

For more information on the license, please refer to the LICENSE.txt file in the repo
```
