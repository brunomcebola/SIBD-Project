#!/usr/bin/python3
import cgi
form = cgi.FieldStorage()
account_number = form.getvalue('account_number')
print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Sailor</title>')
print('</head>')
print('<body>')
print('<h3>Create new Sailor')

print('<form action="create_sailor.cgi" method="post">')
print('<p>FirstName: <input type="text" name="firstname"/></p>')
print('<p>Surname: <input type="text" name="surname"/></p>')
print('<p>Email: <input type="text" name="email"/></p>')
print('<p><input type="submit" value="Submit"/></p>')
print('</form>')

print('</body>')
print('</html>')