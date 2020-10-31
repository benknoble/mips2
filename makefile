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

mars:
	$(JAVA) $(JAVAFLAGS) -jar $(MARS) $(MARSFLAGS)
