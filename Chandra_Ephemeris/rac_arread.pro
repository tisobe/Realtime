pro rac_arread,filename,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,skip=nsk
;+
;NAME:
;  rac_arread
;PURPOSE:
;  read data from a file into 1-D vectors
;CATEGORY:
;  
;CALLING SEQUENCE:
;  rac_arread,filename,a[,b,...,z][,skip=nsk]
;INPUTS:
;  filename = ASCII string, name of file from which data is read
;  a,b,c...etc. = the names of the 1-D arrays into which the data are put
;  skip = keyword giving the number of lines at start of file to skip over
;OUTPUTS:
;  none
;COMMON BLOCKS:
;  none
;SIDE EFFECTS:
;  temporarily allocates a logical unit number.
;RESTRICTIONS:
;  none
;PROCEDURE:
;  
;MODIFICATION HISTORY:
;  written by Robert Cameron, September 1990
;  added the skip keyword. Robert Cameron, July 1997.
;-
;
; count the number of lines in the file
;
spawn,'wc -l '+filename,info
numberlength=strsplit(strcompress(info(0)),' ')
nlines=strmid(info,0,numberlength(1))
;nlines=long(info(1))

print ,'% RAC_ARREAD: ',strtrim(nlines,2),' lines in the file ',filename
;
if n_elements(nsk) le 0 then nsk=0
names = 'abcdefghijklmnopqrstuvwxyz'
nvec = n_params(0)-1             ; NVEC = the number of arrays to be filled
nsk=0
nlines=fix(nlines)
print,nvec,nlines,nsk
;buff = dblarr(nvec,nlines-nsk)   ; setup a buffer array for the input data
buff = dblarr(7,500)   ; setup a buffer array for the input data
temp = dblarr(nvec)
openr,nlun,filename,/get_lun
;
; skip the first nsk lines
;
dumline=''
for nskip = 0,nsk-1 do readf,nlun,dumline
;
; read the data into a buffer
;
nel=0L
while not eof(nlun) do begin
  readf,nlun,temp
print,nel,temp,filename
  buff(0,nel)=temp
  nel=nel+1L
endwhile
free_lun,nlun
print,'% RAC_ARREAD: ',strtrim(nel,2),' lines read from ',filename
if nsk gt 0 then print,'% RAC_ARREAD: after ',strtrim(nsk,2),' skipped lines'
buff = buff(0:nvec-1,0L:nel-1L)
buff = transpose(buff)
for count = 0,nvec-1 do begin
  tst = execute(strmid(names,count,1)+'= buff(*,count)') 
endfor
return
end
