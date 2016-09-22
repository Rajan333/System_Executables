# Install all basic components of a server

execute 'update-upgrade' do
	command 'apt-get update && apt-get upgrade -y'
	action:run
end

#Install oh-my-zsh and git

execute 'installing-zsh-and-git' do
	command 'apt-get install zsh git-core -y && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh && chsh -s `which zsh` ubuntu'
action :run
end

%w{python-pip nginx build-essential youtube-dl zip unzip mysql-server npm nodejs jq mosh supervisor rabbitmq-server python-dev postgresql python-psycopg2 libpq-dev }.each do |pkg|
	package pkg do
		action :install
	end
end

