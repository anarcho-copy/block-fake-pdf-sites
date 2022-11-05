include make.config

help: .config/makehelp src/makefile2help.sh
	@src/makefile2help.sh -c $(CONFIG)

generate: $(BLACKLIST_DOMAINS) $(WASTE_LOGIN_REQUIRED) $(WHITELIST_DOMAINS) $(WHITELIST_TURKISH_BOOKSTORES) $(OTHER_HOSTS_SOURCES)/ $(OTHER_UBLACKLIST_SOURCES)/ src/generate.sh /usr/local/share/faup/custom_tlds_exists
	make check
	@echo Generating files...
	src/generate.sh

generate-with-fetch:
	@echo fetching sources..
	@make -s fetch
	@make -s fetch-etherpad
	make generate

generate-all: $(BLACKLIST_DOMAINS) $(WASTE_LOGIN_REQUIRED) $(WHITELIST_DOMAINS) $(WHITELIST_TURKISH_BOOKSTORES) $(OTHER_HOSTS_SOURCES)/ $(OTHER_UBLACKLIST_SOURCES)/ src/generate.sh
	make check
	@echo Generating all files...
	src/generate.sh --all

generate-all-with-fetch:
	@echo fetching sources..
	@make -s fetch
	@make -s fetch-etherpad
	make generate-all

clean:
	@echo removing configuration files...
	rm -rf $(UBLACKLIST) $(HOSTS) $(DNSMASQ) $(TEMP) $(RAW)

check: INSTALL src/check.sh
	@echo Checking requirements...
	@src/check.sh

fetch: $(OTHER_HOSTS_SOURCES)/ $(OTHER_UBLACKLIST_SOURCES)/ src/fetch.sh
	src/fetch.sh

fetch-etherpad: $(OTHER_UBLACKLIST_SOURCES)/ src/etherpad.sh
	src/etherpad.sh

install-hosts: $(HOSTS) src/hosts.sh
	@echo installing hosts file...
	sudo mkdir -p /etc/hosts.d
	sudo cp $(HOSTS) $(GLOBALHOSTS)
	sudo src/hosts.sh --enable

uninstall-hosts: $(GLOBALHOSTS)  src/hosts.sh
	@echo uninstalling hosts file...
	sudo rm $(GLOBALHOSTS) || true
	sudo src/hosts.sh --disable

serve: src/serve.sh $(CONFIG) $(BUILD_PATH)
	@make serve-kill || true
	@mkdir -p $(TEMP)
	@src/serve.sh -c $(CONFIG) &>> $(TEMP)/server.log &
	@echo -e "\nhttp://$(TEMP_SERVER_BIND):$(TEMP_SERVER_PORT)\n"

serve-kill:
	@ps a | grep $(TEMP_SERVER_PORT) | head -1 | awk '{print $$1}' | xargs kill -SEGV &>/dev/null

public-suffix-list:
	make -C list/ check
	make -C list/ all

/usr/local/share/faup/custom_tlds_exists:
	make -C list/ faup-data

src/build:
	run-parts src/build

.PHONY: src/build
