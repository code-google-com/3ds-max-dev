rollout QualityNormalsRollout "Quality Normals Toggler for Max 2011 and up"
(
	label lbl_QN "Quality Normals Disabled" pos:[8,8] width:144 height:16 enabled:false
	button btn_Enable "Enable Quality Normals" pos:[8,32] width:144 height:32
	
	local QN_ison = false
	
	on QualityNormalsRollout open do
	(
		local Programversion = maxversion()
		
		if Programversion[1] < 13000 then
		(
			messagebox("This is not Max 2011 or higher, script won't do anything here")
		)
		
		local iniDir = getMAXIniFile() 
		
		local QN_type = GetINISetting iniDir "ViewportNormalMapping" "ViewportNormalMappingType"
		messagebox("current ini state: " + QN_Type)
		if QN_type as string == "Legacy" then
		(
		)
		else if QN_type as string == "Qualified" then
		(
			lbl_QN.enabled = true
			lbl_QN.caption = "Quality Normals Enabled"
			btn_Enable.caption = "Disable Quality Normals"
			QN_ison = true
		)
	)	
	
	on btn_Enable pressed do
	(		
		
		local iniDir = getMAXIniFile() 
		
		if QN_ison == false then
		(
			setINISetting iniDir "ViewportNormalMapping" "ViewportNormalMappingType" "Qualified"
			lbl_QN.enabled = true
			lbl_QN.caption = "Quality Normals Enabled"
			btn_Enable.caption = "Disable Quality Normals"
			QN_ison = true
			messagebox("Quality normals enabled!\n Please restart 3DS Max for changes to take effect")
		)
		else if QN_ison then
		(
			setINISetting iniDir "ViewportNormalMapping" "ViewportNormalMappingType" "Legacy"
			lbl_QN.enabled = false
			lbl_QN.caption = "Quality Normals Disabled"
			btn_Enable.caption = "Enable Quality Normals"
			QN_ison = false
			messagebox("Quality normals Disabled!\n Please restart 3DS Max for changes to take effect")
		)
		
	)
	
)

createDialog QualityNormalsRollout 160 72