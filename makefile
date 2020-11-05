.POSIX:
SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .mips .imem .dmem .hex

JAVA = java

.mips.imem:
	$(JAVA) $(JAVAFLAGS) -jar \
		$(MARS) $(MARSFLAGS) nc me a ae1 dump .text HexText '$@' '$<'

.mips.dmem:
	$(JAVA) $(JAVAFLAGS) -jar \
		$(MARS) $(MARSFLAGS) nc me a ae1 dump .data HexText '$@' '$<'

.mips.hex:
	$(JAVA) $(JAVAFLAGS) -jar \
		$(MARS) $(MARSFLAGS) nc me a ae1 dump .text HexText '$@' '$<'
	{ \
		printf '%s\n' .data "$$(basename '$*' | tr -dc [[:alnum:]]):" .word ; \
		<'$@' sed 's/^/0x/' ; \
	} > '$@.tmp'
	mv '$@.tmp' '$@'

init.bmem bmem-map: bmp/*.bmp
bmem-map:
	printf '%s\n' $^ | LC_ALL=C sort | nl -v0 > '$@'
mips/bmem-map.mips: bmem-map
	<bmem-map awk '{ \
		sub(".*/", "", $$2); \
		sub("\\..*$$", "", $$2); \
		gsub("[^[:alnum:]]", "_", $$2); \
		printf ".eqv %s %d\n", toupper($$2), $$1 \
	}' >'$@'
init.bmem:
	printf '%s\n' $^ | LC_ALL=C sort | xargs cat > '$@'
init.smem: bmp/*.bmp bmem-map bin/make-init-smem
	bin/make-init-smem bmem-map > '$@'

mars:
	$(JAVA) $(JAVAFLAGS) -jar $(MARS) $(MARSFLAGS)
