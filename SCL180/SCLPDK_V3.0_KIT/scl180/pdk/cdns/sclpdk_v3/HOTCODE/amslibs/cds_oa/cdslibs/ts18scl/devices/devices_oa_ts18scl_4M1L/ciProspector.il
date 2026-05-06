when( isCallable('ciRegisterDevice)
 ciRegisterDevice("fet"
                  append(ciGetDeviceNames("fet")
                         append(
                         ciGetDeviceNames("nfet")
                         ciGetDeviceNames("pfet")
 )))
 ciRegisterDevice("nfet"
                  append(ciGetDeviceNames("nfet")
                  '(
			'("ts018_scl_prim" "cnwnmos_thk2t" nil)
			'("ts018_scl_prim" "cnwnmos_thk3t" nil)
			'("ts018_scl_prim" "cnwnmos_thn2t" nil)
			'("ts018_scl_prim" "n18hvt_iso" nil)
			'("ts018_scl_prim" "n18hvt" nil)
			'("ts018_scl_prim" "n18lvt_iso" nil)
			'("ts018_scl_prim" "n18lvt" nil)
			'("ts018_scl_prim" "nmos_18_iso" nil)
			'("ts018_scl_prim" "nmos_18" nil)
			'("ts018_scl_prim" "nmos_33_iso" nil)
			'("ts018_scl_prim" "nmos_33" nil)
			'("ts018_scl_prim" "nmos_5V_iso" nil)
			'("ts018_scl_prim" "nmos_5V" nil)
			'("ts018_scl_prim" "nmos_native_33" nil)
			'("ts018_scl_prim" "nmos_native_5" nil)
			'("ts018_scl_prim" "nmos_native" nil)
 )))
 ciRegisterDevice("pfet"
                  append(ciGetDeviceNames("pfet")
                  '(
			'("ts018_scl_prim" "p18hvt" nil)
			'("ts018_scl_prim" "p18lvt" nil)
			'("ts018_scl_prim" "pmos_18" nil)
			'("ts018_scl_prim" "pmos_33" nil)
			'("ts018_scl_prim" "pmos_5V" nil)
 )))
 ciRegisterDevice("ldmos"
                  append(ciGetDeviceNames("ldmos")
                         append(
                         ciGetDeviceNames("nldmos")
                         ciGetDeviceNames("pldmos")
 )))
 ciRegisterDevice("nldmos"
                  append(ciGetDeviceNames("nldmos")
                  '(
 )))
 ciRegisterDevice("pldmos"
                  append(ciGetDeviceNames("pldmos")
                  '(
 )))

 ciRegisterDevice("bjt"
                  append(ciGetDeviceNames("bjt")
                         append(
                            ciGetDeviceNames("npn")
                            ciGetDeviceNames("pnp")
 )))
 ciRegisterDevice("npn"
                  append(ciGetDeviceNames("npn")
                  '(
			'("ts018_scl_prim" "vnpn18_5" nil)
 )))
 ciRegisterDevice("pnp"
                  append(ciGetDeviceNames("pnp")
                  '(
			'("ts018_scl_prim" "vpnp18_10" nil)
			'("ts018_scl_prim" "vpnp18_2" nil)
			'("ts018_scl_prim" "vpnp18_5" nil)
			'("ts018_scl_prim" "vpnp33_10" nil)
			'("ts018_scl_prim" "vpnp33_2" nil)
			'("ts018_scl_prim" "vpnp33_5" nil)
 )))
 ciRegisterDevice("diode"
                  append(ciGetDeviceNames("diode")
                  '(
		    '("ts018_scl_prim" "ddwnps18" nil)
		    '("ts018_scl_prim" "ddwnpw18" nil)
		    '("ts018_scl_prim" "dn50" nil)
		    '("ts018_scl_prim" "dp50" nil)
		    '("ts018_scl_prim" "ndio_33" nil)
		    '("ts018_scl_prim" "ndio_nosal" nil)
		    '("ts018_scl_prim" "ndio_sal" nil)
		    '("ts018_scl_prim" "nwldio_33" nil)
		    '("ts018_scl_prim" "nwldio" nil)
		    '("ts018_scl_prim" "pdio_33" nil)
		    '("ts018_scl_prim" "pdio_nosal" nil)
		    '("ts018_scl_prim" "pdio_sal" nil)
 )))
 ciRegisterDevice("passive"
                  append(ciGetDeviceNames("passive")
                     append(
                       ciGetDeviceNames("resistor")
                       ciGetDeviceNames("capacitor")
 )))
 ciRegisterDevice("resistor"
                  append(ciGetDeviceNames("resistor")
                  '(
		    '("ts018_scl_prim" "mr22t" nil)
		    '("ts018_scl_prim" "mr23t" nil)
		    '("ts018_scl_prim" "rnlpoly2t" nil)
		    '("ts018_scl_prim" "rnlpoly3t" nil)
		    '("ts018_scl_prim" "rnmpoly2t" nil)
		    '("ts018_scl_prim" "rnmpoly3t" nil)
		    '("ts018_scl_prim" "rnplus2t" nil)
		    '("ts018_scl_prim" "rnplus3t" nil)
		    '("ts018_scl_prim" "rnplus_sal2t" nil)
		    '("ts018_scl_prim" "rnplus_sal3t" nil)
		    '("ts018_scl_prim" "rnwell_AA2t" nil)
		    '("ts018_scl_prim" "rnwell_AA3t" nil)
		    '("ts018_scl_prim" "rnwell_STI2t" nil)
		    '("ts018_scl_prim" "rnwell_STI3t" nil)
		    '("ts018_scl_prim" "rphpoly2t" nil)
		    '("ts018_scl_prim" "rphpoly3t" nil)
		    '("ts018_scl_prim" "rplpoly2t" nil)
		    '("ts018_scl_prim" "rplpoly3t" nil)
		    '("ts018_scl_prim" "rpmpoly2t" nil)
		    '("ts018_scl_prim" "rpmpoly3t" nil)
		    '("ts018_scl_prim" "rpplus2t" nil)
		    '("ts018_scl_prim" "rpplus3t" nil)
		    '("ts018_scl_prim" "rpplus_sal2t" nil)
		    '("ts018_scl_prim" "rpplus_sal3t" nil)
		    '("ts018_scl_prim" "rm1" nil)
		    '("ts018_scl_prim" "rm2" nil)
		    '("ts018_scl_prim" "rm3" nil)
		    '("ts018_scl_prim" "rmL" nil)
 )))
 ciRegisterDevice("capacitor"
                  append(ciGetDeviceNames("capacitor")
                  '(
		    '("ts018_scl_prim" "ch53t" nil)
		    '("ts018_scl_prim" "cnwnmos_thk2t" nil)
		    '("ts018_scl_prim" "cnwnmos_thk3t" nil)
		    '("ts018_scl_prim" "cnwnmos_thn2t" nil)
		    '("ts018_scl_prim" "cm32t" nil)
		    '("ts018_scl_prim" "cm33t" nil)
		    '("ts018_scl_prim" "cmim_hc" nil)
		    '("ts018_scl_prim" "cmim_sq" nil)
		    '("ts018_scl_prim" "cmim_stk" nil)
		    '("ts018_scl_prim" "cmim_uhd" nil)
		    '("ts018_scl_prim" "cmim_uhdstk" nil)
 )))
 ciRegisterDevice("inductor"
                  append(ciGetDeviceNames("inductor")
                  '(
 )))
 ciRegisterDevice("fuse"
                  append(ciGetDeviceNames("fuse")
                  '(
		    '("ts018_scl_prim" "epf" nil)
 )))
 ciRegisterDevice("esd"
                  append(ciGetDeviceNames("esd")
                  '(
 )))
 ciRegisterDevice("debug"
                  append(ciGetDeviceNames("debug")
                  '(
 )))

 ciRegisterDevice("standardCell"
                  append(ciGetDeviceNames("standardCell")
                  '(
 )))
 ciMapParam("width"        append(ciGetParamMapping("width")        '("w" "effectiveWidth")))
 ciMapParam("length"       append(ciGetParamMapping("length")       '("l" )))

 ciMapTerm("gate"      append(ciGetTermNames("gate")      '("G")))
;
; The following nets are predefine. Listing them just for the information and
; for the case that the user want to add a new net or/and reduce the list
  ciRegisterNet( "supply"     '("gnd" "gnd!" "GND" "GND!" "vdd" "vdd!" "VDD" "VDD!" "vss" "vss!" "VSS" "VSS!" ))
  ciRegisterNet( "power"      '("vdd" "vdd!" "VDD" "VDD!" ))
   
  ciRegisterNet( "ground"     '("gnd" "gnd!" "GND" "GND!" "vss" "vss!" "VSS" "VSS!"))
) ; when
;ciPrintMappedDeviceNames()
;ciPrintMappedNetNames()
