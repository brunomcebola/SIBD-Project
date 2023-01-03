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
print("""
    <style>
        body, html {
        height: 100%;
        }

        .bg {
        /* The image used */
        background-image: url("boat_wallpaper.jpg");

        /* Full height */
        height: 100%;

        /* Center and scale the image nicely */
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;

        padding: 50px;
        }
    </style>
""")
print("""<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />""")
print('</head>')
print('<body>')
print('<div class="bg">')
connection = None
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql_reservation = 'INSERT INTO trip VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s, %s);'
    data_reservation = (takeoff, arrival, insurance,from_latitude, from_longitude, to_latitude,to_longitude, skipper,reservation_start_date, reservation_end_date, boat_country, cni )

    print('<p>{}</p>'.format(sql_reservation % data_reservation))

    # Feed the data to the SQL query as follows to avoid SQL injection
    cursor.execute(sql_reservation, data_reservation)

    # Commit the update (without this step the database will not change)
    connection.commit()

    # Closing connection
    cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred in the input of the querry. Try again, if there is still an error contact the server</h1>')

finally:
    if connection is not None:
        connection.close()
print("""
    <button class="ui yellow button">
        <a href="sailors.cgi">Home</a>
    </button>
    </div>
""")
print('</body>')
print('</html>')