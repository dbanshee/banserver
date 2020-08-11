#! /bin/bash

LOCAL_URL="http://localhost:3000/channel"
REMOTE_URL="https://banserver.bansheerocks.com:9743/icecast2/channel"

# REQUEST PARAMS
CHANNEL=$(echo $QUERY_STRING | grep -oP 'channel=\K([^&]+)')
SRC=$(echo $QUERY_STRING | grep -oP 'src=\K([^&]+)')


if [ "$SRC" = "remote" ] ; then 
  URL=$REMOTE_URL
else
  URL=$LOCAL_URL
fi

if [ -z $CHANNEL ] ; then
   CHANNEL="0"
fi

URL="${URL}${CHANNEL}"

echo -e "Content-type: text/html\n\n"

# Debug
#echo -e "
#<h1>Radio Debug</h1>\n
#<h2>Args $QUERY_STRING</h2>
#<h3>src : '$SRC'</h3>
#<h3>Url : $URL<h3>
#<h3>Channel : $CHANNEL</h3>
#"

echo -e "
<html>
        <body>
                <script type='text/javascript'>
                    radiostream = \"${URL}\"
                    artwork     = 'https://static.radioforge.com/v2/images/radioforge.png'
                    width       = '320'
                    height      = '200'
                    title       = 'Banserver Stream Radio Channel ${CHANNEL}'
                    artist      = 'Banshee'
                    source      = 'icecast'
                    autoplay    = 'true'
                    artwork     = 'https://static.radioforge.com/v2/images/radioforge.png'
                </script>
                <script type='text/javascript' src='https://static.radioforge.com/radio2014/html5.js?r=789'></script>
        </body>
</html>
"

