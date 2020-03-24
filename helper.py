import datetime
import hashlib
from random import choice
from string import ascii_uppercase

# This function builds flights that are displayed when buying flights
def buildFlights(flights, date):
    results = []
    for flight in flights:
        result = {
            'From': flight['From'],
            'To': flight['To'],
            'Date': datetime.datetime.strptime(date, "%Y-%m-%d").strftime("%m/%d/%Y"),
            'DepartTime': str(flight['DepartTime'])[:-3],
            'FlightID': flight['FlightID'],
            'AircraftID': flight['AircraftID'],
            'Duration': str(flight['Duration'])[:-3] + "h",
            'ArrivalTime': str(flight['DepartTime'] + flight['Duration'])[:-3]
        }
        results.append(result)
    return results

# This function builds trips that are displayed in dashboard and used in email
def buildTrips(trips):
    flights = {}
    for trip in trips:
        if trip['BookingID'] not in flights:
            flights[trip['BookingID']] = []
            flights[trip['BookingID']].append([trip['From'], trip['To'], trip['FlightDate'].strftime("%m/%d/%Y"), str(trip['DepartTime'])[:-3], trip['FlightID'], str(trip['Duration'])[:-3] + "h", trip['Class'], trip['SeatNumber']])
        else:
            flights[trip['BookingID']].append([trip['From'], trip['To'], trip['FlightDate'].strftime("%m/%d/%Y"), str(trip['DepartTime'])[:-3], trip['FlightID'], str(trip['Duration'])[:-3] + "h", trip['Class'], trip['SeatNumber']])
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
    return date.strftime('%A')

# Get values from MySQL cursor
def getValues(multiDict):
    return [value for value in multiDict.values()]

# Hash a password using SHA256
def hashPassword(password):
    return hashlib.sha256(password.encode()).hexdigest()
