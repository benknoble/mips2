.POSIX:
SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .mips .mem .hex

JAVA = java

.mips.mem:
	$(JAVA) $(JAVAFLAGS) -jar \
		$(MARS) $(MARSFLAGS) nc me a ae1 dump .text HexText '$@' '$<'

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
