pro rac_arreadbl,filename,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
;+
;NAME:
;  rac_arreadbl
;PURPOSE:
;  read data from a file into 1-D vectors
;CATEGORY:
;  
;CALLING SEQUENCE:
;  rac_arreadbl,filename,a[,b,...,z]
;INPUTS:
;  filename = ASCII string, name of file from which data is read
;  a,b,c...etc. = the names of the 1-D arrays into which the data is put
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
;-
;
names = 'abcdefghijklmnopqrstuvwxyz'
nvec = n_params(0)-1             ; NVEC = the number of arrays to be filled
buff = dblarr(nvec,300000L)      ; setup a buffer array for the input data
temp = dblarr(nvec)
get_lun, nlun                    ; get an available logical unit number
openr,nlun,filename
nel=0L
while not eof(nlun) do begin
  readf,nlun,temp
  buff(0,nel)=temp
  nel=nel+1L
endwhile
free_lun,nlun
print,''
print,'% RAC_ARREADBL: ',strtrim(nel,2),' lines read from ',filename
buff = buff(0:nvec-1,0L:nel-1L)
buff = transpose(buff)
for count = 0,nvec-1 do begin
  tst = execute(strmid(names,count,1)+'= buff(*,count)') 
endfor
return
end
