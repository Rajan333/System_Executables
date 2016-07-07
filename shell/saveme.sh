ssh influx_db "sudo service influxdb restart"
ssh lumber "sudo service rabbitmq-server restart && sudo supervisorctl restart lumber"

