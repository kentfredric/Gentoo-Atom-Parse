OVERLAY1='kentfredric-experiemental'
OVERLAY2='perl-experimental'
OVERLAY3='java-overlay'
OVERLAY4='berkano'
OVERLAY5='ikelos'
OVERLAY6='kde'
OVERLAY7='mozilla'
OVERLAY8='notmpfs'
OVERLAY9='proaudio'
OVERLAY10='qting-edge'
OVERLAY11='secondlife'
OVERLAY12='sunrise'
OVERLAY13='vdr-testing'


CPVXS='<category>/<name>-<version>:<slot>::'
INNER=''
for i in $( seq 1 13 ); do
  src="\$OVERLAY${i}"
  eval "sval=\"${src}\"";
  INNER="${INNER}{overlaynum=${i}}${sval}{else}{}"
done

export CPVS="${CPVXS}{overlaynum}${INNER}{else}gentoo{}\n"
export FORMAT='<availableversions:CPVS>'
eix -xl --pure-packages

