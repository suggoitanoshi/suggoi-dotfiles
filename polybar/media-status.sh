#!/bin/sh
length=30
delay=0.5
repeat=1
space=4
currentPos=0
currentCharCount=0
prefix=" ["
suffix="]"
separator=" | "
stopMsg="Stopped."
f="$prefix{{artist}}$separator{{title}}$suffix"

if [ $repeat -eq 0 ]; then
  f="$f"$(printf " %.0s" $(seq $((length-4))))
else [ $space -eq $space ] && f="$f"$(printf " %.0s" $(seq $space))
fi

ll=$(wc -L <<< "$prefix$stopMsg$suffix")
if [ $ll -lt $length ]; then
  half=$(((length-ll)/2))
  stopMsg="$prefix"$(printf " %.0s" $(seq $half))"$stopMsg"$(printf " %.0s" $(seq $((length-ll-half))))"$suffix"
  ll=
  half=
fi

while :; do
  current=$(playerctl metadata -f "$f" 2>/dev/null)
  if [ $? -ne 0 -o "$current" == "$prefix$separator$suffix" ]; then
    current="$stopMsg"
  fi
  if [ "$last" != "$current" ]; then
    last="$current"
    currentPos=0
    currentCharCount=$(wc -L <<< "$last")
  fi
  if [ $currentPos -ge $((${#last})) ]; then currentPos=0; fi
  out="${last:$currentPos:$length}"
  outLength=$(wc -L <<< $out)
  if [ $outLength -gt $length ]; then
    tempLength=$length
    while [ $outLength -gt $length ]; do
      ((tempLength-=1))
      out="${last:$currentPos:$tempLength}"
      outLength=$(wc -L <<< $out)
    done
  fi
  while [ $outLength -lt $length ]; do
    if [ $((length-outLength)) -eq 1 -a $(printf "%s" "${out:$((${#out}-1)):1} " | wc -L) -gt 1 ]; then
      out+=' '
      ((outLength+=1))
    fi
    remainder=$((length-outLength))
    remainderText="${last:0:$remainder}"
    remainderLength=$(wc -L <<< "$remainderText")
    while [ $((remainderLength+outLength)) -gt $length -a $remainder -gt 0 ]; do
      ((remainder+=-1))
      remainderText="${last:0:$remainder}"
      remainderLength=$(wc -L <<< "$remainderText")
    done
    out+="$remainderText"
    outLength=$((outLength+remainderLength))
  done
  echo "$out"
  sleep $delay
  ((currentPos+=1))
done
