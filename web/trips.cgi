#!/usr/bin/python3
import psycopg2
import login
import math
import os
from urllib.parse import parse_qs

print('Content-type:text/html; charset=utf-8\n\n')

print(""" 
<html>
    <head>
        <title>Trips</title>
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
            
            .pagination {
                position: relative;
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
                <a href="create_trip_form.cgi">Create Trip</a>
""")

connection = None

query_string = parse_qs(os.environ.get('QUERY_STRING'))

page = int(query_string['page'][0]) if 'page' in query_string else 1
# perPage = int(query_string['perPage'][0]) if 'perPage' in query_string else 5
perPage = 5

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Get number of records
    sql = 'SELECT count(*) FROM trip;'
    cursor.execute(sql)
    total = cursor.fetchone()[0]

    # Making query
    sql = 'SELECT * FROM trip LIMIT {} OFFSET {};'.format(perPage, (page - 1) * perPage)
    cursor.execute(sql)
    result = cursor.fetchall()

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
        print('<td><a href="delete_trip.cgi?takeoff={}&reservation_start_date={}&reservation_end_date={}&boat_country={}&cni={}">Remove Trip</a></td>'.format(row[0],row[8],row[9],row[10],row[11]))

        print('</tr>')
    print("""
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="13">
                        <div class="ui right floated pagination menu">
                            <a class="icon item" href="trips.cgi?page={}">
                                <i class="left chevron icon"></i>
                            </a>
    """.format(page - 1 if page != 1 else page))
    
    
    for i in range(1, math.ceil(total / perPage) + 1):
        print('<a class="item {}" href="trips.cgi?page={}">{}</a>'.format('active' if i == page else '', i, i))
    
    print("""
                            <a class="icon item" href="trips.cgi?page={}">
                                <i class="right chevron icon"></i>
                            </a>
                        </div>
                    </th>
                </tr>
            </tfoot>
        </table>
    """.format(page + 1 if page != math.ceil(total / perPage) else math.ceil(total / perPage)))
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