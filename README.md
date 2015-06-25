# Chart.it
This is a small sample application showing an example of a rest api built in rails (using grape) that is then utilized by a rails web application front end.

This is a charting application that allows you to create pie charts.

The following are the endpoints supported by the REST api:

```
get api/v1/charts   #Fetches a list of a users charts
post api/v1/charts  #Creates a new chart
get api/v1/chart/:chart_id  #Fetches a particular chart
put api/v1/chart/:chart_id  #Updates a particular chart

```

The REST API (for now) uses HTTP_BASIC authentication using the username and password used to sign in to web application.  Therefore each api call should be made according to the following:

```
curl -u username:password API_ENDPOINT
```

Therefore to test the endpoints simple create a user in the web application and then call the endpoints using those credentials.  **Note:  This authentication will eventually be replaces by HMAC api key authentication.
