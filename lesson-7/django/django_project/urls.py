from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('', lambda request: None),
    path('admin/', admin.site.urls),
]
