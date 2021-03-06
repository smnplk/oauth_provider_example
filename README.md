#Description 

Example Rails 4 app demonstrating how to use doorkeeper gem with devise 
to secure api endpoints with 2 legged Oauth 2 authentication [Resource Owner Password Flow](http://oauthbible.com/#oauth-2-two-legged)
Note that you must use oauth2 with SSL, if you can't use SSL in your production app for some reason, better use Oauth 1.0a


# Install

git clone https://github.com/smnplk/oauth_provider_example

cd oauth_provider_example && bundle && rake db:migrate && rake db:seed && rails s

The seed task will create a user with email: 'user@email.com' and password: 'password123' and  three contacts entries. 

Now go to localhost:3000/oauth/applications and create a new application (eg. 'My Mobile Client'), you must enter a redirect uri, but that uri is not used in this auth flow, so you can just use the one for local tests. Once application is created, application_id and application_secret are generated. Copy the application_id, you will need it for authantication.


This demo app only has one api route /api/v1/contacts which returns the list of contacts in json form. Making a request to this route will end up in 401, because you need to first authenticate and obtain access token.

#Steps to making authenticated requests from client side (SPA perspective)

To receive the access_token and refresh_token for the first time, you must also send client credentials. 
Make a POST request to /oauth/token with Content-type 'application/json', the body of the request should be like this: 

```
{"grant_type":"password", "client_id":"<your_app_id>", "username":"user@email.com", "password":"password123"}
```

Note that you don't have to send application_secret and you shouldn't!



You will receive back access token and refresh token. 
IMPORTANT! Note that ideally you should not receive refresh_token back in plain text form. Because you have to store it on the client, to make a request for a new access token once the old one expires. I would suggest making additional route that can receive refresh token in encrypted form, decrypts it and redirects to /oauth/token. How to do this might be in doorkeeper docs. 


Now you can make a GET request /api/v1/contacts, but remember to put Authorization header with value "Bearer your_access_token" (without the quotes) in your http request. Now you should get back the secured resource. 


Access token can expire and it should. In this demo app I have it set up to expire in 5 min(you can change this in doorkeeper.rb). If you make request with expired token in Authorization header, you will also get a 401 response. This is where refresh token comes in. Ofcourse you could again make the same request as above to receive new access and refresh token, but I like to use refresh tokens, because you reduce the number of times you have to send user credentials over the wire. 

So to obtain new access token (and new refresh token!) we just need to send over client_id and refresh_token to /oauth/token. So making the same POST request with refresh token grant type: 

```
  {"grant_type":"refresh_token", "client_id":"<your_client_id>","refresh_token":"<your_current_refresh_token>" }
```

This request will respond with new access token and new refresh token, old refresh token will not be valid anymore. And attempting to obtain new access token with expired refresh token will also result in 401. 

For production environments it is important to make those http calls via SSL to protect against MITM attacks. 

TODO: make this docs better (Written in a hurry)
