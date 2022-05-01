CONFIG = config.conf
include $(CONFIG)

help: .config/makehelp lib/makefile2help.sh
	@lib/makefile2help.sh -c $(CONFIG)

generate: $(TLD) $(SLD) $(LOGINREQ) $(WORDPRESS) $(SERVICE) $(ALLOW) $(STORE) lib/generate.sh
	@echo Generating configuration files...
	lib/generate.sh

generate-all: $(TLD) $(SLD) $(LOGINREQ) $(WORDPRESS) $(SERVICE) $(ALLOW) $(STORE) lib/generate.sh
	@echo Generating configuration files...
	lib/generate.sh --all

clean:
	@echo Removing configuration files...
	rm -rf $(UBLACKLIST) $(HOSTS) $(DNSMASQ) $(TEMP) $(RAW)

check: INSTALL lib/check.sh
	@lib/check.sh

install: $(DNSMASQ) $(UBLACKLIST) $(HOSTS) lib/hosts.sh
	@echo Installing configuration files...
	cp $(DNSMASQ) $(GLOBALDNSMASQ)
	cp $(HOSTS) $(GLOBALHOSTS)
	lib/hosts.sh --enable

uninstall: lib/hosts.sh
	@echo Uninstalling configuration files...
	rm $(GLOBALHOSTS) $(GLOBALDNSMASQ)
	lib/hosts.sh --disable

dnsmasq:
	make clean
	make generate
	@echo Installing dnsmasq configuration file...
	cp $(DNSMASQ) $(GLOBALDNSMASQ)
	@echo Restarting DNS caching server...
	systemctl restart dnsmasq.service

test-with-list: lib/test.sh lib/google_url_extractor.py $(RAW)
	lib/test.sh -g -p 5

test: lib/test.sh lib/google_url_extractor.py
	lib/test.sh -gi -p 5
