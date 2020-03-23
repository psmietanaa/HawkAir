import datetime
from random import choice
from string import ascii_uppercase

# This function builds flights that are displayed in dashboard and used in email
def buildFlights(trips):
    flights = {}
    for trip in trips:
        print(trip, flush=True)
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