/*
 *	Copyright (c) 2012, Pixelbaker
 *	All rights reserved.
 *
 *	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *		Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *		Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 *	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


struct Assert2
(
	/*
	 *	Assert class for custom asserts used inside the maxtest framework.
	 *	This struct merly groups the functionality to not clutter the global scope with different asserts.
	 *	You shouldn't need to instanciate this struct.
	 *	Use it as static methods.
	 *	
	 *	Be aware that the assert works highly with clearing the listener.
	 *	Don't keep important information on your listener when using this assert.
	 * 
	 *	@info: equals and notEquals cannot compare arrays, MAX limitation
	 */
	
	public
	
	-- Helper functions
	-- Need to be public to keep the static notion, but shouldn't be called directly.
	function _locateAssert exceptionStr stacklevel:1 =
	(
		/**
		 *	<String>locateProblem <String>exceptionStr <Integer>stacklevel:
		 *	Searches through a stack report and returns the file and line number,
		 *	where a snapshot of the stack was done.
		 */
		
		local ssException = StringStream exceptionStr
		local searchStackStr = "[stack level: "+stacklevel as String+"]"
		local fileLineInfo = ""
		
		seek ssException 0
		
		result = skipToString ssException searchStackStr
		
		if undefined != result then
		(
			skipToNextLine ssexception
			fileLineInfo = readLine ssexception
		)
		
		fileLineInfo
	),

	
	function _formatResultDescription assertFnName message testVal compareOperator expectedVal fileLineInfo =
	(
		/*
		 *	Formats the resultDescription
		 *
		 */
		
		local resultDescription = StringStream ""
		
		format "\nMaxscript % Failed:\t%\n" assertFnName message to:resultDescription
		
		-- Using print to retain doubleQuotes if testVal is of type String
		print testVal to:resultDescription 
		
		-- Previous print command adds newline, which gets removed here
		seek resultDescription ((filePos resultDescription)-1)
		
		format " % " compareOperator to:resultDescription
		
		-- Using print to retain doubleQuotes if testVal is of type String
		print expectedVal to:resultDescription
		
		format "\n%" fileLineInfo to:resultDescription
		
		resultDescription
	),
	
	
	function _createAssertRaiseStruct =
	(
		/*
		 *	Generates a global class for storing arguments, keywords and a pointer to a function.
		 */
		
		global __AssertRaiseHelper__
		
		struct __AssertRaiseHelper__
		(
			/*
			 *	An object which holds all information to execute a function in global scope.
			 */
			
			-- Members
			----------
			
			-- of type String
			public globalInstanceName = "",
			
			-- of type MAXScriptFunction
			public fnPointer = undefined,
			
			-- of type Value
			public args = #(),
			
			-- of type DataPair(KeywordName, KeywordValue)
			public keywords = #(),
			
			
			-- Methods
			----------
			
			public
			function createCallString =
			(
				/*
				 *	Creates a string, which will run the function with all the arguments and keywords in global scope.
				 *	
				 *	@return: The string to execute the function in global scope.
				 *	@rtype: String
				 */
				
				local fnCallStatement = StringStream ""
				format "::%.fnPointer" globalInstanceName to:fnCallStatement
				
				seek fnCallStatement #eof
				
				if 0 == args.count and 0 == keywords.count then
				(
					format "()" to:fnCallStatement
				)
				else
				(
					for i=1 to args.count do
					(
						format " ::%.args[%]" globalInstanceName i to:fnCallStatement
					)
					
					for i=1 to keywords.count do
					(
						format " %:::%.keywords[%]" keywords[i].v1 globalInstanceName i to:fnCallStatement
					)
				)
				
				fnCallStatement as String
			)
		)
	),
	
	
	function _getListenerContent = 
	(
		/*
		 *	Returns the content of the listener
		 *	
		 *	@return: the completecontent of the listener
		 *	@rtype: String
		 */
		
		setListenerSel #(0, -1)
		getListenerSelText()
	),
	
	
	function _initAssertRaiseHelper fnPointer args keywords =
	(
		/*
		 *	Initiates an AssertRaiseHelper.
		 *	
		 *	@return: Returns the global instance of an AssertRaiseHelper object
		 *	@rtype: __AssertRaiseHelper__
		 */
		if not isStructDef "__AssertRaiseHelper__" then
			Assert2._createAssertRaiseStruct()
		
		global __asserRaiseHelperInst__ = __AssertRaiseHelper__ "__asserRaiseHelperInst__" fnPointer args keywords
	),
	
	
	function _createGlobalFnCallString fnPointer args keywords =
	(
		/*
		 *	Creates a callString which can be executed in global scope 
		 *	
		 *	@return: The global call string to execute the fn with its args and keywords.
		 *	@rtype: String
		 */
		
		local assertRaiseHelper = Assert2._initAssertRaiseHelper fnPointer args keywords
		assertRaiseHelper.createCallString()
	),
	
	
	function _isSciptedStructDefinitionHandlerException exceptionStr = 
	(
		/*
		 *	Tests if a string contains the signature of a exception raised during exception.
		 *
		 *	@param exceptionStr: the exception		 
		 *	@type exceptionStr: String
		 *	
		 *	@return: True if exceptionStr contains the pattern describing an exception during construction
		 *	@rtype: bool
		 */
		
		local pattern = "*MAXScript Scripted Struct Definition Handler Exception:*"
		matchPattern exceptionStr pattern:pattern
	),
	
	
	function _catchConstructorException fnCall =
	(
		/*
		 *	Catches an exception which is raised inside the constructor of a struct.
		 *	This is necessary, cause MAXScript has a bug, resulting in an popup, which prevents further script execution.
		 *
		 *	@param fnCall: the fnCall as string
		 *	@type fnCall: String
		 *	
		 *	@raises: any exception including MAXScript Scripted Struct Definition Handler Exception 
		 */
		
		clearListener()
		
		try
		(
			execute fnCall
		)
		catch
		(
			throw()
		)
		local listenerContent = Assert2._getListenerContent()
		
		if Assert2._isSciptedStructDefinitionHandlerException listenerContent then
		(
			throw listenerContent
		)
	),
	
	
	-- Assert Functions
	-------------------
	function assertTrue expr message:"" =
	(
		/*
		 *	Verifies that the expression is True.
		 *	
		 *	@param expr: the expression to test if true
		 *	@type expr: bool
		 *	
		 *	@keyword message: custom message displayed when assert fails
		 *	@type args: String
		 */
		
		clearListener()
		
		local assertState = assert expr showstack:true
		
		-- Assert failed, get stack
		if not assertState then
		(
			
			local exceptionStr = Assert2._getListenerContent()
			
			local fileLineInfo = Assert2._locateAssert exceptionStr
			
			local resultDescription = Assert2._formatResultDescription "Assert2.assertTrue" message expr "isn't" True fileLineInfo
			
			throw (resultDescription)
		)
	),
	
	
	function assertFalse expr message:"" =
	(
		/*
		 *	Verifies that the expression is False.
		 *	
		 *	@param expr: the expression to test if false
		 *	@type expr: bool
		 *	
		 *	@keyword message: custom message displayed when assert fails
		 *	@type args: String
		 */
		
		clearListener()
		
		local assertState = assert (not expr) showstack:true
		
		-- Assert failed, get stack
		if not assertState then
		(
			
			local exceptionStr = Assert2._getListenerContent()
			
			local fileLineInfo = Assert2._locateAssert exceptionStr
			
			local resultDescription = Assert2._formatResultDescription "Assert2.assertFalse" message expr "isn't" False fileLineInfo
			
			throw (resultDescription)
		)
	),
	
	
	function equals testVal expectedVal message:"" =
	(
		/**
		 *	Compares two values for equality and throws an exception if not equal.
		 *	If not equal the stack gets printed to the listener and copied and parsed
		 *	to locate the file and line, where the assert failed.
		 *
		 *	@param testVal: the value to be compared with the expected value
		 *	@type testVal: Value
		 *
		 *	@param expectedVal: the value which test value has to equal
		 *	@type expectedVal: Value
		 *
		 *	@keyword message: custom message displayed when assert fails
		 *	@type args: String
		 */
		
		clearListener()
		
		local assertState = assert (testVal == expectedVal) showstack:true
		
		-- Assert failed, get stack
		if not assertState then
		(
			
			local exceptionStr = Assert2._getListenerContent()
			
			local fileLineInfo = Assert2._locateAssert exceptionStr
			
			local resultDescription = Assert2._formatResultDescription "Assert2.equals" message testVal "!=" expectedVal fileLineInfo
			
			throw (resultDescription)
		)
	),
	
	
	function notEquals testVal expectedVal message:"" =
	(
		/*
		 *	Asserts that testVal equals expectedVal
		 *	
		 *	@param testVal: the value not to match the expected value
		 *	@type testVal: Value
		 *
		 *	@param expectedVal: the value to be expected not to equal test value
		 *	@type expectedVal: Value
		 *
		 *	@keyword message: custom message displayed when assert fails
		 *	@type args: String
		 */
		
		clearListener()
		
		local assertState = assert (testVal != expectedVal) showstack:true
		
		-- Assert failed, get stack
		if not assertState then
		(
			
			local exceptionStr = Assert2._getListenerContent()
			
			local fileLineInfo = Assert2._locateAssert exceptionStr
			
			local resultDescription = Assert2._formatResultDescription "Assert2.notEquals" message testVal "==" expectedVal fileLineInfo
			
			throw (resultDescription)
		)
	),
	
	
	function raises errorMsgPattern fnPointer args:#() keywords:#() message:"" =
	(
		/*
		 *	Checks if function run with certain parameters raises an exception with a certain string.
		 *
		 *	@param errorMsgPattern: the pattern of the error message, so the assert succeeds
		 *	@type errorMsgPattern: String
		 *
		 *	@param fnPointer: the function to be tested
		 *	@type fnPointer: MAXScriptFunction
		 *
		 *	@param args: the arguments for running the function
		 *	@type args: #(Value)
		 *
		 *	@keyword keywords: the keywords for running the function
		 *	@type keywords: #(DataPair(String, Value))
		 *
		 *	@keyword message: custom message displayed when assert fails
		 *	@type args: String
		 */
		
		local expectedExceptionRaised = false
		local exceptionStr = ""
		
		clearListener()
		
		try
		(
			local fnCallString = Assert2._createGlobalFnCallString fnPointer args keywords
			Assert2._catchConstructorException fnCallString
		)
		catch
		(
			exceptionStr = getCurrentException()
			if MatchPattern exceptionStr pattern:errorMsgPattern then
				expectedExceptionRaised = true
		)
		
		
		if not expectedExceptionRaised then
		(
			local exceptionStream = StringStream ""
			stack showLocals:True firstFrameOnly:false to:exceptionStream
			
			local fileLineInfo = Assert2._locateAssert (exceptionStream as String)
			
			local resultDescription = Assert2._formatResultDescription "Assert2.raises" message errorMsgPattern "pattern doesn't match" exceptionStr fileLineInfo   
			
			throw resultDescription
		)
	),
	
	
	function notRaises fnPointer args:#() keywords:#() message:"" =
	(
		/*
		 *	Checks if function run with certain parameters doesn't raise any exception.
		 *	@info: if no exception should be raised, make errorMsgPattern == ""
		 *	
		 *	@param fnPointer: the function to be tested
		 *	@type fnPointer: MAXScriptFunction
		 *
		 *	@keyword args: the arguments for running the function
		 *	@type args: #(Value)
		 *
		 *	@keyword keywords: the keywords for running the function
		 *	@type keywords: #(DataPair(String, Value))
		 *
		 *	@keyword message: custom message displayed when assert fails
		 *	@type args: String
		 */
		
		local exceptionRaised = false
		
		
		try
		(
			local fnCallString = Assert2._createGlobalFnCallString fnPointer args keywords
			execute fnCallString
		)
		catch
		(
			local exceptionStr = getCurrentException()
			exceptionRaised = true
		)
		
		
		if exceptionRaised then
		(
			local exceptionStream = StringStream ""
			stack showLocals:True firstFrameOnly:false to:exceptionStream
			
			local fileLineInfo = Assert2._locateAssert (exceptionStream as String)
			
			local resultDescription = Assert2._formatResultDescription "Assert2.notRaises" message "Exception was raised" ">>" exceptionStr fileLineInfo
			
			throw (resultDescription)
		)
	)
)

