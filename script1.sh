#!/bin/sh


### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### BASIC CONFIGURATION 



sleep 10
sudo apt install -y net-tools
sleep 10
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
### ### ### ### INSTALL >> UPDATE + GIT + PYTHON3

sleep 10
sudo apt-get update -y
sudo apt install build-essential -y
sudo apt install python3 -y
sudo apt install git -y 
sudo mkdir -p /django/git
#sudo chown ubuntu:ubuntu -R /django/git
#git init /django/git





### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### PREPARING EBS 

sleep 10
sudo mkdir -p /django
sudo file -s /dev/xvdb
sudo mkfs -t xfs /dev/xvdb
sudo mount /dev/xvdb   /django
sudo chown -R ubuntu /django
#sudo chown -R ubuntu /django






### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### AUTOMATICALLY MOUNT EBS 

sleep 10
sudo cp /etc/fstab /etc/fstab.orig
#sudo lsblk -o +UUID | grep -i django
#sudo lsblk -o +UUID | grep -i django | awk {'print $8'}
VARABLENAME="$(sudo lsblk -o +UUID | grep -i django | awk {'print $8'})"
echo "UUID=$VARABLENAME  /django  xfs  defaults,nofail  0  2" | sudo tee -a  /etc/fstab >> /dev/null
sudo umount -l /django
sudo mount -a




### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### INSTALLING PIP3 + POSTGREE

sleep 10
sudo apt-get update -y
sudo apt install python3-pip -y
sudo apt-get install postgresql postgresql-contrib -y
sudo apt-get install -y libpq-dev
sudo pip3 install psycopg2





### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### INSTALLING DJANGO

sleep 10
sudo apt-get update -y
sudo apt install python3-django -y
sudo pip3 install dnspython
sudo pip3 install django
mkdir -p /django/projectmaster
django-admin startproject projectmaster /django
python3 /django/manage.py makemigrations
python3 /django/manage.py migrate


sleep 10


echo "listen_addresses = '*'"  | sudo tee -a /etc/postgresql/12/main/postgresql.conf
echo "host  all  all 0.0.0.0/0 md5"  | sudo tee -a /etc/postgresql/12/main/pg_hba.conf

sudo service postgresql restart

sudo -u postgres psql -c "CREATE ROLE usrdbdjangoprojectmaster LOGIN SUPERUSER PASSWORD 'masterpwdhorus'"
sudo -u postgres psql -c "CREATE DATABASE dbprojectmaster"

sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE dbprojectmaster to usrdbdjangoprojectmaster"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE dbprojectmaster to postgres"






sleep 10
#python3 /django/manage.py createsuperuser
echo "from django.contrib.auth.models import User; User.objects.create_superuser('usrdjangoprojectmaster', '', 'masterpwdhorus')" | python3 /django/manage.py shell






### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### PREPARING SETTINGS.PY

sleep 10
cp /django/projectmaster/settings.py /django/projectmaster/settings.py_bkp_1

nawk '/DATABASES/ {c=6} c && c-- {next}1' /django/projectmaster/settings.py_bkp_1 > /django/projectmaster/settings.py
echo "DATABASES = {    'default': {        'ENGINE': 'django.db.backends.postgresql',        'NAME': 'dbprojectmaster',        'USER': 'usrdbdjangoprojectmaster',        'PASSWORD': 'masterpwdhorus',        'HOST': '$VARABLENAME2',        'PORT': '5432',    }}" >> /django/projectmaster/settings.py
sed -i '/ALLOWED_HOSTS/d' /django/projectmaster/settings.py
echo "ALLOWED_HOSTS = ['$VARABLENAME3']" >> /django/projectmaster/settings.py
sed -i '/SECRET_KEY/d' /django/projectmaster/settings.py
echo "SECRET_KEY = '$VARABLENAME4'" >> /django/projectmaster/settings.py
echo "print(BASE_DIR)"  >> /django/projectmaster/settings.py

