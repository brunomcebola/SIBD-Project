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
print("""
<html>
    <head>
        <title>Delete Reservation</title>
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
                <a class="item" href="trips.cgi">Trips</a>
            </div>
            <div class="content">
""")
connection = None
try:
    can_delete = True

    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # check trip

    sql = "SELECT * FROM trip WHERE reservation_start_date = %(start_date)s AND reservation_end_date = %(end_date)s AND boat_country = %(boat_country)s AND cni = %(cni)s"
    data = {"start_date":start_date, "end_date": end_date, "boat_country": country, "cni":cni}

    cursor.execute(sql, data)
    records = cursor.fetchall()
    num_records = len(records)

    if num_records >= 1:
        can_delete = False
        print("<h1> You can not delete this reservation, because it is referenced by some Trip</h1>")

    # check authorised

    sql = "SELECT * FROM authorised WHERE start_date = %(start_date)s AND end_date = %(end_date)s AND boat_country = %(boat_country)s AND cni = %(cni)s"
    data = {"start_date":start_date, "end_date": end_date, "boat_country": country, "cni":cni}
    
    cursor.execute(sql, data)
    records = cursor.fetchall()
    num_records = len(records)

    if num_records >= 1:
        can_delete = False
        print("<h1> You can not delete this reservation, because it is referenced by some Authorised Sailor</h1>")

    # if all okay, then delete

    if can_delete:
        sql = 'DELETE FROM reservation WHERE start_date = %s AND end_date = %s AND country = %s AND cni = %s;'
        data = (start_date, end_date,country, cni)
    
        cursor.execute(sql, data)
        
        connection.commit()
        
        print('<h1>Reservation successfully deleted</h1>')

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