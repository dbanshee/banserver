#! /bin/bash

export LANG=C.UTF-8

LOG_FILE=/tmp/cgit_auth.log
#LOG_FILE=/dev/null

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

    # User Validation
    # ...

    # Set Cookie
    echo "Status: 302 Redirect"
    echo "Cache-Control: no-cache, no-store"
    echo "Location: /cgit"
    echo "Set-Cookie: cgitauth=; HttpOnly"
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

