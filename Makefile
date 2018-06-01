deploy: test config
	rsync --verbose --archive --recursive --rsh="ssh" --exclude-from ".rsync-exclude" --rsync-path="sudo rsync" ./ 192.168.1.20:/mnt/data/docker/ha/config/
	ssh 192.168.1.20 "cd /home/atomaka/docker && docker-compose restart ha hadashboard"

download:
	rsync -a -e "ssh" --rsync-path="sudo rsync" 192.168.1.20:/mnt/data/docker/ha/config/ ./

config:
	sed 's/:.*$$/:/g' secrets.yaml > secrets.yaml.sample
	sed 's/:.*$$/:/g' dashboards/secrets.yaml > dashboards/secrets.yaml.sample

test:
	docker run -v ${CURDIR}:/config homeassistant/home-assistant:latest python -m homeassistant -c /config --script check_config
	docker run -v ${CURDIR}:/config homeassistant/home-assistant:latest python -m homeassistant --version > .HA_VERSION

update:
	docker pull homeassistant/home-assistant
	$(MAKE) test
	ssh 192.168.1.20 "cd /home/atomaka/docker && docker-compose pull ha && docker-compose up -d --no-deps --build ha"
	scp 192.168.1.20:/mnt/data/docker/ha/config/.HA_VERSION .
