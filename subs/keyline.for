c************************************************************************
c  Get line and reference line parameters
c
c  History:
c    rjs  ??      Original version.
c    rjs  16nov94 Fix reference line retrieval.
c    rjs  06sep99 Added lflag parameter to keygline routine.
c    rjs  10jun09 Fix string too long in DATA statement.
c************************************************************************
c* KeygLine -- Get the linetype from the user interface.
c& rjs
c: user-input
c+
        subroutine keygline(line,nchan,lstart,lwidth,lstep,lflag)
c
        implicit none
        character line*(*)
        integer nchan
        double precision lstart,lwidth,lstep,lflag
c
c  Get the linetype from the user interface.
c
c  Output:
c    line	Either 'channel', 'velocity','felocity' or 'wide'.
c    nchan	Number of channels.
c    lstart,lwidth,lstep  Line parameters.
c--
c------------------------------------------------------------------------
        integer ntypes
        parameter(ntypes=4)
        character ltypes(ntypes)*8
        integer nout
        data ltypes/'channel ','velocity','felocity','wide    '/
c                    12345678   12345678   12345678   12345678                                 
c
        call keymatch('line',ntypes,ltypes,1,line,nout)
        if(nout.eq.0)line = ' '
        call keyi('line',nchan,0)
        if(nchan.lt.0)call bug('f',
     *    'Invalid number of chans in line parameter')
c
        if(line.eq.'felocity'.or.line.eq.'velocity')then
          call keyd('line',lstart,0.d0)
          call keyd('line',lwidth,0.d0)
          call keyd('line',lstep,lwidth)
          lflag = 1.d0
        else
          call keyd('line',lstart,1.d0)
          call keyd('line',lwidth,1.d0)
          call keyd('line',lstep,lwidth)
          call keyd('line',lflag,1.d0)
        endif
c
        end
c************************************************************************
c* KeyLine -- Get the linetype from the user interface.
c& rjs
c: user-input
c+
	subroutine KeyLine(line,nchan,lstart,lwidth,lstep)
c
	implicit none
	character line*(*)
	integer nchan
	double precision lstart,lwidth,lstep
c
c  Get the linetype from the user interface.
c
c  Output:
c    line	Either 'channel', 'velocity','felocity' or 'wide'.
c    nchan	Number of channels.
c    lstart,lwidth,lstep  Line parameters.
c--
c------------------------------------------------------------------------
	integer NTYPES
	parameter(NTYPES=4)
	character ltypes(NTYPES)*8
	integer nout
	data ltypes/'channel ','velocity','felocity','wide    '/
c                    12345678   12345678   12345678   12345678                                 
c
	call keymatch('line',NTYPES,ltypes,1,line,nout)
	if(nout.eq.0)line = ' '
	call keyi('line',nchan,0)
	if(nchan.lt.0)call bug('f',
     *	  'Invalid number of chans in line parameter')
c
	if(line.eq.'felocity'.or.line.eq.'velocity')then
	  call keyd('line',lstart,0.d0)
	  call keyd('line',lwidth,0.d0)
	  call keyd('line',lstep,lwidth)
	else
	  call keyd('line',lstart,1.d0)
	  call keyd('line',lwidth,1.d0)
	  call keyd('line',lstep,lwidth)
	endif
c
	end
c************************************************************************
c* KeyrLine -- Get the reference linetype from the user interface.
c& rjs
c: user-input
c+
	subroutine KeyrLine(line,lstart,lwidth)
c
	implicit none
	character line*(*)
	double precision lstart,lwidth
c
c  Get the reference linetype from the user interface.
c
c  Output:
c    line	Either 'channel', 'velocity','felocity' or 'wide'.
c    lstart,lwidth  Line parameters.
c--
c------------------------------------------------------------------------
	integer NTYPES
	parameter(NTYPES=4)
	character ltypes(NTYPES)*8
	integer nout
	data ltypes/'channel ','velocity','felocity','wide    '/
c                    12345678   12345678   12345678   12345678                                 
c
	call keymatch('ref',NTYPES,ltypes,1,line,nout)
	if(nout.eq.0)line = ' '
c
	if(line.eq.'felocity'.or.line.eq.'velocity')then
	  call keyd('ref',lstart,0.d0)
	  call keyd('ref',lwidth,0.d0)
	else
	  call keyd('ref',lstart,1.d0)
	  call keyd('ref',lwidth,1.d0)
	endif
c
	end
