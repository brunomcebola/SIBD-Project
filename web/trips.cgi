#!/usr/bin/python3
import psycopg2
import login
print('Content-type:text/html; charset=utf-8\n\n')

print(""" 
<html>
    <head>
        <title>Sailor</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <style>
            body, html {
                height: 100%;
            }

            .bg {                
                /* The image used */
                background-image: url("boat_wallpaper_transparent.png");
                background-position: center;
                background-repeat: no-repeat;
                background-attachment: fixed;
                background-size: cover;

                min-height: 100%;
            }
            
            .ui {
                position: fixed;
            }
            
            .material-icons {
                padding-right: 5px;
            }
            
            .content {
                padding: 75px 25px;
            }
            
            table {
                position: relative !important;
                width: 100% !important;
            }
        </style>
    </head>
    <body>
        <div class="bg">
            <div class="ui five item menu">
                <a class="item" href="home.cgi"><i class="material-icons">home</i>Home</a>
                <a class="item" href="sailors.cgi">Sailors</a>
                <a class="item" href="reservations.cgi" >Reservations</a>
                <a class="item" href="sailors_auth.cgi">Authorised Sailors</a>
                <a class="active item" href="trips.cgi">Trips</a>
            </div>
            <div class="content">
                <h2>Trips</h2>
""")
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
    print('<h1>An error occurred in the input of the querry. Try again, if there is still an error contact the server</h1>')
finally:
    if connection is not None:
        connection.close()
print("""
            </div>
        </div>
    </body>
</html>
""")