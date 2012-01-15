/*
MaxScriptManager install/uninstall functions - V.1.0
*/

---------------------------------------------------------------------------------------------------
-- Place this function in your "install" script.
--Example:
--MaxScriptManager_install "GoMax" "264506456" "http://www.norman3d.com/repo.msr" "2.2"
---------------------------------------------------------------------------------------------------
fn MaxScriptManager_install theName theID theRepo theVersion =
(
	--First we create the Folder structure
	makedir "$userscripts\\MaxScriptManager\\INI_Auto\\"
	
	--Let's check if there is a INI file already there with the same ID and Repository URL
	found_theFile = false
	for f in getFiles "$userscripts\\MaxScriptManager\\INI_Auto\\*.ini" do
	(
		f_ID = getINIsetting f "Script" "ID"
		f_theRepo = getINIsetting f "Script" "Repo"
		--Yes, we found a script with the same ID and Repository URL
		if f_ID == theID AND f_theRepo == theRepo do
		(
			--Let's update the Version
			found_theFile = true
			setINIsetting f "Script" "LocalVersion" theVersion
		)
	)
	
	--If we did not find the INI file, let's create it
	if found_theFile == false do
	(
		setINIsetting ("$userscripts\\MaxScriptManager\\INI_Auto\\" + theName + "_" + theID + ".ini") "Script" "Repo" theRepo
		setINIsetting ("$userscripts\\MaxScriptManager\\INI_Auto\\" + theName + "_" + theID + ".ini") "Script" "ID" theID
		setINIsetting ("$userscripts\\MaxScriptManager\\INI_Auto\\" + theName + "_" + theID + ".ini") "Script" "LocalVersion" theVersion
	)
	
	--Finally let's add the repository URL to the repository list.
	theRepoList = "$userscripts\\MaxScriptManager\\Repositories.ini"
	if doesFileExist theRepoList do 
	(
		itemCount = (getINIsetting theRepoList "Repositories" "Count") as integer
		--Is the Repo already in the list?
		is_repo_in_list = false
		for i=1 to itemCount do
		(
			f_repo = getINIsetting theRepoList "Repositories" ("Item_" + (i as string))
			if f_repo == theRepo do
			(
				--Yes it's already there, no need to add it
				is_repo_in_list = true
			)
		)
		is_repo_in_list == false do
		(
			setINIsetting theRepoList "Repositories" "Count" ((itemCount + 1) as string)
			setINIsetting theRepoList "Repositories" ("Item_" + ((itemCount + 1) as string)) theRepo
		)
	)
	
	--Refresh the MaxScriptManager Listview
	if doesFileExist "$userscripts\\MaxScriptManager\\MSM_Functions.ms" do 
	(
		if MaxScriptManager.open == true do
		(
			fill_lv_1()
		)
	)
)

---------------------------------------------------------------------------------------------------
-- Place this function in your "install" script.
--Example:
--MaxScriptManager_uninstall "264506456" "http://www.norman3d.com/repo.msr"
---------------------------------------------------------------------------------------------------
fn MaxScriptManager_uninstall theID theRepo =
(
	--Let's check if there is a INI file already there with the same ID and Repository URL
	for f in getFiles "$userscripts\\MaxScriptManager\\INI_Auto\\*.ini" do
	(
		f_ID = getINIsetting f "Script" "ID"
		f_theRepo = getINIsetting f "Script" "Repo"

		if f_ID == theID AND f_theRepo == theRepo do
		(
			--Yes, we found a script with the same ID and Repository URL
			--Just delete it
			deleteFile f
		)
	)
)