#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
email = form.getvalue('email')

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
    # TODO: senior and junior by trigger
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = "SELECT * FROM senior WHERE email = %s"

    sql_delete_sailor = "DELETE FROM sailor WHERE email = %s"
    data = (email, )

    # Feed the data to the SQL query as follows to avoid SQL injection
    cursor.execute(sql, data)
    result = cursor.fetchall()
    num = len(result)

    if num < 1 :
        sql_delete_type = "DELETE FROM junior WHERE email = %s"
    else:
        sql_delete_type = "DELETE FROM senior WHERE email = %s"

    # The string has the {}, the variables inside format() will replace the {}
    print('<p>{}</p>'.format(sql_delete_sailor % data))
    print('<p>{}</p>'.format(sql_delete_type % data))

    cursor.execute(sql_delete_type, data)
    cursor.execute(sql_delete_sailor, data)

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
        <a href="home.cgi">Home</a>
    </button>
    </div>
""")
print('</body>')
print('</html>')