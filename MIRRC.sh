#!/bin/sh
#-----------------------------------------------------------------------------
# Usage: . MIRRC.sh
#-----------------------------------------------------------------------------
# Bourne shell (bash or ksh) version of MIRRC originally by George Martin.
#
# $Id: MIRRC.sh.in,v 1.8 2012/04/17 05:28:49 wie017 Exp $
#-----------------------------------------------------------------------------
# Miriad root directory set by configure or otherwise.
  MIR=/usr/local/miriad ; export MIR

# Important Miriad subdirectories.
  MIRCAT=$MIR/cat  ; export MIRCAT
  MIRPDOC=$MIR/doc ; export MIRPDOC
  MIRINC=$MIR/inc  ; export MIRINC
  MIRPROG=$MIR/prog; export MIRPROG
  MIRSUBS=$MIR/subs; export MIRSUBS
  [ -d $MIR/man ] && MIRMAN=$MIR/man ; export MIRMAN

# Miriad architecture.
  MIRARCH=`$MIR/scripts/mirarch` ; export MIRARCH
  if [ "$MIRARCH" = unknown ]
  then
    echo "### Unknown host architecture -- no Miriad executables."
  fi

# Miriad system subdirectories.
  MIRARCHD=$MIR/$MIRARCH ; export MIRARCHD
  MIRBIN=$MIRARCHD/bin   ; export MIRBIN
  MIRLIB=$MIRARCHD/lib   ; export MIRLIB
  MIRMAN=$MIRARCHD/man   ; export MIRMAN

# Set up the user's directory to receive .def files.
  if [ -z "$MIRDEF" ]
  then
    if [ -d $HOME/mirdef ]
    then
      MIRDEF=$HOME/mirdef
    else
      MIRDEF=.
    fi

    export MIRDEF
  fi

# PGPLOT_BUFFER=TRUE ; export PGPLOT_BUFFER
  if [ -f $MIRLIB/grfont.dat ]
  then
    PGPLOT_FONT=$MIRLIB/grfont.dat ; export PGPLOT_FONT
  fi

# Set DYLD_FALLBACK_LIBRARY_PATH as well on Darwin/MacOSX. Append default value if empty
  if [ "$MIRARCH" = darwin_x86_64 ]
  then
    if [ "$DYLD_FALLBACK_LIBRARY_PATH" != "" ]
    then
      DYLD_FALLBACK_LIBRARY_PATH="${MIRLIB}:$DYLD_FALLBACK_LIBRARY_PATH"
    else
      DYLD_FALLBACK_LIBRARY_PATH="${MIRLIB}:${HOME}/lib:/usr/local/lib:/lib:/usr/lib"
    fi
    export DYLD_FALLBACK_LIBRARY_PATH
  fi
 
 # DCP: Add to path
 export LD_LIBRARY_PATH=$MIRLIB:$LD_LIBRARY_PATH
 export PATH=$MIRBIN:$PATH
