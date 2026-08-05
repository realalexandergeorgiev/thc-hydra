STRIP=strip
XDEFINES= -DLIBOPENSSL -DLIBNCURSES -DLIBSSH -DHAVE_ZLIB -DHAVE_MATH_H -DHAVE_SYS_PARAM_H
XLIBS= -lz -lcurses -lssl -lssh -lcrypto
XLIBPATHS=-L/usr/lib -L/usr/local/lib -L/lib -L/lib/x86_64-linux-gnu
XIPATHS= -I/usr/include
PREFIX=/usr/local
XHYDRA_SUPPORT=
STRIP=strip

HYDRA_LOGO=
PWI_LOGO=
SEC=-fPIE -fstack-protector-all --param ssp-buffer-size=4 -D_FORTIFY_SOURCE=2
LDSEC= -pie -Wl,-z,now -Wl,-z,relro -Wl,--allow-multiple-definition

#
# Makefile for Hydra - (c) 2001-2023 by van Hauser / THC <vh@thc.org>
#
WARN_CLANG=-Wformat-nonliteral -Wstrncat-size -Wformat-security -Wsign-conversion -Wconversion -Wfloat-conversion -Wshorten-64-to-32 -Wuninitialized -Wmissing-variable-declarations  -Wmissing-declarations
WARN_GCC=-Wformat=2 -Wformat-overflow=2 -Wformat-nonliteral -Wformat-truncation=2 -Wnull-dereference -Wstrict-overflow=2 -Wstringop-overflow=4 -Walloca-larger-than=4096 -Wtype-limits -Wconversion -Wtrampolines -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -fno-common -Wcast-align
CFLAGS ?= -g
OPTS=-I. -O3 $(CFLAGS) -fcommon -Wno-deprecated-declarations
CPPFLAGS += -D_GNU_SOURCE -Wno-deprecated-declarations -Wno-pointer-sign -Wno-format-truncation -Wno-format-overflow
# -Wall -g -pedantic
LIBS=-lm
DESTDIR ?=
BINDIR = /bin
MANDIR = /man/man1/
DATADIR = /etc
PIXDIR = /share/pixmaps
APPDIR = /share/applications

SRC = hydra-vnc.c hydra-pcnfs.c hydra-rexec.c hydra-nntp.c hydra-socks5.c \
      hydra-telnet.c hydra-cisco.c hydra-http.c hydra-ftp.c hydra-imap.c \
      hydra-pop3.c hydra-smb.c hydra-icq.c hydra-cisco-enable.c hydra-ldap.c \
      hydra-memcached.c hydra-mongodb.c hydra-mysql.c hydra-mssql.c hydra-xmpp.c \
      hydra-http-proxy-urlenum.c hydra-snmp.c hydra-cvs.c hydra-smtp.c \
      hydra-smtp-enum.c hydra-sapr3.c hydra-ssh.c hydra-sshkey.c hydra-teamspeak.c \
      hydra-postgres.c hydra-rsh.c hydra-rlogin.c hydra-oracle-listener.c \
      hydra-svn.c hydra-pcanywhere.c hydra-sip.c hydra-oracle.c hydra-vmauthd.c \
      hydra-asterisk.c hydra-firebird.c hydra-afp.c hydra-ncp.c hydra-rdp.c \
      hydra-oracle-sid.c hydra-http-proxy.c hydra-http-form.c hydra-irc.c \
      hydra-s7-300.c hydra-redis.c hydra-adam6500.c hydra-rtsp.c \
      hydra-rpcap.c hydra-radmin2.c hydra-cobaltstrike.c \
      hydra-time.c crc32.c d3des.c bfg.c ntlm.c sasl.c hmacmd5.c hydra-mod.c \
      hydra-smb2.c
OBJ = hydra-vnc.o hydra-pcnfs.o hydra-rexec.o hydra-nntp.o hydra-socks5.o \
      hydra-telnet.o hydra-cisco.o hydra-http.o hydra-ftp.o hydra-imap.o \
      hydra-pop3.o hydra-smb.o hydra-icq.o hydra-cisco-enable.o hydra-ldap.o \
      hydra-memcached.o hydra-mongodb.o hydra-mysql.o hydra-mssql.o hydra-cobaltstrike.o hydra-xmpp.o \
      hydra-http-proxy-urlenum.o hydra-snmp.o hydra-cvs.o hydra-smtp.o \
      hydra-smtp-enum.o hydra-sapr3.o hydra-ssh.o hydra-sshkey.o hydra-teamspeak.o \
      hydra-postgres.o hydra-rsh.o hydra-rlogin.o hydra-oracle-listener.o \
      hydra-svn.o hydra-pcanywhere.o hydra-sip.o hydra-oracle-sid.o hydra-oracle.o \
      hydra-vmauthd.o hydra-asterisk.o hydra-firebird.o hydra-afp.o \
      hydra-ncp.o hydra-http-proxy.o hydra-http-form.o hydra-irc.o \
      hydra-redis.o hydra-rdp.o hydra-s7-300.c hydra-adam6500.o hydra-rtsp.o \
      hydra-rpcap.o hydra-radmin2.o \
      crc32.o d3des.o bfg.o ntlm.o sasl.o hmacmd5.o hydra-mod.o hydra-time.o \
      hydra-smb2.o
BINS = hydra pw-inspector

EXTRA_DIST = README README.arm README.palm CHANGES TODO INSTALL LICENSE \
             hydra-mod.h hydra.h crc32.h d3des.h

all:	pw-inspector hydra $(XHYDRA_SUPPORT) 
	@echo
	@echo Now type "make install"

hydra:	hydra.c $(OBJ)
	$(CC) $(OPTS) $(SEC) $(LDSEC) $(LIBS) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o hydra $(HYDRA_LOGO) hydra.c $(OBJ) $(LIBS) $(XLIBS) $(XLIBPATHS) $(XIPATHS) $(XDEFINES)
	@echo
	@echo If men could get pregnant, abortion would be a sacrament
	@echo

xhydra:	
	-cd hydra-gtk && sh ./make_xhydra.sh

pw-inspector: pw-inspector.c
	$(CC) $(OPTS) $(SEC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o pw-inspector $(PWI_LOGO) pw-inspector.c

.c.o:	
	$(CC) $(OPTS) $(SEC) $(CFLAGS) $(CPPFLAGS) -c $< $(XDEFINES) $(XIPATHS)

strip:	all
	-strip $(BINS)
	-echo OK > /dev/null && test -x xhydra && strip xhydra || echo OK > /dev/null

install:	strip
	-mkdir -p $(DESTDIR)$(PREFIX)$(BINDIR)
	cp -f hydra-wizard.sh $(BINS) $(DESTDIR)$(PREFIX)$(BINDIR) && cd $(DESTDIR)$(PREFIX)$(BINDIR) && chmod 755 hydra-wizard.sh $(BINS)
	-echo OK > /dev/null && test -x xhydra && cp xhydra $(DESTDIR)$(PREFIX)$(BINDIR) && cd $(DESTDIR)$(PREFIX)$(BINDIR) && chmod 755 xhydra || echo OK > /dev/null
	-sed -e "s|^INSTALLDIR=.*|INSTALLDIR="$(PREFIX)"|" dpl4hydra.sh | sed -e "s|^LOCATION=.*|LOCATION="$(DATADIR)"|" > $(DESTDIR)$(PREFIX)$(BINDIR)/dpl4hydra.sh
	-chmod 755 $(DESTDIR)$(PREFIX)$(BINDIR)/dpl4hydra.sh
	-mkdir -p $(DESTDIR)$(PREFIX)$(DATADIR)
	-cp -f *.csv $(DESTDIR)$(PREFIX)$(DATADIR)
	-mkdir -p $(DESTDIR)$(PREFIX)$(MANDIR)
	-cp -f hydra.1 xhydra.1 pw-inspector.1 $(DESTDIR)$(PREFIX)$(MANDIR)
	-mkdir -p $(DESTDIR)$(PREFIX)$(PIXDIR)
	-cp -f xhydra.png $(DESTDIR)$(PREFIX)$(PIXDIR)/
	-mkdir -p $(DESTDIR)$(PREFIX)$(APPDIR)
	-desktop-file-install --dir $(DESTDIR)$(PREFIX)$(APPDIR) xhydra.desktop

clean:
	rm -rf xhydra pw-inspector hydra *.o core *.core *.stackdump *~ Makefile.in Makefile dev_rfc hydra.restore arm/*.ipk arm/ipkg/usr/bin/* hydra-gtk/src/*.o hydra-gtk/src/xhydra hydra-gtk/stamp-h hydra-gtk/config.status hydra-gtk/errors hydra-gtk/config.log hydra-gtk/src/.deps hydra-gtk/src/Makefile hydra-gtk/Makefile
	cp -f Makefile.orig Makefile

uninstall:
	-rm -f $(DESTDIR)$(PREFIX)$(BINDIR)/xhydra $(DESTDIR)$(PREFIX)$(BINDIR)/hydra $(DESTDIR)$(PREFIX)$(BINDIR)/pw-inspector $(DESTDIR)$(PREFIX)$(BINDIR)/hydra-wizard.sh $(DESTDIR)$(PREFIX)$(BINDIR)/dpl4hydra.sh
	-rm -f $(DESTDIR)$(PREFIX)$(DATADIR)/dpl4hydra_full.csv $(DESTDIR)$(PREFIX)$(DATADIR)/dpl4hydra_local.csv
	-rm -f $(DESTDIR)$(PREFIX)$(MANDIR)/hydra.1 $(DESTDIR)$(PREFIX)$(MANDIR)/xhydra.1 $(DESTDIR)$(PREFIX)$(MANDIR)/pw-inspector.1
	-rm -f $(DESTDIR)$(PREFIX)$(PIXDIR)/xhydra.png
	-rm -f $(DESTDIR)$(PREFIX)$(APPDIR)/xhydra.desktop

# ---------------------------------------------------------------------------
# Cross-compilation targets
# ---------------------------------------------------------------------------
# Build hydra for other OS/arch combinations. Each target detects its
# cross-compiler; if missing it prints a clear error and exits non-zero.
#
# These produce MINIMAL hydra binaries (no SSL/SSH/ncurses/etc.) because the
# host's configure-detected libraries are not cross-compatible. To enable
# optional modules for a target, install the cross-compiled dependencies and
# pass them on the command line, e.g.:
#   make cross-linux-arm64 CROSS_XDEFINES="-DLIBOPENSSL" \
#       CROSS_XLIBS="-lssl -lcrypto" CROSS_XIPATHS="-I/opt/a64ssl/include" \
#       CROSS_XLIBPATHS="-L/opt/a64ssl/lib"
#
# Windows native (non-Cygwin) builds are NOT supported out of the box: hydra's
# process model relies on fork(), which mingw does not provide. Use a Cygwin or
# MSYS2 toolchain (which supplies fork()) for functional Windows binaries.
#
# Cross targets rebuild all objects in-place, so run only one at a time and
# `rm -f *.o` before switching back to a native `make`.
# ---------------------------------------------------------------------------

.PHONY: cross cross-all cross-build cross-help \
        cross-linux-x64 cross-linux-x86 cross-linux-arm cross-linux-arm64 \
        cross-windows-x64 cross-windows-x86 cross-macos-x64 cross-macos-arm64

CROSS_CPPFLAGS ?= -D_GNU_SOURCE -Wno-pointer-sign -Wno-format-truncation -Wno-format-overflow
CROSS_XDEFINES ?=
CROSS_XLIBS ?=
CROSS_XIPATHS ?=
CROSS_XLIBPATHS ?=
CROSS_OUT ?= hydra-cross

cross-help:
	@echo "Cross-compilation targets:"
	@echo "  cross-linux-x64       Linux x86_64 (native, full features)"
	@echo "  cross-linux-x86       Linux i386 32-bit (needs gcc -m32; apt install gcc-multilib linux-libc-dev:i386)"
	@echo "  cross-linux-arm       Linux ARM 32-bit hard-float (apt install gcc-arm-linux-gnueabihf)"
	@echo "  cross-linux-arm64     Linux ARM 64-bit (apt install gcc-aarch64-linux-gnu)"
	@echo "  cross-windows-x64     Windows x86_64 (mingw-w64; needs Cygwin for fork)"
	@echo "  cross-windows-x86     Windows i386 (mingw-w64; needs Cygwin for fork)"
	@echo "  cross-macos-x64       macOS x86_64 (osxcross: o64-clang)"
	@echo "  cross-macos-arm64     macOS ARM64 (osxcross: oa64-clang)"
	@echo "  cross-all             attempt every target above (best-effort)"
	@echo "Override vars: CROSS_XLIBS CROSS_XIPATHS CROSS_XLIBPATHS CROSS_XDEFINES CROSS_CPPFLAGS"

# internal: CROSS_CC must be set by the calling target
cross-build:
	@test -n "$(CROSS_CC)" || { echo "[ERROR] CROSS_CC not set; invoke a cross-* target"; exit 1; }
	@command -v $(CROSS_CC) >/dev/null 2>&1 || { echo "[ERROR] compiler '$(CROSS_CC)' not found; install the toolchain to build $(CROSS_OUT)"; exit 1; }
	@echo "[INFO] building $(CROSS_OUT) with $(CROSS_CC)"
	@rm -f *.o hydra pw-inspector
	$(MAKE) hydra CC="$(CROSS_CC)" OPTS="-I. -O2 -fcommon -Wno-deprecated-declarations" CPPFLAGS="$(CROSS_CPPFLAGS)" SEC= LDSEC= XDEFINES="$(CROSS_XDEFINES)" XLIBS="$(CROSS_XLIBS)" XLIBPATHS="$(CROSS_XLIBPATHS)" XIPATHS="$(CROSS_XIPATHS)" HYDRA_LOGO= PWI_LOGO=
	@test -x hydra || { echo "[ERROR] hydra did not build for $(CROSS_OUT)"; rm -f *.o; exit 1; }
	@mv -f hydra "$(CROSS_OUT)"
	@rm -f *.o
	@echo "[OK] built $(CROSS_OUT)"

cross-linux-x64:
	@echo "[INFO] building hydra-linux-x64 (native, full features)"
	@rm -f *.o hydra
	$(MAKE) hydra
	@test -x hydra || { echo "[ERROR] native build failed"; rm -f *.o; exit 1; }
	@mv -f hydra hydra-linux-x64
	@rm -f *.o
	@echo "[OK] built hydra-linux-x64"

cross-linux-x86:
	@command -v gcc >/dev/null 2>&1 || { echo "[ERROR] gcc not found (need gcc + 32-bit multilib: apt install gcc-multilib linux-libc-dev:i386)"; exit 1; }
	$(MAKE) cross-build CROSS_CC="gcc" CROSS_CPPFLAGS="-m32 -D_GNU_SOURCE -Wno-pointer-sign -Wno-format-truncation -Wno-format-overflow" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="$(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-linux-x86"

cross-linux-arm:
	$(MAKE) cross-build CROSS_CC="arm-linux-gnueabihf-gcc" CROSS_CPPFLAGS="$(CROSS_CPPFLAGS)" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="$(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-linux-arm"

cross-linux-arm64:
	$(MAKE) cross-build CROSS_CC="aarch64-linux-gnu-gcc" CROSS_CPPFLAGS="$(CROSS_CPPFLAGS)" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="$(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-linux-arm64"

cross-windows-x64:
	@if command -v x86_64-pc-cygwin-gcc >/dev/null 2>&1; then \
	   $(MAKE) cross-build CROSS_CC="x86_64-pc-cygwin-gcc" CROSS_CPPFLAGS="$(CROSS_CPPFLAGS)" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="$(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-windows-x64.exe"; \
	 elif command -v x86_64-w64-mingw32-gcc >/dev/null 2>&1; then \
	   echo "[WARNING] mingw lacks fork()/POSIX; a functional Windows build needs a Cygwin/MSYS2 toolchain (x86_64-pc-cygwin-gcc)"; \
	   $(MAKE) cross-build CROSS_CC="x86_64-w64-mingw32-gcc" CROSS_CPPFLAGS="-DWIN32 -D_GNU_SOURCE -Wno-pointer-sign -Wno-format-truncation -Wno-format-overflow" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="-lws2_32 -lwinmm $(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-windows-x64.exe"; \
	 else echo "[ERROR] no Windows toolchain found (install x86_64-pc-cygwin-gcc or x86_64-w64-mingw32-gcc)"; exit 1; fi

cross-windows-x86:
	@if command -v i686-pc-cygwin-gcc >/dev/null 2>&1; then \
	   $(MAKE) cross-build CROSS_CC="i686-pc-cygwin-gcc" CROSS_CPPFLAGS="$(CROSS_CPPFLAGS)" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="$(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-windows-x86.exe"; \
	 elif command -v i686-w64-mingw32-gcc >/dev/null 2>&1; then \
	   echo "[WARNING] mingw lacks fork()/POSIX; a functional Windows build needs a Cygwin/MSYS2 toolchain (i686-pc-cygwin-gcc)"; \
	   $(MAKE) cross-build CROSS_CC="i686-w64-mingw32-gcc" CROSS_CPPFLAGS="-DWIN32 -D_GNU_SOURCE -Wno-pointer-sign -Wno-format-truncation -Wno-format-overflow" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="-lws2_32 -lwinmm $(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-windows-x86.exe"; \
	 else echo "[ERROR] no Windows toolchain found (install i686-pc-cygwin-gcc or i686-w64-mingw32-gcc)"; exit 1; fi

cross-macos-x64:
	@if command -v o64-clang >/dev/null 2>&1; then CC="o64-clang"; \
	 elif command -v x86_64-apple-darwin-clang >/dev/null 2>&1; then CC="x86_64-apple-darwin-clang"; \
	 elif command -v x86_64-apple-darwin20.4-clang >/dev/null 2>&1; then CC="x86_64-apple-darwin20.4-clang"; \
	 else echo "[ERROR] no macOS x86_64 toolchain found (install osxcross, e.g. o64-clang)"; exit 1; fi; \
	$(MAKE) cross-build CROSS_CC="$$CC" CROSS_CPPFLAGS="$(CROSS_CPPFLAGS)" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="$(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-macos-x64"

cross-macos-arm64:
	@if command -v oa64-clang >/dev/null 2>&1; then CC="oa64-clang"; \
	 elif command -v aarch64-apple-darwin-clang >/dev/null 2>&1; then CC="aarch64-apple-darwin-clang"; \
	 elif command -v aarch64-apple-darwin20.4-clang >/dev/null 2>&1; then CC="aarch64-apple-darwin20.4-clang"; \
	 else echo "[ERROR] no macOS ARM64 toolchain found (install osxcross, e.g. oa64-clang)"; exit 1; fi; \
	$(MAKE) cross-build CROSS_CC="$$CC" CROSS_CPPFLAGS="$(CROSS_CPPFLAGS)" CROSS_XDEFINES="$(CROSS_XDEFINES)" CROSS_XLIBS="$(CROSS_XLIBS)" CROSS_XIPATHS="$(CROSS_XIPATHS)" CROSS_XLIBPATHS="$(CROSS_XLIBPATHS)" CROSS_OUT="hydra-macos-arm64"

cross-all cross:
	@for t in cross-linux-x64 cross-linux-x86 cross-linux-arm cross-linux-arm64 cross-windows-x64 cross-windows-x86 cross-macos-x64 cross-macos-arm64; do \
	  echo "=== $$t ==="; \
	  $(MAKE) $$t && echo "[DONE] $$t" || echo "[FAIL] $$t"; \
	done
