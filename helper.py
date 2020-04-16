import datetime
import hashlib
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from random import choice
from string import ascii_uppercase
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

# This function generates a BookingID that has not been used
def generateBookingID(ids):
    bookingID = ''.join(choice(ascii_uppercase) for i in range(6))
    while bookingID in ids:
        bookingID = ''.join(choice(ascii_uppercase) for i in range(6))
    return bookingID

# Convert date object to day of the week
def toWeekday(date):
    date = datetime.datetime.strptime(date, "%Y-%m-%d")
    return date.strftime("%A")

def minChangeBookingDate():
    today = datetime.date.today() + datetime.timedelta(days=2)
    return today.strftime("%Y-%m-%d")

def maxChangeBookingDate():
    today = datetime.date.today() + datetime.timedelta(weeks=20)
    return today.strftime("%Y-%m-%d")

# Get values from MySQL cursor
def getValues(multiDict):
    return [value for value in multiDict.values()]

# Hash a password using SHA256
def hashPassword(password):
    return hashlib.sha256(password.encode()).hexdigest()

def get_reset_token(UserID, expires_sec=3600):
    s = Serializer(app.config['SECRET_KEY'], expires_sec)
    return s.dumps({'UserID': UserID}).decode('utf-8')

def verify_reset_token(token):
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
