import re
import datetime
from flask_wtf import FlaskForm
from wtforms import BooleanField, FieldList, Form, FormField, PasswordField, SelectField, StringField, SubmitField, TextAreaField
from wtforms.fields.html5 import DateField
from wtforms.validators import Email, EqualTo, InputRequired, Length, Regexp, Optional, ValidationError
from wtforms_validators import Alpha, AlphaDash, AlphaNumeric, AlphaSpace, Integer
from run import app, mysql

# Regex for validating the forms
textRegex = re.compile("\s*\w*[!@#$%()=+-:;'\",.?]*")
streetRegex = re.compile("\s*\w*[.]*")
phoneRegex = re.compile("\s*\d*[-+.]*")
cardNumberRegex = re.compile("^(\d{4}[- ]){3}\d{4}|\d{16}$")

# Select field options used in the forms
titles = [("", ""), ("Mr", "Mr"), ("Ms", "Ms"), ("Mrs", "Mrs"), ("Mx", "Mx")]
sexes = [("Male", "Male"), ("Female", "Female")]
securityQuestions = [("What was your favorite sport in high school?", "What was your favorite sport in high school?"),
                     ("What is your pet's name?", "What is your pet's name?"),
                     ("What was the color of your first car?", "What was the color of your first car?"),
                     ("What is your favorite team?", "What is your favorite team?"),
                     ("In what city were you born?", "In what city were you born?")]
creditCardTypes = [("Mastercard", "Mastercard"), ("Visa", "Visa")]
expirationMonths = [(str(i), str(i)) for i in range(1, 13)]
expirationYears = [(str(datetime.date.today().year + i), str(datetime.date.today().year + i)) for i in range(0, 5)]
passengersRange = [(str(i), str(i)) for i in range(1, 10)]
flightStatusDates = [((datetime.date.today() + datetime.timedelta(days=i)).strftime("%Y-%m-%d"), (datetime.date.today() + datetime.timedelta(days=i)).strftime("%A, %B %d")) for i in range(0, 3)]

# Get departure and arrival city locations from database
with app.app_context():
    cursor = mysql.connection.cursor()
    cursor.callproc("GetDepartLocations")
    fromCities = [(city['From'], city['From']) for city in cursor.fetchall()]
    cursor.nextset()
    cursor.callproc("GetArrivalLocations")
    toCities = [(city['To'], city['To']) for city in cursor.fetchall()]
    cursor.close()

# Date must be a future date
def FutureDate(form, field):
    today = datetime.date.today()
    margin = datetime.timedelta(weeks=20)
    if not (today <= field.data <= today + margin):
        raise ValidationError("Date must be a future date within 6 months.")

class RoundTripForm(FlaskForm):
    fromCity1 = SelectField("<strong>From</strong>", choices=fromCities)
    toCity1 = SelectField("<strong>To</strong>", choices=toCities)
    passengers1 = SelectField("<strong>Number of Passengers</strong>", choices=passengersRange)
    departDate1 = DateField("<strong>Depart</strong>", format="%Y-%m-%d", validators=[InputRequired(), FutureDate], render_kw={"min": datetime.date.today(), "max": datetime.date.today() + datetime.timedelta(weeks=20)})
    returnDate1 = DateField("<strong>Return</strong>", format="%Y-%m-%d", validators=[InputRequired(), FutureDate], render_kw={"min": datetime.date.today(), "max": datetime.date.today() + datetime.timedelta(weeks=20)})
    submit1 = SubmitField("Search")
    
    # Return date must be after departure date
    def validate(self):
        if not FlaskForm.validate(self):
            return False
        elif self.fromCity1.data == self.toCity1.data:
            self.toCity1.errors.append("From and To cannot be the same.")
            return False
        elif self.departDate1.data > self.returnDate1.data:
            self.returnDate1.errors.append("Return date must be after departure date.")
            return False
        return True
    
class OneWayForm(FlaskForm):
    fromCity2 = SelectField("<strong>From</strong>", choices=fromCities)
    toCity2 = SelectField("<strong>To</strong>", choices=toCities)
    passengers2 = SelectField("<strong>Number of passengers</strong>", choices=passengersRange)
    departDate2 = DateField("<strong>Depart</strong>", format="%Y-%m-%d", validators=[InputRequired(), FutureDate], render_kw={"min": datetime.date.today(), "max": datetime.date.today() + datetime.timedelta(weeks=20)})
    submit2 = SubmitField("Search")
    
    # From and To cannot be the same
    def validate(self):
        if not FlaskForm.validate(self):
            return False
        elif self.fromCity2.data == self.toCity2.data:
            self.toCity2.errors.append("From and To cannot be the same.")
            return False
        return True

class Passenger(Form):
    firstName = StringField("<strong>First Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    lastName = StringField("<strong>Last Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    passport = StringField("<strong>Passport Number</strong>", validators=[InputRequired(), Length(min=6, max=9), AlphaNumeric()])
    
class PassengersForm(FlaskForm):
    passengers = FieldList(FormField(Passenger))
    submit = SubmitField("Continue")
    
    # Check if fields are unique
    def validate(self):
        if not Form.validate(self):
            return False
        result = True
        seenNames = set()
        seenPassports = set()
        for field in self.passengers:
            if (field.firstName.data + " " + field.lastName.data) in seenNames:
                field.firstName.errors.append("Two passengers cannot have the same name")
                field.lastName.errors.append("Two passengers cannot have the same name")
                result = False
            else:
                seenNames.add(field.firstName.data + " " + field.lastName.data)
            if field.passport.data in seenPassports:
                field.passport.errors.append("Two passengers cannot have the same passport number")
                result = False
            else:
                seenPassports.add(field.passport.data)
        return result

class YourTripForm(FlaskForm):
    firstName3 = StringField("<strong>First Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    lastName3 = StringField("<strong>Last Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    bookingNumber3 = StringField("<strong>Booking Number</strong>", validators=[InputRequired(), Length(min=6, max=6, message="Field must be 6 characters long."), Alpha()])
    submit3 = SubmitField("Search")

class FlightStatusDateForm(FlaskForm):
    fromCity4 = SelectField("<strong>From</strong>", choices=fromCities)
    toCity4 = SelectField("<strong>To</strong>", choices=toCities)
    date4 = SelectField("<strong>Date</strong>", choices=flightStatusDates)
    submit4 = SubmitField("Search")
    
    # From and To cannot be the same
    def validate(self):
        if not FlaskForm.validate(self):
            return False
        elif self.fromCity4.data == self.toCity4.data:
            self.toCity4.errors.append("From and To cannot be the same.")
            return False
        return True

class FlightStatusNumberForm(FlaskForm):
    flightNumber5 = StringField("<strong>Flight Number</strong>", validators=[InputRequired(), Length(min=6, max=6, message="Field must be 6 characters long."), AlphaNumeric()])
    date5 = SelectField("<strong>Date</strong>", choices=flightStatusDates)
    submit5 = SubmitField("Search")

class PaymentForm(FlaskForm):
    cardNumber = StringField("<strong>Card Number</strong>", validators=[InputRequired(), Regexp(cardNumberRegex, message="Must only contain numbers and dashes.")])
    cardType = SelectField("<strong>Card Type</strong>", choices=creditCardTypes)
    expirationMonth = SelectField("<strong>Expiration Month</strong>", choices=expirationMonths)
    expirationYear = SelectField("<strong>Expiration Year</strong>", choices=expirationYears)
    cvv = StringField("<strong>CVV</strong>", validators=[InputRequired(), Length(min=3, max=3, message="Field must be 3 digits long."), Integer()])
    name = StringField("<strong>Name on the Card</strong>", validators=[InputRequired(), Length(min=4, max=100), AlphaSpace()])
    submit = SubmitField("Pay")
    
    # Convert card number to numbers only
    def validate(self):
        if not FlaskForm.validate(self):
            return False
        else:
            self.cardNumber.data = self.cardNumber.data.replace("-", "")
            return True

class ContactForm(FlaskForm):
    firstName = StringField("<strong>First Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    lastName = StringField("<strong>Last Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    email = StringField("<strong>Email</strong>", validators=[InputRequired(), Length(min=4, max=100), Email()])
    subject = StringField("<strong>Subject</strong>", validators=[InputRequired(), Length(min=4, max=100), Regexp(textRegex, message="Input contains illegal characters.")])
    message = TextAreaField("<strong>Message</strong>", validators=[InputRequired(), Length(min=4, max=1000), Regexp(textRegex, message="Input contains illegal characters.")], render_kw={"rows": 6, "cols": 1})
    submit = SubmitField("Contact Us")

class LoginForm(FlaskForm):
    username = StringField("<strong>Username or HawkAdvantage</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaNumeric()])
    password = PasswordField("<strong>Password</strong>", validators=[InputRequired(), Length(min=4, max=64), AlphaNumeric()])
    remember = BooleanField("Remember me")
    submit = SubmitField("Log In")

class RegisterForm(FlaskForm):
    title = SelectField("<strong>Title</strong>", choices=titles)
    firstName = StringField("<strong>First Name *</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    middleName = StringField("<strong>Middle Name</strong>", validators=[Optional(), Length(min=4, max=45), Alpha()])
    lastName = StringField("<strong>Last Name *</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    preferredName = StringField("<strong>Preferred Name</strong>", validators=[Optional(), Length(min=1, max=45), Alpha()])
    sex = SelectField("<strong>Sex *</strong>", choices=sexes)
    dateOfBirth = DateField("<strong>Date of Birth *</strong>", format="%Y-%m-%d", validators=[InputRequired()], render_kw={"min": "1990-01-01", "max": datetime.date.today()})
    street = StringField("<strong>Street *</strong>", validators=[InputRequired(), Length(min=4, max=100), Regexp(streetRegex, message="Must only contain alpha characters, numbers, spaces and periods.")])
    city = StringField("<strong>City *</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaSpace()])
    zipCode = StringField("<strong>Zip Code *</strong>", validators=[InputRequired(), Length(min=4, max=10), Integer()])
    state = StringField("<strong>State</strong>", validators=[Optional(), Length(min=2, max=45), AlphaSpace()])
    country = StringField("<strong>Country *</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaSpace()])
    phone = StringField("<strong>Phone *</strong>", validators=[InputRequired(), Length(min=4, max=200), Regexp(streetRegex, message="Must only contain numbers, and some special characters.")])
    email = StringField("<strong>Email *</strong>", validators=[InputRequired(), Length(min=4, max=100), Email()])
    username = StringField("<strong>Username *</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaNumeric()])
    password = PasswordField("<strong>Password *</strong>", validators=[InputRequired(), Length(min=4, max=64), AlphaNumeric(), EqualTo("repeatPassword", "Passwords must match.")])
    repeatPassword = PasswordField("<strong>Repeat Password *</strong>", validators=[InputRequired(), Length(min=4, max=64), AlphaNumeric()])
    securityQuestion = SelectField("<strong>Security Question *</strong>", choices=securityQuestions)
    securityAnswer = StringField("<strong>Answer *</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaNumeric()])
    submit = SubmitField("Register")
    
    # Check if email already exist in database
    def validate_email(self, email):
        with app.app_context():
            cursor = mysql.connection.cursor()
            cursor.execute("SELECT * FROM users WHERE Email = \'%s\'" % self.email.data)
            alreadyExists = cursor.fetchone()
            cursor.close()
        if alreadyExists:
            raise ValidationError("This email is taken. Please choose a different one.")
    
    # Check if username already exist in database
    def validate_username(self, username):
        with app.app_context():
            cursor = mysql.connection.cursor()
            cursor.execute("SELECT * FROM users WHERE Username = \'%s\'" % self.username.data)
            alreadyExists = cursor.fetchone()
            cursor.close()
        if alreadyExists:
            raise ValidationError("This username is taken. Please choose a different one.")

class MulticityFlight(Form):
    fromCity = SelectField("<strong>From *</strong>", choices=fromCities)
    toCity = SelectField("<strong>To *</strong>", choices=toCities)
    departDate = DateField("<strong>Depart *</strong>", format="%Y-%m-%d", validators=[InputRequired(), FutureDate], render_kw={"min": datetime.date.today(), "max": datetime.date.today() + datetime.timedelta(weeks=20)})
    
    # From and To cannot be the same
    def validate(self):
        if not FlaskForm.validate(self):
            return False
        elif self.fromCity.data == self.toCity.data:
            self.toCity.errors.append("From and To cannot be the same.")
            return False
        return True
    
class MulticityForm(FlaskForm):
    flights = FieldList(FormField(MulticityFlight), min_entries=1, max_entries=5)
    passengers = SelectField("<strong>Number of passengers *</strong>", choices=passengersRange)
    submit = SubmitField("Search")

class AdminForm(FlaskForm):
    username = StringField("<strong>Admin Username</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaNumeric()])
    password = PasswordField("<strong>Admin Password</strong>", validators=[InputRequired(), Length(min=4, max=64), AlphaNumeric()])
    submit = SubmitField("Log In")
