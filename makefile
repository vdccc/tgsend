install: /usr/local/bin/tgsend.sh /etc/systemd/system/tgsend.up.service /etc/systemd/system/tgsend.down.service
	install tgsend.sh /usr/local/bin/tgsend.sh
	install tgsend.up.service /etc/systemd/system/tgsend.up.service
	install tgsend.down.service /etc/systemd/system/tgsend.down.service
	systemctl enable tgsend.up
	systemctl enable tgsend.down
