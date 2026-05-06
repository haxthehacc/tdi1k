;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Keep hierarchic pin order within cdl netlist according sim info 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
auCdlCDFPinCntrl=t
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;prevents subckt default values printing  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;auCdlDisablePrintSubcktCDF=t
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;allow netlisting two symbols with one schematic   (example nld_5V_sclV4_ESD)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hnlHandleMultiplePlaceMaster = "ignore"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.cdsenv variables runtime setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
let((iniIsOa)
	iniIsOa = getd('dbGetDatabaseType) && equal(dbGetDatabaseType() "OpenAccess")
	envSetVal("layoutXL" "sfactorNames" 'string "S")
	envSetVal("hspiceD.opts" "SCALE" 'string "1e-06")
	if(iniIsOa == nil then
		envSetVal("hspiceS.opts" "SCALE" 'string  "1e-06")
	else
		;defined here in order to support XL ADE
		defvar(tspGlbLastValueLst list(nil))
	)	
	envSetVal("spectre.opts" "scale" 'string  "1e-06")
	envSetVal("UltraSim.opts" "scale" 'string  "1e-06")
	envSetVal("ams.opts" "scale" 'string  "1e-06")
	if(getShellEnvVar("MGC_AMS_HOME") then
		envSetVal("eldo.opts" "SCALE" 'string  "1e-06")
		envSetVal("eldoD.opts" "SCALE" 'string  "1e-06")
	)
	envSetVal("layout"  "xSnapSpacing"    'float   0.005)
	envSetVal("layout"  "ySnapSpacing"    'float   0.005)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This setup options for the DFII schematici				     ;
; netlisting options							     ;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
procedure(TJAssuraUserDefinedSetupCB(form "r")
    let(()
        when( equal(form->hiFormSym 'vuiLVSForm)       
            vuiLVSschNLoptionForm->viewList->value = "auLvs auCdl schematic symbol"
            vuiLVSschNLoptionForm->stopList->value = "auLvs"
            vuiLVSschNLoptionForm->avSimName->value = "auLvs"
            vuiLVSschNLoptionForm->avMFactorPropName->value = "m"
        ) ; when
        t
    ) ; let
) ; procedure TJAssuraUserDefinedSetupCB
procedure( vuiUserDefinedSetupCB(form "r")
	TJAssuraUserDefinedSetupCB(form)
) 			 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Customize the Virtuoso CDL Out form					    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
procedure(tslnp_CustomizeCDLOutForm()
	let((_libName _libPath _cdlHeader _custCdlHeader)
		printf("\t**Customize the Virtuoso CDL Out form.**\n")
		_libName = "ts018_scl_prim"
		_libPath =  ddGetObjReadPath(ddGetObj(_libName))
		_cdlHeader = sprintf(nil "%s/cdlNetlist.header" _libPath)
		_custCdlHeader = getShellEnvVar("TSPCUSTCDL")
		if(_custCdlHeader && isFile(_custCdlHeader) then
			_cdlHeader = _custCdlHeader
		)
        	transCdlOutForm->cdlOIncFile->value = _cdlHeader        		
        	transCdlOutForm->cdlOResistorValue->value = 0.0
        	transCdlOutForm->cdlOResistorValue->defValue = 0.0
	)	
)
let((libName libPath cdlHeader custCdlHeader oaFileName fileName filePath mppFileName custDisp files patchLibPath)
	libName = "ts018_scl_prim"
	libPath =  ddGetObjReadPath(ddGetObj(libName))
	cdlHeader = sprintf(nil "%s/cdlNetlist.header" libPath)
	
	;attach user init procedure for netlisting
	custCdlHeader = getShellEnvVar("TSPCUSTCDL")	
	if(custCdlHeader && isFile(custCdlHeader) then
		cdlHeader = custCdlHeader
		printf("\tset customized cdl header: %s\n" cdlHeader)
	)
	printf("**\n\tAttach user init procedure to Virtuoso CDL Out form**\n")
	if(isFile(cdlHeader) then
		defUserInitProc("transUI" 'tslnp_CustomizeCDLOutForm)
	else
		printf("\t*Warning* can not find cdlNetlist.header file within pdk lib\n")
	)		
	;attach cdl include file to calibre form (cdlOutKeys global parameter defined by calibre skill packet)	
	if(getShellEnvVar("RDS_CDSLIBS") && getShellEnvVar("RDS_CDS_TECH") then
		cdlOutKeys = '( nil incFILE "" )
		putprop( cdlOutKeys cdlHeader 'incFILE) 
	)
	;load oa files if exist	
	foreach(oaFileName list("customFilter.il" "ciProspector.il")
		filePath = sprintf(nil "%s/%s" libPath oaFileName)
		if(isFile(filePath) then
			if(errset(load(filePath) nil) then 
				printf("\tLoading %s/%s\n" libName oaFileName)
			else
				printf("\tFaild loading %s/%s\n" libName oaFileName)
			)
		)
	)
	;load mpp file if exist
	if(isCallable('leDefineMPPTemplate) then
		foreach(mppFileName list("mpp.il")
			filePath = sprintf(nil "%s/%s" libPath mppFileName)
			if(isFile(filePath) then
				if(errset(load(filePath) nil) then
					printf("\tLoading %s/%s\n" libName mppFileName)
				else
					printf("\tFailed loading %s/%s\n" libName mppFileName)
				)
			)
		)
	)
	;load menu file if exist
	if(isCallable('hiCreateMenuItem) then
		filePath = sprintf(nil "%s/%s" libPath "menu.il")
		if(isFile(filePath) then
			if(errset(load(filePath) nil) then
				printf("\tLoading %s/%s\n" libName "menu.il")
			else
				printf("\tFailed loading %s/%s\n" libName "menu.il")
			)
		)
	)
	;load customized display.drf
	if(fboundp(`drLoadDrf) then
		custDisp = getShellEnvVar("TSPCUSTDISP")	
		if( custDisp && isFile(custDisp) then
			if(drLoadDrf(custDisp) then
				printf("\tLoading customized display file: %s\n" custDisp)
			else
				printf("\tFaild loading customized display file %s\n" custDisp)
			)
					
		)
	)
	;load patch skill files
	patchLibPath = sprintf(nil "%s/patch_code" libPath)
	if(isDir(patchLibPath) then
		files = getDirFiles(sprintf(patchLibPath "%s/patch_code" libPath))
		foreach(fileName files
			filePath = sprintf(nil "%s/%s" patchLibPath fileName)
			if(isFile(filePath) && rexMatchp(".+[.]il" fileName) then
				load(filePath)
				printf("\tLoading skill file %s \n" filePath)
			)
		)
	)
	
	
)
