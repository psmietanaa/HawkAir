# HawkAir
HawkAir is an airline database system made in MySQL, Python, Flask, Bootstrap, and some JavaScript. It was created for a Database Systems course at the University of Iowa named CS:4400. The course was led by Professor Raman Aravamudhan and TA Audry Kibonge. The website was designed and created by Jacob Seedorff, Piotr Smietana, and Sriram Srinivasan.

![](/demo/demo-small.gif)

# Process
- We worked regularly throughout the semester.
- We communicated using WhatsApp and we used GitHub to collaborate together.
- Our biggest strength was teamwork. Everyone wanted to learn something and build a cool database system.
- Thanks to great communication, working remotely was not a big challenge for us. We just had to move our weekly meetings to Zoom.
- We were splitting the workload evenly among each other.

# Features
The following features are supported by our website:
<table>
<thead>
  <tr>
    <td>• One-way flights<br>• Round trip flights<br>• Multi-city flights<br>• Your trips / Dashboard<br>• Flight status<br>• News<br>• About us<br>• Contact us<br>• Login<br>• Register<br>• Admin panel</th>
    <td>• Payments<br>• Multiple passengers<br>• Mileage program<br>• Email notifications<br>• Customer support<br>• Trip cancellation<br>• Trip change<br>• SHA-2 encryption<br>• Forgot username<br>• Forgot password<br>• CRUD</th>
  </tr>
</thead>
</table>

# Usage
- Run DDL.sql and load Procedures.sql into your MySQL Server.
- It is recommended to use MySQL Server 8.0 with the software
- All libraries required to run the code are in requirements.txt
<pre><code>pip install -r requirements.txt</code></pre>
- To run the website type:
<pre><code>python run.py</code></pre>

# Files
- Demo folder contains files used for presentation purposes
- Documents is a folder with class assignments and design documents
- Static folder contains website content, libraries, and some JavaScript
- Templates is a folder with HTML templates that we use to render each website screen
- DDL.sql is a file that contains commands that define the different structures in a database
- Hub.sql has queries used to search for flights with zero, one, and two connections.
- Procedures.sql file holds all procedures that are used by the website.
- Forms.py is a file that defines all the forms present on the website
- Helper.py contains helper functions that are used across other python files.
- Mail.py is a file with message templates and routines to send email to clients.
- Routes.py file has all the logic what happens behind each screen on the website.
- Run.py is a configuration file that runs the entire database system.
