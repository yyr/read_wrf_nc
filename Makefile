FORTRAN=ifort

RM = /bin/rm -f
NETCDFDIR=/usr/local/netcdf

FFLAGS = -free -O2 -g -traceback
LFLAGS = "-L${NETCDFDIR}/lib"
INCLUDES= "-I${NETCDFDIR}/include"
LIBS = -lnetcdf -lm

BUILDFLAGS = ${FFLAGS} ${LFLAGS} ${LIBS} ${INCLUDES}

SRCS = read_wrf_nc.f
OBJS = ${SRCS:.f=.o}

.PHONY : depend clean

all: main

main:
	${FORTRAN} ${SRCS} ${BUILDFLAGS} -o ${OBJS}

.f.o:
	${FORTRAN} $< -o $@

clean:
	${RM} *.o *.mod

depend:
	makedepend ${INCLUDES} $^
# DO NOT DELETE
