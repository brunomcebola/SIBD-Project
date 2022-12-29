#!/usr/bin/python3
import psycopg2

IST_ID = 'ist193030'
host = 'db.tecnico.ulisboa.pt'
port = 5432
password = 'gwfj2733'
db_name = IST_ID

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Lab 01</title>')
print('</head>')
print('<body>')

try:
	# Creating connection
	connection = psycopg2.connect('host=' + host + ' port=' + str(port) + ' user=' + IST_ID + ' password=' + password + ' dbname=' + db_name)
	print('<p>Connected to Postgres on ', host, ' as user ', IST_ID, ' on database ', db_name, '.</p>')
	cursor = connection.cursor()

	# Making query
	sql = 'SELECT * FROM account;'
	print('<p>', sql, '</p>')
	cursor.execute(sql)
	result = cursor.fetchall()
	num = len(result)

	# Displaying results
	print('<p>', num, ' records retrieved:</p>')
	print('<table border="5">')
	print('<tr><td>account_number</td><td>branch_name</td><td>balance</td></tr>')
	for row in result:
		print('<tr>')
		print('<td>', row[0], '</td><td>', row[1], '</td><td>', row[2], '</td>')
		print('</tr>')
	print('</table>')

	#Closing connection
	cursor.close()
	connection.close()

	print('<p>Connection closed.</p>')
	print('<p>Test completed successfully.</p>')
except Exception as e:
	print('<h1>An error occurred.</h1>')
	print('<p>', e, '</p>')

print('</body>')
print('</html>')
