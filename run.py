import hashlib
from flask import *
from flask_bootstrap import *
from forms import *

app = Flask(__name__)
app.config["SECRET_KEY"] = "CS4400"
Bootstrap(app)

@app.route("/", methods=["GET", "POST"])
def index():
    # No need for this field
    # We will fetch the latest 3 news from MySQL using ORDER BY
    news1 = {
        "headline": "May Vacation Sale",
        "picture": "/static/images/vacations.png",
        "content": "Save and earn up to 25,000 bonus miles when you book your flight and hotel together! MileagePlus is your ticket to the world, with the most ways to earn and use miles and the most award destinations of any U.S. airline loyalty program. Now all you need is more vacation days."
    }
    news2 = {
        "headline": "Rent a Car with Avis or Budget",
        "picture": "/static/images/car.png",
        "content": "Save up to 35% off base rates and earn miles. Reserve a car today! No matter the destination, enjoy a trip that delivers more savings. Save up to 30% off of Budget base rates and earn 1,000 AAdvantage bonus miles when you rent for 4 or more days. These miles are in addition to your base miles you receive when renting with Budget."
    }
    news3 = {
        "headline": "Fly Nonstop to Poland",
        "picture": "/static/images/poland.png",
        "content": "New service to Krakow from Chicago OHare start May 7. Search and book your flights! Pack your bags and explore Europe! Take advantage of great fares and low exchange rates and save first on flights and again on hotels, dining and shopping when you get there."
    }
    news = [news1, news2, news3]
    
    roundtrip = RoundTripForm()
    oneway = OneWayForm()
    yourtrip = YourTripForm()
    flightstatusDate = FlightStatusDateForm()
    flightstatusNumber = FlightStatusNumberForm()
    if roundtrip.submit1.data and roundtrip.validate_on_submit():
        return roundtrip.data
    elif oneway.submit2.data and oneway.validate_on_submit():
        return oneway.data
    elif yourtrip.submit3.data and yourtrip.validate_on_submit():
        return yourtrip.data
    elif flightstatusDate.submit4.data and flightstatusDate.validate_on_submit():
        return flightstatusDate.data
    elif flightstatusNumber.submit5.data and flightstatusNumber.validate_on_submit():
        return flightstatusNumber.data
    return render_template("index.html", title="Home", news=news, roundtrip=roundtrip, oneway=oneway, yourtrip=yourtrip, flightstatusDate=flightstatusDate, flightstatusNumber=flightstatusNumber)

@app.route("/about-us")
def aboutUs():
    return render_template("about-us.html", title="About Us")

@app.route("/contact-us", methods=["GET", "POST"])
def contactUs():
    # No need for this field
    # Fetch this data from our database
    data = {
        "phoneNumber": "319-834-0276",
        "email": "hawkair2020@gmail.com"
    }
    form = ContactForm()
    if form.validate_on_submit():
        return form.data
    return render_template("contact-us.html", title="Contact Us", data=data, form=form)

@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
        return form.data
    return render_template("login.html", title="Login / Register", form=form)

@app.route("/register", methods=["GET", "POST"])
def register():
    form = RegisterForm()
    if form.validate_on_submit():
        hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
        return form.data
    return render_template("register.html", title="Register", form=form)

@app.route("/multicity", methods=["GET", "POST"])
def multicity():
    form = MulticityForm()
    if form.validate_on_submit():
        return form.data
    return render_template("multicity.html", title="Multi-City", form=form)

@app.route("/admin", methods=["GET", "POST"])
def admin():
    form = AdminForm()
    if form.validate_on_submit():
        hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
        return form.data
    return render_template("admin.html", title="Admin", form=form)

if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=5000)
