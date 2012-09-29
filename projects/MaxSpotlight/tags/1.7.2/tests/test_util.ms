(
	local currentScriptDir = getFilenamePath (getSourceFileName())
	local SelectAndLogUtil = fileIn (currentScriptDir + @"..\util.ms")
	
	
	local TestHelper = fileIn @"testhelper.ms"
	local testHelper = TestHelper()

	
	local AssertHelper
	struct AssertHelper
	(
		public
		function assertListenerText expectedText =
		(
			local listenerText = testHelper.getListenerText()
			assert2.equals listenerText expectedText
		),
		
		
		private
		function assertlogNumNodesText mode num =
		(
			local expectedText  = StringStream ""
			format "<MaxSpotlight> %: % node(s)\n" mode num to:expectedText
			
			assertListenerText (expectedText as String)
		),
		
		
		public
		function assertlogSelectedNumNodesText num =
		(
			assertLogNumNodesText "Selected" num
		),
		
		
		public
		function assertlogFoundNumNodesText num =
		(
			assertLogNumNodesText "Found" num
		),
		
		
		public
		function assertArray assertedArray expectedArray =
		(
			assert2.equals assertedArray.count expectedArray.count
			
			for i=1 to expectedArray.count do
				assert2.assertTrue (findItem assertedArray expectedArray[i] != 0)
		),
		
		
		public
		function assertSelection expectedNodes =
		(
			assertArray (selection as Array) expectedNodes
		)
	)
	
	local assertHelper = AssertHelper()
	
	
	global TestSelectAndLogUtilLogging
	struct TestSelectAndLogUtilLogging
	(
		/*
			Tests the logging functionality of SelectAndLogUtil
		 */
		
		_util,
		
		
		function setUp =
		(
			_util = SelectAndLogUtil()
			clearListener()
		),
		
		
		function test_logNodeNames_noNodes =
		(
			local nodeNames = #()
			local lineLimit = 1
			_util.logNodeNames nodeNames lineLimit
			
			assertHelper.assertListenerText ""
		),
		
		
		function test_logNodeNames_oneNodeInLimit =
		(
			local nodeNames = #("abc")
			local lineLimit = 1
			_util.logNodeNames nodeNames lineLimit
			
			assertHelper.assertListenerText "<MaxSpotlight> abc\n\n"
		),
		
		
		function test_logNodeNames_twoNodesOutOfLimit =
		(
			local nodeNames = #("abc", "def")
			local lineLimit = 1
			_util.logNodeNames nodeNames lineLimit
			
			local expectedText = 
				"<MaxSpotlight> abc\n\n" +
				"<MaxSpotlight> ... (Reached line limit(1). Other nodes are ommitted.)\n\n"
			assertHelper.assertListenerText expectedText
		),
		
		
		function test_logNodeNames_twoNodesNoLimit =
		(
			local nodeNames = #("abc", "def")
			local lineLimit = 0
			_util.logNodeNames nodeNames lineLimit
			
			local expectedText = 
				"<MaxSpotlight> abc\n" +
				"<MaxSpotlight> def\n\n"
			assertHelper.assertListenerText expectedText
		),
		
		
		function test_logSelectedNumNodes_zero =
		(
			_util.logSelectedNumNodes 0
			assertHelper.assertlogSelectedNumNodesText 0
		),
		
		
		function test_logSelectedNumNodes_one =
		(
			_util.logSelectedNumNodes 1
			assertHelper.assertlogSelectedNumNodesText 1
		),
		
		
		function test_logSelectedNumNodes_negative =
		(
			_util.logSelectedNumNodes -1
			assertHelper.assertlogSelectedNumNodesText -1
		),
		
		
		function test_logFoundNumNodes_zero =
		(
			_util.logFoundNumNodes 0
			assertHelper.assertlogFoundNumNodesText 0
		),
		
		
		function test_logFoundNumNodes_one =
		(
			_util.logFoundNumNodes 1
			assertHelper.assertlogFoundNumNodesText 1
		),
		
		
		function test_logFoundNumNodes_negative =
		(
			_util.logFoundNumNodes -1
			assertHelper.assertlogFoundNumNodesText -1
		)
	)
	
	
	global TestSelectAndLogUtilSelecting
	struct TestSelectAndLogUtilSelecting
	(
		_util,
		_node,
		
		
		function setUp =
		(
			resetMAXFile #noPrompt
			_util = SelectAndLogUtil()
			_node = Sphere name:"abc"
		),
		
		
		function test_getNodeNamesWithExactOrPatternMatch_noNodes =
		(
			local nodeNames =_util.getNodeNamesWithExactOrPatternMatch "nodeNotExist"
			assert2.equals nodeNames.count 0
		),
		
		
		function test_getNodeNamesWithExactOrPatternMatch_oneNodeExactMatch =
		(
			local nodeNames =_util.getNodeNamesWithExactOrPatternMatch "abc"
			assertHelper.assertArray nodeNames #(_node.name)
		),
		
		
		function test_getNodeNamesWithExactOrPatternMatch_oneNodeExactMatchPlusWildcard_regression =
		(
			local nodeNames =_util.getNodeNamesWithExactOrPatternMatch "abc*"
			assertHelper.assertArray nodeNames #(_node.name)
		),
		
		
		function test_getNodeNamesWithExactOrPatternMatch_fullNameAndLeadingAndTrailingWildcard =
		(
			local nodeNames =_util.getNodeNamesWithExactOrPatternMatch "*abc*"
			assertHelper.assertArray nodeNames #(_node.name)
		),
		
		
		function test_getNodeNamesWithExactOrPatternMatch_twoNodesWithSameNameExactMatch =
		(
			Sphere name:"abc"
			local nodeNames =_util.getNodeNamesWithExactOrPatternMatch "abc"
			assertHelper.assertArray nodeNames #(_node.name, _node.name)
		),
		
		
		function test_getNodeNamesWithExactOrPatternMatch_oneNodePatternMatch =
		(
			local nodeNames =_util.getNodeNamesWithExactOrPatternMatch "b"
			assertHelper.assertArray nodeNames #(_node.name)
		),
		
		
		function test_getNodeNamesWithExactOrPatternMatch_oneNodeNestedStarPatternMatch =
		(
			local nodeNames =_util.getNodeNamesWithExactOrPatternMatch "a*c"
			assertHelper.assertArray nodeNames #(_node.name)
		),
		
		
		function test_getNodeNamesWithExactOrPatternMatch_oneNodeSingleStarPatternMatch =
		(
			local nodeNames =_util.getNodeNamesWithExactOrPatternMatch "*"
			assertHelper.assertArray nodeNames #(_node.name)
		),
		
		
		function test_selectNodes_noNodes =
		(
			local nodes =_util.selectNodes "nodeNotExist"
			assert2.equals nodes.count 0
		),
		
		
		function test_selectNodes_oneNodeExactMatch =
		(
			local nodes =_util.selectNodes "abc"
			assertHelper.assertArray nodes #(_node)
			assertHelper.assertSelection nodes
		),
		
		
		function test_selectNodes_twoNodesWithSameNameExactMatch =
		(
			local nodeWithExistingName = Sphere name:"abc"
			local nodes =_util.selectNodes "abc"
			assertHelper.assertArray nodes #(_node, nodeWithExistingName)
			assertHelper.assertSelection nodes
		),
		
		
		function test_selectNodes_oneNodePatternMatch =
		(
			local nodes =_util.selectNodes "b"
			assertHelper.assertArray nodes #(_node)
		),
		
		
		function test_selectNodes_oneNodeNestedStarPatternMatch =
		(
			local nodes =_util.selectNodes "a*c"
			assertHelper.assertArray nodes #(_node)
		),
		
		
		function test_selectNodes_oneNodeSingleStarPatternMatch =
		(
			local nodes =_util.selectNodes "*"
			assertHelper.assertArray nodes #(_node)
		)
	)
	
	
	global TestSelectAndLogUtilBoth
	struct TestSelectAndLogUtilBoth
	(
		_util,
		_node,
		
		
		function setUp =
		(
			resetMAXFile #noPrompt
			_util = SelectAndLogUtil()
			_node = Sphere name:"abc"
			clearListener()
		),
		
		
		function test_selectNodesAndLog_noNodes =
		(
			_util.selectNodesAndLog "nodeNotExist"
			
			assertHelper.assertlogSelectedNumNodesText 0
			assert2.equals selection.count 0
		),
		
		
		function test_selectNodesAndLog_oneNode =
		(
			_util.selectNodesAndLog "abc"
			
			assertHelper.assertlogSelectedNumNodesText 1
			assertHelper.assertSelection #(_node)
		),
		
		
		function test_selectNodesAndLog_twoNodesWithSameNameExactMatch =
		(
			local nodeWithExistingName = Sphere name:"abc"
			_util.selectNodesAndLog "abc"
			
			assertHelper.assertlogSelectedNumNodesText 2
			assertHelper.assertSelection #(_node, nodeWithExistingName)
		),
		
		
		function test_selectNodesAndLog_oneNodePatternMatch =
		(
			_util.selectNodesAndLog "b"
			
			assertHelper.assertlogSelectedNumNodesText 1
			assertHelper.assertSelection #(_node)
		),
		
		
		function test_selectNodesAndLog_oneNodeNestedStarPatternMatch =
		(
			_util.selectNodesAndLog "a*c"
			
			assertHelper.assertlogSelectedNumNodesText 1
			assertHelper.assertSelection #(_node)
		),
		
		
		function test_selectNodesAndLog_oneNodeSingleStarPatternMatch =
		(
			_util.selectNodesAndLog "*"
			
			assertHelper.assertlogSelectedNumNodesText 1
			assertHelper.assertSelection #(_node)
		)
	)
)