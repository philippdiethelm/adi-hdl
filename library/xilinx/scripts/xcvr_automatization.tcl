###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
proc adi_xcvr_generate_path {base_path projname carriername xcvrtype parameters} {

    set path $base_path
    append path "$projname/$carriername/"

    foreach {key value} $parameters {
        append path "${key}${value}_"
    }

    set path [string trimright $path "_"]
    append path "/${projname}_${carriername}.gen/sources_1/ip/${xcvrtype}_cfng.txt"
    
    return $path
}

proc adi_xcvr_parameters {file_paths parameters} {
    # 1. Definirea parametrilor și valorilor implicite
        # "RX_LANE_INVERT" "0"
        # "TX_LANE_INVERT" "0"
    set default_parameters {
        "RX_NUM_OF_LANES" "8"
        "TX_NUM_OF_LANES" "8"
        "QPLL_REFCLK_DIV" "1"
        "QPLL_FBDIV_RATIO" "1"
        "POR_CFG" "16'b0000000000000110"
        "PPF0_CFG" "16'b0000011000000000"
        "PPF1_CFG" "16'b0000011000000000"
        "QPLL_CFG" "27'h0680181"
        "QPLL_FBDIV" "10'b0000110000"
        "QPLL_CFG0" "16'b0011001100011100"
        "QPLL_CFG1" "16'b1101000000111000"
        "QPLL_CFG2" "16'b0000111111000000"
        "QPLL_CFG3" "16'b0000000100100000"
        "QPLL_CFG4" "16'b0000000000000011"
        "QPLL_CP" "10'b0001111111"
        "CPLL_FBDIV" "2"
        "CPLL_FBDIV_4_5" "5"
        "CPLL_CFG0" "16'b0000000111111010"
        "CPLL_CFG1" "16'b0000000000100011"
        "CPLL_CFG2" "16'b0000000000000010"
        "CPLL_CFG3" "16'b0000000000000000"
        "CH_HSPMUX" "16'b0010010000100100"
        "PREIQ_FREQ_BST" "0"
        "RXPI_CFG0" "16'b0000000000000010"
        "RXPI_CFG1" "16'b0000000000010101"
        "RX_WIDEMODE_CDR" "2'b00"
        "RX_XMODE_SEL" "1'b1"
        "TX_OUT_DIV" "1"
        "TX_CLK25_DIV" "20"
        "TXPI_CFG" "16'b0000000001010100"
        "A_TXDIFFCTRL" "5'b10110"
        "RX_OUT_DIV" "1"
        "RX_CLK25_DIV" "20"
        "RX_DFE_LPM_CFG" "16'h0104"
        "RX_PMA_CFG" "32'h001e7080"
        "RX_CDR_CFG" "72'h0b000023ff10400020"
        "RXCDR_CFG0" "16'b0000000000000010"
        "RXCDR_CFG2" "16'b0000001001101001"
        "RXCDR_CFG3" "16'b0000000000010010"
        "TXFE_CFG0" "16'b0000001111000010"
        "TXFE_CFG1" "16'b0110110000000000"
        "TXPI_CFG0" "16'b0000001100000000"
        "TXPI_CFG1" "16'b0001000000000000"
        "TXSWBST_EN" "0"
    }

    set correction_map {
        "TXOUT_DIV" "TX_OUT_DIV"
        "RXOUT_DIV" "RX_OUT_DIV"
        "CPLL_FBDIV_45" "CPLL_FBDIV_4_5"
        "RXCDR_CFG" "RX_CDR_CFG"
    }

    set updated_params {}

    if {[llength $parameters] > 0} {
        foreach {key value} $parameters {
            puts "key: $key v: $value "
            if {[dict exists $default_parameters $key]} {
                set default_value [dict get $default_parameters $key]
                puts "existaaa def val: $default_value \n"
                
                if {$value != $default_value} {
                    puts "diferaaa, se insereaza in dict: param: $key cu val: $value \n"
                    dict set updated_params $key $value
                }
            }   
        }
    }

    #set config_dir_name [file dirname $file_path]
    #puts "$config_dir_name"

    set param_file_path [dict get $file_paths param_file_path]
    set cfng_file_path [dict get $file_paths cfng_file_path]

    set param_file_content [read [open $param_file_path r]]
    #puts "Continutul fișierului common.v este:"
    #puts $param_file_content

    # Definirea pattern-ului regex pentru a extrage parametrii și valorile lor
    set param_pattern {QPLL_FBDIV_TOP =  ([0-9]+);}
    set match [regexp -inline $param_pattern $param_file_content]
    #puts "matchh: [lindex $match 0]"
    set QPLL_FBDIV_TOP [lindex $match 1]
    #puts "QPLL FBDIV TOP: $QPLL_FBDIV_TOP"

    switch $QPLL_FBDIV_TOP {
	   16 {set QPLL_FBDIV_IN "10'b0000100000"}
	   20 {set QPLL_FBDIV_IN "10'b0000110000"}
	   32 {set QPLL_FBDIV_IN "10'b0001100000"}
	   40 {set QPLL_FBDIV_IN "10'b0010000000"}
	   64 {set QPLL_FBDIV_IN "10'b0011100000"}
	   66 {set QPLL_FBDIV_IN "10'b0101000000"}
	   80 {set QPLL_FBDIV_IN "10'b0100100000"}
	   100 {set QPLL_FBDIV_IN "10'b0101110000"}
	   default {set QPLL_FBDIV_IN "10'b0000000000"}
    } 
    #puts "QPLL FBDIV IN: $QPLL_FBDIV_IN"

    switch $QPLL_FBDIV_TOP {
           66 {set QPLL_FBDIV_RATIO "1'b0"}
           default {set QPLL_FBDIV_RATIO "1'b1"}
    }
    #puts "QPLL FBDIV RATIO: $QPLL_FBDIV_RATIO"	

    set file_content [read [open $cfng_file_path r]]
    puts "Continutul fișierului este:"
    #puts $file_content
    
    # Definirea pattern-ului regex pentru a extrage parametrii și valorile lor
    set pattern {'([^']+)' => '([^']+\\?'?[0-9a-h]*)'}
    set results {}
    set matches [regexp -all -inline $pattern $file_content]

    for {set i 0} {$i < [llength $matches]} {incr i 3} {
        set param [lindex $matches $i+1] ; # Grupul 1 (parametrul)
        set value [lindex $matches $i+2] ; # Grupul 2 (valoarea)
        
        puts "Parametru: $param cu Valoare: $value"

        set cleaned_value [string map {"\\" ""} $value]
        #puts $cleaned_value
        set corr_param $param

        if {[dict exists $correction_map $param]} {
            set corr_param [dict get $correction_map $param]
        }
        # puts "cor param: $corr_param"
        if {[dict exists $default_parameters $corr_param]} {
            set default_value [dict get $default_parameters $corr_param]
            puts "existaaa def val: $default_value \n"

            if {$cleaned_value != $default_value} {
		if {[string equal $cleaned_value "QPLL_FBDIV_IN"]} {
		    set cleaned_value $QPLL_FBDIV_IN
		}
	        puts "diferaaa, se insereaza in dict: param: $corr_param cu val: $cleaned_value \n"
                dict set updated_params $corr_param $cleaned_value
            }
        }
        lappend results [list $corr_param $cleaned_value]
    }

    puts "Updated Parameters:"
    dict for {key value} $updated_params {
        puts "$key: $value"
    }

    return $updated_params
}
