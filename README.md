# Knock, Knock. Who's There? Understanding Who's Accessing your Web Applications

Knock, knock.
Who's there?
User.
User who?
user@website.com:password.
Ok, have fun!

There are lots of ways of dealing with authentication, but the
interaction before, during, and after is usually ignored.  This is
pretty much how web applications work today. We don't ask the right
questions of users attempting to access our web applications. How sure
are you that the user accessing your site is who they say they are?
How sure are you that you want them accessing your site at all? Join
Aaron Bedra as he walks you through asking the questions you should be
asking of your users, and how to help prevent abuse, fraud, and
otherwise unwanted activity on your web applications. You will learn
how to ask the right questions without interfering with a great user
experience.

#### Additional Notes
This talk will cover things like passive tcp
fingerprinting, device fingerprinting, user agent filtering, geo
location based interaction filtering, request profiling (is the user
submitting requests that are outside what is expected), behavior
classification, and web application firewalls.

#### Take Away Lessons
* This is about the 80% case. If someone really wants to spoof or hack, they will!
* Don't impact user experience! It's better to let some badness pass through in order to never impact a user
* If a user actively denies your attempts to detect, then mark the account as suspicious
* Always provide customer service information to the user, just in case
* Tell your CS people about what you are doing, and provide them with tools to let them know an account has been marked as suspicious or compromised so they can tell the user

#### High Level Ideas
* Everything should have an example implementation to show that it is possible
* Use nginx for all of the examples so they are consistent
* Create a sample application to house everything with a full README and bootstrap scripts to setup the full stack (webserver + application)

## GeoIP:
* http://wiki.nginx.org/HttpGeoipModule  
* http://www.howtoforge.com/using-geoip-with-nginx-on-debian-squeeze-ubuntu-11.04  
* http://www.howtoforge.com/nginx-how-to-block-visitors-by-country-with-the-geoip-module-debian-ubuntu  

* When a user logs in, store the geo ip details (last_logged_in_geo_details)  
* When a user acts on their account (tries to change password, update email address, etc, attempt to match geo details)  
  * If the details don't match, reject the attempt, and mark the account as potentially compromised  
  * Potentially call the user and let them know  
    * The level at which things don't match is up to you (City, State/Region, Country, etc)  

## User Agent Filtering
* http://www.cyberciti.biz/faq/nginx-if-conditional-http_user_agent-requests/  
* http://wiki.nginx.org/HttpBrowserModule  

* Use nginx to only respond to known user agents  
* Log when an unknown user agent occurs and monitor  
 * Create monitors and queries to show the top unknowns and potentially detect patterns  
* Eventually start denying unknown user agents with a friendly message  
* Requests with empty user agent strings  

## Passive TCP Fingerprinting
* When a computer makes a connection, it is possible most of the time to find out what OS they are using  
  * This allows us to ask questions like does the user agent match the fingerprint  
  * For example, a User agent of "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)" and a detected OS of "iOS iPhone or iPad" doesn't match up  
  * This also allows us to potentially pick up users that are using vpn tunnels or other potentially suspicious connection techniques as well  
* Acting on this is difficult  
  * This is not always accurate  
  * Instead of blocking user activity based solely on this, use it as supporting evidence along with the other techniques used here  
  * Log, log, log!  

# Request profiling
* Define sets of acceptable parameters for each of your requests. If a user makes requests outside of these, then act on it  
* Log the activity and flag the account after a few bad requests  
* Idea: Rails plugin that allows you to declare params for controller methods in the style of attr_accessible  
  * params_acceptable :create, :name, :address, :zip  

# Behavior Tracking/Classification
* Log everything a user does when they are logged in  
  * This is where queues help  
  * Don't worry if you drop some information, make sure you don't impact performance in a noticeable way  
* Think about your user interactions, and what standard interaction looks like  
  * What is the distribution of HTTP verbs (GET, POST, PUT, DELETE) per user?  
  * What is the average time between requests?  
  * How many invalid requests (non 2xx/3xx requests) has the user made?  
  * Other obviously identifiable patterns  
* Provide queries against this data to find users who fall outside of the distributions/averages  
  * This will provide an actionable model that can automatically send you users to investigate  

# Web Application Firewalls
* http://www.modsecurity.org/projects/modsecurity/nginx/index.html  

* They suck, but we should use them  
* Just don't block anything  
  * Well, maybe things like LOINC, etc  
* Have them alert  
  * When they alert, process it and tie it back to the user that triggered the rule  
  * Flag the account after a certain number of offenses  
* This will take a long time to tune the firewall rules and understand how things work  
* Don't disable accounts until you are absolutely sure you aren't going to accidentally lock your users out with a new feature  
