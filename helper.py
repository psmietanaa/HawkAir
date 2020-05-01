import datetime
import hashlib
from random import choice
from string import ascii_uppercase
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from run import app, mysql

# This function builds flights that are displayed when buying flights
def buildFlight(flights, date):
    results = []
    for flight in flights:
        result = {
            'From': flight['From'],
            'To': flight['To'],
            'Date': date,
            'DepartTime': str(flight['DepartTime'])[:-3],
            'FlightID': flight['FlightID'],
            'AircraftID': flight['AircraftID'],
            'Duration': str(flight['Duration'])[:-3] + "h",
            'ArrivalTime': str(flight['DepartTime'] + flight['Duration'])[:-3],
            'AvailableEconomySeats': flight['AvailableEconomySeats'],
            'AvailableFirstClassSeats': flight['AvailableFirstClassSeats']
        }
        results.append(result)
    return results

# This function builds trips that are displayed in dashboard and used in email
def buildTrips(trips):
    flights = {}
    trips = sorted(trips, key=lambda x: (x['FlightDate'], x['DepartTime']))
    for trip in trips:
        if trip['BookingID'] not in flights:
            flights[trip['BookingID']] = []
            flights[trip['BookingID']].append([trip['From'], trip['To'], trip['FlightDate'].strftime("%Y-%m-%d"), str(trip['DepartTime'])[:-3], trip['Class'], trip['Passenger'], trip['FlightID'], str(trip['Duration'])[:-3] + "h"])
        else:
            flights[trip['BookingID']].append([trip['From'], trip['To'], trip['FlightDate'].strftime("%Y-%m-%d"), str(trip['DepartTime'])[:-3], trip['Class'], trip['Passenger'], trip['FlightID'], str(trip['Duration'])[:-3] + "h"])
    return flights

# This function builds flight status
def buildStatus(trips):
    flights = {}
    for trip in trips:
        if trip['FlightID'] not in flights:
            flights[trip['FlightID']] = []
            flights[trip['FlightID']].append([trip['From'], trip['To'], trip['FlightDate'].strftime("%Y-%m-%d"), str(trip['DepartTime'])[:-3], trip['FlightID'], trip['AircraftID'], trip['FlightStatus'], str(trip['Duration'])[:-3] + "h"])
        else:
            flights[trip['FlightID']].append([trip['From'], trip['To'], trip['FlightDate'].strftime("%Y-%m-%d"), str(trip['DepartTime'])[:-3], trip['FlightID'], trip['AircraftID'], trip['FlightStatus'], str(trip['Duration'])[:-3] + "h"])
    return flights

# Validate a round trip
# Returning flight must be after departing flight
def validateRoundTrip(departDate, departTime, departDuration, returnDate, returnTime):
    departDate = datetime.datetime.strptime(departDate, "%Y-%m-%d").date()
    departTime = datetime.datetime.strptime(departTime, "%H:%M").time()
    departDuration = ":".join((departDuration.split(":")[0].zfill(2), departDuration.split(":")[1]))
    departDuration = datetime.datetime.strptime(departDuration, "%H:%Mh").time()
    departDuration = datetime.timedelta(hours=departDuration.hour, minutes=departDuration.minute)
    returnDate = datetime.datetime.strptime(returnDate, "%Y-%m-%d").date()
    returnTime = datetime.datetime.strptime(returnTime, "%H:%M").time()
    parsedDepart = datetime.datetime.combine(departDate, departTime) + departDuration
    parsedReturn = datetime.datetime.combine(returnDate, returnTime)
    return parsedDepart < parsedReturn

# This function generates a BookingID that has not been used
def generateBookingID(ids):
    bookingID = "".join(choice(ascii_uppercase) for i in range(6))
    while bookingID in ids:
        bookingID = "".join(choice(ascii_uppercase) for i in range(6))
    return bookingID

# Convert date object to day of the week
def toWeekday(date):
    date = datetime.datetime.strptime(date, "%Y-%m-%d")
    return date.strftime("%A")

# Minimum date for a flight to be booked
def minChangeBookingDate():
    today = datetime.date.today() + datetime.timedelta(days=2)
    return today.strftime("%Y-%m-%d")

# Maximum date for a flight to be booked
def maxChangeBookingDate():
    today = datetime.date.today() + datetime.timedelta(weeks=20)
    return today.strftime("%Y-%m-%d")

# Get values from a MySQL cursor object
def getValues(multiDict):
    return [value for value in multiDict.values()]

# Hash a password using SHA256
def hashPassword(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Generate token for resetting the password
def getResetToken(UserID, expires_sec=3600):
    s = Serializer(app.config['SECRET_KEY'], expires_sec)
    return s.dumps({'UserID': UserID}).decode('utf-8')

# Verify that a token is valid for the user
def verifyResetToken(token):
    s = Serializer(app.config['SECRET_KEY'])
    try:
        UserID = s.loads(token)['UserID']
        cursor = mysql.connection.cursor()
        cursor.callproc("ValidateUser", [UserID])
        found = cursor.fetchone()['UserID']
        cursor.close()
    except:
        return None
    return found

# Authenticate the payment
def authenticatePayment():
    pass
