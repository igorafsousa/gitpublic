#!/bin/sh


### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### BASIC CONFIGURATION 





export VARABLENAME2="$(ifconfig | grep -i inet | head -1 | awk {'print $2'})"
export VARABLENAME3="$(dig +short myip.opendns.com @resolver1.opendns.com)"
VARABLENAME2="$(ifconfig | grep -i inet | head -1 | awk {'print $2'})"
VARABLENAME3="$(dig +short myip.opendns.com @resolver1.opendns.com)"
#export DJANGO_SETTINGS_MODULE=projectmaster.settings
VARABLENAME4="$(echo $VARABLENAME2 | sha256sum | awk '{print $1}')"







### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### MAKING MIGRATIONS



python3 /django/manage.py makemigrations
python3 /django/manage.py migrate
#sudo pip3 install djongo











### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### CREATING APP POLLS 



### ### ### ### CREATING APP


cd /django
python3 /django/manage.py startapp polls




### ### ### ### MODIFYING MODELS.PY (APP)


#sed -i '/django.db/d' /django/polls/models.py
#echo "from django.db import models" >> /django/polls/models.py





### ### ### ### MODIFYING VIEWS.PY (APP)


mv /django/polls/views.py /django/polls/views.py_bkp_1

echo -e  "from django.shortcuts import render" | sudo tee -a  /django/polls/views.py
echo -e  "from django.http import HttpResponse" | sudo tee -a  /django/polls/views.py
echo -e  "def index(request):" | sudo tee -a  /django/polls/views.py
echo -e  '         return HttpResponse("Hello, world. You're at the polls index.'")''' | sudo tee -a  /django/polls/views.py




### ### ### ### MODIFYING URLS.PY (APP)


echo -e  "from django.urls import path" | sudo tee -a  /django/polls/urls.py
echo -e  "from . import views" | sudo tee -a  /django/polls/urls.py
echo -e  "urlpatterns = [" | sudo tee -a  /django/polls/urls.py
echo -e  "path('', views.index, name='index')," | sudo tee -a  /django/polls/urls.py
echo -e  "]" | sudo tee -a  /django/polls/urls.py




### ### ### ### MODIFYING URLS.PY  (PROJECT)


mv /django/projectmaster/urls.py /django/projectmaster/urls.py_bkp_1

echo -e  "from django.contrib import admin" | sudo tee -a /django/projectmaster/urls.py
echo -e  "from django.urls import include, path" | sudo tee -a /django/projectmaster/urls.py
echo -e  "urlpatterns = [" | sudo tee -a /django/projectmaster/urls.py
echo -e  "path('polls/', include('polls.urls'))," | sudo tee -a /django/projectmaster/urls.py
echo -e  "path('admin/', admin.site.urls)," | sudo tee -a /django/projectmaster/urls.py
echo -e  "]" | sudo tee -a /django/projectmaster/urls.py










### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### MAKING MIGRATIONS


python3 /django/manage.py makemigrations
python3 /django/manage.py migrate











### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### ADDING APP TO INSTALLED_APPS


VARABLENAME31="'polls',"
sed -i "/django.contrib.staticfiles/a     $VARABLENAME31  " /django/projectmaster/settings.py

VARABLENAME32="'projectmaster',"
sed -i "/django.contrib.staticfiles/a     $VARABLENAME32  " /django/projectmaster/settings.py

echo "import django"  >> /django/projectmaster/settings.py
echo "django.setup()" >> /django/projectmaster/settings.py





### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### MAKING MIGRATIONS


python3 /django/manage.py makemigrations
python3 /django/manage.py migrate









### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### RUNNING DJANGO WITH MANAGE.PY

export VARABLENAME2="$(ifconfig | grep -i inet | head -1 | awk {'print $2'})"
export VARABLENAME3="$(dig +short myip.opendns.com @resolver1.opendns.com)"

VARABLENAME2="$(ifconfig | grep -i inet | head -1 | awk {'print $2'})"
VARABLENAME3="$(dig +short myip.opendns.com @resolver1.opendns.com)"


#nohup python3 /django/manage.py runserver $VARABLENAME2:8000 &

sleep 2
   










### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### INSTALL APACHE

sudo apt-get update -y
sudo apt install apache2 apache2-dev -y
#sudo ufw enable
#sudo ufw default allow incoming
#sudo ufw default allow outgoing
#sudo ufw allow ssh
#sudo ufw allow 22
#sudo ufw app list
#sudo ufw allow 'Apache'
sudo systemctl status apache2



sudo systemctl stop apache2.service

#sudo vi /etc/apache2/apache2.conf
#sudo systemctl start apache2.service
#sudo systemctl restart apache2.service
#sudo systemctl status apache2.service










### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### INSTALL WSGI 


#https://pypi.org/project/mod-wsgi/4.7.0/





sudo pip3 install mod_wsgi

VARABLENAME7="'mod_wsgi.server',"
sed -i "/django.contrib.staticfiles/a     $VARABLENAME7  " /django/projectmaster/settings.py

sed -i '/STATIC_URL/d' /django/projectmaster/settings.py


echo "STATIC_URL = '/static/'"                             >> /django/projectmaster/settings.py
echo "STATIC_ROOT = os.path.join(BASE_DIR, 'static')"      >> /django/projectmaster/settings.py






### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### CONFIGURING WSGI FILE TO USE WITH APACHE



cp /django/projectmaster/wsgi.py /django/projectmaster/wsgi.py_bkp



VARABLENAME333="$(sudo find / -iname dist-packages | grep -i /usr/local/lib | grep -vi snap | grep -vi core)"



echo "import os" >   /django/projectmaster/wsgi.py 
echo "import sys" >> /django/projectmaster/wsgi.py 
echo "import site" >> /django/projectmaster/wsgi.py 
#echo "site.addsitedir('/home/ubuntu/.local/lib/python3.8/site-packages')" >> /django/projectmaster/wsgi.py 
echo "site.addsitedir('$VARABLENAME333')" >> /django/projectmaster/wsgi.py 
echo "sys.path.append('/django/projectmaster')" >> /django/projectmaster/wsgi.py 
echo "sys.path.append('/django')" >> /django/projectmaster/wsgi.py 
echo "os.environ['DJANGO_SETTINGS_MODULE'] = 'projectmaster.settings'" >> /django/projectmaster/wsgi.py 
echo "import django.core.handlers.wsgi" >> /django/projectmaster/wsgi.py 
echo "application = django.core.handlers.wsgi.WSGIHandler()" >> /django/projectmaster/wsgi.py 




#/django/projectmaster/wsgi.py ( EXEMPLO )

#####import os
#####import sys
#####import site
#####
###### Add the site-packages of the chosen virtualenv to work with
#####site.addsitedir('/home/ubuntu/.local/lib/python3.8/site-packages')
#####
###### Add the app's directory to the PYTHONPATH
#####sys.path.append('/django/projectmaster')
#####sys.path.append('/django')
#####os.environ['DJANGO_SETTINGS_MODULE'] = 'projectmaster.settings'
#####import django.core.handlers.wsgi
#####application = django.core.handlers.wsgi.WSGIHandler()









### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### MAKING MIGRATIONS

python3 /django/manage.py collectstatic --noinput
python3 /django/manage.py makemigrations
python3 /django/manage.py migrate
python3 /django/manage.py sqlmigrate polls 002







### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### CONFIGURION LoadModule on apache2.conf AND Apache configuration



# /home/ubuntu/.local/bin/mod_wsgi-express module-config


#VARABLENAME5='LoadModule wsgi_module "/home/ubuntu/.local/lib/python3.8/site-packages/mod_wsgi/server/mod_wsgi-py38.cpython-38-x86_64-linux-gnu.so"'
#VARABLENAME6='WSGIPythonHome "/usr"'


VARABLENAME51="$(mod_wsgi-express module-config | head -1)"
VARABLENAME61="$(mod_wsgi-express module-config | tail -1)"

sudo sed -i "/Include module configuration/a  $VARABLENAME51   " /etc/apache2/apache2.conf
sudo sed -i "/wsgi_module/a  $VARABLENAME61   " /etc/apache2/apache2.conf





sudo sed -i "/WSGIPythonHome/a  WSGIScriptAlias / /django/projectmaster/wsgi.py  #WSGICONGIXX1  " /etc/apache2/apache2.conf
sudo sed -i "/WSGICONGIXX1/a  <Directory /django/polls> #WSGICONGIXX2  " /etc/apache2/apache2.conf
sudo sed -i "/WSGICONGIXX2/a  <Files wsgi.py>  #WSGICONGIXX3 " /etc/apache2/apache2.conf
sudo sed -i "/WSGICONGIXX3/a  Require all granted  #WSGICONGIXX4 " /etc/apache2/apache2.conf
sudo sed -i "/WSGICONGIXX4/a  </Files>  #WSGICONGIXX5 " /etc/apache2/apache2.conf
sudo sed -i "/WSGICONGIXX5/a  </Directory>  #WSGICONGIXX6 " /etc/apache2/apache2.conf


sudo sed -i "/WSGICONGIXX6/a  Alias /static/ /django/static/  #WSGICONGIXX7 " /etc/apache2/apache2.conf
sudo sed -i "/WSGICONGIXX7/a  <Directory /django/static/>  #WSGICONGIXX8 " /etc/apache2/apache2.conf
sudo sed -i "/WSGICONGIXX8/a  Require all granted  #WSGICONGIXX9 " /etc/apache2/apache2.conf
sudo sed -i "/WSGICONGIXX9/a  </Directory>  #WSGICONGIXX610 " /etc/apache2/apache2.conf





sudo sed -i 's/#WSGICONGIXX1//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX2//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX3//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX4//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX5//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX6//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX7//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX8//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX9//' /etc/apache2/apache2.conf
sudo sed -i 's/#WSGICONGIXX10//' /etc/apache2/apache2.conf





#####WSGIScriptAlias / /django/projectmaster/wsgi.py
#####<Directory /django/polls>
#####<Files wsgi.py>
#####Require all granted
#####</Files>
#####</Directory>




#Alias /static/ /django/static/
#<Directory /django/static/>
#Require all granted
#</Directory>





sudo sed -i '0,/denied/s//granted/' /etc/apache2/apache2.conf


sudo systemctl restart apache2.service






#sudo systemctl restart apache2.service
#sudo cat /etc/apache2/apache2.conf  
#sudo vi /etc/apache2/apache2.conf    
#tail -f /var/log/apache2/error.log
#python3 /django/manage.py runmodwsgi
#/home/ubuntu/.local/bin/mod_wsgi-express start-server
#apachectl -M


















