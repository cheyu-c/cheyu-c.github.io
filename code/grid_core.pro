function grid_core,filename,pix_size,T,cls_dist=cls_dist,dp=dp,h=h,r_pix_lim=r_pix_lim

; PURPOSE:
;    Use the gravitational potential from surface density to find cores
;
; CALLING SEQUENCE:
;    output=grid_core(filename,pix_size,T,cls_dist=cls_dist,dp=dp,h=h,r_pix_lim=r_pix_lim)
;
;    e.g. output=grid_core('column.fits', 0.005, 10, dp=0.001)
;
; INPUTS:
;    filename     : the name of the FITS file containing column
;                   density N_H, in units of cm^-2
;
;    pix_size     : the resolution of each pixel in the map, in units of pc
;
;    T            : temperature of the cloud (assumed isothermal) in units of K
;
;    dp           : the interval of potential used for core-finding, 
;                   in units of c_s^2; default is 0.01
;
;    cls_dist     : the closest distance permitted between two local potential,
;                   minima for separate cores, in units of pix_size; default is 2
;                   (closer regions are merged)
;
;    h            : the length at which to adjust the 2D potential, in
;                   units of pix_size; default is 1
;
;    r_pix_lim    : the radius of the smallest core that is considered
;                   resolved, in units of pix_size; default is 2
;
; OUTPUTS:
;    A .fits file containing the identified core areas 
;    
;    A .fits file containing the identified bound core areas
;
;    A .ps file showing the core and bound core regions as well as the
;               calculated gravitational potential contours,
;               overlaid on the surface density map
;
;    A .dat file containing the properties of each core: 
;             core number
;             location i (pixel #)
;             location j (pixel #)
;             total mass (Msun)
;             total mass with background subtraction (Msun)
;             bound mass (Msun)
;             area of whole core region (pixels)
;             area of bound region (pixels)
;             potential well |Phi| at center [(km/s)^2]
;             potential well Phi_max-Phi_min [(km/s)^2]
;
; AUTHORS:
;    Hao Gong & Eve C. Ostriker  2011
;    Department of Astronomy, University of Maryland
;    hgong@astro.umd.edu, ostriker@astro.umd.edu
;
;    Modified by Che-Yu Chen, 2016
;    Department of Astronomy, University of Virginia
;    cheyu.c@gmail.com
;
; NOTES:  This code uses publically-available IDL routines imdisp.pro
;         and extremes_2d.pro, included in this file for convenience.
;
;         Some algorithms are adapted from the CLUMPFIND code of 
;         J. Williams, E. de Geus, and L. Blitz (1994, ApJ 428, 693); see 
;         http://www.ifa.hawaii.edu/~jpw/page16/page4/page4.html


COMMON SHARE100,surfd,data,assign,assign_b,ncore
COMMON SHARE200,G,mp,dx,cs2,msun

on_error,2

if N_params() LT 3 THEN BEGIN
  print,'Wrong number of input arguments ...'
  print,'Syntax - output=grid_core(filename,pix_size,T,cls_dist=cls_dist,dp=dp,h=h,r_pix_lim=r_pix_lim)  '
  print,'Example: output=grid_core("column.fits",0.01,10.,cls_dist=6,dp=0.1,h=1.0,r_pix_lim=3)          '
  print,' filename          : FITS file containing column density N_H, in units of cm^-2 '
  print,' pix_size          : the resolution of each pixel, in units of pc'  
  print,' T                 : temperature of the cloud, in units of K '
  print,' cls_dist          : the minimum distance between core centers, in units of pix_size  '
  print,' dp                : the potential interval for core-finding, in units of c_s^2 '
  print,' h                 : the effective thickness of the layer (smoothing scale for the 2D potential), in units of pix_size '
  print,' r_pix_lim         : the limit of the radius of resolved cores, in units of pix_size '
  return,0
endif

;; start to count time
t0=systime(1)

;; Physical constants and parameters
G    = double(6.6743  *10.^(-8))                ; Gravitational constant
k    = double(1.3807  *10.^(-16))               ; Boltzmann's constant
mp   = double(1.6726  *10.^(-24))               ; mass of proton
msun = double(1.989   * 10.^33)                 ; solar mass
pc   = double(3.086   * 10.^18 )                ; pc/cm conversion

;*************************** setting up parameters *****************************
dx        = double(pix_size*pc)                 
 
cs2       = double(k*T/(2.3*mp))                ; sound speed square, assuming molecular gas
cs2       = cs2/10.^10                          ; convert cs to km/s

IF KEYWORD_SET(cls_dist)  THEN cls_pix = cls_dist           ELSE cls_pix   = double(2.)
IF KEYWORD_SET(dp)        THEN dphi    = double(dp*cs2)     ELSE dphi      = double(0.01*cs2)
IF KEYWORD_SET(h)         THEN hdx     = double(h*dx)       ELSE hdx       = double(dx)
IF KEYWORD_SET(r_pix_lim) THEN r_pix   = r_pix_lim          ELSE r_pix     = 2

;*************************** print out parameters *****************************
print,'The set up is ...'
print, pix_size,  format='("Resolution =                                 ", f6.4, 2x, "pc")'
print, T,         format='("temperature of the cloud =                   ", f6.2, 2x, "K")'
print, cls_pix,   format='("minimum distance between core centers =      ", f6.2, 2x, "pixel")'
print, dphi,      format='("the potential interval for core-finding =  ",   e8.2, 2x, "km^2/s^2")'
print, hdx/dx,    format='("the effective thickness of the layer =       ", f6.2, 2x, "pixel")'
print, r_pix,     format='("the limit of the radius of resolved cores =  ", f6.2, 2x, "pixel")'

;***************************readin data***************************************
;; readin data
surfd=readfits(filename,sdh)

;; test
;i_nan = where(~finite(surfd), /null)
;surfd(i_nan)=0.0
;; end of test

surfd=surfd*1.4*mp                         ; convert number density to surface density

fsize=size(surfd)
nx = fsize(1)
ny = fsize(2)

;; set up coordinates for plotting
x=dindgen(nx)*dx                           ; coordinates for later plot
y=dindgen(ny)*dx

;******************************************************************************

;***********Calculating gravitational potential of the column density**********

k0x=2.*!pi/(2.*nx*dx)
k0y=2.*!pi/(2.*ny*dx)

;; Faking periodic surface density: original map at center + mean N outside
meanN = mean(surfd)
pad0_surfd=dblarr(2*nx,2*ny) + meanN
mnx=fix(0.5*nx)
mny=fix(0.5*ny)
pad0_surfd(mnx:nx+mnx-1, mny:ny+mny-1)=surfd(0:nx-1,0:ny-1)


;; wave number for gravitational potential calculation
kw=dblarr(2*nx,2*ny)

kx = dindgen(2*nx)-nx+1.
kx = shift(kx,-nx+1)

kyt = dindgen(2*ny)-ny+1.
kyt = shift(kyt,-ny+1)
ky = transpose(kyt)

kxx = k0x*rebin(kx,2*nx,2*ny)
kyy = k0y*rebin(ky,2*nx,2*ny)

kw = sqrt(kxx^2+kyy^2)

kw(0,0) = (min(kw)+max(kw))/2.             ; set kw(0,0) as non-zero value

;; FFT of zero-padded surface density
fsurfd=fft(pad0_surfd)

;; calculate gravitational potential
fphi_surfd=-2.*!pi*G*fsurfd/kw/(1.+kw*hdx)

fphi_surfd(0,0) = 0.0

phi_surfd=fft(fphi_surfd,/inverse)

;; gravitational potential
data=real_part(phi_surfd)

;; extract the original region
data = data(mnx:nx+mnx-1, mny:ny+mny-1)

;; make the potential positive for later core-finding
data=-(data-max(data))

;; convert potential to km/s
data=data/10.^10

;******************************************************************************

;*************merge local potential minima if Delta x < cls_pix***************

indx_phimin=extremes_2d(data,1) ; index array of local potential minima
                                ; (these are maxima of "data", since we have
                                ; changed the sign)

n_extremes=n_elements(indx_phimin)      ; number of local potential minima

;; if only one minimum, stop
if (n_extremes eq 1) then return,0 ; one core, no largest closed contour

;; 2d minima coordinates
jpeak=indx_phimin/nx
ipeak=indx_phimin-jpeak*nx

;; generate index for distance between minima
if (n_extremes gt 2) then begin
   ;measure distances between minima
   coord=[transpose(ipeak),transpose(jpeak)]
   dists=distance_measure(coord)

   i1=intarr(n_extremes-1)
   i1(*)=1
   for i=n_extremes-2,1,-1 do begin
       a=intarr(i)
       a(*)=n_extremes-i
       i1=[i1,a]
   endfor

;; get rid of the less-extreme minimum when two are close
   id_dis=where(dists le cls_pix,ct)
   if (ct gt 0) then begin
      indx_phimin(i1(id_dis))=-1
      n_extremes=n_extremes-ct

      indx_phimin=indx_phimin(where(indx_phimin ge 0))
      jpeak=indx_phimin/nx
      ipeak=indx_phimin-jpeak*nx
      print,"*********************************"
      print,ct,format='(5x,i3.3,1x,"minima excluded")'
      print,"*********************************"
   endif
endif

;****************************************************************************

;; if only one minimum, stop
if (n_extremes eq 1) then return,0

;**************************GRID core-finding*********************************
up_limit = 1.5 * max(data)         ; set up the upper threshold for search_2d

assign=intarr(nx,ny)

;; first mark all the extrema with unique labels
for i=0,n_extremes-1 do assign(indx_phimin(i))=i+1

for i=0,n_extremes-1 do begin
    flag_stop = 0
    
    phi_start=data(indx_phimin(i))
    print,i+1,n_extremes,format='("Working on No.",5x,i6.6,1x,"extreme out of",5x,i6.6)'
    while (flag_stop eq 0) do begin
       pix=search2d(data,ipeak(i),jpeak(i),phi_start,up_limit,/diagonal)
       new_pix=assign(pix)
       nc=new_pix(uniq(new_pix,sort(new_pix))) 
       if (n_elements(nc) le 2) then begin
          assign(pix) = i + 1
          phi_start  = phi_start - dphi
       endif else begin
          flag_stop = 1
       endelse
    endwhile
endfor
;***************************************************************************

;***********************Reject unresolved cores******************************
;; reject clumps with fewer than npixmin pixels
ncore=n_extremes
npixmin=fix(!pi*r_pix^2)
destroy_bad,npixmin,nbad
print,nbad,format='(5x,i6.6,1x,"bad cores excluded")'
;***************************************************************************

;*****resort the core ID sequence using the depth of potential wells********
pot_well = fltarr(ncore)
for i=1,ncore do begin
    clp_id = where(assign eq i)
    pot_well(i-1) = abs(max(data(clp_id)) - min(data(clp_id)))
endfor

new_seq = reverse(sort(pot_well))+1
new_assign= intarr(nx,ny)
for i=1,ncore do begin
    clp_id = where(assign eq new_seq(i-1))
    new_assign(clp_id)= i
endfor

assign = new_assign
new_assign = 0
;***************************************************************************

;***********************background subtraction******************************
;; if the original column density is background subtracted, no need to do this step
;; subtract the surface density background (the mean of bottom 10% of the non-core region)

atemp=where(assign eq 0)
btemp=where(assign ne 0)

tt=surfd(atemp)
tt=tt(sort(tt))
n_tt=n_elements(tt)
bg=mean(tt(0:n_tt/10))

;; surface density with background subtracted
surfd_rb = surfd-bg
;***************************************************************************

;***********************core parameters*************************************
core_para=dblarr(ncore,9)
assign_b=intarr(nx,ny)

boundcore2d,npixmin,surfd_rb,core_para,x,y
;***************************************************************************

;; time
delta_t=(systime(1)-t0)/60.0
print,format='(f9.1," minutes elapsed")',delta_t

;***********************output identified core areas***********************
lccname='lcc.fits'
lccname_b='lcc_b.fits'
outfn="core_parameters.dat"
coreplt="cores_phi_on_surfd.ps"

writefits,lccname,assign
writefits,lccname_b,assign_b
;***************************************************************************

;*********************output identified core parameters*********************
openw,100,outfn,/append
printf,100,"   #    i    j      mass   mass_bs  mass_bound n_tot n_bound  phi_max    D_phi"
printf,100,"                   M_sun    M_sun      M_sun    pix     pix  [km/s]^2   [km/s]^2"
for i = 0, ncore - 1 do begin
    coret=reform(core_para(i,*))
    printf,100,i+1,coret,format='(3(1x,i4.4),3(1x,g9.5),2(1x,i6.6),2(1x,g9.5))'
endfor
close,100
;***************************************************************************

;*********************plot identified core regions**************************

lev = [0.9,1.1]
indx=where(assign gt 0)
assign(indx) = 1
indx=where(assign_b gt 0,ct)
if (ct gt 0) then assign_b(indx) = 1

;; export the core+phi+surfd plot to a postscript file
x=x/pc
y=y/pc
set_plot,'ps'
device,filename=coreplt,/color,bits_per_pixel=8,/landscape
loadct,13
imdisp,alog10(surfd),/axis,xr=[min(x),max(x)],yr=[min(y),max(y)],xs=1,ys=1,range=[min(alog10(surfd)),max(alog10(surfd))],/noresize,xtitle="x [pc]",ytitle="y [pc]"
philev = findgen(20)*(max(data)-min(data))*0.05 + min(data)
contour,data,x,y,xstyle=1,ystyle=1,/overplot,levels=philev,c_colors=0
contour,assign,x,y,xstyle=1,ystyle=1,/overplot,levels=lev,c_colors=210,thick=8
contour,assign_b,x,y,xstyle=1,ystyle=1,/overplot,levels=lev,c_colors=255,thick=8
device,/close
set_plot,'x'

;***************************************************************************

print,"********************************************"
print,ncore,format='(5x,i6.6,1x,"cores found")'
print,"********************************************"
print,"corefind_surfd exited sucessfully"
;return core mass to main program
return,core_para

END

;***************************************************************************


;;-----------------------------------------------------------------------------
;;  functions
;;-----------------------------------------------------------------------------
pro destroy_bad,nmin,nbad  ; rejects those cores with number of pixels <= nmin

COMMON SHARE100,surfd,data,assign,assign_b,ncore
COMMON SHARE200,G,mp,dx,cs2,msun


ncore_new=0
nbad=0

for n1=1,ncore do begin
    iclp=where(assign eq n1,count)

    assign(iclp) -= nbad
    if (count le nmin) then begin
       nbad += 1
       assign(iclp)=0
    endif
endfor

ncore = ncore - nbad
end

;;-----------------------------------------------------------------------------
pro boundcore2d,nmin,surfd_rb,core_para,x,y  ; identifies bound region

COMMON SHARE100,surfd,data,assign,assign_b,ncore
COMMON SHARE200,G,mp,dx,cs2,msun

cell_area= dx * dx
nx=n_elements(x)
ny=n_elements(y)
for n1=1,ncore do begin

  print,n1,ncore,format='("Calculating core parameters of No.",5x,i6.6," out of",5x,i6.6," cores")'
  iclp=where(assign eq n1,count)
  ppeak = max(data(iclp),peak)

  jpeak=iclp(peak)/nx
  ipeak=iclp(peak)-jpeak*nx

;coordinates of core centers [pixel #]
  core_para(n1-1,0)=ipeak
  core_para(n1-1,1)=jpeak

;the local gravitational potential minimum [(km/s)^2]
  core_para(n1-1,7)=ppeak                

; mass of core without background subtraction [Msun]
  core_para(n1-1,2)= total(surfd(iclp))*cell_area/msun

; mass of core with background subtraction  [Msun]
  core_para(n1-1,3)= total(surfd_rb(iclp))*cell_area/msun

; calculate the total energy inside cores (E_p + E_k)
  surfd_iclp=surfd(iclp)
  phi_iclp=data(iclp)
  phi_edge=min(phi_iclp)
  phi_bott=max(phi_iclp)

  E_w=phi_iclp-phi_edge

  iclp_bound0=where(E_w ge 1.5*cs2, ct0)

  if (ct0 ge nmin) then begin
; bound core index 
  assign_b(iclp(iclp_bound0))=n1
; mass of bound region [Msun]
     core_para(n1-1,4)=total(surfd_rb(iclp(iclp_bound0)))*cell_area/msun
; pixel number of the bound region
     core_para(n1-1,6)=ct0
  endif else begin
; core not bound
     core_para(n1-1,4)=0.0
     core_para(n1-1,6)=0
  endelse

; the depth of the potential well in which the core resides [(km/s)^2]
  core_para(n1-1,8)=(phi_bott-phi_edge)   
; pixel number of the whole core area
  core_para(n1-1,5)=count
endfor
END
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;+
; NAME:
;       EXTREMES_2D
; PURPOSE:
;       Find local extremes in a 2-d array.
; CATEGORY:
; CALLING SEQUENCE:
;       ind = extremes_2d(z, flag)
; INPUTS:
;       z = 2-d array to search.                          in
;       flag = min/max flag: -1 for min, 1 for max.       in
; KEYWORD PARAMETERS:
;       Keywords:
;         /EDGES   Means examine image edges (default ignores edges).
;         VALUE=v  Returned values at each extreme.
; OUTPUTS:
;       ind = 1-d indices of local extremes (-1 if none). out
; COMMON BLOCKS:
; NOTES:
;       Notes: Mimima are sorted in ascending order of value.
;              Maxima are sorted in descending order of value.
;         2-d indices may be found from: one2two,ind,z,ix,iy.
;         Noisy images should be smoothed first.
; MODIFICATION HISTORY:
;       R. Sterner, 23 Dec, 1993
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	function extremes_2d, z, flag, value=v, edges=edges, help=hlp
 
	if (n_params(0) lt 2) or keyword_set(hlp) then begin
	  print,' Find local extremes in a 2-d array.'
	  print,' ind = extremes_2d(z, flag)'
	  print,'   z = 2-d array to search.                          in'
	  print,'   flag = min/max flag: -1 for min, 1 for max.       in'
	  print,'   ind = 1-d indices of local extremes (-1 if none). out'
	  print,' Keywords:'
	  print,'   /EDGES   Means examine image edges (default ignores edges).'
	  print,'   VALUE=v  Returned values at each extreme.'
	  print,' Notes: Mimima are sorted in ascending order of value.'
	  print,'        Maxima are sorted in descending order of value.'
	  print,'   2-d indices may be found from: one2two,ind,z,ix,iy.'
	  print,'   Noisy images should be smoothed first.'
	  return,''
	endif
 
	sz = size(z)			; Image size.
	nx = sz(1)
	ny = sz(2)
	c = bytarr(nx,ny)		; Accumulator. 
	dx = [1,1,0,-1,-1,-1,0,1]	; Shift tables.
	dy = [0,1,1,1,0,-1,-1,-1]
 
	for i = 0, 7 do begin		; Compare neighboring pixels.
	  s = shift(z,dx(i),dy(i))
	  if flag gt 0 then begin	; Max.
	    c = c + (z gt s)
	  endif else begin		; Min.
	    c = c + (z lt s)
	  endelse
	endfor
 
	if not keyword_set(edges) then imgfrm, c, 0	; Drop edges (invalid).
 
	w = where(c eq 8,cnt)		; Extremes.
	if cnt le 0 then return,-1
 
	v = z(w)			; Find values at extremes.
 
	s = sort(v)			; Find sort order.
	if flag gt 0 then s = reverse(s)
 
	v = v(s)			; Sort
	w = w(s)
 
	return, w
 
	end

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
FUNCTION IMDISP_GETPOS, ASPECT, POSITION=POSITION, MARGIN=MARGIN

;- Compute a position vector given an aspect ratio (called by IMDISP_IMSIZE)

;- Check arguments
if (n_params() ne 1) then message, 'Usage: RESULT = IMDISP_GETPOS(ASPECT)'
if (n_elements(aspect) eq 0) then message, 'ASPECT is undefined'

;- Check keywords
if (n_elements(position) eq 0) then position = [0.0, 0.0, 1.0, 1.0]
if (n_elements(margin) eq 0) then margin = 0.1

;- Get range limited aspect ratio and margin input values
aspect_val = (float(aspect[0]) > 0.01) < 100.0
margin_val = (float(margin[0]) > 0.0) < 0.495

;- Compute aspect ratio of position vector in this window
xsize = (position[2] - position[0]) * !d.x_vsize
ysize = (position[3] - position[1]) * !d.y_vsize
cur_aspect = ysize / xsize

;- Compute aspect ratio of this window
win_aspect = float(!d.y_vsize) / float(!d.x_vsize)

;- Compute height and width in normalized units
if (aspect_val ge cur_aspect) then begin
  height = (position[3] - position[1]) - 2.0 * margin
  width  = height * (win_aspect / aspect_val)
endif else begin
  width  = (position[2] - position[0]) - 2.0 * margin
  height = width * (aspect_val / win_aspect)
endelse

;- Compute and return position vector
xcenter = 0.5 * (position[0] + position[2])
ycenter = 0.5 * (position[1] + position[3])
x0 = xcenter - 0.5 * width
y0 = ycenter - 0.5 * height
x1 = xcenter + 0.5 * width
y1 = ycenter + 0.5 * height
return, [x0, y0, x1, y1]

END
;-------------------------------------------------------------------------------
FUNCTION IMDISP_IMSCALE, IMAGE, RANGE=RANGE, BOTTOM=BOTTOM, NCOLORS=NCOLORS, $
  NEGATIVE=NEGATIVE

;- Byte-scale an image (called by IMDISP)

;- Check arguments
if (n_params() ne 1) then message, 'Usage: RESULT = IMDISP_IMSCALE(IMAGE)'
if (n_elements(image) eq 0) then message, 'Argument IMAGE is undefined'

;- Check keywords
if (n_elements(range) eq 0) then begin
  min_value = min(image, max=max_value)
  range = [min_value, max_value]
endif
if (n_elements(bottom) eq 0) then bottom = 0B
if (n_elements(ncolors) eq 0) then ncolors = !d.table_size - bottom

;- Compute the scaled image
scaled = bytscl(image, min=range[0], max=range[1], top=(ncolors - 1))

;- Create a negative image if required
if keyword_set(negative) then scaled = byte(ncolors - 1) - scaled

;- Return the scaled image in the correct color range
return, scaled + byte(bottom)

END
;-------------------------------------------------------------------------------
FUNCTION IMDISP_IMREGRID, DATA, NX, NY, INTERP=INTERP

;- Regrid a 2D array (called by IMDISP)

;- Check arguments
if (n_params() ne 3) then $
  message, 'Usage: RESULT = IMDISP_IMREGRID(DATA, NX, NY)'
if (n_elements(data) eq 0) then message, 'Argument DATA is undefined'
result = size(data)
ndims = result[0]
dims = result[1:ndims]
if (ndims ne 2) then message, 'Argument DATA must have 2 dimensions'
if (n_elements(nx) eq 0) then message, 'Argument NX is undefined'
if (n_elements(ny) eq 0) then message, 'Argument NY is undefined'
if (nx lt 1) then message, 'NX must be 1 or greater'
if (ny lt 1) then message, 'NY must be 1 or greater'

;- Copy the array if the requested size is the same as the current size
if (nx eq dims[0]) and (ny eq dims[1]) then begin
  new = data
  return, new
endif

;- Compute index arrays for bilinear interpolation
xindex = (findgen(nx) + 0.5) * (dims[0] / float(nx)) - 0.5
yindex = (findgen(ny) + 0.5) * (dims[1] / float(ny)) - 0.5

;- Round the index arrays if nearest neighbor sampling is required
if (keyword_set(interp) eq 0) then begin
  xindex = round(xindex)
  yindex = round(yindex)
endif

;- Return regridded array
return, interpolate(data, xindex, yindex, /grid)

END
;-------------------------------------------------------------------------------
PRO IMDISP_IMSIZE, IMAGE, X0, Y0, XSIZE, YSIZE, ASPECT=ASPECT, $
  POSITION=POSITION, MARGIN=MARGIN

;- Compute the size and offset for an image (called by IMDISP)

;- Check arguments
if (n_params() ne 5) then $
  message, 'Usage: IMDISP_IMSIZE, IMAGE, X0, Y0, XSIZE, YSIZE'
if (n_elements(image) eq 0) then $
  message, 'Argument IMAGE is undefined'
if (n_elements(position) eq 0) then position = [0.0, 0.0, 1.0, 1.0]
if (n_elements(position) ne 4) then $
  message, 'POSITION must be a 4 element vector'
if (n_elements(margin) eq 0) then margin = 0.1
if (n_elements(margin) ne 1) then $
  message, 'MARGIN must be a scalar'

;- Get image dimensions
result = size(image)
ndims = result[0]
if (ndims ne 2) then message, 'IMAGE must be a 2D array'
dims = result[1 : ndims]

;- Get aspect ratio for image
if (n_elements(aspect) eq 0) then $
  aspect = float(dims[1]) / float(dims[0])
if (n_elements(aspect) ne 1) then $
  message, 'ASPECT must be a scalar'

;- Check output parameters
if (arg_present(x0) ne 1) then message, 'Argument XO cannot be set'
if (arg_present(y0) ne 1) then message, 'Argument YO cannot be set'
if (arg_present(xsize) ne 1) then message, 'Argument XSIZE cannot be set'
if (arg_present(ysize) ne 1) then message, 'Argument YSIZE cannot be set'

;- Get approximate image position
position = imdisp_getpos(aspect, position=position, margin=margin)

;- Compute lower left position of image (device units)
x0 = round(position[0] * !d.x_vsize) > 0L
y0 = round(position[1] * !d.y_vsize) > 0L

;- Compute size of image (device units)
xsize = round((position[2] - position[0]) * !d.x_vsize) > 2L
ysize = round((position[3] - position[1]) * !d.y_vsize) > 2L

;- Recompute the image position based on actual image size
position = fltarr(4)
position[0] = x0 / float(!d.x_vsize)
position[1] = y0 / float(!d.y_vsize)
position[2] = (x0 + xsize) / float(!d.x_vsize)
position[3] = (y0 + ysize) / float(!d.y_vsize)

END
;-------------------------------------------------------------------------------
PRO IMDISP, IMAGE, RANGE=RANGE, BOTTOM=BOTTOM, NCOLORS=NCOLORS, $
  MARGIN=MARGIN, INTERP=INTERP, DITHER=DITHER, ASPECT=ASPECT, $
  POSITION=POSITION, OUT_POS=OUT_POS, NOSCALE=NOSCALE, NORESIZE=NORESIZE, $
  ORDER=ORDER, USEPOS=USEPOS, CHANNEL=CHANNEL, $
  BACKGROUND=BACKGROUND, ERASE=ERASE, $
  AXIS=AXIS, NEGATIVE=NEGATIVE, _EXTRA=EXTRA_KEYWORDS

;+
; NAME:
;    IMDISP
;
; PURPOSE:
;    Display an image on the current graphics device.
;    IMDISP is an advanced replacement for TV and TVSCL.
;
;    - Supports WIN, MAC, X, CGM, PCL, PRINTER, PS, and Z graphics devices,
;    - Image is automatically byte-scaled (can be disabled),
;    - Custom byte-scaling of Pseudo color images via the RANGE keyword,
;    - Pseudo (indexed) color and True color images are handled automatically,
;    - 8-bit and 24-bit graphics devices  are handled automatically,
;    - Decomposed color settings are handled automatically,
;    - Image is automatically sized to fit the display (can be disabled),
;    - The !P.MULTI system variable is honored for multiple image display,
;    - Image can be positioned via the POSITION keyword,
;    - Color table splitting via the BOTTOM and NCOLORS keywords,
;    - Image aspect ratio customization via the ASPECT keyword,
;    - Resized images can be resampled (default) or interpolated,
;    - Top down image display via the ORDER keyword (!ORDER is ignored),
;    - Selectable display channel (R/G/B) via the CHANNEL keyword,
;    - Background can be set to a specified color via the BACKGROUND keyword,
;    - Screen can be erased prior to image display via the ERASE keyword,
;    - Plot axes can be drawn on the image via the AXIS keyword,
;    - Photographic negative images can be displayed via the NEGATIVE keyword.
;
; CATEGORY:
;    Image display
;
; CALLING SEQUENCE:
;    IMDISP, IMAGE
;
; INPUTS:
;    IMAGE       Array containing image data.
;                Pseudo (indexed) color images must have 2 dimensions.
;                True color images must have 3 dimensions, in either
;                [3, NX, NY], [NX, 3, NY], or [NX, NY, 3] form.
;
; OPTIONAL INPUTS:
;    None.
;
; KEYWORD PARAMETERS:
;    RANGE       For Pseudo Color images only, a vector with two elements
;                specifying the minimum and maximum values of the image
;                array to be considered when the image is byte-scaled
;                (default is minimum and maximum array values).
;                This keyword is ignored for True Color images,
;                or if the NOSCALE keyword is set.
;
;    BOTTOM      Bottom value in the color table to be used
;                for the byte-scaled image
;                (default is 0).
;                This keyword is ignored if the NOSCALE keyword is set.
;
;    NCOLORS     Number of colors in the color table to be used
;                for the byte-scaled image
;                (default is !D.TABLE_SIZE - BOTTOM).
;                This keyword is ignored if the NOSCALE keyword is set.
;
;    MARGIN      A scalar value specifying the margin to be maintained
;                around the image in normal coordinates
;                (default is 0.1, or 0.025 if !P.MULTI is set to display
;                multiple images).
;
;    INTERP      If set, the resized image will be interpolated using
;                bilinear interpolation
;                (default is nearest neighbor sampling).
;
;    DITHER      If set, true color images will be dithered when displayed
;                on an 8-bit graphics device
;                (default is no dithering).
;
;    ASPECT      A scalar value specifying the aspect ratio (height/width)
;                for the displayed image
;                (default is to maintain native aspect ratio).
;
;    POSITION    On input, a 4-element vector specifying the position
;                of the displayed image in the form [X0,Y0,X1,Y1] in
;                in normal coordinates
;                (default is [0.0,0.0,1.0,1.0]).
;                See the examples below to display an image where only the
;                offset and size are known (e.g. MAP_IMAGE output).
;
;    OUT_POS     On output, a 4-element vector specifying the position
;                actually used to display the image.
;
;    NOSCALE     If set, the image will not be byte-scaled
;                (default is to byte-scale the image).
;
;    NORESIZE    If set, the image will not be resized.
;                (default is to resize the image to fit the display).
;
;    ORDER       If set, the image is displayed from the top down
;                (default is to display the image from the bottom up).
;                Note that the system variable !ORDER is always ignored.
;
;    USEPOS      If set, the image will be sized to exactly fit a supplied
;                POSITION vector, over-riding ASPECT and MARGIN
;                (default is to honor ASPECT and MARGIN when a POSITION
;                vector is supplied).
;
;    CHANNEL     Display channel (Red, Green, or Blue) to be written.
;                0 => All channels (the default)
;                1 => Red channel
;                2 => Green channel
;                3 => Blue channel
;                This keyword is only recognized by graphics devices which
;                support 24-bit decomposed color (WIN, MAC, X). It is ignored
;                by all other graphics devices. However True color (RGB)
;                images can be displayed on any device supported by IMDISP.
;
;    BACKGROUND  If set to a positive integer, the background will be filled
;                with the color defined by BACKGROUND.
;
;    ERASE       If set, the screen contents will be erased. Note that if
;                !P.MULTI is set to display multiple images, the screen is
;                always erased when the first image is displayed.
;
;    AXIS        If set, plot axes will be drawn on the image. The default
;                x and y axis ranges are determined by the size of the image.
;                When the AXIS keyword is set, IMDISP accepts any keywords
;                supported by PLOT (e.g. TITLE, COLOR, CHARSIZE etc.).
;
;    NEGATIVE    If set, a photographic negative of the image is displayed.
;                The values of BOTTOM and NCOLORS are honored. This keyword
;                allows True color images scanned from color negatives to be
;                displayed. It also allows Pseudo color images to be displayed
;                as negatives without reversing the color table. This keyword
;                is ignored if the NOSCALE keyword is set.
;
; OUTPUTS:
;    None.
;
; OPTIONAL OUTPUTS:
;    None
;
; COMMON BLOCKS:
;    None
;
; SIDE EFFECTS:
;    The image is displayed on the current graphics device.
;
; RESTRICTIONS:
;    Requires IDL 5.0 or higher (square bracket array syntax).
;
; EXAMPLE:
;
;;- Load test data
;
;openr, lun, filepath('ctscan.dat', subdir='examples/data'), /get_lun
;ctscan = bytarr(256, 256)
;readu, lun, ctscan
;free_lun, lun
;openr, lun, filepath('hurric.dat', subdir='examples/data'), /get_lun
;hurric = bytarr(440, 330)
;readu, lun, hurric
;free_lun, lun
;read_jpeg, filepath('rose.jpg', subdir='examples/data'), rose
;help, ctscan, hurric, rose
;
;;- Display single images
;
;!p.multi = 0
;loadct, 0
;imdisp, hurric, /erase
;wait, 3.0
;imdisp, rose, /interp, /erase
;wait, 3.0
;
;;- Display multiple images without color table splitting
;;- (works on 24-bit displays only; top 2 images are garbled on 8-bit displays)
;
;!p.multi = [0, 1, 3, 0, 0]
;loadct, 0
;imdisp, ctscan, margin=0.02
;loadct, 13
;imdisp, hurric, margin=0.02
;imdisp, rose, margin=0.02
;wait, 3.0
;
;;- Display multiple images with color table splitting
;;- (works on 8-bit or 24-bit displays)
;
;!p.multi = [0, 1, 3, 0, 0]
;loadct, 0, ncolors=64, bottom=0
;imdisp, ctscan, margin=0.02, ncolors=64, bottom=0
;loadct, 13, ncolors=64, bottom=64
;imdisp, hurric, margin=0.02, ncolors=64, bottom=64
;imdisp, rose, margin=0.02, ncolors=64, bottom=128
;wait, 3.0
;
;;- Display an image at a specific position, over-riding aspect and margin
;
;!p.multi = 0
;loadct, 0
;imdisp, hurric, position=[0.0, 0.0, 1.0, 0.5], /usepos, /erase
;wait, 3.0
;
;;- Display an image with axis overlay
;
;!p.multi = 0
;loadct, 0
;imdisp, rose, /axis, /erase
;wait, 3.0
;
;;- Display an image with contour plot overlay
;
;!p.multi = 0
;loadct, 0
;imdisp, hurric, out_pos=out_pos, /erase
;contour, smooth(hurric, 10, /edge), /noerase, position=out_pos, $
;  xstyle=1, ystyle=1, levels=findgen(5)*40.0, /follow
;wait, 3.0
;
;;- Display a small image with correct resizing
;
;!p.multi = 0
;loadct, 0
;data = (dist(8))[1:7, 1:7]
;imdisp, data, /erase
;wait, 3.0
;imdisp, data, /interp
;wait, 3.0
;
;;- Display a true color image without and with interpolation
;
;!p.multi = 0
;imdisp, rose, /erase
;wait, 3.0
;imdisp, rose, /interp
;wait, 3.0
;
;;- Display a true color image as a photographic negative
;
;imdisp, rose, /negative, /erase
;wait, 3.0
;
;;- Display a true color image on PostScript output
;;- (note that color table is handled automatically)
;
;current_device = !d.name
;set_plot, 'PS'
;device, /color, bits_per_pixel=8, filename='imdisp_true.ps'
;imdisp, rose, /axis, title='PostScript True Color Output'
;device, /close
;set_plot, current_device
;
;;- Display a pseudo color image on PostScript output
;
;current_device = !d.name
;set_plot, 'PS'
;device, /color, bits_per_pixel=8, filename='imdisp_pseudo.ps'
;loadct, 0
;imdisp, hurric, /axis, title='PostScript Pseudo Color Output'
;device, /close
;set_plot, current_device
;
;;- Display an image where only the offset and size are known
;
;;- Read world elevation data
;file = filepath('worldelv.dat', subdir='examples/data')
;openr, lun, file, /get_lun
;data = bytarr(360, 360)
;readu, lun, data
;free_lun, lun
;;- Reorganize array so it spans 180W to 180E
;world = data
;world[0:179, *] = data[180:*, *]
;world[180:*, *] = data[0:179, *]
;;- Create remapped image
;map_set, /orthographic, /isotropic, /noborder
;remap = map_image(world, x0, y0, xsize, ysize, compress=1)
;;- Convert offset and size to position vector
;pos = fltarr(4)
;pos[0] = x0 / float(!d.x_vsize)
;pos[1] = y0 / float(!d.y_vsize)
;pos[2] = (x0 + xsize) / float(!d.x_vsize)
;pos[3] = (y0 + ysize) / float(!d.y_vsize)
;;- Display the image
;loadct, 0
;imdisp, remap, pos=pos, /usepos
;map_continents
;map_grid
;
; MODIFICATION HISTORY:
; Liam.Gumley@ssec.wisc.edu
; http://cimss.ssec.wisc.edu/~gumley
; $Id: imdisp.pro,v 1.45 2000/08/28 16:17:14 gumley Exp $
;
; Copyright (C) 1999, 2000 Liam E. Gumley
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;-

rcs_id = '$Id: imdisp.pro,v 1.45 2000/08/28 16:17:14 gumley Exp $'

;-------------------------------------------------------------------------------
;- CHECK INPUT
;-------------------------------------------------------------------------------

;- Check arguments
if (n_params() ne 1) then message, 'Usage: IMDISP, IMAGE'
if (n_elements(image) eq 0) then message, 'Argument IMAGE is undefined'
if (max(!p.multi) eq 0) then begin
  if (n_elements(margin) eq 0) then begin
    if (n_elements(position) eq 4) then margin = 0.0 else margin = 0.1
  endif
endif else begin
  if (n_elements(margin) eq 0) then margin = 0.025
endelse
if (n_elements(order) eq 0) then order = 0
if (n_elements(channel) eq 0) then channel = 0

;- Check position vector
if (n_elements(position) gt 0) then begin
  if (n_elements(position) ne 4) then $
    message, 'POSITION must be a 4 element vector of the form [X0, Y0, X1, Y1]'
  if (position[0] lt 0.0) then message, 'POSITION[0] must be GE 0.0'
  if (position[1] lt 0.0) then message, 'POSITION[1] must be GE 0.0'
  if (position[2] gt 1.0) then message, 'POSITION[2] must be LE 1.0'
  if (position[3] gt 1.0) then message, 'POSITION[3] must be LE 1.0'
  if (position[0] ge position[2]) then $
    message, 'POSITION[0] must be LT POSITION[2]'
  if (position[1] ge position[3]) then $
    message, 'POSITION[1] must be LT POSITION[3]'
endif

;- Check the image dimensions
result = size(image)
ndims = result[0]
if (ndims lt 2) or (ndims gt 3) then $
  message, 'IMAGE must be a Pseudo Color (2D) or True Color (3D) image array'
dims = result[1:ndims]

;- Check that 3D image array is in valid true color format
true = 0
if (ndims eq 3) then begin
  index = where(dims eq 3L, count)
  if (count eq 0) then $
    message, 'True Color dimensions must be [3,NX,NY], [NX,3,NY], or [NX,NY,3]'
  true = 1
  truedim = index[0]
endif

;- Check scaling range for pseudo color images
if (true eq 0) then begin
  if (n_elements(range) eq 0) then begin
    min_value = min(image, max=max_value)
    range = [min_value, max_value]
  endif
  if (n_elements(range) ne 2) then $
    message, 'RANGE keyword must be a 2-element vector'
endif else begin
  if (n_elements(range) gt 0) then $
    message, 'RANGE keyword is not used for True Color images', /continue
endelse

;- Check for supported graphics devices
names = ['WIN', 'MAC', 'X', 'CGM', 'PCL', 'PRINTER', 'PS', 'Z']
result = where((!d.name eq names), count)
if (count eq 0) then message, 'Graphics device is not supported'

;- Get color table information
if ((!d.flags and 256) ne 0) and (!d.window lt 0) then begin
  window, /free, /pixmap
  wdelete, !d.window
endif
if (n_elements(bottom) eq 0) then bottom = 0
if (n_elements(ncolors) eq 0) then ncolors = !d.table_size - bottom

;- Get IDL version number
version = float(!version.release)

;- Check for IDL 5.2 or higher if printer device is selected
if (version lt 5.2) and (!d.name eq 'PRINTER') then $
  message, 'IDL 5.2 or higher is required for PRINTER device support'

;-------------------------------------------------------------------------------
;- GET RED, GREEN, AND BLUE COMPONENTS OF TRUE COLOR IMAGE
;-------------------------------------------------------------------------------

if (true eq 1) then begin
    case truedim of
      0 : begin
            red = image[0, *, *]
            grn = image[1, *, *]
            blu = image[2, *, *]
      end
      1 : begin
            red = image[*, 0, *]
            grn = image[*, 1, *]
            blu = image[*, 2, *]
      end
      2 : begin
            red = image[*, *, 0]
            grn = image[*, *, 1]
            blu = image[*, *, 2]
      end
  endcase
  red = reform(red, /overwrite)
  grn = reform(grn, /overwrite)
  blu = reform(blu, /overwrite)
endif

;-------------------------------------------------------------------------------
;- COMPUTE POSITION FOR IMAGE
;-------------------------------------------------------------------------------

;- Save first element of !p.multi
multi_first = !p.multi[0]

;- Establish image position if not defined
if (n_elements(position) eq 0) then begin
  if (max(!p.multi) eq 0) then begin
    position = [0.0, 0.0, 1.0, 1.0]
  endif else begin
    plot, [0], /nodata, xstyle=4, ystyle=4, xmargin=[0, 0], ymargin=[0, 0]
    position = [!x.window[0], !y.window[0], !x.window[1], !y.window[1]]
  endelse
endif

;- Erase and fill the background if required
if (multi_first eq 0) then begin
  if keyword_set(erase) then erase
  if (n_elements(background) gt 0) then begin
    polyfill, [-0.01,  1.01,  1.01, -0.01, -0.01], $
      [-0.01, -0.01,  1.01,  1.01, -0.01], /normal, color=background[0]
  endif
endif

;- Compute image aspect ratio if not defined
if (n_elements(aspect) eq 0) then begin
  case true of
    0 : result = size(image)
    1 : result = size(red)
  endcase
  dims = result[1:2]
  aspect = float(dims[1]) / float(dims[0])
endif

;- Save image xrange and yrange for axis overlays
xrange = [0, dims[0]]
yrange = [0, dims[1]]
if (order eq 1) then yrange = reverse(yrange)

;- Set the aspect ratio and margin to fill the position window if requested
if keyword_set(usepos) then begin
  xpos_size = float(!d.x_vsize) * (position[2] - position[0])
  ypos_size = float(!d.y_vsize) * (position[3] - position[1])
  aspect_value = ypos_size / xpos_size
  margin_value = 0.0
endif else begin
  aspect_value = aspect
  margin_value = margin
endelse

;- Compute size of displayed image and save output position
pos = position
case true of
  0 : imdisp_imsize, image, x0, y0, xsize, ysize, position=pos, $
        aspect=aspect_value, margin=margin_value
  1 : imdisp_imsize,   red, x0, y0, xsize, ysize, position=pos, $
        aspect=aspect_value, margin=margin_value
endcase
out_pos = pos

;-------------------------------------------------------------------------------
;- BYTE-SCALE THE IMAGE IF REQUIRED
;-------------------------------------------------------------------------------

;- Choose whether to scale the image or not
if (keyword_set(noscale) eq 0) then begin

  ;- Scale the image
  case true of
    0 : scaled = imdisp_imscale(image, bottom=bottom, ncolors=ncolors, $
          range=range, negative=keyword_set(negative))
    1 : begin
          scaled_dims = (size(red))[1:2]
          scaled = bytarr(scaled_dims[0], scaled_dims[1], 3)
          scaled[*, *, 0] = imdisp_imscale(red, bottom=0, ncolors=256, $
            negative=keyword_set(negative))
          scaled[*, *, 1] = imdisp_imscale(grn, bottom=0, ncolors=256, $
            negative=keyword_set(negative))
          scaled[*, *, 2] = imdisp_imscale(blu, bottom=0, ncolors=256, $
            negative=keyword_set(negative))
        end
  endcase

endif else begin

  ;- Don't scale the image
  case true of
    0 : scaled = image
    1 : begin
          scaled_dims = (size(red))[1:2]
          scaled = replicate(red[0], scaled_dims[0], scaled_dims[1], 3)
          scaled[*, *, 0] = red
          scaled[*, *, 1] = grn
          scaled[*, *, 2] = blu
        end
  endcase

endelse

;-------------------------------------------------------------------------------
;- DISPLAY IMAGE ON PRINTER DEVICE
;-------------------------------------------------------------------------------

if (!d.name eq 'PRINTER') then begin

  ;- Display the image
  case true of
    0 : begin
          device, /index_color
          tv, scaled, x0, y0, xsize=xsize, ysize=ysize, order=order
        end
    1 : begin
          device, /true_color
          tv, scaled, x0, y0, xsize=xsize, ysize=ysize, order=order, true=3
        end
  endcase

  ;- Draw axes if required
  if keyword_set(axis) then $
    plot, [0], /nodata, /noerase, position=out_pos, $
      xrange=xrange, xstyle=1, yrange=yrange, ystyle=1, $
      _extra=extra_keywords

  ;- Return to caller
  return

endif

;-------------------------------------------------------------------------------
;- DISPLAY IMAGE ON GRAPHICS DEVICES WHICH HAVE SCALEABLE PIXELS
;-------------------------------------------------------------------------------

if ((!d.flags and 1) ne 0) then begin

  ;- Display the image
  case true of
    0 : tv, scaled, x0, y0, xsize=xsize, ysize=ysize, order=order
    1 : begin
          tvlct, r, g, b, /get
          loadct, 0, /silent
          tv, scaled, x0, y0, xsize=xsize, ysize=ysize, order=order, true=3
          tvlct, r, g, b
        end
  endcase

  ;- Draw axes if required
  if keyword_set(axis) then $
    plot, [0], /nodata, /noerase, position=out_pos, $
      xrange=xrange, xstyle=1, yrange=yrange, ystyle=1, $
      _extra=extra_keywords

  ;- Return to caller
  return

endif

;-------------------------------------------------------------------------------
;- RESIZE THE IMAGE
;-------------------------------------------------------------------------------

;- Resize the image
if (keyword_set(noresize) eq 0) then begin
  if (true eq 0) then begin
    resized = imdisp_imregrid(scaled, xsize, ysize, interp=keyword_set(interp))
  endif else begin
    resized = replicate(scaled[0], xsize, ysize, 3)
    resized[*, *, 0] = imdisp_imregrid(reform(scaled[*, *, 0]), xsize, ysize, $
      interp=keyword_set(interp))
    resized[*, *, 1] = imdisp_imregrid(reform(scaled[*, *, 1]), xsize, ysize, $
      interp=keyword_set(interp))
    resized[*, *, 2] = imdisp_imregrid(reform(scaled[*, *, 2]), xsize, ysize, $
      interp=keyword_set(interp))
  endelse
endif else begin
  resized = temporary(scaled)
  x0 = 0
  y0 = 0
endelse

;-------------------------------------------------------------------------------
;- GET BIT DEPTH FOR THIS DISPLAY
;-------------------------------------------------------------------------------

;- If this device supports windows, make sure a window has been opened
if (!d.flags and 256) ne 0 then begin
  if (!d.window lt 0) then begin
    window, /free, /pixmap
    wdelete, !d.window
  endif
endif

;- Set default display depth
depth = 8

;- Get actual bit depth on supported displays
if (!d.name eq 'WIN') or (!d.name eq 'MAC') or (!d.name eq 'X') then begin
  if (version ge 5.1) then begin
    device, get_visual_depth=depth
  endif else begin
    if (!d.n_colors gt 256) then depth = 24
  endelse
endif

;-------------------------------------------------------------------------------
;- SELECT DECOMPOSED COLOR MODE (ON OR OFF) FOR 24-BIT DISPLAYS
;-------------------------------------------------------------------------------

if (!d.name eq 'WIN') or (!d.name eq 'MAC') or (!d.name eq 'X') then begin
  if (depth gt 8) then begin
    if (version ge 5.2) then device, get_decomposed=entry_decomposed else $
      entry_decomposed = 0
    if (true eq 1) or (channel gt 0) then device, decomposed=1 else $
      device, decomposed=0
  endif
endif

;-------------------------------------------------------------------------------
;- DISPLAY THE IMAGE
;-------------------------------------------------------------------------------

;- If the display is 8-bit and the image is true color,
;- convert image from true color to indexed color
if (depth le 8) and (true eq 1) then begin
  resized = color_quan(temporary(resized), 3, r, g, b, $
    colors=ncolors, dither=keyword_set(dither)) + byte(bottom)
  tvlct, r, g, b, bottom
  true = 0
endif

;- Set channel value for supported devices
if (!d.name eq 'WIN') or (!d.name eq 'MAC') or (!d.name eq 'X') then begin
  channel_value = channel
endif else begin
  channel_value = 0
endelse

;- Display the image
case true of
  0 : tv, resized, x0, y0, order=order, channel=channel_value
  1 : tv, resized, x0, y0, order=order, true=3
endcase

;-------------------------------------------------------------------------------
;- RESTORE THE DECOMPOSED COLOR MODE FOR 24-BIT DISPLAYS
;-------------------------------------------------------------------------------

if (!d.name eq 'WIN') or (!d.name eq 'MAC') or (!d.name eq 'X') then begin
  if (depth gt 8) then device, decomposed=entry_decomposed
endif

;-------------------------------------------------------------------------------
;- DRAW AXES IF REQUIRED
;-------------------------------------------------------------------------------

if keyword_set(axis) then $
  plot, [0], /nodata, /noerase, position=out_pos, $
    xrange=xrange, xstyle=1, yrange=yrange, ystyle=1, $
    _extra=extra_keywords

END
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
