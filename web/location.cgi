#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
country = form.getvalue('country')

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Reservation</title>')
print('</head>')
print('<body>')
print('<h3>Reservations</h3>')
connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT latitude, longitude, name,country_name FROM location WHERE country_name = %s;'
    data = (country,)
    cursor.execute(sql,data)
    result = cursor.fetchall()
    num = len(result)

    # Displaying results
    print('<table border="0" cellspacing="5">')
    for row in result:
        print('<tr>')
        for value in row:
            # The string has the {}, the variables inside format() will replace the {}
            print('<td>{}</td>'.format(value))

        print('</tr>')
    print('</table>')
    # Closing connection
    cursor.close()
except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred.</h1>') 
    print('<p>{}</p>'.format(e))
finally:
    if connection is not None:
        connection.close()
print('</body>')
print('</html>')