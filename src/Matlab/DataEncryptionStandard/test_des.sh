#!/bin/sh

if [ $# -ne 2 ]; then
	echo "Usage: $0 key data"
	exit 1
fi

key="$1"
data="$2"

echo "The key is '$key'."
echo "The data is '$data'."

cmd=$(echo "$data" | sed -r "s/(..)(..)(..)(..)(..)(..)(..)(..)/awk 'BEGIN{ printf(\"%c%c%c%c%c%c%c%c\", 0x\1, 0x\2, 0x\3, 0x\4, 0x\5, 0x\6, 0x\7, 0x\8); exit; }'/")

enc=$( (eval $cmd) | openssl des -des-ecb -K "$key" -iv '0000000000000000' -nosalt -nopad -e |od -t x1 | head -n 1 |cut -d" " -f 2- )
dec=$( (eval $cmd) | openssl des -des-ecb -K "$key" -iv '0000000000000000' -nosalt -nopad -d |od -t x1 | head -n 1 |cut -d" " -f 2- )

echo "The encrypted data is '$enc'."
echo "The decrypted data is '$dec'."

