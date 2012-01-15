rollout Viewport_Shading_Explorer_Dialog "Viewport Shading Explorer"

(

 local vss = maxops.getViewportShadingSettings()

 group "Hardware Shading"

 (


  dropdownlist ddl_ShadingQuality items:#("Good Quality", "Best Quality") selection:(findItem #(#Good, #Best) vss.ShadingQuality)

  checkbox chk_TonemappingActive "Exposure Control In Viewport" checked:vss.TonemappingActive

 )

 group "Transparency"
 
 (
	 dropdownlist ddl_TransparencyQuality items:#("Off","Simple", "Best") selection:(viewport.GetTransparencyLevel())
 )


 group "Ambient Occlusion"

 (

  dropdownlist ddl_AmbientOcclusionMode items:#("Ambient Occlusion Off","Ambient Occlusion Only", "Ambient Occlusion Composite") selection:(findItem #(#AOOff,#AOOnly,#AOComposite) vss.AmbientOcclusionMode )

  dropdownlist ddl_AmbientOcclusionQuality items:#("Low Quality","Medium Quality", "High Quality") selection:(findItem #(#Low,#Medium,#High) vss.AmbientOcclusionQuality )

  spinner spn_AmbientOcclusionRadius "Sample Radius:" range:[0,100,vss.AmbientOcclusionRadius] fieldwidth:50

  spinner spn_AmbientOcclusionStrength "Strength:" range:[0,1,vss.AmbientOcclusionStrength] scale:0.001 fieldwidth:50

 )



 

 group "Depth Of Field"

 (

  checkbox chk_DepthOfFieldActive "Depth Of Field Active" checked:vss.DepthOfFieldActive

  spinner spn_DepthOfFieldNearPlane "Near Plane" range:[0,10000000,vss.DepthOfFieldNearPlane] fieldwidth:50

  spinner spn_DepthOfFieldFarPlane "Far Plane" range:[0,10000000,vss.DepthOfFieldFarPlane] fieldwidth:50

  spinner spn_DepthOfFieldFocusPlane "Focus Plane" range:[0,10000000,vss.DepthOfFieldFocusPlane] fieldwidth:50

 )

 

 on ddl_ShadingQuality selected itm do 

  vss.ShadingQuality = (#(#Good, #Best))[itm]

 on chk_TonemappingActive changed state do 

  vss.TonemappingActive = state

 
 on ddl_TransparencyQuality selected itm do

  viewport.SetTransparencyLevel(itm)
 
 
 on ddl_AmbientOcclusionMode selected itm do 

  vss.AmbientOcclusionMode = (#(#AOOff,#AOOnly,#AOComposite))[itm]

 on ddl_AmbientOcclusionQuality selected itm do 

  vss.AmbientOcclusionQuality = (#(#Low,#Medium,#High))[itm]

 on spn_AmbientOcclusionRadius changed val do 

  vss.AmbientOcclusionRadius = val

 on spn_AmbientOcclusionStrength changed val do 

  vss.AmbientOcclusionStrength = val



 

 on chk_DepthOfFieldActive changed state do

  vss.DepthOfFieldActive = state

 on spn_DepthOfFieldNearPlane changed val do 

  vss.DepthOfFieldNearPlane = val

 on spn_DepthOfFieldFarPlane changed val do 

  vss.DepthOfFieldFarPlane = val

 on spn_DepthOfFieldFocusPlane changed val do 

  vss.DepthOfFieldFocusPlane = val

)

 

createDialog Viewport_Shading_Explorer_Dialog 200 360

