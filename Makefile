##
# Makefile automatically generated by genmake 1.0, Feb-11-2014 
# genmake 1.0 by muquit@muquit.com, http://www.muquit.com/
##
srcdir = .

top_srcdir = .
CC= gcc
DEFS= -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE_URL=\"\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_STRING_H=1 -DHAVE_STRINGS_H=1 -DHAVE_MEMORY_H=1 -DHAVE_UNISTD_H=1 -DHAVE_CTYPE_H=1 -DHAVE_STDINT_H=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_STDLIB_H=1 -DHAVE_FCNTL_H=1 -DHAVE_SYS_FILE_H=1 -DHAVE_LIMITS_H=1 -DHAVE_SYS_SYSLIMITS_H=1 -DHAVE_RAND_R=1 -DHAVE_SOCKET=1 -DHAVE_GETADDRINFO=1 -DSIZEOF_VOID_P=8 -DHAVE_OPENSSL=1 -DUNIX
AR= /usr/bin/ar
ARFLAGS = cruv
RANLIB= ranlib
LIBNAME= librncryptorc.a
PROGNAME= 
INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_EXEC = @INSTALL_EXEC@

DESTDIR = 
prefix = /usr/local
exec_prefix = ${prefix}
datarootdir = ${prefix}/share
datadir = ${datarootdir}
bindir = ${exec_prefix}/bin
includedir = ${prefix}/include
libdir = ${exec_prefix}/lib
mandir = ${datarootdir}/man
man1dir = $(mandir)/man1
BINDIR = $(DESTDIR)$(bindir)
MAN1DIR = $(DESTDIR)$(man1dir)

MANPAGE= 

OPENSSL_DIR=/usr/local/opt/openssl/
OPENSSL_INC=-I/usr/local/opt/openssl//include
OPENSSL_LIBS=-L/usr/local/opt/openssl//lib -lssl -lcrypto 

STRIP=/usr/bin/strip

INCLUDES=  -I. $(OPENSSL_INC)

DEFINES= $(INCLUDES) $(DEFS) -DHAVE_STRING_H=1 -DHAVE_STDLIB_H=1 \
	-DHAVE_MATH_H=1

CFLAGS= -g -O2 -Wall $(DEFINES)
LIBS=$(LIBNAME) $(OPENSSL_LIBS)

SRCS = rncryptor_c.c mutils.c
OBJS = rncryptor_c.o mutils.o

.c.o:
	rm -f $@
	$(CC) $(CFLAGS) -c $*.c

all: $(LIBNAME) examples

$(LIBNAME) : $(OBJS)
	rm -f $@
	$(AR) $(ARFLAGS) $@ $(OBJS)
	$(RANLIB) $@

examples: $(LIBNAME)
	$(CC) $(CFLAGS) rn_decrypt.c -o rn_decrypt $(LIBS)
	$(CC) $(CFLAGS) rn_encrypt.c -o rn_encrypt $(LIBS)
	$(CC) $(CFLAGS) rn_encrypt_with_key.c -o rn_encrypt_with_key $(LIBS)
	$(CC) $(CFLAGS) rn_decrypt_with_key.c -o rn_decrypt_with_key $(LIBS)


# Generate the C code from RNCryptor's test vectors
gen_tester:
	(cd tests;./GenVectorTests-C.rb -o test_with_test_vectors.c test_vectors)
	$(CC) $(CFLAGS) tests/test_with_test_vectors.c -o tests/test_with_test_vectors $(LIBS)

# sanity test
test_simple:examples
	+ruby tests/test.rb

# test code must be pre-generated with target gen_test_vector_code
# we use the test in windows as well but code is generated in Unix with ruby
test:gen_tester
	tests/test_with_test_vectors

install: installdirs install-all

install-man:
	$(INSTALL_DATA) $(MANPAGE) $(MAN1DIR)

installdirs:
	$(SHELL) ${top_srcdir}/mkinstalldirs ${DESTDIR}${includedir}
	$(SHELL) ${top_srcdir}/mkinstalldirs ${DESTDIR}${bindir}
	$(SHELL) ${top_srcdir}/mkinstalldirs ${DESTDIR}${libdir}

install-all:
	$(INSTALL_DATA) rncryptor_c.h ${DESTDIR}${includedir}
	$(INSTALL_DATA) $(LIBNAME) ${DESTDIR}${libdir}
	$(INSTALL_PROGRAM) rn_decrypt ${DESTDIR}${bindir}
	$(INSTALL_PROGRAM) rn_decrypt_with_key ${DESTDIR}${bindir}
	$(INSTALL_PROGRAM) rn_encrypt ${DESTDIR}${bindir}
	$(INSTALL_PROGRAM) rn_encrypt_with_key ${DESTDIR}${bindir}

clean:
	rm -f $(OBJS) *.o $(LIBNAME) rn_encrypt rn_decrypt rn_encrypt_with_key rn_decrypt_with_key \
		tests/test_with_test_vectors
