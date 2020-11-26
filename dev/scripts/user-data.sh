#!/bin/bash

# install neccessary dependency
sudo yum update -y
sudo yum install -y git gcc readline-devel openssl-devel mysql-devel ImageMagick-devel mercurial
sudo amazon-linux-extras install nginx1.12 lamp-mariadb10.2-php7.2 -y
# sudo npm install yarn -g

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
cd ./redmine

# install bundler, rails, unicorn for ruby
echo "gem 'unicorn'" >> Gemfile
gem install bundler rails webpacker unicorn mysql2 puma rmagick
bundle

git clone -q https://github.com/khanhdoduc/ha-rails.git ha-rails

# configure unicorn
mkdir -p shared/pids shared/sockets shared/log
cp ./ha-rails/dev/scripts/unicorn.rb ./config/unicorn.rb

# create unicorn init script
sudo cp ./ha-rails/dev/scripts/unicorn_redmine /etc/init.d/unicorn_redmine
sudo chmod 755 /etc/init.d/unicorn_redmine
sudo chkconfig --add unicorn_redmine
# sudo service unicorn_redmine start

# configure nginx
sudo cp ha-rails/dev/scripts/nginx.conf /etc/nginx/nginx.conf
sudo service nginx restart

# mkdir -p shared/pids shared/sockets shared/log
# vi /etc/init.d/unicorn_helloworld
# sudo chmod 755 /etc/init.d/unicorn_helloworld
# sudo chkconfig --add unicorn_helloworld
# sudo mkdir /etc/nginx/sites-available
# sudo mkdir /etc/nginx/sites-enabled
# sudo vi /etc/nginx/nginx.conf