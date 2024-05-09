PREFIX ?= /usr
BINARY_NAME = projectdo

all:
	@echo RUN \'make install\' to install $(BINARY_NAME)
	@echo RUN \'make uninstall\' to uninstall $(BINARY_NAME)
	@echo RUN \'make test\' to run tests for $(BINARY_NAME)

install:
	@install -Dm755 $(BINARY_NAME) $(DESTDIR)$(PREFIX)/bin/$(BINARY_NAME)

uninstall:
	@rm -f $(DESTDIR)$(PREFIX)/bin/$(BINARY_NAME)

test:
	sh run-tests.sh
