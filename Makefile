
all: update libracc.rb


DEBUG = #-g
TMP = ${DEBUG} -v#P
RUBYPATH = /usr/local/bin/ruby
DRACC    = ./racc.rb ${TMP} -e${RUBYPATH}


# app data

VERSION  = 0.9.2
APPNAME  = racc


# dirs

include ../makefile.common


##### source file

BACKUPF  = ${RACCSRC} ${RACCTOOL} ${RACCBIN} \
           ${CALCSRC} ${CALCTOOL}

RACCBIN  = racc.rb
RACCRB   = \
           racc.rb     \
           libracc.rb

RACCSRC  = \
           d.head.rb   \
           d.facade.rb \
	         d.scan.rb   \
	         d.parse.rb  \
           d.rule.rb   \
	         d.state.rb  \
           d.format.rb \

RACCTOOL = Makefile bld.rb
R10SRC   = e.racc.y e.scan

LIBSRC   = \
           extmod.rb   \
					 must.rb     \
					 bug.rb      \
					 parser.rb   \
					 scanner.rb

CALCSRC  = calc.y
CALCTOOL = calc.makefile

HTML     = \
           index.html   \
           command.html \
           grammer.html \
           changes.html \
           debug.html

TEXT     = README.jp README.en

#-------------------------------------------------------------

libracc.rb: ${RACCTOOL} ${RACCSRC}
	./bld.rb &> er

debug: ${RACCTOOL} ${RACCSRC}
	update -w2 -v${VERSION} ${RACCSRC} ${RACCBIN}
	./bld.rb -g &> er

#-------------------------------------------------------------

install: racc.rb libracc.rb
	mupdate racc.rb ${BINDIR}/racc.rb
	mupdate libracc.rb ${LIBDIR}/libracc.rb

pack:
	make update
	make archive

clean:
	rm -f timestamp-* libracc.rb racc*.tar.gz chk.rb
	cd ${BINDIR} ; rm -f racc.rb
	cd ${LIBDIR} ; rm -f libracc.rb
	touch ${HTMLDIR}/*.html

update:
	update -w2 -v${VERSION} ${RACCSRC} ${RACCBIN}

#-------------------------------------------------------------

archive: ${ARC}

${ARC}: set_ruby set_lib set_calc set_text set_html
	rm -rf ${APPNAME}-0.9.*.tar.gz
	mv ${ARCDIR} ${PACKDIR}
	tar c ${PACKDIR} | gzip > $@
	mv ${PACKDIR} ${ARCDIR}

set_ruby:
	cupdate -t -v${VERSION} -c -s. -d${ARCDIR} ${RACCRB}

set_lib:
	cupdate -t -c -s${LIBDIR} -d${ARCDIR} ${LIBSRC}

set_calc:
	cupdate -t -c -s. -d ${ARCDIR} ${CALCSRC}

set_html:
	cupdate -c -s${HTMLDIR}/jp -d${ARCDIR}/doc.jp ${HTML}
	cupdate -c -s${HTMLDIR}/en -d${ARCDIR}/doc.en ${HTML}

set_text:
	tab ${TEXTDIR}/*.en
	cupdate -c -s${TEXTDIR} -d${ARCDIR} ${TEXT}

#-------------------------------------------------------------

site:
	rm -f ${SITEDIR}/${APPNAME}-*.tar.gz
	mupdate ${ARC} ${SITEDIR}/${ARC}
	cupdate -c -s${HTMLDIR}/jp -d${JSITEDOC} ${HTML}
	cupdate -c -s${HTMLDIR}/en -d${ESITEDOC} ${HTML}

#-------------------------------------------------------------

e: all e.racc.y
	${DRACC} -oout e.racc.y &> er

test: debug
	${DRACC} -ochk.rb chk.y &> er
	./chk.rb

calc: libracc.rb racc.rb
	make -f calc.makefile

rmcalc:
	rm -f calc.rb calc.output

#-------------------------------------------------------------