# Install all basic components of a server

execute 'update-upgrade' do
	command 'apt-get update && apt-get upgrade -y'
	action:run
end

#Install oh-my-zsh and git

execute 'installing-zsh-and-git' do
	command 'apt-get install zsh git-core -y && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh && chsh -s `which zsh`'
action :run
end

%w{python-pip nginx build-essential zip unzip mysql-server npm nodejs jq mosh supervisor rabbitmq-server python-dev postgresql python-psycopg2 libpq-dev }.each do |pkg|
	package pkg do
		action :install
	end
end

execute 'downloading from git' do 
	command 'mkdir git && cd git && git init --bare && wget -O hooks/post-receive https://gist.githubusercontent.com/Rajan333/5baa2d0d011bf589d80ad7fffcfc4ac3/raw/00d0ad931c9a4efe874a02a3e51001d9bd1138a1/post-receive && cd && git clone https://github.com/PressPlayTV/siege.git'
	action :run
end

execute 'Downloading supervisor configuration...' do
    command 'wget -O /etc/supervisor/conf.d/trebuchet.conf https://gist.githubusercontent.com/Rajan333/e95f322d3c99b6539f14cf8594bdbc1e/raw/25aa502f1b73f66a3efcff28342c323d389b15ed/trebuchet.conf && wget -O /etc/supervisor/conf.d/cannon.conf https://gist.githubusercontent.com/Rajan333/d4b5cc96268ef9ec73a01636eb472e86/raw/218813afc57a4cc2c60ababe20e14d10af5c43bd/cannon.conf && service supervisor restart'
    action :run
end


