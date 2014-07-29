/**
 * post.js
 *
 */

// setting
var id = '53d4c41fe4b0f86f8d431154';

var mongodb_server = '10.0.1.13';
var mongodb_port = 27017;
var mongodb_database = 'hotel';
var mongodb_collection = 'hotel';

var gungnir_server = '10.0.1.13';
var gungnir_port = 9191;
var gungnir_tuple = 'demo';


var http = require('http');
var mongodb = require('mongodb');

var i = 0, rand, stat, options, hotels;

var stats = {
	"commit": 0,
	"watch": 0,
	"cancel": 0
};
var httpStats = {
	"success": 0,
	"fail": 0
};

// get hotels
var conn = new mongodb.Db(
	mongodb_database,
	new mongodb.Server(mongodb_server, mongodb_port, {}),
	{safe: false}
);
conn.open(function(err, db){
	if (err) {
		console.log(err);
		return;
	}
	db.collection(mongodb_collection).find().toArray(function(err, docs){
		db.close();
		if (err) {
			console.log(err);
			return;
		}
		hotels =  docs;

		setTimeout(func, 1);
	});
});


var func = function(){
	rand = Math.floor(Math.random() * 100);
	if (rand < 10) {
		stat = "commit";
	} else if (rand == 99) {
		stat = "cancel";
	} else {
		stat = "watch";
	}

	// post
	options = {
		host: gungnir_server,
		port: gungnir_port,
		method: 'POST',
		path: '/gungnir/v0.1/track/' + id + '/' + gungnir_tuple,
		headers: {
			'Content-Type': 'application/json'
		}
	};

	var req = http.request(options, function(res){
		// console.log("STATUS:" + res.statusCode);
		if (res.statusCode == 200) {
			httpStats["success"]++;
		} else {
			httpStats["fail"]++;
			console.log("STATUS:" + res.statusCode);
		}
		res.on('data', function(chunk){
			//console.log("DATA: " + chunk);
		});
	});
	req.on('error', function(e){
		console.log(e.message);
		res.on('data', function(chunk){
			console.log('BODY: ' + chunk);
		});
	});
	req.write(JSON.stringify({
		status: stat,
		hotelId: hotels[Math.floor(Math.random() * 10)]["hotelId"]
	}));
	req.end();

	i++
	stats[stat]++;

	if (i % 100 == 0) {
		end = (new Date()).getTime();
		console.log(
			("          " + i).slice(-10) + " total, "
			+ ("          " + stats["watch"]).slice(-10) + " watches, "
			+ ("          " + stats["commit"]).slice(-10) + " commits, "
			+ ("          " + stats["cancel"]).slice(-10) + " cancels"
		);
	}

	setTimeout(func, Math.floor(Math.random() * 20) * 10);
};

// EOF
