import re
from flask_wtf import FlaskForm 
from wtforms import BooleanField, FieldList, Form, FormField, PasswordField, SelectField, StringField, SubmitField, TextAreaField
from wtforms.fields.html5 import DateField
from wtforms.validators import Email, EqualTo, InputRequired, Length, Regexp, Optional
from wtforms_validators import Alpha, AlphaSpace, AlphaNumeric, Integer

textRegex = re.compile("\s*\w*[!@#$%()=+-:;'\",.?]*")
streetRegex = re.compile("\s*\w*[.]*")
phoneRegex = re.compile("\s*\d*[-+.]*")

titles = [("", ""), ("Mr", "Mr"), ("Ms", "Ms"), ("Mrs", "Mrs"), ("Mx", "Mx")]
sexes = [("Male", "Male"), ("Female", "Female")]
securityQuestions = [("What was your favorite sport in high school?", "What was your favorite sport in high school?"),
                     ("What is your pet's name?", "What is your pet's name?"),
                     ("What was the color of your first car?", "What was the color of your first car?"),
                     ("What is your favorite team?", "What is your favorite team?"),
                     ("In what city were you born?", "In what city were you born?")]
fromCities = [("ORD", "ORD")]
toCities = [("LAX", "LAX"), ("DFW", "DFW"), ("JFK", "JFK"), ("DEN", "DEN"), ("MIA", "MIA")]
passengersRange = [(str(i), str(i)) for i in range(1, 10)]

class RoundTripForm(FlaskForm):
    fromCity1 = SelectField("<strong>From</strong>", choices=fromCities)
    toCity1 = SelectField("<strong>To</strong>", choices=toCities)
    passengers1 = SelectField("<strong>Number of passengers</strong>", choices=passengersRange)
    departDate1 = DateField("<strong>Depart</strong>", format="%Y-%m-%d", validators=[InputRequired()])
    returnDate1 = DateField("<strong>Return</strong>", format="%Y-%m-%d", validators=[InputRequired()])
    submit1 = SubmitField("Search")

class OneWayForm(FlaskForm):
    fromCity2 = SelectField("<strong>From</strong>", choices=fromCities)
    toCity2 = SelectField("<strong>To</strong>", choices=toCities)
    passengers2 = SelectField("<strong>Number of passengers</strong>", choices=passengersRange)
    departDate2 = DateField("<strong>Depart</strong>", format="%Y-%m-%d", validators=[InputRequired()])
    submit2 = SubmitField("Search")

class YourTripForm(FlaskForm):
    firstName3 = StringField("<strong>First Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    lastName3 = StringField("<strong>Last Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    bookingNumber3 = StringField("<strong>Booking Number</strong>", validators=[InputRequired(), Integer()])
    submit3 = SubmitField("Search")

class FlightStatusDateForm(FlaskForm):
    fromCity4 = SelectField("<strong>From</strong>", choices=fromCities)
    toCity4 = SelectField("<strong>To</strong>", choices=toCities)
    date4 = DateField("<strong>Depart</strong>", format="%Y-%m-%d", validators=[InputRequired()])
    submit4 = SubmitField("Search")

class FlightStatusNumberForm(FlaskForm):
    flightNumber5 = StringField("<strong>Flight Number</strong>", validators=[InputRequired(), Length(min=6, max=6, message="Field must be 6 characters long."), AlphaNumeric()])
    date5 = DateField("<strong>Depart</strong>", format="%Y-%m-%d", validators=[InputRequired()])
    submit5 = SubmitField("Search")

class ContactForm(FlaskForm):
    firstName = StringField("<strong>First Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    lastName = StringField("<strong>Last Name</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    email = StringField("<strong>Email</strong>", validators=[InputRequired(), Length(min=4, max=100), Email()])
    subject = StringField("<strong>Subject</strong>", validators=[InputRequired(), Length(min=4, max=100), Regexp(textRegex, "Input contains illegal characters.")])
    message = TextAreaField("<strong>Message</strong>", validators=[InputRequired(), Length(min=4, max=1000), Regexp(textRegex, "Input contains illegal characters.")], render_kw={"rows": 4, "cols": 1})
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
    preferredName = StringField("<strong>Preferred Name</strong>", validators=[Optional(), Length(min=4, max=45), Alpha()])
    dateOfBirth = DateField("<strong>Date of Birth *</strong>", format="%Y-%m-%d", validators=[InputRequired()])
    sex = SelectField("<strong>Sex *</strong>", choices=sexes)    
    street = StringField("<strong>Street *</strong>", validators=[InputRequired(), Length(min=4, max=100), Regexp(streetRegex, "Must only contain alpha characters, numbers, spaces and periods.")])
    city = StringField("<strong>City *</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    zipCode = StringField("<strong>Zip Code *</strong>", validators=[InputRequired(), Length(min=4, max=10), Integer()])
    state = StringField("<strong>State</strong>", validators=[Optional(), Length(min=4, max=45), Alpha()])
    country = StringField("<strong>Country *</strong>", validators=[InputRequired(), Length(min=4, max=45), Alpha()])
    email = StringField("<strong>Email *</strong>", validators=[InputRequired(), Length(min=4, max=100), Email()])    
    phone = StringField("<strong>Phone *</strong>", validators=[InputRequired(), Length(min=4, max=200), Regexp(streetRegex, "Must only contain numbers, and some special characters.")])
    username = StringField("<strong>Username *</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaNumeric()])
    password = PasswordField("<strong>Password *</strong>", validators=[InputRequired(), Length(min=4, max=64), AlphaNumeric(), EqualTo("repeatPassword", "Passwords must match.")])
    repeatPassword = PasswordField("<strong>Repeat Password *</strong>", validators=[InputRequired(), Length(min=4, max=64), AlphaNumeric()])
    securityQuestion = SelectField("<strong>Security Question *</strong>", choices=securityQuestions)
    securityAnswer = StringField("<strong>Answer *</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaNumeric()])
    submit = SubmitField("Register")

class MulticityFlight(Form):
    fromCity = SelectField("<strong>From *</strong>", choices=fromCities)
    toCity = SelectField("<strong>To *</strong>", choices=toCities)
    departDate = DateField("<strong>Depart *</strong>", format="%Y-%m-%d", validators=[InputRequired()])
    
class MulticityForm(FlaskForm):
    flights = FieldList(FormField(MulticityFlight), min_entries=1, max_entries=5)
    passengers = SelectField("<strong>Number of passengers *</strong>", choices=passengersRange)
    submit = SubmitField("Search")

class AdminForm(FlaskForm):
    username = StringField("<strong>Admin Username</strong>", validators=[InputRequired(), Length(min=4, max=45), AlphaNumeric()])
    password = PasswordField("<strong>Admin Password</strong>", validators=[InputRequired(), Length(min=4, max=64), AlphaNumeric()])
    submit = SubmitField("Log In")
