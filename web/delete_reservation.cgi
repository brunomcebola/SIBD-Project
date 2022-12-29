#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
start_date = form.getvalue('start_date')
end_date = form.getvalue('end_date')
country = form.getvalue('country')
cni = form.getvalue('cni')

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Sailor</title>')
print('</head>')
print('<body>')
connection = None
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    print('<p>{} {} {} {} </p>'.format(start_date, end_date, country, cni))
    # Making query
    sql_date_interval = 'DELETE FROM date_interval WHERE start_date = %s AND end_date = %s'
    data_date_interval = (start_date,end_date)

    sql_reservation = 'DELETE FROM reservation WHERE start_date = %s AND end_date = %s AND country = %s AND cni = %s;'
    data_reservation = (start_date, end_date,country, cni)

    print('<p>{}</p>'.format(sql_reservation % data_reservation))

    # Feed the data to the SQL query as follows to avoid SQL injection
    cursor.execute(sql_date_interval, data_date_interval)
    cursor.execute(sql_reservation, data_reservation)

    # Commit the update (without this step the database will not change)
    connection.commit()

    # Closing connection
    cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred in the input of the querry.</h1>')
    print('<p>{}</p>'.format(e))

finally:
    if connection is not None:
        connection.close()
print('</body>')
print('</html>')