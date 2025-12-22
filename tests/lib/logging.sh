
# =========
# Logging and text edition
# =========

ret()       { printf "\n"; }
separator() { printf "${ON}${BLU}m""              ----------------------------""$RES"; }

launch()    { printf "%s" " [${ON}${MAG};${BLINK}m" "  LAUNCH  " "${RES}] " "$*"; ret; }
test()      { printf "%s" " [${ON}${MAG};${BLINK}m" "   TEST   " "${RES}] " "$*"; ret; }
info()      { printf "%s" " [${ON}${CYA}m"          "   INFO   " "${RES}] " "$*"; ret; }
logs()      { printf "%s" " [${ON}${BLU}m"          "   LOGS   " "${RES}] " "$*"; ret; }
warn()      { printf "%s" " [${ON}${YEL}m"          "   WARN   " "${RES}] " "$*"; ret; }
skiped()      { printf "%s" " [${ON}${BRO}m"          "  SKIPED  " "${RES}] " "$*"; ret; }

ok()        { printf "%s" " [${ON}${GRE}m"          "    OK    " "${RES}] " "$*"; ret; }
pass()      { printf "%s" " [${ON}${LGR}m"          "   PASS   " "${RES}] " "$*"; ret; }
validate()  { printf "%s" " [${ON}${LGR};${BLINK}m" " VALIDATE " "${RES}] " "$*"; ret; }

ko()        { printf "%s" " [${ON}${LRE}m"          "    KO    " "${RES}] " "$*"; ret; }
fail()      { printf "%s" " [${ON}${RED}m"          "   FAIL   " "${RES}] " "$*"; ret; }
failed()    { printf "%s" " [${ON}${RED};${BLINK}m" "  FAILED  " "${RES}] " "$*"; ret; }

red()   { printf "%s" "${ON}${RED}m" "$*" "$RES"; }
gre()   { printf "%s" "${ON}${GRE}m" "$*" "$RES"; }
yel()   { printf "%s" "${ON}${YEL}m" "$*" "$RES"; }
blu()   { printf "%s" "${ON}${BLU}m" "$*" "$RES"; }
mag()   { printf "%s" "${ON}${MAG}m" "$*" "$RES"; }
cia()   { printf "%s" "${ON}${CYA}m" "$*" "$RES"; }
bro()   { printf "%s" "${ON}${BRO}m" "$*" "$RES"; }
bla()   { printf "%s" "${ON}${BLA}m" "$*" "$RES"; }
