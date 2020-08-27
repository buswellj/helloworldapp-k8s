// Application Specific Information
var hhappname = "Handy Hello World App";
var hhversion = "1.0.3";
var hhcopyright = "Copyright (c) 2020 John Buswell";
var hhcheck = "OK";

// Load dependencies
var express = require('express');
var fs = require('fs');
var morgan = require('morgan');
var responseTime = require('response-time');

// Create express
var app = express()

// Create log stream
var accessLogStream = fs.createWriteStream('/tmp/hhapp-access.log',{flags: 'a'});

// Configure Express
app.use(morgan('combined',{stream: accessLogStream}));
app.use(responseTime());


// Simple End points

app.get('/', function(req,res) {
  res.status(200).send('Hello World!')
})

app.get('/:name/hello', function(req, res) {
  var hellothere = 'Hello ' + req.params.name;
  res.status(200).send(hellothere)
})

app.get('/hello/:name', function(req, res) {
  var hellothere = 'Hello ' + req.params.name;
  res.status(200).send(hellothere)
})

app.get('/version',function(req,res) {
  res.status(200).send(hhversion)
})

app.get('/health',function(req,res) {
  res.status(200).send(hhcheck)
})

app.get('/dumplog',function(req,res) {
  fs.readFile('/tmp/hhapp-access.log', 'utf8', function(err, contents) {
   res.send(contents);
  });
})

app.use(function (req, res, next) {
  res.status(404).send("Error 404: Invalid URL - Sorry can't find that!")
})

// Start server

var server = app.listen(8666, '0.0.0.0', function() {
  var host = server.address().address;
  var port = server.address().port;

  console.log('');
  console.log('%s, version %s', hhappname, hhversion);
  console.log('%s', hhcopyright);
  console.log('');
  console.log('Listening on http://%s:%s', host, port);
  console.log('');
});
