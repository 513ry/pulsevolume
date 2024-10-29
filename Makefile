FILES=pulsevolume.service pulsevolume.sh
BUILD=/usr/local/bin/pulsevolume.sh /etc/systemd/system/pulsevolume.service
USER_ID=$(shell id -u $$USER)

.PHONY: all install uninstall

all: install enable

pulsevolume.service: pulsevolume.service.temp
	$(shell sed 's/<user>/$(USER)/g' $^ >$@)
	$(shell sed -i 's/<user_id>/$(USER_ID)/g' $@)

install: $(FILES)
	cp pulsevolume.sh /usr/local/bin/
	cp pulsevolume.service /etc/systemd/system/

uninstall: $(BUILD)
	rm /usr/local/bin/pulsevolume.sh
	rm /etc/systemd/system/pulsevolume.service

enable: $(BUILD)
	$(shell systemctl daemon-reload)
	$(shell systemctl enable pulsevolume.service)
	$(shell systemctl start pulsevolume.service)

stop: $(BUILD)
	$(shell systemctl stop pulsevolume.service)

reload: $(BUILD)
	$(shell systemctl daemon-reload)
	$(shell systemctl restart pulsevolume.service)
