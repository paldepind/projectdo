PREFIX ?= /usr
MANDIR = $(PREFIX)/share/man
BINARY_NAME = projectdo

all:
	@echo RUN \'make install\' to install $(BINARY_NAME)
	@echo RUN \'make uninstall\' to uninstall $(BINARY_NAME)
	@echo RUN \'make manpage\' to generate manpage for $(BINARY_NAME)
	@echo RUN \'make test\' to run tests for $(BINARY_NAME)

install:
	@install -Dm755 $(BINARY_NAME) $(DESTDIR)$(PREFIX)/bin/$(BINARY_NAME)
	@mkdir -p $(DESTDIR)$(MANDIR)/man1
	@cp -p man/$(BINARY_NAME).1 $(DESTDIR)$(MANDIR)/man1

manpage:
	@if [ -n "$(shell command -v pandoc)" ]; then \
		pandoc --standalone --to man man/$(BINARY_NAME).1.md --output man/$(BINARY_NAME).1; \
		echo "SUCCESS: manpage generated"; \
	else \
		echo "ERROR: could not generate manpage. Pandoc not found."; \
	fi

version:
	@sh -c docs/version_changer.sh

uninstall:
	@rm -f $(DESTDIR)$(PREFIX)/bin/$(BINARY_NAME)
	@rm -rf $(DESTDIR)$(MANDIR)/man1/$(BINARY_NAME).1*

test:
	sh run-tests.sh
