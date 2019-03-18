#!/usr/bin/env bash

gzipchk(){
  curl -sILH 'Accept-Encoding: gzip,deflate' "$@" | grep 'Content-Encoding:';
}

if [[ $(gzipchk "$@") ]]; then
  words=$(curl -A "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3" -H "Accept-Encoding: gzip" -s --raw -N "$1" | gunzip - | html2text -width 67 -nobs -style pretty | recode html | cat -s)
else
  words=$(curl -A "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3" -s --raw -N "$1" | html2text -width 67 -nobs -style pretty | recode html | cat -s)
fi

clr="\033[2J\033[f"
for word in $words; do
  echo -e "$clr"
  printf "%s" "$word" | figlet -c -w 80
  l=${#word}
  if ((l<=3)); then
    sleep 0.3
  elif ((l<=7));then
    sleep 0.2
  else
    sleep 0.3
  fi
done
