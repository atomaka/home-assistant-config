deploy: test
	rsync -a -e "ssh" --rsync-path="sudo rsync" ./ 192.168.1.20:/mnt/data/docker/ha/config/
	ssh 192.168.1.20 "cd /home/atomaka/docker && docker-compose restart ha"

download:
	rsync -a -e "ssh" --rsync-path="sudo rsync" 192.168.1.20:/mnt/data/docker/ha/config/ ./

test:
	docker run -v ${CURDIR}:/config homeassistant/home-assistant:latest python -m homeassistant -c /config --script check_config
