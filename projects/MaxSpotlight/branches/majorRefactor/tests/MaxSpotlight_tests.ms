maxtestDir = @"C:\_dev\maxtest\trunk\"
	
fileIn (maxtestDir + @"assert.ms")
fileIn (maxtestDir + @"finder.ms")
fileIn (maxtestDir + @"runner.ms")
fileIn (maxtestDir + @"presenter.ms")


(

	local currentScriptDir = getFilenamePath (getSourceFileName())
	
	-- gather different finders
	local finders = #()
 	append finders (DirCrawler currentScriptDir "*test_*.ms")
	append finders (DirCrawler currentScriptDir "*integrationtest_*.ms" "Integrationtest")

	
	-- run all finders
	local tests = #()
	for finderOn in finders do tests += finderOn.getTests()

	
	-- execute runner
	local testRunner = Runner tests
	local results = testRunner.getResults()	
	
	
	-- display results
	local presenter = PresenterListener results
	presenter.show()
)