#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
takeoff = form.getvalue('takeoff')
arrival = form.getvalue('arrival')
insurance = form.getvalue('insurance')
from_latitude = form.getvalue('from_latitude')
from_longitude = form.getvalue('from_longitude')
to_latitude = form.getvalue('to_latitude')
to_longitude = form.getvalue('to_longitude')
skipper = form.getvalue('skipper')
reservation_start_date = form.getvalue('reservation_start_date')
reservation_end_date = form.getvalue('reservation_end_date')
boat_country = form.getvalue('boat_country')
cni = form.getvalue('cni')

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Trip</title>')
print("""<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />""")
print('</head>')
print('<body>')
connection = None
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql_trip = 'DELETE FROM trip WHERE takeoff = %s AND reservation_start_date = %s AND reservation_end_date = %s AND boat_country = %s AND cni = %s;'
    data_trip = (takeoff,reservation_start_date, reservation_end_date, boat_country, cni )

    print('<p>{}</p>'.format(sql_trip % data_trip))

    # Feed the data to the SQL query as follows to avoid SQL injection
    cursor.execute(sql_trip, data_trip)

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
print("""
    <button class="ui primary basic button">
        <a href="home.cgi">Home</a>
    </button>
""")
print('</body>')
print('</html>')