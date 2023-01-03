#!/usr/bin/python3
import psycopg2
import login

print('Content-type:text/html; charset=utf-8\n\n')

print(""" 
<html>
    <head>
        <title>Create Trip Form</title>
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
            
            parent {
                display: flex;
                justify-content: space-between;
            }
            
            #left {
                width: 30%;
                float: left;
                padding-right: 10px;
            }
            
            #right {
                width: 70%;
                float: left;
                padding-left: 10px;
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
              <h2>Create Trip</h2>
              <div id="parent">
                  <div id="left">
                    <form action="create_trip.cgi" method="post" class="ui form">
                      <div class="ui form">

                        <div class="fields">
                          <div class="field">
                              <label>Takeoff</label>
                              <input type="date" placeholder="Takeoff" name="takeoff">
                          </div>
                          <div class="field">
                              <label>Arrival</label>
                              <input type="date" placeholder="Arrival" name="arrival">
                          </div>
                        </div>

                        <div class="fields">
                          <div class="field">
                              <label>Insurance</label>
                              <input type="text" placeholder="Insurance" name="insurance">
                          </div>
                        </div>

                        <div class="fields">
                          <div class="field">
                              <label>From Latitude</label>
                              <input type="text" placeholder="From Latitude" name="from_latitude">
                          </div>
                          <div class="field">
                              <label>From Longitude</label>
                              <input type="text" placeholder="From Longitude" name="from_longitude">
                          </div>
                        </div>

                        <div class="fields">
                          <div class="field">
                              <label>To Latitude</label>
                              <input type="text" placeholder="To Latitude" name="to_latitude">
                          </div>
                          <div class="field">
                              <label>To Longitude</label>
                              <input type="text" placeholder="To Longitude" name="to_longitude">
                          </div>
                        </div>

                        <div class="fields">
                          <div class="field">
                              <label>Reservation Start Date</label>
                              <input type="date" placeholder="Reservation Start Date" name="reservation_start_date">
                          </div>
                          <div class="field">
                              <label>Reservation End Date</label>
                              <input type="date" placeholder="Reservation End Date" name="reservation_end_date">
                          </div>
                        </div>

                        <div class="fields">
                          <div class="field">
                            <label>Boat Country</label>
                            <select name="boat_country">
  """)
connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT DISTINCT country FROM reservation;'
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
    sql = 'SELECT DISTINCT cni FROM reservation;'
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
                    <label>Skipper</label>
                    <select name="skipper">
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
      <button class="ui button primary" type="submit">Submit</button>
    </form>
  </div>
  """)

print("""
        <div id="right">
          <h3> Available Locations </h3>
""")

connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT * FROM location;'
    cursor.execute(sql)
    result = cursor.fetchall()

    num = len(result)

    # Displaying results
    print("""
        <table class="ui celled table">
            <thead>
                <tr><th>Latitude</th>
                <th>Longitude</th>
                <th>Name</th>
                <th>Country Name</th>
            </tr></thead>
            <tbody> 
    """)
    for row in result:
        print('<tr>')
        for value in row:
            # The string has the {}, the variables inside format() will replace the {}
            print('<td>{}</td>'.format(value))
        # Remove Reservation
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
      </div>
    </div>
  </body>
</html>
""")