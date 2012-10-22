<cfscript>
	async = new async();

	endpoints = [
		"https://github.com/caolan/async",
		"https://github.com/joshuairl/mkdirp",
		"https://github.com/joshuairl/fpm-test-module",
		"https://github.com/foundrycf/foundry",
		"https://github.com/foundrycf/fpm"
	];

	doneEndpoints = function(err) {
		writeOutput("in doneEndpoints()");
		if(structKeyExists(arguments,'err')) {
			writeOutput("<div>error!</div>");
		}
		writeOutput("<div>success!</div>");

		return true;
	};

	async.forEach(endpoints,function (endpoint, next) {
		writeOutput("<div>#endpoint#</div>");
		next();
	  },
	  doneEndpoints
	);


	// async.forEachSeries(endpoints,function(endpoint, next) {
	// 	next();
	// },doneEndpoints);


	// async.forEachLimit(endpoints,10,function(endpoint, next) {
	// 	next();
	// },doneEndpoints);
</cfscript>