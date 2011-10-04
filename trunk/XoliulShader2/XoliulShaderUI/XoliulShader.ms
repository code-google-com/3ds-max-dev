/*
	XoliulShader 2 Installer
	------------------------------
	Version : Release 1.0
	Developed By : Robbert-Jan Brems en Laurens Corijn
	Info:  www.nysuatro.com and http://www.laurenscorijn.com/
	Description: UI design for controlling the Xoliul Shader with good usability and extra functionality.
	Year : 2011
	-------------------------------
	
	Bij de boulder preset doet em raar bij de light select dropdownlist
	En hij update de lighttoggles niet altijd
	Ook de shadowknop niet
	Bij material presets zet em de afbeelding nog niet direct aan.
*/

try
(
	g_CallbackItem = undefined
	gc light:true
)
catch()

(--Start Project
	
	/* ==================================================================================================================GLOBALS*/
	
	global b_IsMax2009
	
	--CallbackEvent var
	local g_CallbackItem = undefined
	
	local ShaderReset = false
	
	global Presets
	local m_QuickLoad
	
	--Promptwindow rollout
	local PromptWindow
	local rollout_ImagePreview
	
	/* ==================================================================================================================FUNCTIONS*/
	
	function ConvertStringToColor pString=
	(
		local tempOutput = pString as string
		tempOutput = filterstring tempOutput "(color )"
		tempOutput = color (tempOutput[1] as float) (tempOutput[2] as float) (tempOutput[3] as float)
		return tempOutput
	)
	
	function ConvertStringToPoint pString=
	(
		local tempOutput = pString as string
		tempOutput = filterstring tempOutput "[,]"
		tempOutput = Point3 (tempOutput[1] as float) (tempOutput[2] as float) (tempOutput[3] as float)
		return tempOutput
	)
	
	--Callbackfunction for checking new lights and adding them to the rollouts
	function UpdateLights ev nd =
	(
-- 		local tempSlot = medit.GetActiveMtlSlot()

-- 		medit.SetActiveMtlSlot (tempSlot+1) false
-- 		medit.SetActiveMtlSlot tempSlot false
		try(
		Presets.m_RefRolloutLighting.UpdateLightLists()
		)
		catch()
	)
	
	/* ==================================================================================================================ROLLOUTS*/

	rollout PromptWindow "Create Preset" width:280 height:80
	(
		button btn_Create "Create" pos:[56,48] width:72 height:26
		button btnCancel "Cancel" pos:[136,50] width:72 height:24
		editText edt_PresetName "" pos:[32,16] fieldWidth:200
		
		local r_Ouput = ""
		
		function Init =
		(
			edt_PresetName.text = r_Ouput
		)--End Function Init
		
		function Destroy=
		(
			r_Ouput = undefined
			destroydialog PromptWindow
		)--End Function Destroy
		
		function CreatePreset=
		(
			r_Ouput = edt_PresetName.text
			if r_Ouput != "" then
			(
				if Presets.m_TypePrompt == "light" then Presets.AddLightPreset r_Ouput
				if Presets.m_TypePrompt == "material" then Presets.AddMaterialPreset r_Ouput
			)
			else
				messagebox "Please insert a name for the preset."
			Destroy()
		)--End Function CreatePreset
		
		on PromptWindow open  do Init()
		on PromptWindow close  do Destroy()
		on btn_Create pressed  do CreatePreset()
		on btnCancel pressed  do Destroy()
		on edt_PresetName entered txt do CreatePreset()
	)--End rollout PromptWindow
	
	rollout rollout_Quickload "Quickload Setup" width:160 height:198
	(
		button btn_Save "Save" pos:[12,166] width:64 height:24
		button btn_Cancel "Cancel" pos:[84,166] width:64 height:24
		editText edt_Diffuse "" pos:[69,32] width:80 height:17
		editText edt_Specular "" pos:[69,54] width:80 height:17
		editText edt_Glossiness "" pos:[69,76] width:80 height:17
		editText edt_Normal "" pos:[69,98] width:80 height:17
		editText edt_SelfIllum "" pos:[69,120] width:80 height:17
		editText edt_Reflect "" pos:[69,142] width:80 height:17
		label lbl_Diffuse "Diffuse" pos:[13,34] width:56 height:17
		label lbl_Specular "Specular" pos:[13,56] width:56 height:17
		label lbl_Glossiness "Glossiness" pos:[13,78] width:56 height:17
		label lbl_Normal "Normal" pos:[13,100] width:56 height:17
		label lbl_SelfIllum "Self Illum." pos:[13,122] width:56 height:17
		label lbl_Reflect "Reflect" pos:[13,144] width:56 height:17
		
		function Init=
		(
			edt_Diffuse.text = m_QuickLoad.m_MapNameData_Diffuse
			edt_Specular.text = m_QuickLoad.m_MapNameData_Specular
			edt_Glossiness.text = m_QuickLoad.m_MapNameData_Glossiness
			edt_Normal.text = m_QuickLoad.m_MapNameData_Normal
			edt_SelfIllum.text = m_QuickLoad.m_MapNameData_SelfIllum
			edt_Reflect.text = m_QuickLoad.m_MapNameData_Reflect
		)
		
		function Destroy=
		(
			m_QuickLoad.m_MapNameData_Diffuse = edt_Diffuse.text
			m_QuickLoad.m_MapNameData_Specular = edt_Specular.text
			m_QuickLoad.m_MapNameData_Glossiness = edt_Glossiness.text
			m_QuickLoad.m_MapNameData_Normal = edt_Normal.text
			m_QuickLoad.m_MapNameData_SelfIllum = edt_SelfIllum.text
			m_QuickLoad.m_MapNameData_Reflect = edt_Reflect.text
		)
		
		on btn_Save pressed do
		(
			Destroy()
			m_QuickLoad.SaveQuickloadSettings()
		)
		on btn_Cancel pressed do m_QuickLoad.DestroyRollout_Quickload()
		on rollout_Quickload open do Init()
		on rollout_Quickload close do Destroy()
	)--End Rollout
	
	rollout rollout_ImagePreview "Image Preview" width:512 height:512
	(
		imgtag img_Preview "system.windows.forms.picturebox" pos:[0,0] width:512 height:512 toolTip:"Here will come the filename"
		
		function Init pFilePath=
		(
			createdialog rollout_ImagePreview
			img_Preview.bitmap = openBitMap (*pFilePath)
			img_Preview.tooltip = img_Preview.bitmap.filename
		)
		
		on img_Preview click do destroydialog rollout_ImagePreview
	)--End Rollout rollout_ImagePreview
	
	/* ==================================================================================================================PLUGINS*/

	plugin material UI_Xoliulshader
		name:"Xoliul Shader"
		classID:#(0x173e90af, 0x141b318a)
		extends:DirectX_9_Shader replaceUI:true version:1
	(			
		/* ==================================================================================================================PLUGIN VARIABLES*/
		
		local helpFileLocation = scriptsPath + "XoliulShaderUI\\XS2help.chm"

		local CountLights = 0
		local b_EnableDC_Diffuse = false
		local b_EnableDC_Specular = false
		local b_EnableDC_Glossiness = false
		local b_EnableDC_Normal = false
		local b_EnableDC_SelfIllum= false
		local b_EnableDC_Reflect= false
		local b_EnableDC_Cubemap= false
		local b_EnableDC_Gradient= false
		
		local b_Toggle_Diffuse = false
		local b_Toggle_Specular = false
		local b_Toggle_Glossiness = false
		local b_Toggle_SelfIllumination = false
		local b_Toggle_Normal = false
		local b_Toggle_ReflectMap = false
		local b_Toggle_Cubemap = false
		local b_Toggle_Gradient = false
		
		local btn_LightOne -- Because default value is on // We need the plugin to know this UI from the beginning
		
		local tempImageClass = dotnetclass "System.Drawing.Image"
		local bm_Header_Cubemap = tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_Cubemap.png")
		local bm_HeaderMaps = tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_Shader.png")
		local bm_Header_Diffuse = tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_Diffuse.png")
		local bm_Header_Specular = tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_Specular.png")
		local bm_Header_Glossiness= tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_Glossiness.png")
		local bm_Header_Normal = tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_Normal.png")
		local bm_Header_SelfIllum = tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_SelfIllum.png")
		local bm_Header_Reflect = tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_Reflect.png")
		local bm_Header_Gradient = tempImageClass.FromFile (scriptsPath + "XoliulShaderUI\\images\\header_Gradient.png")

		local bm_Filename = (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")
		local bm = tempImageClass.FromFile bm_Filename
		local bm_Diffuse = bm
		local bm_Specular = bm
		local bm_Glossiness = bm
		local bm_Normal = bm
		local bm_SelfIllum = bm
		local bm_Cubemap = bm
		local bm_Gradient = bm
		local bm_ReflectMap = bm
		
		local filePath_Diffuse = undefined
		local filePath_Specular = undefined
		local filePath_Glossiness = undefined
		local filePath_Normal = undefined
		local filePath_SelfIllum = undefined
		local filePath_Cubemap = undefined
		local filePath_Gradient = undefined
		local filePath_ReflectMap = undefined
		
		local bm_OnOff_Diffuse = DataPair undefined undefined
		local bm_OnOff_Specular = DataPair undefined undefined
		local bm_OnOff_Glossiness = DataPair undefined undefined
		local bm_OnOff_SelfIllum = DataPair undefined undefined
		local bm_OnOff_Normal = DataPair undefined undefined
		local bm_OnOff_Gradient = DataPair undefined undefined
		local bm_OnOff_Cubemap = DataPair undefined undefined
		local bm_OnOff_Reflectmap = DataPair undefined undefined
		
		local iSelectionPresetsLight = 1
		local iSelectionPresetsMaterial = 1
		
		local i_ShadowTerm = 0
		
		local b_CleanState = false
		
		--Reference to the rollouts
		local rollout_Presets
		local rollout_Lighting
		local rollout_Maps
		local rollout_Techniques
		
		--Forward declaration functions
		local CreateOffImage
		local CreateOnImage
		
		/* ==================================================================================================================STRUCTS*/

		struct Quickload
		(
			m_MainMapsFolders = undefined,
			m_FilepathIniFile = undefined,
			
			m_MapNameData_Diffuse = undefined,
			m_MapNameData_Specular = undefined,
			m_MapNameData_Glossiness = undefined,
			m_MapNameData_Normal = undefined,
			m_MapNameData_SelfIllum = undefined,
			m_MapNameData_Reflect = undefined,
			
			fn DestroyRollout_Quickload=(),
			
			function SaveQuickloadSettings=
			(			
				--Then we save out the data to the initfile
				setINISetting m_FilepathIniFile "SetupQuickload" "DataDif" (m_MapNameData_Diffuse as string)
				setINISetting m_FilepathIniFile "SetupQuickload" "DataSpec" (m_MapNameData_Specular as string)
				setINISetting m_FilepathIniFile "SetupQuickload" "DataGloss" (m_MapNameData_Glossiness as string)
				setINISetting m_FilepathIniFile "SetupQuickload" "DataNorm" (m_MapNameData_Normal as string)
				setINISetting m_FilepathIniFile "SetupQuickload" "DataSelfIl" (m_MapNameData_SelfIllum as string)
				setINISetting m_FilepathIniFile "SetupQuickload" "DataReflect" (m_MapNameData_Reflect as string)
				
				DestroyRollout_Quickload()
			),
			
			function RunQuickload=
			(
				--Open a browse dialog to get the folder with all the images in
				m_MainMapsFolders = getSavePath caption:"Select the folder with al the images."
				
				if m_MainMapsFolders != undefined then
				(
					--Get all the files in this filder en loop throught it
					local tempFiles = getFiles (m_MainMapsFolders + "\\*")
					for item in tempFiles where getFilenameType item == ".jpg" or getFilenameType item == ".tga" or getFilenameType item == ".dds" or getFilenameType item == ".bmp" or getFilenameType item == ".psd"  do
					(
						if (findstring (getFilenameFile item) m_MapNameData_Diffuse ) != undefined then
						(
							filePath_Diffuse = item
							delegate.bUseDiffuseMap = true
						)
						if (findstring (getFilenameFile item) m_MapNameData_Specular) != undefined  then
						(
							filePath_Specular = item
							delegate.bUseSpecMap = true
						)
						if (findstring (getFilenameFile item) m_MapNameData_Glossiness) != undefined  then
						(		
							filePath_Glossiness = item
							delegate.bUseGlossMap = true
						)
						if (findstring (getFilenameFile item) m_MapNameData_Normal) != undefined  then
						(					
							filePath_Normal = item
							delegate.bUseNormalMap = true
						)
						if (findstring (getFilenameFile item) m_MapNameData_SelfIllum) != undefined  then
						(
							filePath_SelfIllum = item
							delegate.bUseSIMap = true
						)
						if (findstring (getFilenameFile item) m_MapNameData_Reflect) != undefined  then
						(				
							filePath_ReflectMap = item
							delegate.bUseReflMap = true
						)
					)--End for
				)--End if
				
				--We now must load ing all the new images in the map slots
				Presets.ApplyMaterialsMaps()
-- 				UpdateLights undefined undefined
				Presets.m_RefRolloutMaterials.Open_Rollout_Maps()
			),
			
			function BrowseQuickload=
			(
				if m_MainMapsFolders != undefined then shellLaunch "explorer.exe" m_MainMapsFolders
					else messagebox "No folder to browse to"
			),
				
			function SetupQuickload=
			(
				createdialog rollout_Quickload
			),
			
			function DestroyRollout_Quickload=
			(
				destroydialog rollout_Quickload
			),
			
			function Init=
			(
				--Declare the filepath of the inifile to save out the data for the quickload setup
				m_FilepathIniFile = scriptspath + "XoliulShaderUI\\SettingsQuickload.ini"
				
				m_MainMapsFolders = maxFilePath
				
				--Defined the prefixes and postfixes
				m_MapNameData_Diffuse = getInisetting m_FilepathIniFile "SetupQuickload" "DataDif"
				m_MapNameData_Specular = getInisetting m_FilepathIniFile "SetupQuickload" "DataSpec"
				m_MapNameData_Glossiness = getInisetting m_FilepathIniFile "SetupQuickload" "DataGloss"
				m_MapNameData_Normal = getInisetting m_FilepathIniFile "SetupQuickload" "DataNorm"
				m_MapNameData_SelfIllum = getInisetting m_FilepathIniFile "SetupQuickload" "DataSelfIl"
				m_MapNameData_Reflect = getInisetting m_FilepathIniFile "SetupQuickload" "DataReflect"
				m_PostfixOrPrefix = getInisetting m_FilepathIniFile "SetupQuickload" "DataChoicePostOrPre"
			)
		)--End Struct
		
		struct MainPresets
		(
			m_MaxRootKEY = "[x_maxroot_x]",
			m_CurrentMaxRoot = GetDir #maxroot,
			m_RelativePath = undefined,
			m_AbsolutePath = undefined,
			m_MainPath = scriptspath + "XoliulShaderUI\\",
			m_PrefixLight = "PrLight_",
			m_PrefixMaterial = "PrMaterial_",
			m_FolderNameLightPresets = "Presets_Light\\",
			m_FolderNameMaterialPresets = "Presets_Shader\\",
			m_ArrLightPresets = #(),
			m_ArrMaterialPresets = #(),
			m_RefDroplistLights = undefined,
			m_RefDroplistMaterials = undefined,
			m_TypePrompt = undefined,
			m_RefRolloutPresets = undefined,
			m_RefRolloutLighting = undefined,
			m_RefRolloutMaterials = undefined,
			m_RefRolloutTechniques = undefined,
			
			--Here we assign the UI dropdownlists to the struct for later reference
			function Init pRefLightsDdl pRefMaterialsDdl pRefPresets pRefLighting pRefMaterials pRefTechniques=
			(
				m_RefDroplistLights = *pRefLightsDdl
				m_RefDroplistMaterials = *pRefMaterialsDdl
				m_RefRolloutPresets = *pRefPresets
				m_RefRolloutLighting = *pRefLighting
				m_RefRolloutMaterials = *pRefMaterials
				m_RefRolloutTechniques = *pRefTechniques
			),
			
			function UpdateUI=
			(
				try
				(
					m_RefDroplistLights.items = m_ArrLightPresets
					m_RefDroplistMaterials.items = m_ArrMaterialPresets
					m_RefRolloutPresets.CheckStateUI()
				)
				catch
					messagebox "Can not update the UI for presets!"
			),--End function UpdateUI
			
			--Look at how much presets files there are for light and load them into the UI
			function LoadPresets pType=
			(
				--Collect all the init files from the specific presetsfolder
				local tempFolderName = undefined
				local tempArrayPresets = undefined
				local tempDll = undefined
				
				if pType == "light" then 
				(
					tempFolderName = m_FolderNameLightPresets
					tempArrayPresets = &m_ArrLightPresets
					tempDll = &m_RefDroplistLights
				)
				if pType == "material" then
				(
					tempFolderName = m_FolderNameMaterialPresets
					tempArrayPresets = &m_ArrMaterialPresets
					tempDll = &m_RefDroplistMaterials
				)
				
				local tempFolderPathName = m_MainPath + tempFolderName
				
				try
				(
					*tempArrayPresets = #()--clear array before appending
					local tempFiles = getfiles (tempFolderPathName + "*.ini")
					for initFile in tempFiles do
						append (*tempArrayPresets) (getFilenameFile initFile)
					
				)--End Try
				catch
				(
					messagebox "Could not load the presetfiles"
				)
				
				--Update the UI
				UpdateUI()
			),--End function LoadPresets
			
			function AddPreset pType=
			(
				try
				(
					m_TypePrompt = pType
					createdialog PromptWindow
				)
				catch
					messagebox "Can not create new Preset"
			),--End Function Addpreset
			
			function RemovePreset pType=
			(
				local tempName = "Undefined"
				local tempFolderName = "Undefined"
				try
				(
					if pType == "light" then
					(
						tempName = m_RefDroplistLights.selected
						tempFolderName = &m_FolderNameLightPresets
					)
					if pType == "material" then
					(
						tempName = m_RefDroplistMaterials.selected
						tempFolderName = &m_FolderNameMaterialPresets
					)
					
					local tempPath = m_MainPath + *tempFolderName + tempName + ".ini"
					deleteFile tempPath
					
					if pType == "light" then
					(
						deleteItem m_ArrLightPresets m_RefDroplistLights.selection
-- 						m_RefDroplistLights.selection = 1
					)
					if pType == "material" then
					(
						deleteItem m_ArrMaterialPresets m_RefDroplistMaterials.selection
-- 						m_RefDroplistMaterials.selection = 1
					)
				)
				catch
					messagebox ("The preset called: " + tempName + " can not be removed")
					
				UpdateUI()
			),
			
			function RelativeMaxPath filepath adjustedpath=
			(
				*adjustedpath = (substituteString filepath m_CurrentMaxRoot m_MaxRootKEY) as string
			),
			
			function AbsoluteMaxPath presetpath adjustedpath=
			(
				*adjustedpath = (substituteString (presetpath as string) m_MaxRootKEY m_CurrentMaxRoot) 
			),

			--Making and saving a init file for the current light properties
			function AddLightPreset pName=
			(
				--first we create the filepath for the new file
				local tempPath = m_MainPath + m_FolderNameLightPresets + pName + ".ini"
				
				--Here we save out all the different properties of the shader for the light settings
				setINISetting  tempPath pName "spn_Gamma" (m_RefRolloutLighting.spn_Gamma.value as string)
				setINISetting  tempPath pName "ddl_shadowType" (m_RefRolloutLighting.ddl_shadowType.selection as string)
				setINISetting  tempPath pName "spn_ShadowIntensity" (m_RefRolloutLighting.spn_ShadowIntensity.value as string)
				setINISetting  tempPath pName "spn_ShadowQuality" (m_RefRolloutLighting.spn_ShadowQuality.value as string)
				setINISetting  tempPath pName "spn_ShadedHudeAdjustment" (m_RefRolloutLighting.spn_ShadedHudeAdjustment.value as string)
				setINISetting  tempPath pName "spn_HalflambertPower" (m_RefRolloutLighting.spn_HalflambertPower.value as string)
				setINISetting  tempPath pName "spn_EnvCubeBlur" (m_RefRolloutLighting.spn_EnvCubeBlur.value as string)
				setINISetting  tempPath pName "spn_EnvCubeStrength" (m_RefRolloutLighting.spn_EnvCubeStrength.value as string)
				setINISetting  tempPath pName "ddl_Light1Pos" (m_RefRolloutLighting.ddl_Light1Pos.selection as string)
				setINISetting  tempPath pName "ddl_Light2Pos" (m_RefRolloutLighting.ddl_Light2Pos.selection as string)
				setINISetting  tempPath pName "ddl_Light3Pos" (m_RefRolloutLighting.ddl_Light3Pos.selection as string)
				setINISetting  tempPath pName "btn_LightOne" (m_RefRolloutLighting.btn_LightOne.state  as string)
				setINISetting  tempPath pName "btn_LightTwo" (m_RefRolloutLighting.btn_LightTwo.state as string)
				setINISetting  tempPath pName "btn_LightThree" (m_RefRolloutLighting.btn_LightThree.state as string)
				setINISetting  tempPath pName "btn_Shadow1" (m_RefRolloutLighting.btn_Shadow1.state as string)
				setINISetting  tempPath pName "btn_Shadow2" (m_RefRolloutLighting.btn_Shadow2.state as string)
				setINISetting  tempPath pName "btn_Shadow3" (m_RefRolloutLighting.btn_Shadow3.state as string)
				setINISetting  tempPath pName "chk_HalfLambertShading" (m_RefRolloutLighting.chk_HalfLambertShading.state  as string)
				setINISetting  tempPath pName "cp_AmbientColor" (m_RefRolloutLighting.cp_AmbientColor.color as string)
				setINISetting  tempPath pName "sld_EnvRotation" (m_RefRolloutLighting.sld_EnvRotation.value as string)
				setINISetting  tempPath pName "spn_CubeGamma" (m_RefRolloutLighting.spn_CubeGamma.value as string)
				--Saving the images of the Env Cubemap
				if(m_RefRolloutLighting.btn_Reload_IBLCubemap.tooltip != (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")) then
				(
					RelativeMaxPath (m_RefRolloutLighting.btn_Reload_IBLCubemap.tooltip as string) &m_RelativePath
					setINISetting  tempPath pName "EnvCubemap" m_RelativePath
				)
				if(m_RefRolloutLighting.btn_Reload_Gradient.tooltip != (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")) then
				(
					RelativeMaxPath (m_RefRolloutLighting.btn_Reload_Gradient.tooltip as string) &m_RelativePath
					setINISetting  tempPath pName "gradientMap" m_RelativePath
				)
				--Reset Tooltips
				m_RefRolloutLighting.btn_Reload_IBLCubemap.tooltip = ""
				m_RefRolloutLighting.btn_Reload_Gradient.tooltip = ""

				
				local tempLights = (lights as array)
				local tempAmountFfLights = tempLights.count
				setINISetting  tempPath pName "AmountOfLights" (tempAmountFfLights as string)
				for i = 1 to tempAmountFfLights do
				(
					local tempLightName = "Light_" + (i as string) + "_"
					setINISetting  tempPath pName (tempLightName + "Name") (tempLights[i].name as string)
					setINISetting  tempPath pName (tempLightName + "LightColor") (tempLights[i].rgb as string)
					setINISetting  tempPath pName (tempLightName + "Pos") (tempLights[i].position as string)
					setINISetting  tempPath pName (tempLightName + "Multiplier") (tempLights[i].multiplier as string)
				)
				--Update the UI with the existing files
				LoadPresets "light"
				
				UpdateUI()
			),--End Function AddLightPreset

			--Making and saving a init file for the current material properties
			function AddMaterialPreset pName=
			(
				--first we create the filepath for the new file
				local tempPath = m_MainPath + m_FolderNameMaterialPresets + pName + ".ini"
				
				--Here we save out all the different properties of the shader for the material settings
				setINISetting  tempPath pName "btn_FresnelReflections" (m_RefRolloutMaterials.btn_FresnelReflections.state as string)
				setINISetting  tempPath pName "chk_ColorDifMap" (m_RefRolloutMaterials.chk_ColorDifMap.state as string)
				setINISetting  tempPath pName "chk_EnableAlphaChannel" (m_RefRolloutMaterials.chk_EnableAlphaChannel.state as string)
				setINISetting  tempPath pName "chk_FlipGreen" (m_RefRolloutMaterials.chk_FlipGreen.state as string)
				setINISetting  tempPath pName "chk_ObjectSpace" (m_RefRolloutMaterials.chk_ObjectSpace.state as string)
				setINISetting  tempPath pName "chk_OpacityAffectsReflections" (m_RefRolloutMaterials.chk_OpacityAffectsReflections.state as string)
				setINISetting  tempPath pName "chk_UseGlossmapForBlur" (m_RefRolloutMaterials.chk_UseGlossmapForBlur.state as string)
				setINISetting  tempPath pName "cp_Diffuse" (m_RefRolloutMaterials.cp_Diffuse.color as string)
				setINISetting  tempPath pName "cp_DifFresnelC" (m_RefRolloutMaterials.cp_DifFresnelC.color as string)
				setINISetting  tempPath pName "cp_Specular" (m_RefRolloutMaterials.cp_Specular.color as string)
				setINISetting  tempPath pName "cp_FresnelReflections" (m_RefRolloutMaterials.cp_FresnelReflections.color as string)
				setINISetting  tempPath pName "spn_DifMapChannel" (m_RefRolloutMaterials.spn_DifMapChannel.value as string)
				setINISetting  tempPath pName "spn_VertCStrength" (m_RefRolloutMaterials.spn_VertCStrength.value as string)
				setINISetting  tempPath pName "spn_diffuseFresnelPower" (m_RefRolloutMaterials.spn_diffuseFresnelPower.value as string)
				setINISetting  tempPath pName "spn_FreshnelMultiplier" (m_RefRolloutMaterials.spn_FreshnelMultiplier.value as string)
				setINISetting  tempPath pName "spn_GlobalOpacityLevel" (m_RefRolloutMaterials.spn_GlobalOpacityLevel.value as string)
				setINISetting  tempPath pName "spn_SpecGlobalLevel" (m_RefRolloutMaterials.spn_SpecGlobalLevel.value as string)
				setINISetting  tempPath pName "spn_GlossMax" (m_RefRolloutMaterials.spn_GlossMax.value as string)
				setINISetting  tempPath pName "spn_GlossMin" (m_RefRolloutMaterials.spn_GlossMin.value as string)
				setINISetting  tempPath pName "spn_SIMultiply" (m_RefRolloutMaterials.spn_SIMultiply.value as string)
				setINISetting  tempPath pName "spn_FresnelPower" (m_RefRolloutMaterials.spn_FresnelPower.value as string)
				setINISetting  tempPath pName "spn_FresnelBias" (m_RefRolloutMaterials.spn_FresnelBias.value as string)
				setINISetting  tempPath pName "spn_FresnelMultiplier" (m_RefRolloutMaterials.spn_FresnelMultiplier.value as string)
				setINISetting  tempPath pName "spn_FresnelMaskHardness" (m_RefRolloutMaterials.spn_FresnelMaskHardness.value as string)
				setINISetting  tempPath pName "spn_CubemapBlur" (m_RefRolloutMaterials.spn_CubemapBlur.value as string)
				setINISetting  tempPath pName "spn_normalMapChannel" (m_RefRolloutMaterials.spn_normalMapChannel.value as string)
				setINISetting  tempPath pName "ddl_ReflectType" (m_RefRolloutMaterials.ddl_ReflectType.selection as string)
				
				setINISetting  tempPath pName "ddl_Techniques" (m_RefRolloutTechniques.ddl_Techniques.selection as string)
				setINISetting  tempPath pName "chk_Clip" (m_RefRolloutTechniques.chk_Clip.state as string)
				setINISetting  tempPath pName "spn_ClipTreshold" (m_RefRolloutTechniques.spn_ClipTreshold.value as string)		
				
				if(m_RefRolloutMaterials.btn_Reload_Diffuse.tooltip != (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")) then
				(
				RelativeMaxPath (m_RefRolloutMaterials.btn_Reload_Diffuse.tooltip as string) &m_RelativePath
				setINISetting  tempPath pName "Diffuse" m_RelativePath
				)
				if(m_RefRolloutMaterials.btn_Reload_Specular.tooltip != (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")) then
				(
				RelativeMaxPath (m_RefRolloutMaterials.btn_Reload_Specular.tooltip as string) &m_RelativePath
				setINISetting  tempPath pName "Specular" m_RelativePath
				)
				if(m_RefRolloutMaterials.btn_Reload_Glossiness.tooltip != (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")) then
				(
				RelativeMaxPath (m_RefRolloutMaterials.btn_Reload_Glossiness.tooltip as string) &m_RelativePath
				setINISetting  tempPath pName "Glossiness" m_RelativePath
				)
				if(m_RefRolloutMaterials.btn_Reload_Normal.tooltip != (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")) then
				(
				RelativeMaxPath (m_RefRolloutMaterials.btn_Reload_Normal.tooltip as string) &m_RelativePath
				setINISetting  tempPath pName "Normal" m_RelativePath
				)
				if(m_RefRolloutMaterials.btn_Reload_SelfIllumination.tooltip != (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")) then
				(
				RelativeMaxPath (m_RefRolloutMaterials.btn_Reload_SelfIllumination.tooltip as string) &m_RelativePath
				setINISetting  tempPath pName "SelfIllum" m_RelativePath
				)
				if(m_RefRolloutMaterials.btn_Reload_ReflectMap.tooltip != (scriptsPath + "XoliulShaderUI\\images\\NoImage.png")) then
				(
 				RelativeMaxPath (m_RefRolloutMaterials.btn_Reload_ReflectMap.tooltip as string) &m_RelativePath
				setINISetting  tempPath pName "Reflect" m_RefRolloutMaterials.btn_Reload_ReflectMap.tooltip
				)
				--Reset Tooltips
				m_RefRolloutMaterials.btn_Reload_Diffuse.tooltip = ""
				m_RefRolloutMaterials.btn_Reload_Specular.tooltip = ""
				m_RefRolloutMaterials.btn_Reload_Glossiness.tooltip = ""
				m_RefRolloutMaterials.btn_Reload_Normal.tooltip = ""
				m_RefRolloutMaterials.btn_Reload_SelfIllumination.tooltip = ""
				m_RefRolloutMaterials.btn_Reload_ReflectMap.tooltip = ""
				
				--Update the UI with the existing files
				LoadPresets "material"
				
				UpdateUI()
			),--End Function AddMaterialPreset
			
			function ApplyPresetMap pFilePath pOnOffMap pImage pEnableDC pToggle pBool pMap pBitmap=
			(
				--if *pFilePath != bm_Filename  then messagebox( "" + *pFilePath)
				if *pFilePath != undefined and *pFilePath != "" and *pFilePath != "undefined" and *pFilePath != bm_Filename then
				(
					--first do relative maxroot magic
					AbsoluteMaxPath (*pFilePath) &m_AbsolutePath
					--then open bitmap into temp var
					local tempImage =  openbitmap (m_AbsolutePath)
					--if it didn't work
					if tempImage == undefined then
					(
						--then suggest to open one
						tempImage = selectBitMap caption:("We can not find the image : " + *pFilePath) 
						--if it worked, set the file path
						if tempImage != undefined then *pFilePath = tempImage.filename
					)
					--if an image is found
					if tempImage != undefined then 
					(
						local tempOnOff = *pOnOffMap
						tempOnOff.v1 = CreateOffImage tempImage
						tempOnOff.v2 = CreateOnImage tempImage
						local tempImageClass = dotnetclass "System.Drawing.Image"
						if (*pToggle == true) then *pImage = tempImageClass.FromFile tempOnOff.v2
						else *pImage = tempImageClass.FromFile tempOnOff.v1
						--messagebox("ptoggle: " + (*pToggle as string) + " penabledc: " + (*pEnableDC as string))
						
						if not *pEnableDC then 
						(
							*pBool = true
							--messagebox "new map loaded"
						)
						*pEnableDC = true 
						
						*pMap  = openbitmap (m_AbsolutePath)
						*pBitmap = (*pMap)
						*pToggle = *pBool
					)
				)
				else
				(
					
					local tempImage =  openbitmap bm_Filename
					
					local tempRef = *pBitmap
					tempRef = tempImage
					*pEnableDC = false
					*pFilePath = bm_Filename
					
					local tempRefOnOffImage = *pOnOffMap
					tempRefOnOffImage.v1 = CreateOffImage tempImage
					tempRefOnOffImage.v2 = CreateOnImage tempImage
					
					local tempImageClass = dotnetclass "System.Drawing.Image"
					*pImage = tempImageClass.FromFile  tempRefOnOffImage.v1
					
					*pMap  = openbitmap bm_Filename
					*pToggle = false
					*pBool = false
				)
			),
			
			Function CreateLightScene=
			(
				tempPresetName = m_RefDroplistLights.selected
				tempFilename = m_MainPath + m_FolderNameLightPresets + tempPresetName + ".ini"
		
				local tempReturn = queryBox  "Remove all existing lights before creating new ones?" title:"Reset Light Scene"
				if tempReturn then
				(
					for item in lights as array do delete item
				)
				else
				(
					for item in lights as array do item.name = "Prev_" + item.name
				)
				
				--Get the data from the initfile and check it witht he existing lights if they already exist or not.
				--This check is based on the position, lightcolor and multiplier
				local tempAmountFfLights = (getINIsetting tempFilename tempPresetName "AmountOfLights") as integer
				if tempAmountFfLights == undefined or tempAmountFfLights == "" then tempAmountFfLights = 0
				if tempAmountFfLights == 0 then messagebox "There are no lights in the preset to be created"
					else
				(
					for i = 1 to tempAmountFfLights do
					(
						local tempLightName = "Light_" + (i as string) + "_"
						local tempName = (getINIsetting tempFilename tempPresetName (tempLightName + "Name")) as string
						local tempColor = ConvertStringToColor  (getINIsetting tempFilename tempPresetName (tempLightName + "LightColor"))
						local tempPos = ConvertStringToPoint  (getINIsetting tempFilename tempPresetName (tempLightName + "Pos"))
						local tempMultiplier = (getINIsetting tempFilename tempPresetName (tempLightName + "Multiplier")) as float
						
						local tempAllowCreationLight = true
						for item in lights as array do
						(
							if item.rgb == tempColor and item.pos == tempPos and item.multiplier == tempMultiplier then tempAllowCreationLight = false
						)--End for
						
						if tempAllowCreationLight then
						(
							local tempLight = omniLight()
							tempLight.name = tempName
							tempLight.rgb = tempColor
							tempLight.pos = tempPos
							tempLight.multiplier = tempMultiplier
							tempAllowCreationLight = true
						)--End if
					)--End for
				)				
			),
			
			function ApplyMaterialsMaps=
			(				
				ApplyPresetMap &filePath_Diffuse &bm_OnOff_Diffuse &(m_RefRolloutMaterials.imgT_Diffuse.image) &b_EnableDC_Diffuse &b_Toggle_Diffuse &delegate.bUseDiffuseMap &delegate.Diffusemap &bm_Diffuse
				m_RefRolloutMaterials.btn_Reload_Diffuse.toolTip = filePath_Diffuse

				ApplyPresetMap &filePath_Specular &bm_OnOff_Specular &(m_RefRolloutMaterials.imgT_Specular.image) &b_EnableDC_Specular &b_Toggle_Specular &delegate.bUseSpecMap &delegate.specularMap  &bm_Specular
				m_RefRolloutMaterials.btn_Reload_Specular.toolTip = filePath_Specular

				ApplyPresetMap &filePath_Glossiness &bm_OnOff_Glossiness &(m_RefRolloutMaterials.imgT_Glossiness.image) &b_EnableDC_Glossiness &b_Toggle_Glossiness &delegate.bUseGlossMap &delegate.Glossmap &bm_Glossiness
				m_RefRolloutMaterials.btn_Reload_Glossiness.toolTip = filePath_Glossiness
				
				ApplyPresetMap &filePath_Normal &bm_OnOff_Normal &(m_RefRolloutMaterials.imgT_Normal.image) &b_EnableDC_Normal &b_Toggle_Normal &delegate.bUseNormalMap &delegate.normalMap  &bm_Normal
				m_RefRolloutMaterials.btn_Reload_Normal.toolTip = filePath_Normal

				ApplyPresetMap &filePath_SelfIllum &bm_OnOff_SelfIllum &(m_RefRolloutMaterials.imgT_SelfIllum.image) &b_EnableDC_SelfIllum &b_Toggle_SelfIllumination &delegate.bUseSIMap &delegate.siMap  &bm_SelfIllum
				m_RefRolloutMaterials.btn_Reload_SelfIllumination.toolTip = filePath_SelfIllum
				
				ApplyPresetMap &filePath_ReflectMap &bm_OnOff_Reflectmap &(m_RefRolloutMaterials.imgT_ReflectMap.image) &b_EnableDC_Reflect &b_Toggle_ReflectMap &delegate.bUseReflMap &delegate.ReflMap  &bm_ReflectMap
				m_RefRolloutMaterials.btn_Reload_ReflectMap.toolTip = filePath_ReflectMap
			),
			
			function ApplyLightingMaps=
			(
				ApplyPresetMap &filePath_Cubemap &bm_OnOff_Cubemap &(m_RefRolloutLighting.imgT_Cubemap.image) &b_EnableDC_Cubemap &b_Toggle_Cubemap &delegate.UseIBLambient &delegate.EnvCubemap &bm_Cubemap
				m_RefRolloutLighting.btn_Reload_IBLCubemap.toolTip = filePath_Cubemap
				
				ApplyPresetMap &filePath_Gradient &bm_OnOff_Gradient &(m_RefRolloutLighting.imgT_Gradient.image) &b_EnableDC_Gradient &b_Toggle_Gradient &delegate.UseGradientRamp &delegate.gradientMap &bm_Gradient
				m_RefRolloutLighting.btn_Reload_Gradient.toolTip = filePath_Gradient
			),
			
			function ApplyPreset pType=
			(
				local tempFilename = undefined
				local tempPresetName = undefined
				if pType == "light" then 
				(
					tempPresetName = m_RefDroplistLights.selected
					tempFilename = m_MainPath + m_FolderNameLightPresets + tempPresetName + ".ini"
					
					--Here we get the data from the initfile and qssign it to the shader
					m_RefRolloutLighting.spn_Gamma.value = (getINIsetting tempFilename tempPresetName "spn_Gamma") as float
					m_RefRolloutLighting.ddl_shadowType.selection = (getINIsetting tempFilename tempPresetName "ddl_shadowType") as integer
					m_RefRolloutLighting.spn_ShadowIntensity.value = (getINIsetting tempFilename tempPresetName "spn_ShadowIntensity") as float
					m_RefRolloutLighting.spn_ShadowQuality.value = (getINIsetting tempFilename tempPresetName "spn_ShadowQuality") as integer
					m_RefRolloutLighting.spn_ShadedHudeAdjustment.value = (getINIsetting tempFilename tempPresetName "spn_ShadedHudeAdjustment") as float
					m_RefRolloutLighting.spn_HalflambertPower.value = (getINIsetting tempFilename tempPresetName "spn_HalflambertPower") as float
					m_RefRolloutLighting.spn_EnvCubeBlur.value = (getINIsetting tempFilename tempPresetName "spn_EnvCubeBlur") as float
					m_RefRolloutLighting.spn_EnvCubeStrength.value = (getINIsetting tempFilename tempPresetName "spn_EnvCubeStrength") as float
					m_RefRolloutLighting.ddl_Light1Pos.selection = (getINIsetting tempFilename tempPresetName "ddl_Light1Pos") as integer
					if m_RefRolloutLighting.ddl_Light1Pos.selection == 0 then m_RefRolloutLighting.ddl_Light1Pos.selection = 1
					m_RefRolloutLighting.ddl_Light2Pos.selection = (getINIsetting tempFilename tempPresetName "ddl_Light2Pos") as integer
					if m_RefRolloutLighting.ddl_Light2Pos.selection == 0 then m_RefRolloutLighting.ddl_Light2Pos.selection = 1
					m_RefRolloutLighting.ddl_Light3Pos.selection = (getINIsetting tempFilename tempPresetName "ddl_Light3Pos") as integer
					if m_RefRolloutLighting.ddl_Light3Pos.selection == 0 then m_RefRolloutLighting.ddl_Light3Pos.selection = 1
					m_RefRolloutLighting.btn_LightOne.state = (getINIsetting tempFilename tempPresetName "btn_LightOne") as booleanClass
					delegate.UseLight1 = (getINIsetting tempFilename tempPresetName "btn_LightOne") as booleanClass
					m_RefRolloutLighting.btn_LightTwo.state = (getINIsetting tempFilename tempPresetName "btn_LightTwo") as booleanClass
					delegate.UseLight2 = (getINIsetting tempFilename tempPresetName "btn_LightTwo") as booleanClass
					m_RefRolloutLighting.btn_LightThree.state = (getINIsetting tempFilename tempPresetName "btn_LightThree") as booleanClass
					delegate.UseLight3 = (getINIsetting tempFilename tempPresetName "btn_LightThree") as booleanClass
					m_RefRolloutLighting.btn_Shadow1.state = (getINIsetting tempFilename tempPresetName "btn_Shadow1") as booleanClass
					delegate.UseShadow1 = (getINIsetting tempFilename tempPresetName "btn_Shadow1") as booleanClass
					m_RefRolloutLighting.btn_Shadow2.state = (getINIsetting tempFilename tempPresetName "btn_Shadow2") as booleanClass
					delegate.UseShadow2 = (getINIsetting tempFilename tempPresetName "btn_Shadow2") as booleanClass
					m_RefRolloutLighting.btn_Shadow3.state = (getINIsetting tempFilename tempPresetName "btn_Shadow3") as booleanClass
					delegate.UseShadow3 = (getINIsetting tempFilename tempPresetName "btn_Shadow3") as booleanClass
					m_RefRolloutLighting.chk_HalfLambertShading.state = (getINIsetting tempFilename tempPresetName "chk_HalfLambertShading") as booleanClass
					m_RefRolloutLighting.cp_AmbientColor.color = ConvertStringToColor (getINIsetting tempFilename tempPresetName "cp_AmbientColor")
					m_RefRolloutLighting.sld_EnvRotation.value = (getINIsetting tempFilename tempPresetName "sld_EnvRotation") as float
					m_RefRolloutLighting.spn_CubeGamma.value = (getINIsetting tempFilename tempPresetName "spn_CubeGamma") as float
					
					m_RefRolloutLighting.SetLights 0
					
					if  m_RefRolloutLighting.btn_Shadow1.state and m_RefRolloutLighting.ddl_Light1Pos.selection != 0 then
					(
						m_RefRolloutLighting.btn_Shadow1.changed (m_RefRolloutLighting.btn_Shadow1.state)
						m_RefRolloutLighting.UseShadow true
						m_RefRolloutLighting.SetShadowType m_RefRolloutLighting.ddl_shadowType.selection
					)
					if m_RefRolloutLighting.btn_Shadow2.state and m_RefRolloutLighting.ddl_Light2Pos.selection != 0 then
					(
						m_RefRolloutLighting.btn_Shadow2.changed (m_RefRolloutLighting.btn_Shadow2.state)
						m_RefRolloutLighting.UseShadow true
						m_RefRolloutLighting.SetShadowType m_RefRolloutLighting.ddl_shadowType.selection
					)
					if m_RefRolloutLighting.btn_Shadow3.state and m_RefRolloutLighting.ddl_Light3Pos.selection != 0 then
					(
						m_RefRolloutLighting.btn_Shadow3.changed (m_RefRolloutLighting.btn_Shadow3.state)
						m_RefRolloutLighting.UseShadow true
						m_RefRolloutLighting.SetShadowType m_RefRolloutLighting.ddl_shadowType.selection
					)
					
					filePath_Cubemap =  getINIsetting tempFilename tempPresetName "EnvCubemap"
					ApplyPresetMap &filePath_Cubemap &bm_OnOff_Cubemap &(m_RefRolloutLighting.imgT_Cubemap.image) &b_EnableDC_Cubemap &b_Toggle_Cubemap &delegate.UseIBLambient &delegate.EnvCubemap &bm_Cubemap
					if m_RefRolloutLighting.imgT_Cubemap.image != undefined then 
					(
						--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
						m_RefRolloutLighting.btn_Reload_IBLCubemap.toolTip = filePath_Cubemap
					)
					
					filePath_Gradient =  getINIsetting tempFilename tempPresetName "gradientMap"
					ApplyPresetMap &filePath_Gradient &bm_OnOff_Gradient &(m_RefRolloutLighting.imgT_Gradient.image) &b_EnableDC_Gradient &b_Toggle_Gradient &delegate.UseGradientRamp &delegate.gradientMap &bm_Gradient
					if m_RefRolloutLighting.imgT_Gradient.image != undefined then 
					(
						m_RefRolloutLighting.btn_Reload_Gradient.toolTip = filePath_Gradient
					)
					format "Apply Light Preset is done\n"
-- 					UpdateLights undefined undefined
					Presets.m_RefRolloutLighting.OpenRollout_Lighting()
				)
				if pType == "material" then
				(
					tempPresetName = m_RefDroplistMaterials.selected
					tempFilename = m_MainPath + m_FolderNameMaterialPresets + tempPresetName + ".ini"
					
					--Here we get the data from the initfile and qssign it to the shader
					m_RefRolloutMaterials.btn_FresnelReflections.state = (getINIsetting tempFilename tempPresetName "btn_FresnelReflections") as booleanClass
					m_RefRolloutMaterials.chk_ColorDifMap.state = (getINIsetting tempFilename tempPresetName "chk_ColorDifMap") as booleanClass
					m_RefRolloutMaterials.chk_EnableAlphaChannel.state = (getINIsetting tempFilename tempPresetName "chk_EnableAlphaChannel") as booleanClass
					m_RefRolloutMaterials.chk_FlipGreen.state = (getINIsetting tempFilename tempPresetName "chk_FlipGreen") as booleanClass
					m_RefRolloutMaterials.chk_ObjectSpace.state = (getINIsetting tempFilename tempPresetName "chk_ObjectSpace") as booleanClass
					m_RefRolloutMaterials.chk_OpacityAffectsReflections.state = (getINIsetting tempFilename tempPresetName "chk_OpacityAffectsReflections") as booleanClass
					m_RefRolloutMaterials.chk_UseGlossmapForBlur.state = (getINIsetting tempFilename tempPresetName "chk_UseGlossmapForBlur") as booleanClass
					m_RefRolloutMaterials.cp_Diffuse.color = ConvertStringToColor (getINIsetting tempFilename tempPresetName "cp_Diffuse")
					m_RefRolloutMaterials.cp_DifFresnelC.color = ConvertStringToColor (getINIsetting tempFilename tempPresetName "cp_DifFresnelC")
					m_RefRolloutMaterials.cp_Specular.color = ConvertStringToColor (getINIsetting tempFilename tempPresetName "cp_Specular")
					m_RefRolloutMaterials.cp_FresnelReflections.color = ConvertStringToColor (getINIsetting tempFilename tempPresetName "cp_FresnelReflections")
					m_RefRolloutMaterials.spn_DifMapChannel.value = (getINIsetting tempFilename tempPresetName "spn_DifMapChannel") as integer
					m_RefRolloutMaterials.spn_diffuseFresnelPower.value = (getINIsetting tempFilename tempPresetName "spn_diffuseFresnelPower") as float
					m_RefRolloutMaterials.spn_VertCStrength.value = (getINIsetting tempFilename tempPresetName "spn_VertCStrength") as float
					m_RefRolloutMaterials.spn_FreshnelMultiplier.value = (getINIsetting tempFilename tempPresetName "spn_FreshnelMultiplier") as float
					m_RefRolloutMaterials.spn_GlobalOpacityLevel.value = (getINIsetting tempFilename tempPresetName "spn_GlobalOpacityLevel") as float
					m_RefRolloutMaterials.spn_SpecGlobalLevel.value = (getINIsetting tempFilename tempPresetName "spn_SpecGlobalLevel") as float
					m_RefRolloutMaterials.spn_GlossMax.value = (getINIsetting tempFilename tempPresetName "spn_GlossMax") as float
					m_RefRolloutMaterials.spn_GlossMin.value = (getINIsetting tempFilename tempPresetName "spn_GlossMin") as float
					m_RefRolloutMaterials.spn_SIMultiply.value = (getINIsetting tempFilename tempPresetName "spn_SIMultiply") as float
					m_RefRolloutMaterials.spn_FresnelPower.value = (getINIsetting tempFilename tempPresetName "spn_FresnelPower") as float
					m_RefRolloutMaterials.spn_FresnelBias.value = (getINIsetting tempFilename tempPresetName "spn_FresnelBias") as float
					m_RefRolloutMaterials.spn_FresnelMultiplier.value = (getINIsetting tempFilename tempPresetName "spn_FresnelMultiplier") as float
					m_RefRolloutMaterials.spn_FresnelMaskHardness.value = (getINIsetting tempFilename tempPresetName "spn_FresnelMaskHardness") as float
					m_RefRolloutMaterials.spn_CubemapBlur.value = (getINIsetting tempFilename tempPresetName "spn_CubemapBlur") as float
					m_RefRolloutMaterials.spn_normalMapChannel.value = (getINIsetting tempFilename tempPresetName "spn_normalMapChannel") as integer
					reflecttype = (getINIsetting tempFilename tempPresetName "ddl_ReflectType") as integer
					if reflecttype == 1 then
					( 
						delegate.bUseWorldMask = false  
						delegate.bUseCubeMap = false
					)
					if reflecttype == 2 then
					(
						delegate.bUseWorldMask = true
						delegate.bUseCubeMap = false)
					if reflecttype == 3 then
					(
						delegate.bUseWorldMask = false 
						delegate.bUseCubeMap = true)
					
					
					
					m_RefRolloutTechniques.ddl_Techniques.selection = (getINIsetting tempFilename tempPresetName "ddl_Techniques") as integer
					m_RefRolloutTechniques.chk_Clip.state = (getINIsetting tempFilename tempPresetName "chk_Clip") as booleanClass
					m_RefRolloutTechniques.spn_ClipTreshold.value = (getINIsetting tempFilename tempPresetName "spn_ClipTreshold") as float
					
					--Diffuse
					filePath_Diffuse =  getINIsetting tempFilename tempPresetName "Diffuse"
					
					ApplyPresetMap &filePath_Diffuse &bm_OnOff_Diffuse &(m_RefRolloutMaterials.imgT_Diffuse.image) &b_EnableDC_Diffuse &b_Toggle_Diffuse &delegate.bUseDiffuseMap &delegate.Diffusemap &bm_Diffuse
					if m_RefRolloutMaterials.imgT_Diffuse.image != undefined then 
					(
						--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
						m_RefRolloutMaterials.btn_Reload_Diffuse.toolTip = filePath_Diffuse
					)
					
					--Specular
					filePath_Specular =  getINIsetting tempFilename tempPresetName "Specular"
					ApplyPresetMap &filePath_Specular &bm_OnOff_Specular &(m_RefRolloutMaterials.imgT_Specular.image) &b_EnableDC_Specular &b_Toggle_Specular &delegate.bUseSpecMap &delegate.specularMap  &bm_Specular
					if m_RefRolloutMaterials.imgT_Specular.image != undefined then
					(
						--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
						m_RefRolloutMaterials.btn_Reload_Specular.toolTip = filePath_Specular
					)
					
					--Glossiness
					filePath_Glossiness =  getINIsetting tempFilename tempPresetName "Glossiness"
					ApplyPresetMap &filePath_Glossiness &bm_OnOff_Glossiness &(m_RefRolloutMaterials.imgT_Glossiness.image) &b_EnableDC_Glossiness &b_Toggle_Glossiness &delegate.bUseGlossMap &delegate.Glossmap &bm_Glossiness
					
				
						--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
						m_RefRolloutMaterials.btn_Reload_Glossiness.toolTip = filePath_Glossiness
					
					
					--Normal
					filePath_Normal =  getINIsetting tempFilename tempPresetName "Normal"
					ApplyPresetMap &filePath_Normal &bm_OnOff_Normal &(m_RefRolloutMaterials.imgT_Normal.image) &b_EnableDC_Normal &b_Toggle_Normal &delegate.bUseNormalMap &delegate.normalMap  &bm_Normal
					if m_RefRolloutMaterials.imgT_Normal.image != undefined then 
					(
						--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
						m_RefRolloutMaterials.btn_Reload_Normal.toolTip = filePath_Normal
					)
					
					--SelffIllum
					filePath_SelfIllum =  getINIsetting tempFilename tempPresetName "SelfIllum"
					ApplyPresetMap &filePath_SelfIllum &bm_OnOff_SelfIllum &(m_RefRolloutMaterials.imgT_SelfIllum.image) &b_EnableDC_SelfIllum &b_Toggle_SelfIllumination &delegate.bUseSIMap &delegate.siMap  &bm_IBLCubemap
					if m_RefRolloutMaterials.imgT_SelfIllum.image != undefined then
					(
						--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
						m_RefRolloutMaterials.btn_Reload_SelfIllumination.toolTip = filePath_SelfIllum
					)
					
					--Reflectmap
					filePath_ReflectMap =  getINIsetting tempFilename tempPresetName "Reflect"
					ApplyPresetMap &filePath_ReflectMap &bm_OnOff_Reflectmap &(m_RefRolloutMaterials.imgT_ReflectMap.image) &b_EnableDC_Reflect &b_Toggle_ReflectMap &delegate.bUseReflMap &delegate.ReflMap  &bm_ReflectMap
					if m_RefRolloutMaterials.imgT_ReflectMap.image != undefined then
					(
						--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
						m_RefRolloutMaterials.btn_Reload_ReflectMap.toolTip = filePath_ReflectMap
					)
					
					--Checking if a Env Cubemap is there when reflections are on
					if m_RefRolloutMaterials.btn_FresnelReflections.state and m_RefRolloutMaterials.ddl_ReflectType.selection == m_RefRolloutMaterials.ddl_ReflectType.items.count then
					(
						local bmT = selectBitMap caption:"Select an Environment Cubemap"
						if bmT != undefined then
						(
							filePath_Cubemap = bmT.filename
							ApplyPresetMap &filePath_Cubemap &bm_OnOff_Cubemap &tempImageReturn &b_EnableDC_Cubemap &b_Toggle_Cubemap &delegate.UseIBLambient &delegate.EnvCubemap &bm_Cubemap
							if tempImageReturn != undefined then 
							(
								m_RefRolloutLighting.imgT_Cubemap.image = tempImageReturn
								--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
								m_RefRolloutLighting.btn_Reload_IBLCubemap.toolTip = filePath_Cubemap
							)
						)
					)
					format "Apply Material Preset is done\n"
-- 					UpdateLights undefined undefined
					Presets.m_RefRolloutMaterials.Open_Rollout_Maps()
				)
			)--End Function ApplyPreset
		)--End Presets Struct
		
		/* ==================================================================================================================PLUGIN FUNCTIONS*/
		
		--We need to create a image with the on icon blended on top of the loaded image
		function CreateOnImage bgImage=
		(
			--First we load the image with the icon
			local tempBitmap = bitmap 64 64
			copy bgImage tempBitmap
			local icon = openBitMap "$Scripts\\XoliulShaderUI\\images\\on.png"
			pastebitmap icon tempBitmap [0,0] [0,0] type:#blend
			local tempImageFilePath = scriptspath + "XoliulShaderUI\\images\\temp\\" + "On_" + (getFilenameFile bgImage.filename) + ".jpg"
			tempBitmap.filename = tempImageFilePath
			close tempBitmap
			save tempBitmap quiet:true
			return tempImageFilePath
		)--End function CreateOnImage &bgImage
		
		--We need to make the preview image the right size
		function CreateOffImage bgImage=
		(
			--First we load the image with the icon
			local tempBitmap = bitmap 64 64
			copy bgImage tempBitmap
			local icon = openBitMap "$Scripts\\XoliulShaderUI\\images\\off.png"
			pastebitmap icon tempBitmap [0,0] [0,0] type:#blend
			local tempImageFilePath = scriptspath + "XoliulShaderUI\\images\\temp\\" + "Off_" + (getFilenameFile bgImage.filename) + ".jpg"
			tempBitmap.filename = tempImageFilePath
			close tempBitmap
			save tempBitmap quiet:true
			return tempImageFilePath
		)--End function CreateOnImage &bgImage
		
		--Reloading the image and showing a preview
		function RefreshImage pIMG pBM pAllowReload pToggle pMap pOnOffImage pFilePath=
		(
			local tempBitmap = *pBM
			if *pAllowReload == true then
			(
				tempBitmap = openBitmap (*pFilePath)
				if tempBitmap != undefined then
				(
					*pMap  = tempBitmap
					local tempRefOnOffImage = *pOnOffImage
					tempRefOnOffImage.v1 = CreateOffImage tempBitmap
					tempRefOnOffImage.v2 = CreateOnImage tempBitmap
					
					local tempImageClass = dotnetclass "System.Drawing.Image"
					
					if *pToggle == false then
					(
						pIMG.image = tempImageClass.FromFile tempRefOnOffImage.v2
					)
					else
					(
						pIMG.image = tempImageClass.FromFile tempRefOnOffImage.v1
					)
				)--End if
			)--End if
		)--End function refreshImage
		
		/* ==================================================================================================================PARAMETERS*/
		
		parameters MapsParams rollout:rollout_Maps
		(
			--Diffusemap
			m_diffuseColor type:#color ui:cp_Diffuse default:(color 128 128 128 1.0)
			on m_diffuseColor set val do delegate.diffuseColor  = val
			m_DiffuseMapUV type:#integer ui:spn_DifMapChannel default:1
			on m_DiffuseMapUV set val do delegate.DiffuseMapUV  = val
			m_VertexDiffuse type:#float ui:spn_VertCStrength default:0.0
			on m_VertexDiffuse set val do delegate.VertexDiffuse  = val
			m_bColorDiffuse type:#boolean ui:chk_ColorDifMap default:false
			on m_bColorDiffuse set val do delegate.bColorDiffuse  = val
			m_diffusefresnelColor type:#color ui:cp_DifFresnelC default:(color 128 128 128 1.0)
			on m_diffusefresnelColor set val do delegate.diffusefresnelColor  = val
			m_diffuseFresnelPower type:#float ui:spn_diffuseFresnelPower default:3.0
			on m_diffuseFresnelPower set val do delegate.diffuseFresnelPower  = val
			m_diffuseFresnelMult type:#float ui:spn_FreshnelMultiplier default:0.0
			on m_diffuseFresnelMult set val do delegate.diffuseFresnelMult  = val
			--Opacity
			m_bUseAlpha type:#boolean ui:chk_EnableAlphaChannel default:false
			on m_bUseAlpha set val do delegate.bUseAlpha  = val
			m_GlobalOpacity type:#float ui:spn_GlobalOpacityLevel default:1.0
			on m_GlobalOpacity set val do delegate.GlobalOpacity  = val
			--Specular
			m_specularColor type:#color ui:cp_Specular default:(color 255 255 255 1.0)
			on m_specularColor set val do delegate.specularColor  = val
			m_speclevel type:#float ui:spn_SpecGlobalLevel default:1.0
			on m_speclevel set val do delegate.speclevel  = val
			--Glossiness
			m_glossiness type:#float ui:spn_GlossMax default:25.0
			on m_glossiness set val do delegate.glossiness  = val
			m_glossoffset type:#float ui:spn_GlossMin default:10.0
			on m_glossoffset set val do delegate.glossoffset  = val
			--Normal
			m_bFlipGreenChannel type:#boolean ui:chk_FlipGreen default: true
			on m_bFlipGreenChannel set val do delegate.bFlipGreenChannel  = val
			m_bUseObjectNormals type:#boolean ui:chk_ObjectSpace default:false
			on m_bUseObjectNormals set val do delegate.bUseObjectNormals  = val
			m_NormalMapUV type:#integer ui:spn_normalMapChannel default:1
			on m_NormalMapUV set val do delegate.NormalMapUV  = val
			--SelfIllum
			m_siMapMult type:#float ui:spn_SIMultiply default:1.0
			on m_siMapMult set val do delegate.siMapMult  = val
			m_bUseFresnel type:#boolean ui:btn_FresnelReflections default:false
			on m_bUseFresnel set val do delegate.bUseFresnel  = val
			m_bAlphaMasksFresnel type:#boolean ui:chk_OpacityAffectsReflections default:false
			on m_bAlphaMasksFresnel set val do delegate.bAlphaMasksFresnel = val
			m_FresnelPower type:#float ui:spn_FresnelPower default:3.0
			on m_FresnelPower set val do delegate.FresnelPower  = val
			m_FresnelBias type:#float ui:spn_FresnelBias default:0.0
			on m_FresnelBias set val do delegate.FresnelBias  = val
			m_FresnelMult type:#float ui:spn_FresnelMultiplier default:2.0
			on m_FresnelMult set val do delegate.FresnelMult  = val
			m_FresnelColor type:#color ui:cp_FresnelReflections  default:(color 255 255 255 1.0)
			on m_FresnelColor  set val do delegate.FresnelColor   = val
			m_FresnelMaskHardness type:#float ui:spn_FresnelMaskHardness default:4.0
			on m_FresnelMaskHardness  set val do delegate.FresnelMaskHardness   = val
			m_CubeMapBlur type:#float ui:spn_CubemapBlur default:0.0
			on m_CubeMapBlur  set val do delegate.CubeMapBlur   = val
			m_bUseReflGloss type:#boolean ui:chk_UseGlossmapForBlur default:false
			on m_bUseReflGloss  set val do delegate.bUseReflGloss   = val
		)--End parameters MapsParams

		parameters LightingParams rollout:rollout_Lighting
		(	
			m_Gamma type:#float ui:spn_Gamma default:2.2
			on m_Gamma set val do delegate.Gamma = val
			m_Shadow1Type type:#integer default:0
			on m_Shadow1Type set val do delegate.Shadow1Type = val
			m_Shadow1Strength type:#float ui:spn_ShadowIntensity default:1.0
			on m_Shadow1Strength set val do delegate.Shadow1Strength = val
			m_HueAdjust type:#float ui:spn_ShadedHudeAdjustment default:0.3
			on m_HueAdjust set val do delegate.HueAdjust = val
			m_bUseHalfLambert type:#boolean ui:chk_HalfLambertShading default:false
			on m_bUseHalfLambert set val do delegate.bUseHalfLambert = val
			m_HalfLambertPower type:#float ui:spn_HalflambertPower default:2.0
			on m_HalfLambertPower set val do delegate.HalfLambertPower = val
			m_ambientcolor type:#color ui:cp_AmbientColor default:(color 0 0 0)
			on m_ambientcolor set val do delegate.ambientcolor = val
			m_IBLBlur type:#float ui:spn_EnvCubeBlur default:7.6
			on m_IBLBlur set val do delegate.IBLBlur = val
			m_IBLmultiplier type:#float ui:spn_EnvCubeStrength default:0.5
			on m_IBLmultiplier set val do delegate.IBLmultiplier = val
			m_EnvRotation type:#float ui:sld_EnvRotation default:0.0
			on m_EnvRotation set val do delegate.EnvRotation = val
			m_CubeGamma type:#float ui:spn_CubeGamma default:1.0
			on m_CubeGamma set val do delegate.CubeMapGamma = val
		)--End parameters LightingParams

		parameters techniquesParams rollout:rollout_Techniques
		(
			m_bClip type:#boolean default:false ui:chk_Clip
			on m_bClip set val do delegate.bClip = val
			m_ClipTreshold type:#float ui:spn_Cliptreshold default:0.3
			on m_ClipTreshold set val do delegate.ClipTreshold = val
			m_technique	type:#integer default:1 ui:ddl_Techniques
			on m_technique set val do
			(
				delegate.Technique = 0
				if val == 2 then delegate.Technique = 1
			)--End Event
		)--End parameters techniquesParams
		
		/* ==================================================================================================================PLUGIN ROLLOUTS : rollout_Presets*/
		
		rollout rollout_Presets "Material Presets"
		(
			dropdownList ddl_PresetsLights "" pos:[48,8] width:124 height:21
			dropdownList ddl_PresetsShader "" pos:[48,32] width:124 height:21
			button btn_ApplyLightPreset "A" pos:[198,8] width:20 height:20 toolTip:"Apply Preset without Light Creation"
			button btn_CreateLightScene"L" pos:[174,8] width:20 height:20 toolTip:"Create your saved omni lightscene"
			button btn_CreateLightPreset "+" pos:[218,8] width:20 height:20 toolTip:"Create Light Preset"
			button btn_ApplyShaderPreset "A" pos:[198,32] width:20 height:20  toolTip:"LMBC = Apply Preset "
			button btn_CreateShaderPreset "+" pos:[218,32] width:20 height:20 toolTip:"Create Material Preset"
			button btn_BrowsePresets "Browse" pos:[273,32] width:48 height:20
			button btn_RefreshPresets "Refresh" pos:[273,8] width:48 height:20
			label lbl_PresetLights "Lights" pos:[4,11] width:36 height:16
			label lbl_PresetsShader "Material" pos:[4,35] width:44 height:16
			button btn_DeleteLightPreset "-" pos:[248,8] width:20 height:20 toolTip:"Delete Light Preset"
			button btn_DeleteMaterialPreset "-" pos:[248,32] width:20 height:20 toolTip:"Delete Material Preset"
			
			/* ==================================================================================================================ROLLOUT VARIABLES*/
			
			local r_RemoveMessage = "Are you sure you want to remove the preset?"
			
			/* ==================================================================================================================ROLLOUT FUNCTIONS*/
	
			function CheckStateUI=
			(
				if ddl_PresetsLights.items.count == 0 then
				(
					btn_DeleteLightPreset.enabled = false
					btn_ApplyLightPreset.enabled = false
					btn_CreateLightScene.enabled = false
				)
				else
				(
					btn_DeleteLightPreset.enabled = true
					btn_ApplyLightPreset.enabled = true
					btn_CreateLightScene.enabled = true
				)
				if ddl_PresetsShader.items.count == 0 then
				(
					btn_DeleteMaterialPreset.enabled = false
					btn_ApplyShaderPreset.enabled = false
				)
				else
				(
					btn_DeleteMaterialPreset.enabled = true
					btn_ApplyShaderPreset.enabled = true
				)
			)--End Function CheckStateUI
			
			function BrowsePresets=
			(
				--Here we have to go to the shaderfolder were the 2 folders are for the presets
				local rootPath = getDir #maxRoot
				local uiRoot = getDir #ui
				local filePathName = (rootPath + "Scripts\\XoliulShaderUI")
				shellLaunch "explorer.exe" filePathName
			)
			
			/* ==================================================================================================================ROLLOUT EVENTS*/
			
			on btn_BrowsePresets pressed do BrowsePresets()
			on btn_ApplyLightPreset pressed do Presets.ApplyPreset "light"
			on btn_CreateLightScene pressed do 
			(
				Presets.CreateLightScene()
			)
			on btn_ApplyShaderPreset pressed do Presets.ApplyPreset "material"
			on btn_CreateLightPreset pressed do 
			(
				Presets.AddPreset "light"
				CheckStateUI()
			)
			on btn_CreateShaderPreset pressed do
			(
				Presets.AddPreset "material"
				CheckStateUI()
			)
			on btn_DeleteLightPreset pressed do
			(
				if queryBox r_RemoveMessage then Presets.RemovePreset "light"
				CheckStateUI()
			)
			on btn_DeleteMaterialPreset pressed do
			(
				if queryBox r_RemoveMessage then Presets.RemovePreset "material"
				CheckStateUI()
			)
			on btn_RefreshPresets pressed do
			(
				Presets.LoadPresets "light"
				Presets.LoadPresets "material"
			)
			
			on rollout_Presets open do
			(
				format "The rollout open event is called at : % \n" localtime
				--Create presets if they do not exist yet
				if Presets == undefined then
				(
					Presets = MainPresets()
				)
				if m_QuickLoad == undefined then
				(
					m_QuickLoad = Quickload()
					m_Quickload.Init()
				)
				
				ddl_PresetsLights.selection = iSelectionPresetsLight
				ddl_PresetsShader.selection = iSelectionPresetsMaterial
				
				Presets.Init &ddl_PresetsLights &ddl_PresetsShader &rollout_Presets &rollout_Lighting &rollout_Maps &rollout_Techniques
				Presets.LoadPresets "light"
				Presets.LoadPresets "material"
				
				CheckStateUI()
			)--End Event
			
			on rollout_Presets close do
			(
				iSelectionPresetsLight = ddl_PresetsLights.selection
				iSelectionPresetsMaterial = ddl_PresetsShader.selection
			)
		)--End Rollout rollout_Presets
		
		/* ==================================================================================================================PLUGIN ROLLOUTS : rollout_Lighting*/

		rollout rollout_Lighting "Lighting"
		(
			/* ==================================================================================================================ROLLOUT VARIABLES*/
			local ShadowTermDelegate = 0
			local shadowbuttonindex
			local ShadowedLight
			local vss 
			local tempEnvStr = 0.5
			
			local UILight1 = 0
			local UILight2 = 0
			local UILight3 = 0
			
			local offsetX = 35
			local Icon_Light = #("$Scripts\\XoliulShaderUI\\images\\icon_Light.png",undefined,2,2,1,2,1 )
			local Icon_Shadow = #("$Scripts\\XoliulShaderUI\\images\\icon_Shadow.png",undefined,2,1,2,1,2 )	
			local Icon_Refresh = #("$Scripts\\XoliulShaderUI\\images\\icon_Refresh.png",undefined,1,1,1,1,1 )
			
			dotnetcontrol imgT_Cubemap "system.windows.forms.picturebox" pos:[4,200] width:64 height:64
			
			dotnetcontrol imgT_Header_Environmentmap "system.windows.forms.picturebox" pos:[95,200] width:68 height:20 enabled:false
			
			dotnetcontrol imgT_Gradient "system.windows.forms.picturebox" pos:[4,113] width:64 height:64
			
			dotnetcontrol imgT_Header_Gradient "system.windows.forms.picturebox" pos:[95,113] width:68 height:20 enabled:false
			
			spinner spn_Gamma "" pos:[280,7] width:44 height:16 range:[0,10,1]
			dropdownList ddl_shadowType "" pos:[275,29] width:50 height:21 items:#("Hard", "Soft", "Area") selection:1 enabled:false
			spinner spn_ShadowIntensity "" pos:[280,57] width:44 height:16 range:[0,1,1] scale:0.01 enabled:false
			spinner spn_ShadowQuality "" pos:[280,83] width:44 height:16 range:[6,11,9] type:#integer enabled:false
			
			spinner spn_Multiplier1 "" pos:[116,31] width:44 height:16 type:#float enabled:false tooltip:"Multiplier of selected light"
			spinner spn_Multiplier2 "" pos:[116,57] width:44 height:16 type:#float enabled:false tooltip:"Multiplier of selected light"
			spinner spn_Multiplier3 "" pos:[116,83] width:44 height:16 type:#float enabled:false tooltip:"Multiplier of selected light"
			
			spinner spn_ShadedHudeAdjustment "" pos:[275,136] width:44 height:16 range:[0,2,0.3]
			spinner spn_HalflambertPower "" pos:[275,111] width:44 height:16 range:[0,10,2] enabled:false
			spinner spn_EnvCubeBlur "" pos:[120,187+36] width:44 height:16 range:[0,10,7.6] enabled:false
			spinner spn_EnvCubeStrength "" pos:[120,243] width:44 height:16 range:[0,10,0.5] scale:0.05 enabled:false
			spinner spn_CubeGamma "" pos:[275,243] width:44 height:16 range:[0,10,1] scale:0.05 enabled:false

			dropdownList ddl_Light1Pos "" pos:[27,29] width:90 height:21 tooltip:"Right Click on dropdownlist to select the specific light in the scene"
			dropdownList ddl_Light2Pos "" pos:[27,55] width:90 height:21 tooltip:"Right Click on dropdownlist to select the specific light in the scene"
			dropdownList ddl_Light3Pos "" pos:[27,81] width:90 height:21 tooltip:"Right Click on dropdownlist to select the specific light in the scene"
			checkbutton btn_LightOne "" pos:[5,28] width:21 height:21 images:Icon_Light
			checkbutton btn_LightTwo "" pos:[5,55] width:21 height:21 images:Icon_Light
			checkbutton btn_LightThree "" pos:[5,81] width:21 height:21 images:Icon_Light
			checkbutton btn_Shadow1 "" pos:[162,28] width:21 height:21 images:Icon_Shadow
			checkbutton btn_Shadow2 "" pos:[162,55] width:21 height:21 images:Icon_Shadow
			checkbutton btn_Shadow3 "" pos:[162,81] width:21 height:21 images:Icon_Shadow
			checkbox chk_HalfLambertShading "" pos:[260,111] width:16 height:16
			colorPicker cp_AmbientColor "" pos:[272,157] width:47 height:20
			button btn_Reload_IBLCubemap "R" pos:[72,200] width:20 height:20 images:Icon_Refresh
			button btn_Reload_Gradient "R" pos:[72,113] width:20 height:20 images:Icon_Refresh
			slider  sld_EnvRotation "" pos:[170,210] width:160 height:16 range:[-180,180,0] type:#integer orient:#horizontal ticks:18 enabled:false
			label lbl_GammaCorrection "Gamma Correction" pos:[190,7] width:88 height:16
			label lbl_ShadowType "Shadow Type" pos:[190,33] width:72 height:16 enabled:false
			label lbl_ShadowIntensity "Shadow Intensity" pos:[190,58] width:88 height:16 enabled:false
			label lbl_ShadowQuality "Shadow Quality" pos:[190,84] width:88 height:16 enabled:false
			
			label lbl_ShaderHueAdjustment "Shaded Hue" pos:[170,136] width:90 height:16
			label lbl_HalfLambertShading "Half Lambert" pos:[170,113] width:70 height:16
			label lbl_AmbientColor "Ambient Color" pos:[170,160] width:72 height:16
			label lbl_EnvRotation "Environment Rotation" pos:[190,200] width:110 height:15 enabled:false
			label lbl_AmbientCubeBlur "Env. Blur" pos:[72,188+36] width:45 height:16 enabled:false
			label lbl_AmbientCubeStrength "Env. Str." pos:[72,244] width:45 height:16 enabled:false
			label lbl_CubeGamma "Cubemap Gamma" pos:[170,244] width:90 height:16 enabled:false
			GroupBox grp_Shading "" pos:[2,101] width:322 height:85
			
			/* ==================================================================================================================ROLLOUT FUNCTIONS*/

			function SetShadowType item=
			(
				if (lights as array).count != 0 then
				(
					if not b_IsMax2009 and ShadowedLight != undefined then
					(
						if item == 1 then
						(
							m_Shadow1Type=0
							ShadowTermDelegate = &(delegate.__PlaceHolder_255_HardshadowTerm)
							
							if(ShadowedLight != undefined) then ShadowedLight.shadowGenerator = shadowMap()
							vss.ShadowMode = #Hard
							ViewportSSB.AreaShadow = false
							spn_ShadowQuality.enabled=false
							spn_ShadowQuality.value = 9
							lbl_ShadowQuality.enabled=false
							delegate.Shadow1Type = 0
						)
						if item == 2  then
						(
							m_Shadow1Type=1
							ShadowTermDelegate = &(delegate.__PlaceHolder_000_SoftshadowTerm)
							
							if(ShadowedLight != undefined) then ShadowedLight.shadowGenerator = shadowMap()
							vss.ShadowMode = #Soft
							ViewportSSB.AreaShadow = false
							spn_ShadowQuality.enabled=true
							spn_ShadowQuality.value = sqrt ViewportSSB.ShadowMapSize
							lbl_ShadowQuality.enabled=true
							delegate.Shadow1Type = 1
						)
						if item == 3 then
						(
							m_Shadow1Type=2
							ShadowTermDelegate = &(delegate.__PlaceHolder_000_AreashadowTerm)
							
							if(ShadowedLight != undefined) then ShadowedLight.shadowGenerator = Area_Shadows()
							vss.ShadowMode = #Soft
							ViewportSSB.AreaShadow = true
							spn_ShadowQuality.enabled=true
							spn_ShadowQuality.value = sqrt ViewportSSB.ShadowMapSize
							lbl_ShadowQuality.enabled=true
							delegate.Shadow1Type = 2
						)
					)
					else if b_IsMax2009 then
					(
						m_Shadow1Type=0
						ShadowTermDelegate = &(delegate.__PlaceHolder_HardshadowTerm)
						if(ShadowedLight != undefined) then ShadowedLight.shadowGenerator = shadowMap()
					)
				)
			)
			
			function UseShadow state=
			(
				if (lights as array).count != 0 then
				(
					if not b_IsMax2009 and ShadowedLight != undefined then
					(
						local rootPath = getDir #maxRoot
						if state then
						(
							ddl_shadowType.enabled = true
							spn_ShadowIntensity.enabled = true
							lbl_ShadowQuality.enabled=true
							lbl_ShadowType.enabled = true
							lbl_ShadowIntensity.enabled = true
							delegate.bUseShadow = true
							vss.ShadowsActive = true
							if(ShadowedLight != undefined) then ShadowedLight.baseObject.castShadows =true
							SetShadowType (ddl_ShadowType.selection)
						)
						else
						(
							ddl_ShadowType.enabled = false
							spn_ShadowIntensity.enabled = false
							spn_ShadowQuality.enabled=false
							lbl_ShadowType.enabled = false
							lbl_ShadowIntensity.enabled = false
							lbl_ShadowQuality.enabled=false
							delegate.bUseShadow = false
							vss.ShadowsActive = false
							if(ShadowedLight != undefined) then ShadowedLight.baseObject.castShadows = false
						)
					)
					else if b_IsMax2009 then
					(
						if state then
						(
							spn_ShadowIntensity.enabled = true
							lbl_ShadowIntensity.enabled = true
							delegate.bUseShadow = true
							if(ShadowedLight != undefined) then ShadowedLight.baseObject.castShadows =true
							if(ShadowedLight != undefined) then ShadowedLight.ViewportShadowCasting = true
							SetShadowType (0)
						)
						else
						(
							ddl_ShadowType.enabled = false
							spn_ShadowIntensity.enabled = false
							lbl_ShadowType.enabled = false
							lbl_ShadowIntensity.enabled = false
							delegate.bUseShadow = false
							
						)
					)
				)
			)--End Function
			
			function SetShadowDelegate delgt=
			(
				if btn_Shadow1.checked or btn_Shadow2.checked or btn_Shadow3.checked then SetShadowType ddl_shadowType.selection 
				if ShadowTermDelegate != 0 then *ShadowTermDelegate = delgt
			)
			
			on ddl_ShadowType selected item do
			(
				SetShadowType item
				if btn_Shadow1.checked then
				(
					if ddl_Light1Pos.selection != 1 then SetShadowDelegate (ddl_Light1Pos.selection-1)
				)
				if btn_Shadow2.checked then
				(
					if ddl_Light3Pos.selection != 1 then SetShadowDelegate (ddl_Light2Pos.selection-1)
				)	
				if btn_Shadow3.checked then
				(
					if ddl_Light3Pos.selection != 1 then SetShadowDelegate (ddl_Light3Pos.selection-1)
				)				
			)			
			
			function ChangeStateShadow pMainButton pButtonA pButtonB pLightPosDll pLightButton=
			(
				
				if pMainButton.checked and pLightButton.checked then
				(
					pButtonA.checked = false
					pButtonB.checked = false
					SetShadowDelegate (pLightPosDll.selection-1)
					ShadowedLight = getnodebyname(pLightPosDll.selected)
					UseShadow true
				)
				else
				(
					pMainButton.checked = false
					UseShadow false
				)
			)
			
			/* ==================================================================================================================ROLLOUT EVENTS*/
			
			on spn_ShadowQuality changed val do
			(
				ViewportSSB.ShadowMapSize = 2^val
			)
			
			function CountLightsUsed num=
			(
				num = 0
				
				if btn_LightOne.checked then num+=1
				if btn_LightTwo.checked then num+=1
				if btn_LightThree.checked then num+=1
				
				delegate.numberOfActiveLights = num
			)
			
			function SetLights x=
			(
				UILight1 = 0
				UILight2 = 0
				UILight3 = 0
				
				local templight = 0

				
				--fill UIlight vars according to checked buttons. should account for all situations
				if btn_LightOne.checked then 
				(
					UILight1 = ddl_Light1Pos.selection - 1
					if btn_LightTwo.checked then
					(
						UILight2 = ddl_Light2Pos.selection - 1
						if btn_LightThree.checked then
						(
							UILight3 = ddl_Light3Pos.selection - 1
							
							if btn_Shadow2.checked then
							(
								templight = UILight1
								UILight1 = UILight2
								UILight2 = templight
							)
							if btn_Shadow3.checked then
							(
								templight = UILight1
								UILight1 = UILight3
								UILight3 = templight
							)
						)
					)
					else
					(
						if btn_LightThree.checked then
						(
							UILight2 = ddl_Light3Pos.selection - 1
							
							if btn_Shadow3.checked then
							(
								templight = UILight1
								UILight1 = UILight2
								UILight2 = templight
							)
						)
					)
				)
				else
				(
					if btn_LightTwo.checked then
					(
						UILight1 = ddl_Light2Pos.selection - 1
						if btn_LightThree.checked then
						(
							UILight2 = ddl_Light3Pos.selection - 1
							if btn_Shadow3.checked then
							(
								templight = UILight1
								UILight1 = UILight2
								UILight2 = templight
							)
						)
					)
					else
					(
						if btn_LightThree.checked then
						(
							UILight1 = ddl_Light3Pos.selection - 1
						)
					)
				)
				
				CountLightsUsed CountLights
				
				delegate.light1_Position  = UILight1
				delegate.light2_Position  = UILight2
				delegate.light3_Position  = UILight3
				
			)--end fction	
			
			function UpdateLightLists=
			(
				collectionOmniLights = #("Default Light")
				--Here we are going to check on all the lights in the scene
				for item in Lights do
				(
					if classof item == Omnilight then append collectionOmniLights item.name
				)
				ddl_Light1Pos.items = collectionOmniLights
				ddl_Light2Pos.items = collectionOmniLights
				ddl_Light3Pos.items = collectionOmniLights
			)
			
			function OpenRollout_Lighting=
			(
				spn_Gamma.value = delegate.gamma
				spn_ShadowIntensity.value = delegate.Shadow1Strength
				spn_ShadedHudeAdjustment.value = delegate.HueAdjust
				chk_HalfLambertShading.state = delegate.bUseHalfLambert
				spn_HalflambertPower.enabled =  chk_HalfLambertShading.state
				cp_AmbientColor.color = delegate.ambientcolor
				spn_EnvCubeBlur.value = delegate.IBLBlur
				spn_EnvCubeStrength.value = delegate.IBLmultiplier
				sld_EnvRotation.value = delegate.EnvRotation
				spn_CubeGamma.value = delegate.CubeMapGamma
				
				--b_Toggle_Cubemap = (getAppData rootnode 17) as booleanClass
				
				imgT_Header_Environmentmap.image = bm_Header_Cubemap
				imgT_Header_Gradient.image = bm_Header_Gradient
				
				local ProgramVersion = maxVersion()
				
				b_IsMax2009 = true
				
				if ProgramVersion[1] >11000 then b_IsMax2009 = false
				
				if not b_IsMax2009 then
				(
					vss= maxops.getViewportShadingSettings()
				)
				
				if not b_IsMax2009 then spn_ShadowQuality.value = sqrt ViewportSSB.ShadowMapSize
				
				if b_CleanState == false then
				(
					if b_IsMax2009 then ShadowTermDelegate = &(delegate.__PlaceHolder_HardshadowTerm)
					else ShadowTermDelegate = &(delegate.__PlaceHolder_255_HardshadowTerm)
					UseShadow false
					b_CleanState = true
					
				)
				
				--get Shadow Button check states
				
				btn_Shadow1.checked = delegate.UseShadow1
				btn_Shadow2.checked = delegate.UseShadow2
				btn_Shadow3.checked = delegate.UseShadow3
				
				UpdateLightLists()
				
				--Here we assign the data to the checbuttons for the lights
				
				btn_LightOne.checked = delegate.UseLight1
				btn_LightTwo.checked = delegate.UseLight2
				btn_LightThree.checked = delegate.UseLight3
				
				
				ddl_Light1Pos.selection = delegate.light1_Position + 1
				if ddl_Light1Pos.selection == 0 then
				(
					btn_Shadow1.checked = false
					ddl_Light1Pos.selection = ddl_Light1Pos.items.count
				)
				ddl_Light2Pos.selection = delegate.light2_Position + 1
				if ddl_Light2Pos.selection == 0 then 
				(
					btn_Shadow2.checked = false
					ddl_Light2Pos.selection = ddl_Light2Pos.items.count
				)
				ddl_Light3Pos.selection = delegate.light3_Position + 1
				if ddl_Light3Pos.selection == 0 then
				(
					btn_Shadow3.checked = false
					ddl_Light3Pos.selection = ddl_Light1Pos.items.count
				)
				
				local tempLight =  getnodebyname ddl_Light1Pos.selected
				if tempLight != undefined then
				(
					spn_Multiplier1.value = tempLight.multiplier
					spn_Multiplier1.enabled = true
				)
				tempLight =  getnodebyname ddl_Light2Pos.selected
				if tempLight != undefined then
				(
					spn_Multiplier2.value = tempLight.multiplier
					spn_Multiplier2.enabled = true
				)
				tempLight =  getnodebyname ddl_Light3Pos.selected
				if tempLight != undefined then
				(
					spn_Multiplier3.value = tempLight.multiplier
					spn_Multiplier3.enabled = true
				)
				
				if not b_IsMax2009 then
					(
						if vss.ShadowMode == #Hard then 
						(
							ddl_Shadowtype.selection = 1
							SetShadowType 1
						)
						else if vss.ShadowMode == #Soft and not ViewportSSB.AreaShadow then 
						(
							ddl_Shadowtype.selection = 2
							SetShadowType 2
						)
						else if vss.ShadowMode == #Soft and ViewportSSB.AreaShadow then 
						(
							ddl_Shadowtype.selection = 3
							SetShadowType 3
						)	
					)
				else
					(
						ddl_Shadowtype.selection = 1
					)
				
				if  btn_Shadow1.checked and (lights as array).count != 0 then ShadowedLight = getnodebyname(ddl_Light1Pos.selected)
				if  btn_Shadow2.checked and (lights as array).count != 0 then ShadowedLight = getnodebyname(ddl_Light2Pos.selected)
				if  btn_Shadow3.checked and (lights as array).count != 0 then ShadowedLight = getnodebyname(ddl_Light3Pos.selected)
				
				if delegate.bUseShadow then
				(
					SetShadowType ddl_Shadowtype.selection
					UseShadow true
				)
				else UseShadow false
				
				--Reset Tooltips
				btn_Reload_IBLCubemap.tooltip = ""
				
				
				filePath_Cubemap = substring (delegate.Envcubemap as string) 8 1000
				
				if filePath_Cubemap == undefined or  filePath_Cubemap == "" or  filePath_Cubemap == "ed" then filePath_Cubemap =  bm_Filename
				else btn_Reload_IBLCubemap.tooltip = filePath_Cubemap
				
				
				btn_Reload_Gradient.tooltip = ""
				
				filePath_Gradient = substring (delegate.Gradientmap as string) 8 1000
				
				if filePath_Gradient == undefined or  filePath_Gradient == "" or  filePath_Gradient == "ed" then filePath_Gradient =  bm_Filename
				else btn_Reload_Gradient.tooltip = filePath_Gradient
				
				if ShaderReset then
				(
					--Reset the Shader
					
					filePath_Cubemap = bm_Filename
					filePath_Gradient = bm_Filename
				)
				
				b_Toggle_Cubemap = delegate.UseIBLambient
				
				b_Toggle_Gradient = delegate.UseGradientRamp
				
				
				if Presets != undefined then Presets.ApplyLightingMaps()
				
				if b_Toggle_Cubemap and b_EnableDC_Cubemap then
				(
					lbl_AmbientCubeBlur.enabled = true
					lbl_AmbientCubeStrength.enabled =true
					spn_EnvCubeBlur.enabled = true
					spn_EnvCubeStrength.enabled = true
					sld_EnvRotation.enabled = true
					lbl_EnvRotation.enabled = true
					lbl_CubeGamma.enabled = true
					spn_CubeGamma.enabled=true
				)
				else if not b_Toggle_Cubemap and b_EnableDC_Cubemap then
				(
					lbl_AmbientCubeBlur.enabled = false
					lbl_AmbientCubeStrength.enabled = false
					spn_EnvCubeBlur.enabled = false
					spn_EnvCubeStrength.enabled = false
					sld_EnvRotation.enabled = false
					lbl_EnvRotation.enabled = false
					lbl_CubeGamma.enabled = false
					spn_CubeGamma.enabled=false
				)
				
				SetLights 0
			
			)--End Function
			
			function CloseRollout_Lighting=
			(	
				--set Button states to delegate, these only serve for the UI and have no function other than that inside the delegate
				delegate.UseLight1 = btn_LightOne.checked
				delegate.UseLight2 = btn_LightTwo.checked
				delegate.UseLight3 = btn_LightThree.checked
				delegate.UseShadow1 = btn_Shadow1.checked
				delegate.UseShadow2 = btn_Shadow2.checked
				delegate.UseShadow3 = btn_Shadow3.checked
			)--End Function
			
			/* ==================================================================================================================ROLLOUT EVENTS*/
			
			on imgT_Cubemap MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then
				(
					if filePath_Cubemap == bm_Filename then
					(
							local bmT = bitmap 64 64
							bmT = selectBitMap()
							
							if not(bmT == undefined) then
							(					
								
								local ext = getfilenametype bmT.filename
								if ext != ".dds" then 
								(
									Messagebox( "Not a DDS file! You will get unexpected results!")
								)
								
								btn_Reload_IBLCubemap.tooltip = filePath_Cubemap
								bm_Cubemap = bmT
								filePath_Cubemap = bmT.filename
								b_EnableDC_Cubemap=true
								delegate.UseIBLambient=true
								b_Toggle_Cubemap = delegate.UseIBLambient
								
								local tempRefOnOffImage = bm_OnOff_Cubemap
								tempRefOnOffImage.v1 = CreateOffImage bmT
								tempRefOnOffImage.v2 = CreateOnImage bmT
								
								local tempBitmap = bm_OnOff_Cubemap
								local tempImageClass = dotnetclass "System.Drawing.Image"
							
								imgT_Cubemap.image = tempImageClass.FromFile tempBitmap.v2
								btn_Reload_IBLCubemap.tooltip = filePath_Cubemap
								
								delegate.Envcubemap  = openbitmap filePath_Cubemap
								
								--UI
							
								lbl_AmbientCubeBlur.enabled = true
								lbl_AmbientCubeStrength.enabled = true
								spn_EnvCubeBlur.enabled = true
								spn_EnvCubeStrength.enabled = true
								sld_EnvRotation.enabled = true
								lbl_EnvRotation.enabled = true
								lbl_CubeGamma.enabled = true
								spn_CubeGamma.enabled=true
							)
					)
					else if b_EnableDC_Cubemap then
					(
						local tempBitmap = bm_OnOff_Cubemap
						local tempImageClass = dotnetclass "System.Drawing.Image"
						if b_Toggle_Cubemap then --there was some confusion in this code, stuff flipped around, mainly code was half disabling and half enabling. I cleared it up, works fine now -L
						(
							delegate.UseIBLambient=false
							
							imgT_Cubemap.image = tempImageClass.FromFile tempBitmap.v1
							btn_Reload_IBLCubemap.tooltip = filePath_Cubemap
							b_Toggle_Cubemap =false
							
							--UI
							
							lbl_AmbientCubeBlur.enabled = false
							lbl_AmbientCubeStrength.enabled =false
							spn_EnvCubeBlur.enabled = false
							spn_EnvCubeStrength.enabled = false
							sld_EnvRotation.enabled = false
							lbl_EnvRotation.enabled = false
							lbl_CubeGamma.enabled = false
							spn_CubeGamma.enabled=false
						)
						else
						(
							delegate.UseIBLambient=true
							
							imgT_Cubemap.image = tempImageClass.FromFile tempBitmap.v2
							btn_Reload_IBLCubemap.tooltip = ""
							b_Toggle_Cubemap = true
							
							--UI
							
							lbl_AmbientCubeBlur.enabled = true
							lbl_AmbientCubeStrength.enabled = true
							spn_EnvCubeBlur.enabled = true
							spn_EnvCubeStrength.enabled = true
							sld_EnvRotation.enabled = true
							lbl_EnvRotation.enabled = true
							lbl_CubeGamma.enabled = true
							spn_CubeGamma.enabled=true
						)
					)
				)--End if
				
				if _arg.Button == _arg.Button.Right then
				(
					if  b_EnableDC_Cubemap then
					(
						local bmT = bitmap 50 50
						bmT = selectBitMap()
						
						if not(bmT == undefined) then
						(
							filePath_Cubemap = bmT.filename
							local ext = getfilenametype bmT.filename
							if ext != ".dds" then
							(
								messageBox("Not a DDS file! You will get unexpected results!\nDo you still want to continue?")
							)
								btn_Reload_IBLCubemap.tooltip = filePath_Cubemap
								local tempRefOnOffImage = bm_OnOff_Cubemap
								tempRefOnOffImage.v1 = CreateOffImage bmT
								tempRefOnOffImage.v2 = CreateOnImage bmT							
								local tempImageClass = dotnetclass "System.Drawing.Image"
								bm_Cubemap = bmT
								filePath_Cubemap = bmT.filename
								delegate.Envcubemap  = openbitmap filePath_Cubemap						
								imgT_Cubemap.image = tempImageClass.FromFile tempRefOnOffImage.v2
						)
					)--End if
				)--End f
				if _arg.Button == _arg.Button.Middle and b_EnableDC_Cubemap == true then rollout_ImagePreview.Init &filePath_Cubemap
			)--End Event on imgT_IBLCubemap click do
			
			on imgT_Gradient MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then
				(
					if filePath_Gradient == bm_Filename then
					(
							local bmT = bitmap 64 64
							bmT = selectBitMap()
							
							if not(bmT == undefined) then
							(					
								
							
								
								btn_Reload_Gradient.tooltip = filePath_Gradient
								bm_Gradient = bmT
								filePath_Gradient = bmT.filename
								b_EnableDC_Gradient=true
								delegate.UseGradientRamp=true
								b_Toggle_Gradient = delegate.UseGradientRamp
								
								local tempRefOnOffImage = bm_OnOff_Gradient
								tempRefOnOffImage.v1 = CreateOffImage bmT
								tempRefOnOffImage.v2 = CreateOnImage bmT
								
								local tempBitmap = bm_OnOff_Gradient
								local tempImageClass = dotnetclass "System.Drawing.Image"
							
								imgT_Gradient.image = tempImageClass.FromFile tempBitmap.v2
								btn_Reload_Gradient.tooltip = filePath_Gradient
								
								delegate.Gradientmap  = openbitmap filePath_Gradient
								
							)
					)
					else if b_EnableDC_Gradient then
					(
						local tempBitmap = bm_OnOff_Gradient
						local tempImageClass = dotnetclass "System.Drawing.Image"
						if b_Toggle_Gradient then --there was some confusion in this code, stuff flipped around, mainly code was half disabling and half enabling. I cleared it up, works fine now -L
						(
							delegate.UseGradientRamp=false
							
							imgT_Gradient.image = tempImageClass.FromFile tempBitmap.v1
							btn_Reload_Gradient.tooltip = filePath_Gradient
							b_Toggle_Gradient =false

						)
						else
						(
							delegate.UseGradientRamp=true
							
							imgT_Gradient.image = tempImageClass.FromFile tempBitmap.v2
							btn_Reload_Gradient.tooltip = ""
							b_Toggle_Gradient = true
							
						)
					)
				)--End if
				
				if _arg.Button == _arg.Button.Right then
				(
					if  b_EnableDC_Gradient then
					(
						local bmT = bitmap 50 50
						bmT = selectBitMap()
						
						if not(bmT == undefined) then
						(
							filePath_Gradient = bmT.filename
								btn_Reload_Gradient.tooltip = filePath_Gradient
								local tempRefOnOffImage = bm_OnOff_Gradient
								tempRefOnOffImage.v1 = CreateOffImage bmT
								tempRefOnOffImage.v2 = CreateOnImage bmT							
								local tempImageClass = dotnetclass "System.Drawing.Image"
								bm_Gradient = bmT
								filePath_Gradient = bmT.filename
								delegate.Gradientmap  = openbitmap filePath_Gradient						
								imgT_Gradient.image = tempImageClass.FromFile tempRefOnOffImage.v2
						)
					)--End if
				)--End f
				if _arg.Button == _arg.Button.Middle and b_EnableDC_Gradient == true then rollout_ImagePreview.Init &filePath_Gradient
			)--End Event on imgT_Gradient click do

			on btn_Shadow1 changed state do 
			(
				if ddl_Light1Pos.selection != 1 then
				(
					if state then 
					(
						ShadowedLight = getnodebyname(ddl_Light1Pos.selected)
						SetShadowDelegate (ddl_Light1Pos.selection-1)		
						shadowbuttonindex = (ddl_Light1Pos.selection-1)	
					)
					
					ChangeStateShadow btn_Shadow1 btn_Shadow2 btn_Shadow3 ddl_Light1Pos btn_LightOne
					SetLights 0
				)
				else btn_Shadow1.checked = false
			)
			on btn_Shadow2 changed state do 
			(
				if ddl_Light2Pos.selection != 1 then
				(
					if state then 
					(
						ShadowedLight = getnodebyname(ddl_Light2Pos.selected)
						SetShadowDelegate (ddl_Light2Pos.selection-1)
						shadowbuttonindex = (ddl_Light2Pos.selection-1)	
					)
					ChangeStateShadow btn_Shadow2 btn_Shadow1 btn_Shadow3 ddl_Light2Pos btn_LightTwo
					SetLights 0
				)
				else btn_Shadow2.checked = false
			
			)
			on btn_Shadow3 changed state do 
			(
				if ddl_Light3Pos.selection != 1 then
				(
					if state then 
					(
						ShadowedLight = getnodebyname(ddl_Light3Pos.selected)
						SetShadowDelegate (ddl_Light3Pos.selection-1)
						shadowbuttonindex = (ddl_Light3Pos.selection-1)	
					)
					ChangeStateShadow btn_Shadow3 btn_Shadow1 btn_Shadow2 ddl_Light3Pos btn_LightThree
					SetLights 0
				)
				else btn_Shadow3.checked = false
				
			)
			
			on ddl_Light1Pos selected state do
			(
				SetLights 0
				if btn_Shadow1.checked then SetShadowDelegate (ddl_Light1Pos.selection-1)
				if ddl_Light1Pos.selection != 1 then
				(
					spn_Multiplier1.enabled = true
					local tempLight = ddl_Light1Pos.selected
					tempLight = getnodebyname tempLight
					spn_Multiplier1.value = tempLight.multiplier
				)
				else
				(
					btn_Shadow1.checked = false
					spn_Multiplier1.enabled = false
				)
			)
			on ddl_Light2Pos selected state do 
			(
				SetLights 0
				if btn_Shadow2.checked then SetShadowDelegate (ddl_Light2Pos.selection-1)
				if ddl_Light2Pos.selection != 1 then
				(
					spn_Multiplier2.enabled = true
					local tempLight = ddl_Light2Pos.selected
					tempLight = getnodebyname tempLight
					spn_Multiplier2.value = tempLight.multiplier
				)
				else
				(
					btn_Shadow2.checked = false
					spn_Multiplier2.enabled = false
				)
			)
			on ddl_Light3Pos selected state do
			(
				SetLights 0
				if btn_Shadow3.checked then SetShadowDelegate (ddl_Light3Pos.selection-1)
				if ddl_Light3Pos.selection != 1 then
				(
					spn_Multiplier3.enabled = true
					local tempLight = ddl_Light3Pos.selected
					tempLight = getnodebyname tempLight
					spn_Multiplier3.value = tempLight.multiplier
				)
				else
				(
					btn_Shadow3.checked = false
					spn_Multiplier3.enabled = false
				)
			)
			on btn_LightOne changed theState do	
			(
				SetLights 0
			)
			on btn_LightTwo changed theState do	
			(
				SetLights 0
			)
			on btn_LightThree changed theState do	
			(
				SetLights 0
			)
			
			--Multiplierspinners for lights
			on spn_Multiplier1 changed _arg do
			(
				local tempLight = ddl_Light1Pos.selected
				tempLight = getnodebyname tempLight
				tempLight.multiplier = _arg
			)
			on spn_Multiplier2 changed _arg do
			(
				local tempLight = ddl_Light2Pos.selected
				tempLight = getnodebyname tempLight
				tempLight.multiplier = _arg
			)
			on spn_Multiplier3 changed _arg do
			(
				local tempLight = ddl_Light3Pos.selected
				tempLight = getnodebyname tempLight
				tempLight.multiplier = _arg
			)
			
			on btn_LightOne rightclick do
			(
				local tempLight = ddl_Light1Pos.selected
				tempLight = getnodebyname tempLight
				if tempLight != undefined then 
				(
					tempcolor = colorPickerDlg tempLight.rgb ("Change the color of the light " + tempLight.name)
					if tempcolor != undefined then tempLight.rgb = tempcolor
				)
			)
			on btn_LightTwo rightclick do
			(
				local tempLight = ddl_Light2Pos.selected
				tempLight = getnodebyname tempLight
				if tempLight != undefined then 
				(
					tempcolor = colorPickerDlg tempLight.rgb ("Change the color of the light " + tempLight.name)
					if tempcolor != undefined then tempLight.rgb = tempcolor
				)
			)
			on btn_LightThree rightclick do
			(
				local tempLight = ddl_Light3Pos.selected
				tempLight = getnodebyname tempLight
				if tempLight != undefined then 
				(
					tempcolor = colorPickerDlg tempLight.rgb ("Change the color of the light " + tempLight.name)
					if tempcolor != undefined then tempLight.rgb = tempcolor
				)
			)
			
			on ddl_Light1Pos rightclick do
			(
				local tempLight = ddl_Light1Pos.selected
				tempLight = getnodebyname tempLight
				if tempLight != undefined then select tempLight
			)
			on ddl_Light2Pos rightclick do
			(
				local tempLight = ddl_Light2Pos.selected
				tempLight = getnodebyname tempLight
				if tempLight != undefined then select tempLight
			)
			on ddl_Light3Pos rightclick do
			(
				local tempLight = ddl_Light3Pos.selected
				tempLight = getnodebyname tempLight
				if tempLight != undefined then select tempLight
			)
			
			on btn_Reload_IBLCubemap pressed do RefreshImage imgT_Cubemap &bm_IBLCubemap &b_EnableDC_Cubemap &b_Toggle_Cubemap &(delegate.Envcubemap) &bm_OnOff_Cubemap  &filePath_Cubemap
			on rollout_Lighting open do OpenRollout_Lighting()
			on rollout_Lighting close do CloseRollout_Lighting()
			
			on sld_EnvRotation changed rot do delegate.EnvRotation = rot 
			on sld_EnvRotation rightClick do 
			(
				delegate.EnvRotation = 0
				sld_EnvRotation.value = 0
			)--End Event
			
			on chk_HalfLambertShading changed state do
			(
				spn_HalflambertPower.enabled = state
			)--End Event
					
		)--End Rolllout rollout_Lighting		
		
		/* ==================================================================================================================PLUGIN ROLLOUTS : rollout_Maps*/
		
		rollout rollout_Maps "Materials"
		(	
			/* ==================================================================================================================ROLLOUT VARIABLES*/
			local b_CleanStart=true
			local Icon_Refresh = #("$Scripts\\XoliulShaderUI\\images\\icon_Refresh.png",undefined, 1,1,1,1,1 )
			local posX = 12
			local poxY = 300
			local posx2 = 170
			
			dotnetcontrol imgT_Diffuse "system.windows.forms.picturebox" pos:[4,73] width:64 height:64 toolTip:"Click on the button to use the map or double click to load a bitmap"
			dotnetcontrol imgT_Specular "system.windows.forms.picturebox" pos:[170,5] width:64 height:64 toolTip:"Click on the button to use the map or double click to load a bitmap"
			dotnetcontrol imgT_Glossiness "system.windows.forms.picturebox" pos:[170,75] width:64 height:64 toolTip:"Click on the button to use the map or double click to load a bitmap"
			dotnetcontrol imgT_SelfIllum "system.windows.forms.picturebox" pos:[170,232] width:64 height:64 toolTip:"Click on the button to use the map or double click to load a bitmap"
			dotnetcontrol imgT_Normal "system.windows.forms.picturebox" pos:[170,145] width:64 height:64 toolTip:"Click on the button to use the map or double click to load a bitmap"
			dotnetcontrol imgT_ReflectMap "system.windows.forms.picturebox" pos:[posx2,100+poxY] width:64 height:64 toolTip:"Click on the button to use the map or double click to load a bitmap"
			
			dotnetcontrol imgT_HeaderMaps "system.windows.forms.picturebox" pos:[4,5] width:160 height:34 enabled:true
			dotnetcontrol imgT_Header_Specular "system.windows.forms.picturebox" pos:[280,5] width:44 height:20 enabled:false
			dotnetcontrol imgT_Header_Glossiness "system.windows.forms.picturebox" pos:[255,76] width:68 height:20 enabled:false
			dotnetcontrol imgT_Header_Normal "system.windows.forms.picturebox" pos:[255,145] width:68 height:20 enabled:false
			dotnetcontrol imgT_Header_SelfIllum "system.windows.forms.picturebox" pos:[255,232] width:68 height:20 enabled:false
			dotnetcontrol imgT_Header_Diffuse "system.windows.forms.picturebox" pos:[115,73] width:44 height:20 enabled:false
			dotnetcontrol imgT_Header_Reflect "system.windows.forms.picturebox" pos:[256,100+poxY] width:68 height:20 enabled:false
			
			checkbutton btn_FresnelReflections "On" pos:[12,13+poxY] width:24 height:24
			checkbox chk_ColorDifMap "Checkbox" pos:[147,121] width:12 height:12
			checkbox chk_EnableAlphaChannel "Checkbox" pos:[145,249] width:12 height:12
			checkbox chk_FlipGreen "Checkbox" pos:[310,193] width:12 height:12
			checkbox chk_ObjectSpace "Checkbox" pos:[310,173] width:12 height:12
			checkbox chk_OpacityAffectsReflections "" pos:[posx+102,100+poxY] width:12 height:12 enabled:false
			checkbox chk_UseGlossmapForBlur "" pos:[posx2+111,80+poxY] width:12 height:12 enabled:false
			colorPicker cp_Diffuse "" pos:[90,73] width:24 height:20
			colorPicker cp_DifFresnelC "" pos:[113,149] width:46 height:20 color:(color 0 0 155) enabled:false
			colorPicker cp_Specular "" pos:[255,5] width:24 height:20 color:(color 0 0 155)
			colorPicker cp_FresnelReflections "" pos:[40,13+poxY] width:28 height:24 color:(color 0 0 155) title:"Rim Color" enabled:false
			spinner spn_DifMapChannel "" pos:[130,101] width:30 height:16 range:[1,100,1] type:#integer
			spinner spn_VertCStrength "" pos:[115,220] width:44 height:16 range:[0,2,0] type:#float
			spinner spn_diffuseFresnelPower "" pos:[115,174] width:44 height:16 range:[0,100,3] type:#float enabled:false
			spinner spn_FreshnelMultiplier "" pos:[115,194] width:44 height:16 range:[0,100,0] type:#float
			spinner spn_GlobalOpacityLevel "" pos:[115,270] width:44 height:16 range:[0,1,1] type:#float scale:0.05
			spinner spn_SpecGlobalLevel "" pos:[280,33] width:44 height:16 range:[0,20,1] type:#float scale:0.01
			spinner spn_GlossMax "" pos:[278,104] width:45 height:16 range:[0,200,25] type:#float scale:0.1
			spinner spn_GlossMin "" pos:[278,124] width:45 height:16 range:[0,200,10] type:#float scale:0.1 enabled:false
			spinner spn_SIMultiply "" pos:[284,260] width:40 height:16 range:[0,10,1] type:#float scale:0.01
			spinner spn_FresnelPower "" pos:[posx+100,40+poxY] width:44 height:16 range:[0,100,3] enabled:false
			spinner spn_FresnelBias "" pos:[posx+100,80+poxY] width:44 height:16 range:[0,1,0] scale:0.001 enabled:false
			spinner spn_FresnelMultiplier "" pos:[posx+100,60+poxY] width:44 height:16 range:[0,100,2] enabled:false
			spinner spn_FresnelMaskHardness "" pos:[posx2+110,40+poxY] width:40 height:16 range:[0,200,4] enabled:false
			spinner spn_CubemapBlur "" pos:[posx2+110,60+poxY] width:40 height:16 range:[0,10,0] enabled:false
			spinner spn_normalMapChannel "" pos:[278,212] width:44 height:16 range:[1,100,1] type:#integer
			button btn_Reload_Diffuse "R" pos:[72,73] width:20 height:20 images:Icon_Refresh
			button btn_Reload_Specular "R" pos:[237,5] width:20 height:20 images:Icon_Refresh
			button btn_Reload_Glossiness "R" pos:[237,76] width:20 height:20 images:Icon_Refresh
			button btn_Reload_Normal "R" pos:[237,145] width:20 height:20 images:Icon_Refresh
			button btn_Reload_SelfIllumination "R" pos:[237,232] width:20 height:20 images:Icon_Refresh
			button btn_Reload_ReflectMap "R" pos:[posx2+66,100+poxY] width:20 height:20 images:Icon_Refresh enabled:false
			button btn_Quickload "Quickload" pos:[4,44] width:52 height:24 toolTip:"Load Images with one Click"
			button btn_Setup "Setup" pos:[58,44] width:52 height:24 toolTip:"Setup Filenames for Quickload"
			button btn_BrowseImages "Browse" pos:[112,44] width:52 height:24 toolTip:"Browe Images Folder"
			label lbl_GlobalOpacityLevel "Global Opacity Level" pos:[12,270] width:105 height:16
			label lbl_DifMapChannel "Map Chan" pos:[72,101] width:50 height:16
			label lbl_VertCStrength "Vert Color Str." pos:[19,220] width:80 height:16
			label lbl_ColorDifMap "Color Dif Map" pos:[72,121] width:67 height:16
			label lbl_DifFresnelC "Dif Fresnel Color" pos:[12,151] width:80 height:16 enabled:false
			label lbl_DiffuseFresnelPower "Fresnel Power" pos:[12,174] width:84 height:16 enabled:false
			label lbl_DifFresnelMultiplier "Fresnel Multiplier" pos:[12,194] width:84 height:16
			label lbl_SIMultiply "Strength" pos:[237,260] width:45 height:16
			label lbl_ObjectSpace "Object Space" pos:[237,173] width:70 height:16
			label lbl_FlipGreen "Flip Green" pos:[237,193] width:70 height:16
			label lbl_GlossMin "Min" pos:[237,124] width:30 height:16 enabled:false
			label lbl_SpecGlobalLevel "Strength" pos:[237,33] width:42 height:16
			label lbl_GlossLevel "Max" pos:[237,104] width:30 height:16
			label lbl_NormalMapChannel "Normal Map Channel" pos:[170,212] width:110 height:16
			label lbl_EnableAlphaChannel "Enable Alpha Channel" pos:[12,249] width:107 height:16
			label lbl_opacityAffectsReflections "Opaque Reflections" pos:[12,100+poxY] width:100 height:15 enabled:false
			label lbl_FresnelPower "Fresnel Power" pos:[posX,40+poxY] width:68 height:15 enabled:false
			label lbl_FresnelBias "Fresnel Bias" pos:[posX,80+poxY] width:80 height:15 enabled:false
			label lbl_fresnelMultiplier "Fresnel Multiplier" pos:[posX,60+poxY] width:80 height:15 enabled:false
			label lbl_FresnelMaskHardness "Reflection Hardness" pos:[posX2,40+poxY] width:105 height:15 enabled:false
			label lbl_ReflType "Reflection Type" pos:[80,17+poxY] width:80 height:15 enabled:false
			label lbl_UseGlossmapForBlur "Use Glossmap for Blur" pos:[posx2,80+poxY] width:104 height:15 enabled:false
			label lbl_CubemapBlur "Cubemap Blur" pos:[posx2,60+poxY] width:70 height:15 enabled:false
			GroupBox grpdiffuse "" pos:[4,138] width:160 height:77
			GroupBox grpopacity "" pos:[4,235] width:160 height:61
			groupBox grpfresnel "Reflections" pos:[4,-1+poxY] width:320 height:171 enabled:false			
			dropdownList ddl_ReflectType "" pos:[168,15+poxY] width:153 height:21 items:#("Soft", "Hard", "Cubemap") enabled:false
			
			/* ==================================================================================================================ROLLOUT FUNCTIONS*/
			
			function LoadMaterialImages=
			(	
				filePath_Diffuse = (delegate.diffuseMap as string)
				filePath_Specular = (delegate.specularMap as string)
				filePath_Glossiness = (delegate.glossMap as string)
				filePath_Normal = (delegate.normalMap as string)
				filePath_SelfIllum = (delegate.siMap as string)
				filePath_ReflectMap = (delegate.ReflMap as string)
				
				
				if filePath_Diffuse == undefined or  filePath_Diffuse == "" or  filePath_Diffuse == "undefined"  then filePath_Diffuse =  bm_Filename
				else filePath_Diffuse = substring (delegate.diffuseMap as string) 8 1000
				if filePath_Specular == undefined or  filePath_Specular == "" or  filePath_Specular == "undefined" then filePath_Specular =  bm_Filename
				else filePath_Specular = substring (delegate.specularMap as string) 8 1000
				if filePath_Glossiness == undefined or  filePath_Glossiness == "" or  filePath_Glossiness == "undefined"  then filePath_Glossiness =  bm_Filename
				else filePath_Glossiness = substring (delegate.glossMap as string) 8 1000
				if filePath_Normal == undefined or  filePath_Normal == "" or filePath_Normal == "undefined"  then filePath_Normal =  bm_Filename
				else filePath_Normal = substring (delegate.normalMap as string) 8 1000
				if filePath_SelfIllum == undefined or  filePath_SelfIllum == "" or  filePath_SelfIllum == "undefined"  then filePath_SelfIllum =  bm_Filename
				else filePath_SelfIllum = substring (delegate.siMap as string) 8 1000
				if filePath_ReflectMap == undefined or  filePath_ReflectMap == "" or  filePath_ReflectMap == "undefined"  then filePath_ReflectMap =  bm_Filename
				else filePath_ReflectMap = substring (delegate.ReflMap as string) 8 1000
				
				if ShaderReset then
				(
					--Reset the Shader
					filePath_Diffuse = bm_Filename
					filePath_Specular = bm_Filename
					filePath_Glossiness = bm_Filename
					filePath_Normal = bm_Filename
					filePath_SelfIllum = bm_Filename
					filePath_ReflectMap = bm_Filename
					
					ShaderReset = false
				)				
				
				--We now must load in all the new images in the map slots
				Presets.ApplyMaterialsMaps()
				
				imgT_HeaderMaps.image = bm_HeaderMaps
				imgT_Header_Diffuse.image = bm_Header_Diffuse
				imgT_Header_Specular.image = bm_Header_Specular
				imgT_Header_Glossiness.image = bm_Header_Glossiness
				imgT_Header_Normal.image = bm_Header_Normal
				imgT_Header_SelfIllum.image = bm_Header_SelfIllum
				imgT_Header_Reflect.image = bm_Header_Reflect
			)--End Function
			
			function BackupMaterialImages=
			(
				bm_Diffuse = imgT_Diffuse.image
				bm_Specular = imgT_Specular.image
				bm_Glossiness = imgT_Glossiness.image
				bm_Normal = imgT_Normal.image
				bm_SelfIllum = imgT_SelfIllum.image
				bm_ReflectMap = imgT_ReflectMap.image
			)--End Function
			
			function OnClickIMGtag pBitmap pImgBitmap pEnableDC pToggle pMapBool pMap pOnOffImage pFilename pReloadButton=
			(
				local tempBitmap = *pBitmap
				local tempReloadBtn = (*pReloadButton)
				if *pFilename == bm_Filename  then
				(
					local bmT = bitmap 64 64
					bmT = selectBitMap()
					
					if not(bmT == undefined) then
					(					
						*pBitmap = bmT
						*pEnableDC = true
						*pFilename = bmT.filename
						
						local tempRefOnOffImage = *pOnOffImage
						tempRefOnOffImage.v1 = CreateOffImage bmT
						tempRefOnOffImage.v2 = CreateOnImage bmT
						
						local tempBitmap = *pOnOffImage
						local tempImageClass = dotnetclass "System.Drawing.Image"
						
						*pMapBool = true
						*pMap  = openBitMap (*pFilename)
						pImgBitmap.image =  tempImageClass.FromFile tempBitmap.v2
						tempReloadBtn.tooltip = (*pFilename)
					)
				)--End if
				else if *pEnableDC then
				(
					local tempBitmap = *pOnOffImage
					local tempImageClass = dotnetclass "System.Drawing.Image"
					if *pToggle then
					(
						*pMapBool = true
						*pMap  = openBitMap (*pFilename)
						pImgBitmap.image =  tempImageClass.FromFile tempBitmap.v2
						*pToggle = false
						tempReloadBtn.tooltip = (*pFilename)
					)
					else
					(
						*pMapBool = false
						pImgBitmap.image =  tempImageClass.FromFile tempBitmap.v1
						*pToggle = true
						tempReloadBtn.tooltip = ""
					)
				)--End if
			)--End Function
			
			function OnRightClickIMGtag pEnableDC pBm pIMG pMap pBool pOnOffImage pFilename pReloadButton=
			(
				if *pEnableDC then
				(
					local bmT = bitmap 64 64
					bmT = selectBitMap()
					
					if not(bmT == undefined) then
					(					
						*pBm = bmT
						*pMap = bmT
						*pFilename = bmT.filename
						local tempReloadBtn = (*pReloadButton)
						tempReloadBtn.tooltip = bmT.filename
						
						local tempRefOnOffImage = *pOnOffImage
						tempRefOnOffImage.v1 = CreateOffImage bmT
						tempRefOnOffImage.v2 = CreateOnImage bmT
						
						local tempImageClass = dotnetclass "System.Drawing.Image"
						local tempBitmap = *pOnOffImage
						
						--Preview
						if *pBool == false then
							pIMG.image = tempImageClass.FromFile tempBitmap.v1
						else
							pIMG.image = tempImageClass.FromFile tempBitmap.v2
					)--End if
				)--End if
			)--End Function
			
			/* ==================================================================================================================ROLLOUT EVENTS*/

			--Refresh Buttons for the images
			on btn_Reload_Diffuse pressed do RefreshImage imgT_Diffuse &bm_Diffuse &b_EnableDC_Diffuse &b_Toggle_Diffuse &(delegate.diffuseMap) &bm_OnOff_Diffuse &filePath_Diffuse
			on btn_Reload_Specular pressed do RefreshImage imgT_Specular &bm_Specular &b_EnableDC_Specular &b_Toggle_Specular &(delegate.specularMap) &bm_OnOff_Specular &filePath_Specular
			on btn_Reload_Glossiness pressed do RefreshImage imgT_Glossiness &bm_Glossiness &b_EnableDC_Glossiness &b_Toggle_Glossiness &(delegate.glossMap) &bm_OnOff_Glossiness &filePath_Glossiness
			on btn_Reload_Normal pressed do RefreshImage imgT_Normal &bm_Normal &b_EnableDC_Normal &b_Toggle_Normal &(delegate.normalMap) &bm_OnOff_Normal &filePath_Normal
			on btn_Reload_SelfIllumination pressed do RefreshImage imgT_SelfIllum &bm_SelfIllum &b_EnableDC_SelfIllum &b_Toggle_SelfIllumination &(delegate.siMap) &bm_OnOff_SelfIllum &filePath_SelfIllum
			on btn_Reload_Reflectmap pressed do RefreshImage imgT_ReflectMap &bm_ReflectMap &b_EnableDC_Reflect &b_Toggle_ReflectMap &(delegate.ReflMap) &bm_OnOff_Reflectmap &filePath_ReflectMap
			
			--Quickload Buttons
			on btn_Quickload pressed do m_QuickLoad.RunQuickload()
			on btn_Setup pressed do m_QuickLoad.SetupQuickload()
			on btn_BrowseImages pressed do m_QuickLoad.BrowseQuickload()
			
			function FresnelUIActivation FresnelActive=
			(
				if FresnelActive == true then
				(
					cp_FresnelReflections.enabled=true
					chk_OpacityAffectsReflections.enabled=true
					chk_UseGlossmapForBlur.enabled=true
					ddl_ReflectType.enabled=true
					if ddl_ReflectType.selection == 1 or ddl_ReflectType.selection == 2 then
					(
						lbl_CubemapBlur.enabled=false
						spn_CubemapBlur.enabled=false
						lbl_UseGlossmapForBlur.enabled=false
						chk_UseGlossmapForBlur.enabled=false
						lbl_FresnelMaskHardness.enabled=true
						spn_FresnelMaskHardness.enabled=true
					)
					else if ddl_ReflectType.selection == 3 then
					(
						lbl_CubemapBlur.enabled=true
						spn_CubemapBlur.enabled=true
						lbl_UseGlossmapForBlur.enabled=true
						chk_UseGlossmapForBlur.enabled=true
						lbl_FresnelMaskHardness.enabled=false
						spn_FresnelMaskHardness.enabled=false
					)
				
					spn_FresnelPower.enabled=true
					spn_FresnelBias.enabled=true
					spn_FresnelMultiplier.enabled=true
					btn_Reload_ReflectMap.enabled=true
					lbl_opacityAffectsReflections.enabled=true
					lbl_FresnelPower.enabled=true
					lbl_FresnelBias.enabled=true
					lbl_fresnelMultiplier.enabled=true
					lbl_ReflType.enabled=true
					
					imgT_ReflectMap.enabled=true
 					setProperty imgT_ReflectMap "enabled" true
				)
				else
				(
					cp_FresnelReflections.enabled=false
					chk_OpacityAffectsReflections.enabled=false
					chk_UseGlossmapForBlur.enabled=false
					ddl_ReflectType.enabled=false
					lbl_CubemapBlur.enabled=false
					spn_CubemapBlur.enabled=false
					lbl_UseGlossmapForBlur.enabled=false
					chk_UseGlossmapForBlur.enabled=false
					lbl_FresnelMaskHardness.enabled=false
					spn_FresnelMaskHardness.enabled=false
					spn_FresnelPower.enabled=false
					spn_FresnelBias.enabled=false
					spn_FresnelMultiplier.enabled=false
					btn_Reload_ReflectMap.enabled=false
					lbl_opacityAffectsReflections.enabled=false
					lbl_FresnelPower.enabled=false
					lbl_FresnelBias.enabled=false
					lbl_fresnelMultiplier.enabled=false
					lbl_ReflType.enabled=false
					
					imgT_ReflectMap.enabled=false
 					setProperty imgT_ReflectMap "enabled" false
				)
			)
			
			on btn_FresnelReflections changed FresnelActive do
			(
				FresnelUIActivation FresnelActive
			)
			
			--HELPFILE CHM
			
			on imgT_HeaderMaps MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then ShellLaunch helpFileLocation ""
			)
				
			
			on imgT_Diffuse MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then OnClickIMGtag &bm_Diffuse imgT_Diffuse &b_EnableDC_Diffuse &b_Toggle_Diffuse &(delegate.bUseDiffuseMap) &(delegate.diffuseMap) &bm_OnOff_Diffuse &filePath_Diffuse &btn_Reload_Diffuse
				if _arg.Button == _arg.Button.Right then OnRightClickIMGtag &b_EnableDC_Diffuse &bm_Diffuse imgT_Diffuse &(delegate.diffuseMap) &(delegate.bUseDiffuseMap) &bm_OnOff_Diffuse &filePath_Diffuse &btn_Reload_Diffuse
				if _arg.Button == _arg.Button.Middle and b_EnableDC_Diffuse == true then rollout_ImagePreview.Init &filePath_Diffuse
			)
			on imgT_Specular MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then OnClickIMGtag &bm_Specular imgT_Specular &b_EnableDC_Specular &b_Toggle_Specular &(delegate.bUseSpecMap) &(delegate.specularMap) &bm_OnOff_Specular &filePath_Specular &btn_Reload_Specular
				if _arg.Button == _arg.Button.Right then OnRightClickIMGtag &b_EnableDC_Specular &bm_Specular imgT_Specular &(delegate.specularMap) &(delegate.bUseSpecMap) &bm_OnOff_Specular &filePath_Specular &btn_Reload_Specular
				if _arg.Button == _arg.Button.Middle and b_EnableDC_Specular == true then rollout_ImagePreview.Init &filePath_Specular
			)
			on imgT_Glossiness MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then
				(
					OnClickIMGtag &bm_Glossiness imgT_Glossiness &b_EnableDC_Glossiness &b_Toggle_Glossiness &(delegate.bUseGlossMap) &(delegate.glossMap) &bm_OnOff_Glossiness &filePath_Glossiness &btn_Reload_Glossiness
					spn_GlossMin.enabled = not b_Toggle_Glossiness
					lbl_GlossMin.enabled = not b_Toggle_Glossiness
				)
				if _arg.Button == _arg.Button.Right then OnRightClickIMGtag& b_EnableDC_Glossiness &bm_Glossiness imgT_Glossiness &(delegate.glossMap) &(delegate.bUseGlossMap) &bm_OnOff_Glossiness &filePath_Glossiness &btn_Reload_Glossiness
				if _arg.Button == _arg.Button.Middle and b_EnableDC_Glossiness == true then rollout_ImagePreview.Init &filePath_Glossiness
			)
			on imgT_SelfIllum MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then OnClickIMGtag &bm_SelfIllum imgT_SelfIllum &b_EnableDC_SelfIllum &b_Toggle_SelfIllumination &(delegate.bUseSIMap) &(delegate.siMap) &bm_OnOff_SelfIllum &filePath_SelfIllum &btn_Reload_SelfIllumination
				if _arg.Button == _arg.Button.Right then OnRightClickIMGtag& b_EnableDC_SelfIllum &bm_SelfIllum imgT_SelfIllum &(delegate.siMap) &(delegate.bUseSIMap) &bm_OnOff_SelfIllum &filePath_SelfIllum &btn_Reload_SelfIllumination
				if _arg.Button == _arg.Button.Middle and b_EnableDC_SelfIllum == true then rollout_ImagePreview.Init &filePath_SelfIllumbtn_Reload_SelfIllumination
			)
			on imgT_Normal MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then OnClickIMGtag &bm_Normal imgT_Normal &b_EnableDC_Normal &b_Toggle_Normal &(delegate.bUseNormalMap) &(delegate.normalMap) &bm_OnOff_Normal &filePath_Normal &btn_Reload_Normal
				if _arg.Button == _arg.Button.Right then OnRightClickIMGtag &b_EnableDC_Normal &bm_Normal imgT_Normal &(delegate.normalMap) &(delegate.bUseNormalMap) &bm_OnOff_Normal &filePath_Normal &btn_Reload_Normal
				if _arg.Button == _arg.Button.Middle and b_EnableDC_Normal == true then rollout_ImagePreview.Init &filePath_Normal
			)
			
			on imgT_ReflectMap MouseClick _arg do
			(
				if _arg.Button == _arg.Button.Left then
				(
					if filePath_ReflectMap == bm_Filename then
					(
						local bmT = bitmap 64 64
						bmT = selectBitMap()
						
						if not(bmT == undefined) then
						(					
							bm_ReflectMap = bmT
							b_EnableDC_Reflect = true
							filePath_ReflectMap = bmT.filename
							btn_Reload_ReflectMap.tooltip = filePath_ReflectMap
							
							local tempRefOnOffImage = bm_OnOff_Reflectmap
							tempRefOnOffImage.v1 = CreateOffImage bm_ReflectMap
							tempRefOnOffImage.v2 = CreateOnImage bm_ReflectMap
						)
					)
					if b_EnableDC_Reflect then
					(
						local tempBitmap = bm_OnOff_Reflectmap
						local tempImageClass = dotnetclass "System.Drawing.Image"
						if b_Toggle_ReflectMap then
						(
							delegate.bUseReflMap = true
							delegate.ReflMap  = openbitmap filePath_ReflectMap
							imgT_ReflectMap.image = tempImageClass.FromFile tempBitmap.v2
							b_Toggle_ReflectMap = false
						)
						else
						(
							delegate.bUseReflMap = false
							imgT_ReflectMap.image = tempImageClass.FromFile tempBitmap.v1
							b_Toggle_ReflectMap = true
						)--End Else
					)--End if
				)--End if
				if _arg.Button == _arg.Button.Right then
				(
					if b_EnableDC_Reflect then
					(
						local bmT = bitmap 50 50
						bmT = selectBitMap()
						
						if not(bmT == undefined) then
						(	
							filePath_ReflectMap = bmT.filename
							local tempRefOnOffImage = bm_OnOff_Reflectmap
							tempRefOnOffImage.v1 = CreateOffImage bmT
							tempRefOnOffImage.v2 = CreateOnImage bmT
							
							local tempImageClass = dotnetclass "System.Drawing.Image"
							bm_ReflectMap = bmT
							delegate.ReflMap  = bmT
							--Preview
							if delegate.bUseReflMap == true then
							(
								imgT_ReflectMap.image = tempImageClass.FromFile tempRefOnOffImage.v1
							)
							else
							(
								imgT_ReflectMap.image = tempImageClass.FromFile tempRefOnOffImage.v2
							)
						)--End if
					)--End if
				)--End if
				if _arg.Button == _arg.Button.Middle and b_EnableDC_Reflect == true then rollout_ImagePreview.Init &filePath_ReflectMap
			)--End Event
						
			on ddl_ReflectType selected item do
			(
				if item == 1 then
				(
					delegate.bUseWorldMask = false
					delegate.bUseCubeMap = false		
					lbl_CubemapBlur.enabled=false
					spn_CubemapBlur.enabled=false
					lbl_UseGlossmapForBlur.enabled=false
					chk_UseGlossmapForBlur.enabled=false
					lbl_FresnelMaskHardness.enabled=true
					spn_FresnelMaskHardness.enabled=true
					if spn_FresnelMultiplier.value ==1.0 then spn_FresnelMultiplier.value=2.0
				)
				if item == 2 then
				(
					delegate.bUseWorldMask = true
					delegate.bUseCubeMap = false
					lbl_CubemapBlur.enabled=false
					spn_CubemapBlur.enabled=false
					lbl_UseGlossmapForBlur.enabled=false
					chk_UseGlossmapForBlur.enabled=false
					lbl_FresnelMaskHardness.enabled=true
					spn_FresnelMaskHardness.enabled=true
					if spn_FresnelMultiplier.value ==1.0 then spn_FresnelMultiplier.value=2.0
				)	
				if item == 3 then
				(
					delegate.bUseWorldMask = false
					delegate.bUseCubeMap = true
					lbl_CubemapBlur.enabled=true
					spn_CubemapBlur.enabled=true
					lbl_UseGlossmapForBlur.enabled=true
					chk_UseGlossmapForBlur.enabled=true
					lbl_FresnelMaskHardness.enabled=false
					spn_FresnelMaskHardness.enabled=false
					if spn_FresnelMultiplier.value ==2.0 then spn_FresnelMultiplier.value=1.0
					if bm_Cubemap == bm then
					(
						local bmT = selectBitMap caption:"Select an Environment Cubemap"
						if bmT != undefined then
						(
							local tempImageReturn = undefined
							filePath_Cubemap = bmT.filename
							Presets.ApplyPresetMap &filePath_Cubemap &bm_OnOff_Cubemap &tempImageReturn &b_EnableDC_Cubemap &b_Toggle_Cubemap &delegate.UseIBLambient &delegate.EnvCubemap &bm_Cubemap
							if tempImageReturn != undefined then 
							(
								rollout_Lighting.imgT_Cubemap.image = tempImageReturn
								--Reload the path in the reloadbuttons so when you make a new save it saves it out properly
								rollout_Lighting.btn_Reload_IBLCubemap.toolTip = filePath_Cubemap
							)
						)
					)
				)				
			)--End Event ddl_ReflectType selected
			
			function DiffFresnelUIActivation val=
			(
				if val == 0 then 
				(
					spn_diffuseFresnelPower.enabled = false
					lbl_diffuseFresnelPower.enabled = false
					cp_DifFresnelC.enabled = false
					lbl_DifFresnelC.enabled = false
				)
				else 
				(
					spn_diffuseFresnelPower.enabled = true
					lbl_diffuseFresnelPower.enabled = true
					cp_DifFresnelC.enabled = true
					lbl_DifFresnelC.enabled = true
				)
			)
					
			on spn_FreshnelMultiplier changed val do
			(
				DiffFresnelUIActivation val
				delegate.diffuseFresnelMult = val
			)--End Event 
			
			function Open_Rollout_Maps=
			(
				/*UPDATE from shader*/
				b_Toggle_Diffuse = delegate.bUseDiffuseMap
				b_Toggle_Specular = delegate.bUseSpecMap
				b_Toggle_Glossiness = delegate.bUseGlossMap
				b_Toggle_Normal = delegate.bUseNormalMap
				b_Toggle_SelfIllumination = delegate.bUseSIMap
				b_Toggle_ReflectMap = delegate.bUseReflMap
				
				cp_Diffuse.color = delegate.diffuseColor
				spn_DifMapChannel.value = delegate.DiffuseMapUV
				spn_VertCStrength.value = delegate.VertexDiffuse
				chk_ColorDifMap.state = delegate.bColorDiffuse
				cp_DifFresnelC.color = delegate.diffusefresnelColor
				spn_diffuseFresnelPower.value = delegate.diffuseFresnelPower
				chk_EnableAlphaChannel.state = delegate.bUseAlpha
				spn_GlobalOpacityLevel.value = delegate.GlobalOpacity
				cp_Specular.color = delegate.specularColor
				spn_SpecGlobalLevel.value = delegate.speclevel
				spn_GlossMax.value = delegate.glossiness
				spn_GlossMin.value = delegate.glossoffset
				chk_FlipGreen.state = delegate.bFlipGreenChannel
				chk_ObjectSpace.state = delegate.bUseObjectNormals
				spn_normalMapChannel.value = delegate.NormalMapUV
				spn_SIMultiply.value = delegate.siMapMult
				btn_FresnelReflections.state = delegate.bUseFresnel
				chk_OpacityAffectsReflections.state = delegate.bAlphaMasksFresnel
				spn_FresnelPower.value = delegate.FresnelPower
				spn_FresnelBias.value = delegate.FresnelBias
				spn_FresnelMultiplier.value = delegate.FresnelMult
				cp_FresnelReflections.color = delegate.FresnelColor
				spn_FresnelMaskHardness.value =delegate.FresnelMaskHardness
				spn_CubemapBlur.value = delegate.CubeMapBlur
				chk_UseGlossmapForBlur.state = delegate.bUseReflGloss
				
				spn_GlossMin.enabled = delegate.bUseGlossMap
				lbl_GlossMin.enabled = delegate.bUseGlossMap
				
				LoadMaterialImages()
				
				b_Toggle_Diffuse = not(b_Toggle_Diffuse)
				b_Toggle_Specular = not(b_Toggle_Specular)
				b_Toggle_Glossiness = not(b_Toggle_Glossiness)
				b_Toggle_Normal = not(b_Toggle_Normal)
				b_Toggle_SelfIllumination = not(b_Toggle_SelfIllumination)
				b_Toggle_ReflectMap = not(b_Toggle_ReflectMap)
				/* END Update*/
				
				if delegate.bUseWorldMask == false and delegate.bUseCubeMap == false then ddl_ReflectType.selection = 1
				if delegate.bUseWorldMask == true and delegate.bUseCubeMap == false then ddl_ReflectType.selection = 2
				if delegate.bUseWorldMask == false and delegate.bUseCubeMap == true then ddl_ReflectType.selection = 3
				DiffFresnelUIActivation spn_FreshnelMultiplier.value
				
				--perhaps add code here to reset tooltips to "" for bm_filepath
				
				if b_CleanStart then
				(
					imgT_ReflectMap.enabled=false
					setProperty imgT_ReflectMap "enabled" false
					b_CleanStart=false
				)
				if btn_FresnelReflections.checked then btn_FresnelReflections.changed true
			)
			
			--Handeling the closing and startups of the rollout to save the current UI of the shader
			on rollout_Maps open do
			(
				Open_Rollout_Maps()
			)--End Event
			on rollout_Maps close do
			(
				--Save the filepaths of the images to the rootscene of the maxfile
				--removed, as the delegate stores this anyway -L
				
				BackupMaterialImages()
				if ddl_ReflectType.selection == 1 then
				(
					delegate.bUseWorldMask = false
					delegate.bUseCubeMap = false
				)
				if ddl_ReflectType.selection == 2 then
				(
					delegate.bUseWorldMask = true
					delegate.bUseCubeMap = false
				)
				if ddl_ReflectType.selection == 3 then
				(
					delegate.bUseWorldMask = false
					delegate.bUseCubeMap = true
				)
			)--End Event
			
		)--End Rolllout rollout_Maps
		
		/* ==================================================================================================================PLUGIN ROLLOUTS : rollout_Techniques*/

		rollout rollout_Techniques "Techniques"
		(
			dropdownList ddl_Techniques "" pos:[160,5] width:163 height:21 items:#("One Sided", "Two Sided")
			label lbl_Technique "Technique" pos:[10,7] width:70 height:21
			label lbl_Clip "Enable Clipping" pos:[10,37] width:100 height:21
			checkbox chk_Clip "Checkbox" pos:[145,37] width:12 height:12
			label lbl_ClipTreshold "Clipping Treshold" pos:[160,37] width:100 height:21 enabled:false
			spinner spn_ClipTreshold "" pos:[278,37] width:45 height:16 range:[0,1,0.3] type:#float scale:0.01 enabled:false
			
			/* ==================================================================================================================ROLLOUT EVENTS*/
			
			on rollout_Techniques open do
			(
				/*UPDATE from shader*/
				chk_Clip.state = delegate.bClip
				spn_Cliptreshold.value = delegate.ClipTreshold
				ddl_Techniques.selection = delegate.Technique + 1
				/* END Update*/
				
				lbl_ClipTreshold.enabled = chk_Clip.checked
				spn_ClipTreshold.enabled = chk_Clip.checked
			)
			
			on ddl_Techniques selected _arg do delegate.Technique = _arg - 1
			
			on chk_Clip changed _arg do 
			(
				lbl_ClipTreshold.enabled = chk_Clip.checked
				spn_ClipTreshold.enabled = chk_Clip.checked
			)
			
		)--End Rolllout rollout_Techniques
		
		/* ==================================================================================================================PLUGIN EVENTS*/
		
		on create do
		(			
			local rootPath = getDir #maxRoot
			local uiRoot = getDir #ui
			local fxPath = "maps\\fx\\"
			local ProgramVersion = maxVersion()
			local ShaderVersion = "Xoliulshader_2.0_max2009.fx"
			local vss 
			
			
			b_IsMax2009 = true
			if ProgramVersion[1] >11000 then 
			(
				ShaderVersion = "Xoliulshader_2.0.fx"
				b_IsMax2009 = false
			)
			if not b_IsMax2009 then
			(
				vss = maxops.getViewportShadingSettings()
				
				vss.ActivateViewportShading = true
				vss.ShadingQuality = #Best
			)
			else if b_IsMax2009 then
			(
				IViewportShadingMgr.ShadingLimits = #Best
			)
			
			effectfile = (rootPath + fxPath + ShaderVersion)  --set the effect file when we apply the scripted material
			delegate.effectfile = effectfile
			delegate.bUseDiffuseMap = false
			delegate.bUseSpecMap = false
			delegate.bUseGlossMap = false
			delegate.bUseNormalMap = false
			delegate.bUseSIMap = false
			delegate.bUseWorldMask = false
			delegate.bUseCubeMap = false
			delegate.UseIBLambient = false
			delegate.bUseReflMap = false
			delegate.UseGradientRamp = false
			CountLights = 1 -- Because on default the first light is on
			delegate.numberOfActiveLights = CountLights
			
			delegate.bUseShadow = false
			
			delegate.UseLight1 = true
			delegate.UseLight2 = false
			delegate.UseLight3 = false
			delegate.UseShadow1 = false
			delegate.UseShadow2 = false
			delegate.UseShadow3 = false
		
			Presets = MainPresets()

			m_QuickLoad = Quickload()
			m_QuickLoad.Init()
			
			ShaderReset = true
			
			g_CallbackItem = NodeEventCallback mouseUp:true added:UpdateLights deleted:UpdateLights
		)--End on Create do
		
		on deleted do
		(					
			g_CallbackItem = undefined
			gc light:true
			
			tempFiles = getfiles (scriptspath + "XoliulShaderUI\\images\\temp\\" + "*.jpg")
			for item in tempFiles do deletefile item
		)--End Event

	)--End PLugin

)--End Project
