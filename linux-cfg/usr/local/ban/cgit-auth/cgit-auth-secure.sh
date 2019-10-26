#! /bin/bash

export LANG=C.UTF-8

LOG_FILE=/tmp/cgit_auth.log
#LOG_FILE=/dev/null

ALLOWED_USER="banshee"
ALLOWED_PASS="30069f3264078fe359c5703ac909edd4f7121dea1856ac6ce569919900a15bfe" # patata
SECRET_FILENAME=/home/banshee/auth-secret
SECRET_SIZE_BYTES=32


function get_secret {
  if [ ! -f $SECRET_FILENAME ] ; then
    echo "Secret File : '$SECRET_FILENAME' not exists" >> $LOG_FILE
    dd if=/dev/urandom bs=${SECRET_SIZE_BYTES} count=1 2> /dev/null | hexdump -v -e '/1 "%02X"' >> $SECRET_FILENAME
  fi

  cat $SECRET_FILENAME
}



# MAIN

echo "############################" >> $LOG_FILE
echo "Params :  $@"    >> $LOG_FILE
#echo "Env : `env`"     >> $LOG_FILE
echo "" >> $LOG_FILE


ACTION=$1
echo "ACTION : '$ACTION'" >> $LOG_FILE


if [ "$ACTION" = "authenticate-cookie" ] ; then
  echo "Procesing action: 'authenticate-cookie'" >> $LOG_FILE 

  COOKIE="$2"
  echo "Cookie : $COOKIE" >> $LOG_FILE

  # Cookie Validation
  if [ -z "$COOKIE" ] ; then
    exit 0 
  else
    exit 1
  fi

elif [ "$ACTION" = "authenticate-post" ] ; then
    echo "Procesing action : authenticate-post" >> $LOG_FILE

    echo "Try read stdin" >> $LOG_FILE
    
    POSTBODY=""
    while read -rn1 line
    do
      #echo "line : $line" >> $LOG_FILE
      POSTBODY+=$line
    done
    echo "Post Body : $POSTBODY" >> $LOG_FILE

    # Response
    echo "Status: 302 Redirect"
    echo "Cache-Control: no-cache, no-store"
    echo "Location: /cgit"

    # User Validation
    # ...
    user=$(echo $POSTBODY | grep -oP 'username=\K([^&]+)')
    pass=$(echo $POSTBODY | grep -oP 'password=\K([^&]+)')

    echo "User : $user, Password : $pass" >> $LOG_FILE

    hash=$(echo "$pass" | sha256sum | cut -d' ' -f1)
    echo "Hash : '${hash}', Allowed : ${ALLOWED_PASS}" >> $LOG_FILE
    echo "Secret value : $(get_secret)" >> $LOG_FILE

    # Set Cookie 
    if [ "$hash" != "$ALLOWED_PASS" ] ; then      
      echo "Set-Cookie: cgitauth=; HttpOnly"
    else
      echo "Set-Cookie: cgitauth=${ALLOWED_USER}; HttpOnly"
    fi
    echo ""

    exit 0
elif [ "$ACTION" = "body" ] ; then
   echo "Procesing action: 'body'" >> $LOG_FILE
 
   echo "
<h2>Authentication Required</h2>
<form method='post' action='/cgit/?p=login'>
    <table>
      <tr><td><label for='username'>Username:</label></td><td><input id='username' name='username' autofocus /></td></tr>
      <tr><td><label for='password'>Password:</label></td><td><input id='password' name='password' type='password' /></td></tr>
      <tr><td colspan='2'><input value='Login' type='submit' /></td></tr>
    </table>
</form>
"
  exit 0
else 
  echo "Unexpected exit" >> $LOG_FILE
  exit -1
fi 

