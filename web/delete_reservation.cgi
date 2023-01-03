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
print("""<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />""")
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
print('</head>')
print('<body>')
print('<div class="bg">')
connection = None
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql_trip = "SELECT * FROM trip WHERE reservation_start_date = %(start_date)s AND reservation_end_date = %(end_date)s AND boat_country = %(boat_country)s AND cni = %(cni)s"
    data_trip = {"start_date":start_date, "end_date": end_date, "boat_country": country, "cni":cni}

    sql_auth = "SELECT * FROM authorised WHERE start_date = %(start_date)s AND end_date = %(end_date)s AND boat_country = %(boat_country)s AND cni = %(cni)s"
    data_auth = {"start_date":start_date, "end_date": end_date, "boat_country": country, "cni":cni}

    sql_reservation = 'DELETE FROM reservation WHERE start_date = %s AND end_date = %s AND country = %s AND cni = %s;'
    data_reservation = (start_date, end_date,country, cni)

    # Feed the data to the SQL query as follows to avoid SQL injection
    cursor.execute(sql_trip, data_trip)
    trips = cursor.fetchall()
    num_trip = len(trips)

    cursor.execute(sql_auth, data_auth)
    auth = cursor.fetchall()
    num_auth = len(auth)

    if num_trip >= 1:
        print("<h1> You can not delete this reservation, there are still some Trips attached to it </h1>")
        cursor.close()

    if num_auth >= 1:
        print("<h1> You can not delete this reservation, there are still some Authorised Sailors attached to it </h1>")
        cursor.close()


    if num_trip == 0 and num_auth == 0:
        cursor.execute(sql_reservation, data_reservation)
        print('<h2>The process of deleting the reservation went well. The item was removed</h2>')
    elif num_trip < 0 or num_auth < 0:
        print("<h1>Something went wrong</h1>")

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