#!/usr/bin/env python

import sys      
import codecs

#print('auth-filter python')

action = sys.argv[1]

f = open('/tmp/cgit-auth.log', 'a+')
print >> f, 'action : ', action

if action == 'authentication-cookie':

    exit(0)
elif action == 'authenticate-post':
#    sys.stdin = codecs.getreader("utf-8")(sys.stdin.detach())
    text = sys.stdin.read().strip()
#    print text
    print >> f, 'stdin: ''', text, ''

#    lines = sys.stdin.readlines()
#    for i in range(len(lines)):
#        lines[i] = lines[i].replace('\n', '')
#    print lines

    exit(0)
elif action == 'body':
    print( "<h2>Authentication Required</h2> \
<form method='post' action='/cgit/?p=login'> \
    <table> \
      <tr><td><label for='username'>Username:</label></td><td><input id='username' name='username' autofocus /></td></tr> \
      <tr><td><label for='password'>Password:</label></td><td><input id='password' name='password' type='password' /></td></tr> \
      <tr><td colspan='2'><input value='Login' type='submit' /></td></tr> \
    </table> \
</form>")

    exit(0)
else:
    exit(0)

f.close()

