from django.db import models

class Product(models.Model):
    title       = models.CharField(max_lenght=120) # max_lenght = required
    description = models.TextField(blank=True, null=True)
    price       = models.DecimalField(decimal_places=2, max_digits=10000)
    summary     = models.TextField(blank=False, null=False)
    featured    = models.BooleanField(default=False) # null=True, default=True
