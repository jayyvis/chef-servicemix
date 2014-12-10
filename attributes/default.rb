#General Variables for cookbook
#
default["java"]["install_flavor"] = "openjdk"
default["java"]["jdk_version"] = "7"
default["java"]["set_etc_environment"] = "true"
default["servicemix"]["download_link"] = "http://apache.claz.org/servicemix/servicemix-5/5.1.4/apache-servicemix-5.1.4.zip"
default["servicemix"]["file_name"] = "apache-servicemix-5.1.4"
default["servicemix"]["file_type"] = "zip"
default["servicemix"]["user_name"] = "servicemixadmin"
default["servicemix"]["user_password"] = "password"
default["servicemix"]["code_url"] = "https://github.com/booz-allen-hamilton/servicemix/raw/master/bin/ce-routes-1.0.3.kar"
default["servicemix"]["code_file_name"] = "ce-routes-1.0.3.kar"
