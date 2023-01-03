#!/usr/bin/python3
import psycopg2
import login
print('Content-type:text/html; charset=utf-8\n\n')

print(""" 
<html>
    <head>
        <title>Create Reservation Form</title>
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
                <h2>Create Reservation</h2>
                <form action="create_reservation.cgi" method="post" class="ui form">
                    <div class="ui form">                        
                        <div class="fields">
                          <div class="field">
                              <label>Start Date</label>
                              <input type="date" placeholder="Takeoff" name="start_date">
                          </div>
                          <div class="field">
                              <label>End Date</label>
                              <input type="date" placeholder="Arrival" name="end_date">
                          </div>
                        </div>

                        <div class="fields">
                            <div class="field">
                                <label>Boat Country</label>
                                <select name="country">
""")

connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT name FROM country;'
    cursor.execute(sql)
    result = cursor.fetchall()

    num = len(result)

    for row in result:
        for value in row:
            print('<option value="{}">{}</option>'.format(row[0], row[0]))
    # Closing connection
    print(""" 
                    </select>
                </div>
                <div class="field">
                    <label>Boat CNI</label>
                    <select name="cni">
    """)
    sql = 'SELECT cni FROM boat;'
    cursor.execute(sql)
    result = cursor.fetchall()

    num = len(result)

    for row in result:
        for value in row:
            print('<option value="{}">{}</option>'.format(row[0], row[0]))
    print(""" 
                    </select>
                </div>
                <div class="field">
                    <label>Resposible</label>
                    <select name="email">
    """)
    sql = 'SELECT email FROM sailor;'
    cursor.execute(sql)
    result = cursor.fetchall()

    num = len(result)

    for row in result:
        for value in row:
            print('<option value="{}">{}</option>'.format(row[0], row[0]))

    print(""" 
                    </select>
                </div>
            </div>
            <button class="ui button primary" type="submit">Submit</button>
        </form>
    """)

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
      </div>
    </div>
  </body>
</html>
""")