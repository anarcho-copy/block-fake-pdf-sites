CONFIG = config.conf
include $(CONFIG)

help: .config/makehelp lib/makefile2help.sh
	@lib/makefile2help.sh -c $(CONFIG)

generate: $(TLD) $(SLD) $(LOGINREQ) $(WORDPRESS) $(SERVICE) $(ALLOW) $(STORE) $(OTHERSOURCES)/ lib/generate.sh
	@echo Generating configuration files...
	lib/generate.sh


generate-with-fetch: $(TLD) $(SLD) $(LOGINREQ) $(WORDPRESS) $(SERVICE) $(ALLOW) $(STORE) $(OTHERSOURCES)/ lib/generate.sh
	@echo fetching sources..
	@make -s fetch
	@make -s fetch-etherpad
	@echo generating configuration files...
	lib/generate.sh

generate-all: $(TLD) $(SLD) $(LOGINREQ) $(WORDPRESS) $(SERVICE) $(ALLOW) $(STORE) $(OTHERSOURCES)/ lib/generate.sh
	@echo generating configuration files...
	lib/generate.sh --all

generate-all-with-fetch: $(TLD) $(SLD) $(LOGINREQ) $(WORDPRESS) $(SERVICE) $(ALLOW) $(STORE) $(OTHERSOURCES)/ lib/generate.sh
	@echo fetching sources..
	@make -s fetch
	@make -s fetch-etherpad
	@echo generating configuration files...
	lib/generate.sh --all

clean:
	@echo removing configuration files...
	rm -rf $(UBLACKLIST) $(HOSTS) $(DNSMASQ) $(TEMP) $(RAW)

check: INSTALL lib/check.sh
	@lib/check.sh

fetch: $(OTHERSOURCES)/ lib/fetch.sh
	lib/fetch.sh

fetch-etherpad: $(OTHERSOURCES)/ lib/fetch.sh
	lib/etherpad.sh

install: $(DNSMASQ) $(UBLACKLIST) $(HOSTS) lib/hosts.sh
	@echo installing configuration files...
	cp $(DNSMASQ) $(GLOBALDNSMASQ) || true
	mkdir -p /etc/hosts.d
	cp $(HOSTS) $(GLOBALHOSTS)
	lib/hosts.sh --enable

uninstall: lib/hosts.sh
	@echo uninstalling configuration files...
	rm $(GLOBALHOSTS) $(GLOBALDNSMASQ) || true
	lib/hosts.sh --disable

dnsmasq:
	make clean
	make generate
	@echo installing dnsmasq configuration file...
	cp $(DNSMASQ) $(GLOBALDNSMASQ)
	@echo restarting DNS caching server...
	systemctl restart dnsmasq.service

test-with-list: lib/test.sh lib/google_url_extractor.py $(RAW)
	lib/test.sh -g -p 5

test: lib/test.sh lib/google_url_extractor.py
	lib/test.sh -gi -p 5

serve: lib/serve.sh $(CONFIG) $(BUILD_PATH)
	@make serve-kill || true
	@mkdir -p $(TEMP)
	@lib/serve.sh -c $(CONFIG) &>> $(TEMP)/server.log &
	@echo -e "\nhttp://$(TEMP_SERVER_BIND):$(TEMP_SERVER_PORT)\n"

serve-kill:
	@ps a | grep $(TEMP_SERVER_PORT) | head -1 | awk '{print $$1}' | xargs kill -SEGV &>/dev/null
