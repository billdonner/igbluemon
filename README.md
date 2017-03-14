# IGBlueMon - dynamic server monitor for IOS and OSX

I'm monitoring a dozen or so bluemix servers with this tool.

Reads a remote JSON configuration file to specify servers.

## Setting Up monitoring

Each server needs a /json route to return a small JSON dictionary 

- servertitle -- a short name for your server
- description -- a longe fuller description 
- elapsed-secs -- the uptime for the server
- softwareversion -- version

## Configuration 

<code>
 {
"comment": "yada",
"servers": [
{
"server": "https://blufile.mybluemix.net"
},
 {
"server": "https://faymuz-cookie.mybluemix.net"
}]
}
</code>
