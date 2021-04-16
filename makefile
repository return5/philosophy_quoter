#makefile for philosophy_quoter.d www.github.com/return5/philosophy_quoter
#needs dmd and gtkd.
#this makefile currently only works on linux systems. 

CC=dmd
LDFLAGS=-lgtkd-3
DIRECTORY=/usr/include/d/gtkd-3/
CFLAGS=-w -de -O -color -inline -wi -I$(DIRECTORY) -L$(LDFLAGS)
FILES=philosophy_quoter.d

all:
	$(CC) $(CFLAGS) $(FILES)
