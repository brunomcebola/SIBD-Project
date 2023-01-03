#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
firstname = form.getvalue('firstname')
surname = form.getvalue('surname')
email = form.getvalue('email')
sailor_type = form.getvalue('sailor_type')

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
    sql_sailor = 'INSERT INTO sailor VALUES(%s,%s,%s);'
    
    
    
    
    data_sailor = (firstname, surname, email)
    data_type = (email, )

    if sailor_type.lower() != "senior" and sailor_type.lower() != "junior":
        print('<p>You are not either Senior nor Junior, wrong input </p>')
        cursor.close()

    else:
        if sailor_type.lower() == "senior":
            sql_type = 'INSERT INTO senior VALUES(%s);'
        elif sailor_type.lower() == "junior":
            sql_type = 'INSERT INTO junior VALUES(%s);'
        # The string has the {}, the variables inside format() will replace the {}
        print('<p>{}</p>'.format(sql_sailor % data_sailor))

        # Feed the data to the SQL query as follows to avoid SQL injection
        cursor.execute(sql_sailor, data_sailor)
        cursor.execute(sql_type, data_type)

        # Commit the update (without this step the database will not change)
        connection.commit()

        # Closing connection
        cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred in the input of the querry. Try again, if there is still an error contact the server</h1>')
    print('<p>{}</p>'.format(e))
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