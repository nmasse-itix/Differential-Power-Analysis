#!/bin/sh

FOP_PREFIX="$HOME/bin/fop"
CLASSPATH="$FOP_PREFIX/build/fop.jar:$FOP_PREFIX/lib/xercesImpl.jar:$FOP_PREFIX/lib/xalan.jar"
CLASSPATH="$CLASSPATH:$FOP_PREFIX/lib/avalon-framework.jar:$FOP_PREFIX/lib/xml-apis.jar"
CLASSPATH="$CLASSPATH:$FOP_PREFIX/lib/commons-logging-1.0.4.jar:$FOP_PREFIX/lib/commons-io-1.1.jar"
CLASS="org.apache.fop.fonts.apps.TTFReader"
ENC="ansi"

if [ $# -ne 1 ]; then
  echo "Usage: $0 <ttf file>"
  exit 1
fi

java -cp "$CLASSPATH" "$CLASS" -enc "$ENC" "$1" "$(echo "$1" |sed 's/\.[Tt][Tt][Ff]//').xml"

