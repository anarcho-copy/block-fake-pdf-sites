include make.config

all: faup-data psl-data

check: INSTALL ../src/check.sh
	@../src/check.sh

faup-data: $(TLD_FILE) /usr/local/share/faup/mozilla.tlds
	rm -rf ~/.faup
	sudo bash -c "faup -u && rm -f /usr/local/share/faup/custom_tlds_exists"
	sudo bash -c "cat $(TLD_FILE) >> /usr/local/share/faup/mozilla.tlds && touch /usr/local/share/faup/custom_tlds_exists"

psl-data: $(TLD_FILE)
	psl-make-dafsa --output-format=binary $(TLD_FILE) $(TLD_FILE).dafsa
