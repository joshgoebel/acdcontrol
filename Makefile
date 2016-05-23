RELEASE_FILES=99-acdcontrol.rules acdcontrol.cpp acdcontrol.init acdcontrol.sysconfig COPYING COPYRIGHT Makefile VERSION
VERSION=$(shell cat VERSION)
VERNAME=acdcontrol-$(VERSION)
DIRNAME=/tmp/$(VERNAME)

acdcontrol: acdcontrol.cpp

99-acdcontrol.rules: acdcontrol
	./acdcontrol -l | sed --r -e 's/Vendor= 0x([0-9a-f]*) \(.*\), Product=0x([0-9a-f]*) \[(.*)\]/\# \3\nATTR{idVendor}=\"\1\", ATTR{idProduct}=\"\2\", MODE=\"0666\"/g' > 99-acdcontrol.rules

release:
	mkdir -p $(DIRNAME)
	rm -rf $(DIRNAME)/*
	cp $(RELEASE_FILES) $(DIRNAME)
	tar cvfz $(VERNAME).tar.gz -C /tmp $(VERNAME) 

upload:
	curl -T $(VERNAME).tar.gz ftp://anonymous@upload.sourceforge.net/incoming/
