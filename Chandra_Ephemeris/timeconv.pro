pro timeconv,gmt,year,day,hour,min,sec,y0=y0

; convert a time in seconds to year, day, hour, min, sec
; should work with arrays of times

print,'% TIMECONV: NOTE! Day number starts with 1 at the beginning of a year!'

; Robert Cameron
; September 1999

nday=[31622400d0,31536000d0,31536000d0,31536000d0]

if n_elements(y0) eq 0 then y0=1970

year = gmt - gmt + y0
yidx = year mod 4
t = gmt
j = where(t ge nday(yidx),nj)

while (nj gt 0) do begin
  t(j) = t(j) - nday(yidx(j))
  year(j) = year(j) + 1
  yidx = year mod 4
  j = where(t ge nday(yidx),nj)
endwhile

year = year + t / nday(yidx)

day = t/86400.0

t = t - fix(day)*86400.0

day = day + 1

hour = t/3600.0

t = t - fix(hour)*3600.0

min = t/60.0

sec = t - fix(min)*60.0

return 

end

