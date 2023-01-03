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
                <a class="active item" href="sailors_auth.cgi">Authorised Sailors</a>
                <a class="item" href="trips.cgi">Trips</a>
            </div>
            <div class="content">
                <h2>Authorised Sailors</h2>
""")
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
    print("""
        <table class="ui celled table">
            <thead>
                <tr><th>Start Date</th>
                <th>End Date</th>
                <th>Boat Country</th>
                <th>CNI</th>
                <th>Sailor's Email</th>
                <th>Remove Reservation</th>
            </tr></thead>
            <tbody> 
    """)
    for row in result:
        print('<tr>')
        for value in row:
            # The string has the {}, the variables inside format() will replace the {}
            print('<td>{}</td>'.format(value))
        
        # Remove Sailor
        print('<td><a href="deauth_sailor.cgi?start_date={}&end_date={}&country={}&cni={}&email={}">Remove Reservation</a></td>'.format(row[0],row[1],row[2],row[3], row[4] ))
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