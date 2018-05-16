; read CRM data cube

; Robert Cameron
; May 2004

filename = 'SolWind_Kp_PROT.ASC'
filename = 'XYZmap_MagSph_ACE_LIMIT.PROT'
;filename = 'XYZmap_MagSheath_ACE_Limit.PROT'
f = fltarr(60,60,60,9)
n = bytarr(60,60,60,9)
p = fltarr(60,60,60,3)
v = fltarr(3)
d = fltarr(9)
c = intarr(9)
dummy = ''
openr,nlun,filename,/get_lun
readf,nlun,dummy
while not eof(nlun) do begin & readf,nlun,i,j,k,v,d,c & f(i-1,j-1,k-1,*) = d & n(i-1,j-1,k-1,*) = c & xyz(i-1,j-1,k-1,*) = v & endwhile

end
