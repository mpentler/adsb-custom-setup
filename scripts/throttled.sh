#!/bin/bash

# https://retropie.org.uk/forum/topic/2295/runcommand-warning-if-voltage-temperature-throttling

#Flag Bits
UNDERVOLTED=0x1
CAPPED=0x2
THROTTLED=0x4
HAS_UNDERVOLTED=0x10000
HAS_CAPPED=0x20000
HAS_THROTTLED=0x40000

#Output Strings
GOOD="NO"
BAD="YES"

#Get Status, extract hex
STATUS=$(vcgencmd get_throttled)
STATUS=${STATUS#*=}

echo -n "Status: "
(($STATUS!=0)) && echo "${STATUS}" || echo "${STATUS}"

echo -n "Undervolt:"
echo -n "   Now: "
((($STATUS&UNDERVOLTED)!=0)) && echo -n "$BAD" || echo -n "$GOOD"
echo -n "   Run: "
((($STATUS&HAS_UNDERVOLTED)!=0)) && echo "$BAD" || echo "$GOOD"

echo -n "Throttled:"
echo -n "   Now: "
((($STATUS&THROTTLED)!=0)) && echo -n "$BAD" || echo -n "$GOOD"
echo -n "   Run: "
((($STATUS&HAS_THROTTLED)!=0)) && echo "$BAD" || echo "$GOOD"

echo -n "Freq Capped:"
echo -n "   Now: "
((($STATUS&CAPPED)!=0)) && echo -n "$BAD" || echo -n "$GOOD"
echo -n "   Run: "
((($STATUS&HAS_CAPPED)!=0)) && echo "$BAD" || echo "$GOOD"
