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
print('</head>')
print('<body>')
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
    print('<h1>An error occurred.</h1>')
    print('<p>{}</p>'.format(e))

finally:
    if connection is not None:
        connection.close()
print('</body>')
print('</html>')