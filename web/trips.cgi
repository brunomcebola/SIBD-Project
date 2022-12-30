#!/usr/bin/python3
import psycopg2
import login

print('Content-type:text/html; charset=utf-8\n\n')
print('<html>')
print('<head>')
print('<title>Trips</title>')
print("""<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />""")
print('</head>')
print('<body>')
print('<h3>Trips</h3>')
connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT * FROM trip;'
    cursor.execute(sql)
    result = cursor.fetchall()
    num = len(result)

    # Create Trip
    print('<a href="create_trip_form.cgi">Create Trip</a>')
    # Displaying results
    print("""
        <table class="ui celled table">
            <thead>
                <tr><th>Takeoff</th>
                <th>Arrival</th>
                <th>Insurange</th>
                <th>From Latitue</th>
                <th>From Longitude</th>
                <th>To Latitue</th>
                <th>To Longitude</th>
                <th>Skipper</th>
                <th>Reservation Start Date</th>
                <th>Reservation End Date</th>
                <th> Boat Country </th>
                <th> CNI </th>
                <th>Remove Trip</th>
            </tr></thead>
            <tbody> 
    """)
    for row in result:
        print('<tr>')
        for value in row:
            # The string has the {}, the variables inside format() will replace the {}
            print('<td>{}</td>'.format(value))
        
        # Remove Sailor
        print('<td><a href="remove_trip.cgi?takeoff={}&reservation_start_date={}&reservation_end_date={}&boat_country={}&cni={}">Remove Trip</a></td>'.format(row[0],row[8],row[9],row[10],row[11]))

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
print("""
    <button class="ui primary basic button">
        <a href="home.cgi">Home</a>
    </button>
""")
print('</body>')
print('</html>')