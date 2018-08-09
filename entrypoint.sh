#!/bin/bash

first_lock="/bgmi_install.lock"
bangumi_db="$BGMI_PATH/bangumi.db"
transmission_setting="/bgmi/conf/transmission/settings.json"

data_source="bangumi_moe"	#default data source set to bangumi.moe
admin_token="bgmi_token" #default admin token

pid=0

function init_proc {
	touch $first_lock

	if [ ! -z $BGMI_ADMIN_TOKEN ]; then
		admin_token=$BGMI_ADMIN_TOKEN
	fi

	if [ ! -z $BGMI_SOURCE ]; then
		data_source=$BGMI_SOURCE
	fi

	if [ ! -f $bangumi_db ]; then
		bgmi install
		bgmi source $data_source
		bgmi config ADMIN_TOKEN $admin_token
		bgmi config SAVE_PATH /bgmi/bangumi
		bgmi config DOWNLOAD_DELEGATE transmission-rpc
	else
		bgmi upgrade
		bash /home/bgmi-docker/BGmi/bgmi/others/crontab.sh
	fi

	mkdir -p /var/run/nginx
	mkdir -p /bgmi/conf/bgmi
	mkdir -p /bgmi/conf/transmission
	mkdir -p /bgmi/log
	mkdir -p /bgmi/bangumi
	mkdir -p /etc/supervisor.d

	cp /home/bgmi-docker/config/bgmi_nginx.conf /etc/nginx/conf.d/default.conf
	cp /home/bgmi-docker/config/bgmi_supervisord.ini /etc/supervisor.d/bgmi_supervisord.ini
	cp /home/bgmi-docker/config/transmission-daemon /etc/conf.d/transmission-daemon
	
	if [ ! -f $transmission_setting ]; then
		cp /home/bgmi-docker/config/transmission_settings.json $transmission_setting
	fi
}

function exit_proc {
	kill ${!}
	kill -SIGTERM "$pid"
	wait "$pid"
	exit 143;
}

if [ ! -f $first_lock ]; then
	init_proc
fi

trap 'exit_proc' SIGINT
trap 'exit_proc' SIGTERM
trap 'exit_proc' SIGQUIT

/usr/bin/supervisord -n &
pid="$!"

while true
do
	tail -f /dev/null & wait ${!}
done
