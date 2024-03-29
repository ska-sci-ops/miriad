#-----------------------------------------------------------------------------
# GNUmakefile for compiling Miriad tools.
#
# Original: 2006/08/25, Mark Calabretta, ATNF
# $Id: GNUmakefile,v 1.9 2018/11/23 04:52:41 wie017 Exp $
#-----------------------------------------------------------------------------
# Get common makefile variables and rules.
include $(MIR)/GNUmakedefs

MIREXES  := $(basename $(filter %.c,$(MIRSRCS)))

show ::
	-@ echo ""
	-@ echo ""
	-@ echo "Variables defined in the tools GNUmakefile"
	-@ echo "=========================================="
	-@ echo ""
	-@ echo "MIREXES  = $(MIREXES)"

ifeq "$(MAKEMODE)" "system"
  # System-oriented rules.
  #-----------------------

  # Pattern rules.
  #---------------
  $(MIRBIND)/% : $(CODEDIR)/%.c
	   $(CC) $(CCOPT) -o $@ $<
	-@ chmod 775 $@

  # Extract preamble comments into a Miriad "doc" file.
  $(MIRDOCD)/%.doc : %.c
	-@ $(RM) $(MIRDOCD)/$*.doc
	   $(MIRBIND)/doc -f $< > $@
	-@ chmod 664 $@

  # Static and static pattern rules.
  #---------------------------------
  allsys :: bin doc
  
  bin : $(MIREXES:%=$(MIRBIND)/%) ;

  ifneq "$(READLINELIB)" ""
    READLINESTATICLIB = $(filter %.a, $(READLINELIB))
    $(MIRBIND)/miriad : $(CODEDIR)/miriad.c $(READLINESTATICLIB)
	   $(CC) -DREADLINE $(CCOPT) -o $@ $< $(READLINELIB) $(READLINEINC)
	-@ chmod 775 $@
  endif

  doc : $(MIREXES:%=$(MIRDOCD)/%.doc) ;

  help ::
	-@ echo ""
	-@ echo "Targets defined in the tools GNUmakefile"
	-@ echo "----------------------------------------"
	-@ echo "     allsys: recompile MIREXES."
	-@ echo "        bin: compile and link all programs."
	-@ echo "        doc: generate doc files for all programs."

else
  # Programmer-oriented rules.
  #---------------------------
  VPATH    := .:$(CODEDIR)

  PGMREXES := $(basename $(wildcard *.c))

  # Pattern rules.
  #---------------
  .PRECIOUS : $(PGMRBIND)/%

  % : $(PGMRBIND)/% ;

  $(PGMRBIND)/% : %.c
	$(CC) $(CDBG) -o $@ $<

  # Static and static pattern rules.
  #---------------------------------
  all :: $(addprefix $(PGMRBIND)/, $(PGMREXES))

  ifneq "$(READLINELIB)" ""
    $(PGMRBIND)/miriad : miriad.c
	$(CC) -DREADLINE $(CDBG) -o $@ $< $(READLINELIB)
  endif

  clean ::
	$(RM) *.o

  cleanest :: clean
	cd $(PGMRBIND) && $(RM) $(sort $(PGMREXES) $(MIREXES))

  help ::
	-@ echo ""
	-@ echo "Targets defined in the tools GNUmakefile"
	-@ echo "----------------------------------------"
	-@ echo "          %: recompile the specified program."

  show ::
	-@ echo ""
	-@ echo "VPATH    = $(VPATH)"
	-@ echo "PGMREXES = $(PGMREXES)"
endif
