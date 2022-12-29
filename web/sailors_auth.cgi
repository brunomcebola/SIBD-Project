#!/usr/bin/python3
import psycopg2
import login

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Lab 09</title>')
print('</head>')
print('<body>')
print('<h3>Accounts</h3>')
connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT * FROM authorised;'
    cursor.execute(sql)
    result = cursor.fetchall()
    num = len(result)

    # Create Sailor
    print('<a href="auth_sailor_form.cgi">Authorise Sailor</a>')
    # Displaying results
    print('<table border="0" cellspacing="5">')
    for row in result:
        print('<tr>')
        for value in row:
            # The string has the {}, the variables inside format() will replace the {}
            print('<td>{}</td>'.format(value))
        
        # Remove Sailor
        print('<td><a href="remove_reservation.cgi?start_date={}&end_date={}&country={}&cni={}&email={}">Remove Reservation</a></td>'.format(row[0],row[1],row[2],row[3], row[4] ))
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