CFLAGS := -Wall -g -O2 -DNDEBUG=1  -DSG=1
# Remove -DSG=1 if you don't need scather-gather support
# NDEBUG=1 is recommended for production

#CFLAGS += -m32
#LDFLAGS += -m32

all: scmd verify sgverify

snappy.o: snappy.c

LIBSNAPPY_OBJS := snappy.o map.o util.o
libsnappy.a: ${LIBSNAPPY_OBJS} 
	 ar rcs libsnappy.a ${LIBSNAPPY_OBJS}

scmd: scmd.o libsnappy.a

CLEAN := ${LIBSNAPPY_OBJS} libsnappy.a scmd.o scmd bench bench.o fuzzer.o fuzzer verify.o \
	 verify sgverify sgverify.o

clean: 
	rm -f ${CLEAN}

src: src.lex
	flex src.lex
	gcc ${CFLAGS} -o src lex.yy.c



#LZO := ../comp/lzo.o
LZO := ../comp/minilzo-2.06/minilzo.o

OTHER := ${LZO} ../comp/zlib.o ../comp/lzf.o ../comp/quicklz.o \
	 ../comp/fastlz.o

# incompatible with 32bit
# broken due to namespace collision
#SNAPREF_BASE := ../../src/snappy-1.0.3
#SNAPREF_FL := -I ${SNAPREF_BASE} -D SNAPREF
#SNAPREF := ${SNAPREF_BASE}/snappy-c.o ${SNAPREF_BASE}/snappy.o \
#           ${SNAPREF_BASE}/snappy-sinksource.o \
#           ${SNAPREF_BASE}/snappy-stubs-internal.o \
LDFLAGS += -lstdc++

fuzzer.o: CFLAGS += -D COMP ${SNAPREF_FL}

fuzzer: fuzzer.o libsnappy.a ${OTHER} # ${SNAPREF}

bench: bench.o libsnappy.a ${OTHER} # ${SNAPREF}

bench.o: CFLAGS += -I ../simple-pmu -D COMP # ${SNAPREF_FL}  # -D SIMPLE_PMU

verify: verify.o libsnappy.a

sgverify: sgverify.o libsnappy.a


