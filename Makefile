D_COMPILER=dmd
D_FLAGS=-IBioD -g#-O -release -inline # -version=serial

HTSLIB_PATH=-L/home/lomereiter/github/htslib
HTSLIB_SUBCMD=$(HTSLIB_PATH) -Wl,-Bstatic -lhts -Wl,-Bdynamic
RDMD_FLAGS=--force --build-only --compiler=$(D_COMPILER) $(D_FLAGS)

all:
	mkdir -p build/
	rdmd --force --build-only $(D_FLAGS) -c -ofbuild/sambamba.o main.d
	gcc -o build/sambamba build/sambamba.o $(HTSLIB_SUBCMD) -Xlinker --export-dynamic -l:libphobos2.a -lrt -lpthread -lm

sambamba-ldmd2-64:
	mkdir -p build/
	export LIBRARY_PATH=/home/lomereiter/Downloads/ldc2-0.14.0-linux-x86_64/lib
	export PATH=/home/lomereiter/Downloads/ldc2-0.14.0-linux-x86_64/bin:$$PATH
	ldmd2 @sambamba-ldmd-release.rsp
	gcc -o build/sambamba build/sambamba.o $(HTSLIB_SUBCMD) -Xlinker --export-dynamic -l:libphobos2-ldc.a -l:libdruntime-ldc.a -lrt -lpthread -lm

# all below link to libhts dynamically for simplicity

sambamba-flagstat:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-flagstat sambamba/flagstat.d

sambamba-merge:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-merge sambamba/merge.d

sambamba-index:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-index sambamba/index.d

sambamba-sort:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-sort sambamba/sort.d

sambamba-view:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-view sambamba/view.d

sambamba-slice:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-slice sambamba/slice.d

sambamba-markdup:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-markdup sambamba/markdup.d

sambamba-depth:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-depth sambamba/depth.d

sambamba-pileup:
	mkdir -p build/
	rdmd $(RDMD_FLAGS) -L-lhts -version=standalone -ofbuild/sambamba-pileup sambamba/pileup.d

.PHONY: clean

clean:
	rm -rf build/
