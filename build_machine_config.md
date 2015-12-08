  sudo apt-get update  
  sudo apt-get upgrade  
  wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -  
  sudo apt-get install vim build-essential apache2 git cmake libncurses5-dev zip unzip   
  sudo vim /etc/sources.list  
  # Add this line:  
  # deb http://pkg.jenkins-ci.org/debian binary/  

  sudo apt-get update  
  sudo apt-get install jenkins  

  sudo a2enmod proxy  
  sudo a2enmod proxy_http  
  sudo vim /etc/apache2/mods-enabled  
  sudo vim /etc/apache2/sites-enabled/000-default  

</code>
