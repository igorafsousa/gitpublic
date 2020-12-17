sudo chown -R ubuntu:ubuntu /django

 mkdir -p /django/polls/templates/polls
 touch /django/polls/templates/polls/home.html


###############
###############
###############
############### CREATE TEMPLATE HOME

echo "" 						> /django/polls/templates/polls/home.html
echo "<form action="{% url \'password\' %}">" 		>> /django/polls/templates/polls/home.html
echo '<select name="lenght">' 				>> /django/polls/templates/polls/home.html

echo '<<option value="6" >6</option>' 	>> /django/polls/templates/polls/home.html
echo '<<option value="7" >7</option>' 	>> /django/polls/templates/polls/home.html
echo '<<option value="8" >8</option>' 	>> /django/polls/templates/polls/home.html
echo '<<option value="9" >9</option>' 	>> /django/polls/templates/polls/home.html

echo '</select>' >> /django/polls/templates/polls/home.html

echo '<input type="submit" value="submit">'	>> /django/polls/templates/polls/home.html

echo '</form>' >> /django/polls/templates/polls/home.html



###############
###############
###############
############### CREATE TEMPLATE PASSWORD


echo "<h1>PASSWORD</h1>"  >  /django/polls/templates/polls/password.html




###############
###############
###############
############### CORRECT URLS.PY ON PROJECT 


cp /django/projectmaster/urls.py /django/projectmaster/urls.py_bkp_2



echo -e  "from django.contrib import admin" | sudo tee -a /django/projectmaster/urls.py
echo -e  "from django.urls import include, path" | sudo tee -a /django/projectmaster/urls.py
echo -e  "urlpatterns = [" | sudo tee -a /django/projectmaster/urls.py

echo -e  "path('admin/', admin.site.urls)," | sudo tee -a /django/projectmaster/urls.py

echo -e  "path('', include('polls.urls'))," | sudo tee -a /django/projectmaster/urls.py

echo -e  "]" | sudo tee -a /django/projectmaster/urls.py






###############
###############
###############
############### CORRECT URLS.PY ON APP POLLS


cp /django/polls/urls.py /django/polls/urls.py_bkp_2

echo "" 								 > /django/polls/urls.py	
echo "from django.urls import path"					>> /django/polls/urls.py
echo "from . import views"						>> /django/polls/urls.py
echo "urlpatterns = ["						>> /django/polls/urls.py
echo "path('', views.index, name='index'),"				>> /django/polls/urls.py
echo "path('generatedpassword/', views.password, name='password'),"	>> /django/polls/urls.py		
echo "]"								>> /django/polls/urls.py



#
#from django.urls import path
#from . import views
#urlpatterns = [
#path('', views.index, name='index'),
#path('generatedpassword/', views.password, name='password'),
#]






###############
###############
###############
############### CHANGE ON VIEWS.PY ON APP

cp /django/polls/views.py /django/polls/views.py_bkp_2

echo ""								 > /django/polls/views.py
echo "from django.shortcuts import render" 			>> /django/polls/views.py
echo "from django.http import HttpResponse"			>> /django/polls/views.py
echo "def index(request):"					>> /django/polls/views.py
echo "         return render(request, 'polls/home.html')"	>> /django/polls/views.py


echo "def password(request):"					>> /django/polls/views.py
echo "         return render(request, 'polls/password.html')"	>> /django/polls/views.py










### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### MAKING MIGRATIONS

python3 /django/manage.py collectstatic --noinput
python3 /django/manage.py makemigrations
python3 /django/manage.py migrate




### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### 
### ### ### ### RESTART APACHE

sudo systemctl restart apache2.service




