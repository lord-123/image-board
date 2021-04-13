# basically my personal notes this is very early days

- requires `mysql-server` `ImageMagick` `apache2` `libapache2-mod-parser3` `libmysqlclient-dev`
- install mysql drivers from parser 3 website into `/usr/lib/parser3` as debian repo is broken
- `sudo a2enmod rewrite`
- `sudo a2enmod mpm_prefork`
- `chmod +x compress.sh`
- The `apache2` folder should go to `/etc/apache2`
- `image-board` goes to `/var/www/image-board` (or whatever you want to call it)
- `*.example` files should be edited and renamed without `.example`
- Run `sql/createdb.sql` to generate the database. Run `sql/populate.sql` to fill with some dummy data for testing.
-----
- Install script is to be made