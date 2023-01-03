#!/usr/bin/python3
import psycopg2
import login

print('Content-type:text/html; charset=utf-8\n\n')

print("""
<!DOCTYPE html>
<html>
  <head>
    <title>Trip</title>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.7/dist/semantic.css" />
    <script src="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.7/dist/semantic.js"></script>
  
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
    }

    #parent {
      display: flex;
      justify-content: space-between;
    }
    
    #right {
      padding : 50px;
      width: 70%;
    }

    #left {
     padding : 50px;
    }

    </style>
    
  </head>
  <body>
    <div class="bg">
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
                        <select name="boat_country">
                            <option value="">Country</option> 
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
                    <select name="cni">
                        <option value="">CNI</option> 
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
                    <select name="skipper">
                        <option value="">Email</option> 
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
      <button class="ui button" type="submit">Submit</button>
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
      <button class="ui yellow button">
          <a href="sailors.cgi" >Home</a>
      </button>
    </div>
  </body>
</html>
""")