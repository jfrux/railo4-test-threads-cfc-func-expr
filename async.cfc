component name="async_module" output=true {
	public any function init() {
		return this;
	}

	public any function forEach(arr, iterator, cb) {
        var callback = isFunction(cb)? cb : noop;

        if (arrayLen(arr) EQ 0) {
        	writeOutput("it's 0");
            return callback();
        }

        var completed = 1;
        var threadTick = 0;
        _syncForEach(arr, function (x) {
        	var threadName = "thread-#threadTick#";
        	
        	thread name="#threadName#" action="run" {
        		writeOutput(completed);
	        	iterator(x, function (err) {
	                if (structKeyExists(arguments,'err')) {
	                	callback(err);
	                    callback = function () {};
	                } else {
	                    completed++;
	                    if (completed GT arrayLen(arr)) {
	                    	callback(returnNull());
	                    }
	                }
	            });
        	}
        	threadTick++;
        });
   	};

   	/**
	* 	@header _.each(collection, iterator, [context]) : void
	*	@hint Iterates over a collection of elements, yielding each in turn to an iterator function. The iterator is bound to the context object (component or struct), if one is passed. Each invocation of iterator is called with three arguments: (element, index, collection, this). If collection is an object/struct, iterator's arguments will be (value, key, collection, this).
	* 	@example _.each([1, 2, 3], function(num){ writeDump(num); }); <br />=> dumps each number in turn... <br />_.each({one : 1, two : 2, three : 3}, function(num, key){ writeDump(num); });<br />=> dumps each number in turn...
	*/
	public void function _syncForEach(obj = this.obj, iterator = _.identity) {
		var element = "";
		if (isArray(arguments.obj)) {
			var index = 1;
			for (element in arguments.obj) {
				if (arrayIsDefined(arguments.obj, index)) {
					iterator(element, index, arguments.obj);
				}
				index++;
			}
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			for (key in arguments.obj) {
				var val = arguments.obj[key];
				iterator(val, key, arguments.obj, arguments.this);
			}
		}
		else {
			// query or something else? convert to array and recurse
			_syncForEach(toArray(arguments.obj), iterator, arguments.this);
		}
 	}

	/**
	* 	@header _.isEmpty(object) : boolean
	*	@hint Returns true if object contains no values. Delegates to ArrayLen for arrays, structIsEmpty() otherwise.
	* 	@example _.isEmpty([1, 2, 3]);<br />=> false<br />_.isEmpty({});<br />=> true
	*/
	public boolean function isEmpty(obj = this.obj) {
		if (isArray(arguments.obj)) {
			return (ArrayLen(arguments.obj) == 0);
		}
		else if (isStruct(arguments.obj)) {
			return structIsEmpty(arguments.obj);
		}
		else if (isString(arguments.obj)) {
			return (len(arguments.obj) == 0);
		}
		else {
			throw("isEmpty() error: Not sure what obj is", "Underscore");
		}
	}

	/**
	* 	@header _.isFunction(object) : boolean
	*	@hint Returns true if object is a Function.	Delegates to native isClosure() || isCustomFunction()
	* 	@example _.isFunction(function(){return 1;});<br />=> true
	*/
	public boolean function isFunction(obj = this.obj) {
		return isClosure(arguments.obj) || isCustomFunction(arguments.obj);
	}

	/**
	* 	@header _.isString(object) : boolean
	*	@hint Returns true if object is a String. Uses Java String type comparison.
	* 	@example _.isString("moe");<br />=> true<br />_.isString(1);<br />=> true//Coldfusion converts numbers to strings
	*/
	public boolean function isString(obj = this.obj) {
		return isInstanceOf(arguments.obj, "java.lang.String");
	}

	/**
	* 	@header _.isNumber(object) : boolean
	*	@hint Returns true if object is of a Java numeric type.
	* 	@example _.isNumber(1);<br />=> false//Coldfusion converts numbers to strings<br />_.isNumber(JavaCast("int", 1));<br />=> true
	*/
	public boolean function isNumber(obj = this.obj) {
		return isInstanceOf(arguments.obj, "java.lang.Integer") || isInstanceOf(arguments.obj, "java.lang.Short") ||
			isInstanceOf(arguments.obj, "java.lang.Long") || isInstanceOf(arguments.obj, "java.lang.Double") ||
			isInstanceOf(arguments.obj, "java.lang.Float");
	}

	public void function returnNull() {}

	public any function noop() {}
}