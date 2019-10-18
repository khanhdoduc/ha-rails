#!/bin/bash

# install neccessary dependency
yum update -y
yum install -y git gcc readline-devel openssl-devel mysql-devel nodejs ImageMagick-devel mercurial
sudo amazon-linux-extras install nginx1.12 -y
sudo amazon-linux-extras install lamp-mariadb10.2-php7.2
sudo npm install yarn -g

# install ruby version manager rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# install plugin ruby-build
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
exec $SHELL

# install ruby
rbenv install 2.6.5
rbenv global 2.6.5

hg clone --updaterev 4.0-stable https://bitbucket.org/redmine/redmine-all redmine
cd /redmine

# install bundler, rails, unicorn for ruby
gem install bundler rails webpacker unicorn mysql2 puma rmagick
bundle


# mkdir -p shared/pids shared/sockets shared/log
# vi /etc/init.d/unicorn_helloworld
# sudo chmod 755 /etc/init.d/unicorn_helloworld
# sudo chkconfig --add unicorn_helloworld
# sudo mkdir /etc/nginx/sites-available
# sudo mkdir /etc/nginx/sites-enabled
# sudo vi /etc/nginx/nginx.conf