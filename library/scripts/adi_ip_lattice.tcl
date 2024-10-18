###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

namespace eval ipl {
    set interfaces_paths_list [split $env(LATTICE_INTERFACE_SEARCH_PATH) ";"]
    # puts $interfaces_paths_list

    foreach file $interfaces_paths_list {
        if {[regexp {^.+\/PropelIPLocal} $file PropelIPLocal_path]} {
            puts $file
            puts $PropelIPLocal_path
        }
    }

    #node: {name attributes content childs}
    #attributes {{id0} {att0} {id1} {att1}}
    set ip_desc {{lsccip:ip} {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip" xmlns:xi="http://www.w3.org/2001/XInclude" version="1.0" platform="radiant" platform_version="2023.2"}} {} {
            {lsccip:general} {{lsccip:general} {} {} {
                    {lsccip:vendor} {{lsccip:vendor} {} {analog.com} {}}
                    {lsccip:library} {{lsccip:library} {} {ip} {}}
                    {lsccip:name} {{lsccip:name} {} {} {}}
                    {lsccip:display_name} {{lsccip:display_name} {} {} {}}
                    {lsccip:version} {{lsccip:version} {} {1.0} {}}
                    {lsccip:category} {{lsccip:category} {} {ADI} {}}
                    {lsccip:keywords} {{lsccip:keywords} {} {ADI IP} {}}
                    {lsccip:min_radiant_version} {{lsccip:min_radiant_version} {} {2022.1} {}}
                    {lsccip:max_radiant_version} {{} {} {} {}}
                    {lsccip:min_esi_version} {{lsccip:min_esi_version} {} {1.0} {}}
                    {lsccip:max_esi_version} {{} {} {} {}}
                    {lsccip:supported_products} {{lsccip:supported_products} {} {} {}}
                    {lsccip:supported_platforms} {{lsccip:supported_platforms} {} {} {}}
                    {href} {{} {} {https://wiki.analog.com/resources/fpga/docs/ip_cores} {}}
                }
            }
            {lsccip:settings} {{lsccip:settings} {} {} {}}
            {lsccip:ports} {{} {} {} {}}
            {lsccip:outFileConfigs} {{} {} {} {
                wrapper_type {{} {} {} {}}
            }}
            {xi:include} {{} {} {} {}}
            {lsccip:componentGenerators} {{} {} {} {}}
        }
    }
    set componentGenerator_desc {{lsccip:componentGenerator} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:generatorExe} {{lsccip:generatorExe} {} {} {}}
        }
    }
    set busInterfaces_desc {{lsccip:busInterfaces} {{0}
        {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}} {} {}}
    set busInterface_desc {{lsccip:busInterface} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:displayName} {{lsccip:displayName} {} {} {}}
            {lsccip:description} {{lsccip:description} {} {} {}}
            {lsccip:busType} {{lsccip:busType} {} {} {}}
            {lsccip:abstractionTypes} {{lsccip:abstractionTypes} {} {} {
                    {lsccip:abstractionType} {{lsccip:abstractionType} {} {} {
                            {lsccip:abstractionRef} {{lsccip:abstractionRef} {} {} {}}
                            {lsccip:portMaps} {{lsccip:portMaps} {} {} {}}
                        }
                    }
                }
            }
            {lsccip:master_slave} {{} {} {} {}}
        }
    }
    set portMap_desc {{lsccip:portMap} {} {} {
            {lsccip:logicalPort} {{lsccip:logicalPort} {} {} {
                    {lsccip:name} {{lsccip:name} {} {} {}}
                }
            }
            {lsccip:physicalPort} {{lsccip:physicalPort} {} {} {
                    {lsccip:name} {{lsccip:name} {} {} {}}
                }
            }
        }
    }
    set addressSpaces_desc {{lsccip:addressSpaces}
        {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}} {} {}}
    set addressSpace_desc {{lsccip:addressSpace} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:range} {{lsccip:range} {} {0x100000000} {}}
            {lsccip:width} {{lsccip:width} {} {32} {}}
        }
    }
    set memoryMaps_desc {{lsccip:memoryMaps}
        {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}} {} {}}
    set memoryMap_desc {{lsccip:memoryMap} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:description} {{lsccip:description} {} {} {}}
            {lsccip:addressBlock} {{lsccip:addressBlock} {} {} {}}
        }
    }
    set addressBlock_desc {{lsccip:addressBlock} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:baseAddress} {{lsccip:baseAddress} {} {0} {}}
            {lsccip:range} {{lsccip:range} {} {4096} {}}
            {lsccip:width} {{lsccip:width} {} {32} {}}
        }
    }

    set abstractionDefinition_desc {
        {ipxact:abstractionDefinition}
        {{0} {xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:ipxact="http://www.accellera.org/XMLSchema/IPXACT/1685-2014"
            xsi:schemaLocation="http://www.accellera.org/XMLSchema/IPXACT/1685-2014 http://www.accellera.org/XMLSchema/IPXACT/1685-2014/index.xsd"}}
        {} {{ipxact:vendor} {{ipxact:vendor} {} {} {}}
            {ipxact:library} {{ipxact:library} {} {} {}}
            {ipxact:name} {{ipxact:name} {} {} {}}
            {ipxact:version} {{ipxact:version} {} {} {}}
            {ipxact:busType} {{ipxact:busType} {} {} {}}
            {ipxact:ports} {{ipxact:ports} {} {} {}}
            {ipxact:description} {{ipxact:description} {} {} {}}
        }
    }

    set busDefinition_desc {
        {ipxact:busDefinition} 
        {{0} {xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:ipxact="http://www.accellera.org/XMLSchema/IPXACT/1685-2014"
            xsi:schemaLocation="http://www.accellera.org/XMLSchema/IPXACT/1685-2014 http://www.accellera.org/XMLSchema/IPXACT/1685-2014/index.xsd"}}
        {} {{ipxact:vendor} {{ipxact:vendor} {} {} {}}
            {ipxact:library} {{ipxact:library} {} {} {}}
            {ipxact:name} {{ipxact:name} {} {} {}}
            {ipxact:version} {{ipxact:version} {} {} {}}
            {ipxact:directConnection} {{ipxact:directConnection} {} {} {}}
            {ipxact:isAddressable} {{ipxact:isAddressable} {} {} {}}
            {ipxact:description} {{ipxact:description} {} {} {}}
        }
    }

    set if { {} {} {} {
            abstractionDefinition_desc {{} {} {} {}}
            busDefinition_desc {{} {} {} {}}
        }
    }

# <ipxact:requiresDriver driverType="singleShot">true</ipxact:requiresDriver>
# <ipxact:requiresDriver driverType="clock">true</ipxact:requiresDriver>
    set port_desc {
        {ipxact:port} {} {} {
            {ipxact:logicalName} {{ipxact:logicalName} {} {} {}}
            {ipxact:description} {{ipxact:description} {} {} {}}
            {ipxact:wire} {{ipxact:wire} {} {} {
                    {ipxact:qualifier} {{ipxact:qualifier} {} {} {
                            {ipxact:isClock} {{} {} {} {}}
                            {ipxact:isReset} {{} {} {} {}}
                            {ipxact:isAddress} {{} {} {} {}}
                            {ipxact:isData} {{} {} {} {}}
                        }
                    }
                    {ipxact:onMaster} {{ipxact:onMaster} {} {} {
                            {ipxact:presence} {{ipxact:presence} {} {optional} {}}
                            {ipxact:width} {{} {} {} {}}
                            {ipxact:direction} {{ipxact:direction} {} {out} {}}
                        }
                    }
                    {ipxact:onSlave} {{ipxact:onSlave} {} {} {
                            {ipxact:presence} {{ipxact:presence} {} {optional} {}}
                            {ipxact:width} {{} {} {} {}}
                            {ipxact:direction} {{ipxact:direction} {} {in} {}}
                        }
                    }
                    {ipxact:requiresDriver} {{} {} {} {}}
                }
            }
        }
    }

    proc create_interface {args} {
        array set opt [list -if "$::ipl::if" \
            -vendor "" \
            -library "" \
            -name "" \
            -version "" \
            -directConnection "" \
            -isAddressable "" \
            -description "" \
            -ports ""  \
        {*}$args]
        
        set if $opt(-if)
        set ports $opt(-ports)
        set library $opt(-library)
        set name $opt(-name)
        set version $opt(-version)
        set vendor $opt(-vendor)

        set optla {
            vendor
            library
            name
            version
            description
        }
        set optlb {
            vendor
            library
            name
            version
            directConnection
            isAddressable
            description
        }
        if {[ipl::getnchilds {} abstractionDefinition_desc $if] == ""} {
            set abst $::ipl::abstractionDefinition_desc
            set if [ipl::setnode {} abstractionDefinition_desc $abst $if]
        }
        if {[ipl::getnchilds {} busDefinition_desc $if] == ""} {
            set busd $::ipl::busDefinition_desc
            set if [ipl::setnode {} busDefinition_desc $busd $if]
        }
        set atts [list library "library=\"$library\"" \
            name "name=\"$name\"" \
            vendor "vendor=\"$vendor\"" \
            version "version=\"$version\""]
        set if [ipl::setatts abstractionDefinition_desc ipxact:busType $atts $if]
        foreach op $optla {
            set val $opt(-$op)
            if {$val != ""} {
                if {[ipl::getnname abstractionDefinition_desc "ipxact:$op" $if] != ""} {
                    set if [ipl::setncont abstractionDefinition_desc "ipxact:$op" $val $if]
                } else {
                    set if [ipl::setnode abstractionDefinition_desc "ipxact:$op" [list "ipxact:$op" {} $val {}] $if]
                }
            }
        }
        foreach op $optlb {
            set val $opt(-$op)
            if {$val != ""} {
                if {[ipl::getnname busDefinition_desc "ipxact:$op" $if] != ""} {
                    set if [ipl::setncont busDefinition_desc "ipxact:$op" $val $if]
                } else {
                    set if [ipl::setnode busDefinition_desc "ipxact:$op" [list "ipxact:$op" {} $val {}] $if]
                }
            }
        }
        set if [ipl::add_interface_ports $if $ports]
        return $if
    }

    proc add_interface_port {args} {
        array set opt [list -if "$::ipl::if" \
            -logicalName "" \
            -description "" \
            -qualifier "data" \
            -presence "" \
            -width "" \
            -direction "" \
        {*}$args]

        set if $opt(-if)
        set logicalName $opt(-logicalName)
        set description $opt(-description)
        set qualifier $opt(-qualifier)
        set presence $opt(-presence)
        set width $opt(-width)
        set direction $opt(-direction)
        set port $::ipl::port_desc

        if {$logicalName != ""} {
            set port [ipl::setncont {} ipxact:logicalName $logicalName $port]
        }
        if {$description != ""} {
            set port [ipl::setncont {} ipxact:description $description $port]
        } else {
            set port [ipl::setncont {} ipxact:description "$logicalName port" $port]
        }
        switch $qualifier {
            clock {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isClock ipxact:isClock $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isClock true $port]
            }
            reset {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isReset ipxact:isReset $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isReset true $port]
            }
            data {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isData ipxact:isData $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isData true $port]
            }
            address {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isAddress ipxact:isAddress $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isAddress true $port]
            }
            add {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isAddress ipxact:isAddress $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isAddress true $port]
            }
        }
        if {$presence != ""} {
            set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:presence $presence $port]
            set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:presence $presence $port]
        }
        if {$width != ""} {
            set port [ipl::setnname ipxact:wire/ipxact:onMaster ipxact:width ipxact:width $port]
            set port [ipl::setnname ipxact:wire/ipxact:onSlave ipxact:width ipxact:width $port]
            set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:width $width $port]
            set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:width $width $port]
        }
        if {$direction != ""} {
            if {$direction == "in"} {
                set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:direction in $port]
                set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:direction out $port]
            }
            if {$direction == "out"} {
                set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:direction out $port]
                set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:direction in $port]
            }
        }
        if {$qualifier == "clock" || $qualifier == "reset"} {
            set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:direction in $port]
            set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:direction in $port]
            set port [ipl::setnname ipxact:wire ipxact:requiresDriver ipxact:requiresDriver $port]
            switch $qualifier {
                clock {
                    set port [ipl::setatt ipxact:wire ipxact:requiresDriver driverType "driverType=\"clock\"" $port]
                }
                reset {
                    set port [ipl::setatt ipxact:wire ipxact:requiresDriver driverType "driverType=\"singleShot\"" $port]
                }
            }
            set port [ipl::setncont ipxact:wire ipxact:requiresDriver true $port]
        }
        if {[ipl::getnchilds {} abstractionDefinition_desc $if] == ""} {
            set abst $::ipl::abstractionDefinition_desc
            set if [ipl::setnode {} abstractionDefinition_desc $abst $if]
        }
        set if [ipl::setnode abstractionDefinition_desc/ipxact:ports $logicalName $port $if]
        return $if
    }

    proc add_interface_ports {if ports} {
        foreach port $ports {
            set opts {}
            if {[dict keys $port -n] != ""} {
                dict set opts -logicalName [dict get $port -n]
            }
            if {[dict keys $port -d] != ""} {
                dict set opts -direction [dict get $port -d]
            }
            if {[dict keys $port -w] != ""} {
                dict set opts -width [dict get $port -w]
            }
            if {[dict keys $port -q] != ""} {
                dict set opts -qualifier [dict get $port -q]
            }
            if {[dict keys $port -p] != ""} {
                dict set opts -presence [dict get $port -p]
            }
            set if [ipl::add_interface_port -if $if {*}$opts]
        }
        return $if
    }

    proc generate_interface {if {dpath ""}} {
        if {$dpath == ""} {
            set dpath $ipl::PropelIPLocal_path/interfaces
        }

        set abstractionDefinition [ipl::getnode {} abstractionDefinition_desc $if]
        set busDefinition [ipl::getnode {} busDefinition_desc $if]

        set vendor [ipl::getncont busDefinition_desc ipxact:vendor $if]
        set library [ipl::getncont busDefinition_desc ipxact:library $if]
        set name [ipl::getncont busDefinition_desc ipxact:name $if]
        set version [ipl::getncont busDefinition_desc ipxact:version $if]

        if {[file exist $dpath/$vendor/$library/$name/$version] != 1} {
            file mkdir $dpath/$vendor/$library/$name/$version
        }

        set busdef [open "$dpath/$vendor/$library/$name/$version/${name}.xml" w]
        puts $busdef {<?xml version="1.0" encoding="UTF-8"?>}
        puts $busdef [ipl::generate_xml $busDefinition]
        close $busdef
        set abstdef [open "$dpath/$vendor/$library/$name/$version/${name}_rtl.xml" w]
        puts $abstdef {<?xml version="1.0" encoding="UTF-8"?>}
        puts $abstdef [ipl::generate_xml $abstractionDefinition]
        close $abstdef
    }

    set ip [list {} {} {} [list fdeps {{fdeps} {} {} {
                {eval} {}
                {plugin} {}
                {doc} {}
                {rtl} {}
                {testbench} {}
                {driver} {}
                {ldc} {}
            }} \
        ip_desc $ip_desc addressSpaces_desc {} \
        busInterfaces_desc {} \
        memoryMaps_desc {}]]

    proc generate_xml {node {nid "0"} {index 0}} {
        set name [lindex $node 0]
        set attr [lindex $node 1]
        set content [lindex $node 2]
        set childs [lindex $node 3]

        if {$name == ""} {
            set xmlstring ""
            foreach {id child} $childs {
                set xmlstring "$xmlstring[generate_xml $child $id $index]"
            }
        } else {
            set xmlstring "[string repeat "    " $index]<$name"
            if {$name == "lsccip:port" || $name == "lsccip:setting"} {
                set rep [expr [string length $name] + 1]
                foreach {id att} $attr {
                    set xmlstring "$xmlstring $att\n[string repeat "    " $index][string repeat " " $rep]"
                }
            } else {
                foreach {id att} $attr {
                    set xmlstring "$xmlstring $att"
                }
            }
            if {$content == "" && $childs == ""} {
                set xmlstring "$xmlstring/>\n"
            } elseif {$content != "" && $childs == ""} {
                set xmlstring "$xmlstring>$content</$name>\n"
            } else {
                set xmlstring "$xmlstring>$content\n"
                foreach {id child} $childs {
                    set xmlstring "$xmlstring[generate_xml $child $id [expr $index + 1]]"
                }
                set xmlstring "$xmlstring[string repeat "    " $index]</$name>\n"
            }
        }
        return $xmlstring
    }

    proc setnode {path id node {desc {"" "" "" ""}}} {
        set debug 0
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]
        if {$debug} {
            puts "pth: $pth"
            puts "pth0: $pth0"
            puts "pt: $pt"
        }
        if {[llength $pth] != 0 } {
            if {$debug} {
                puts "dict keys childs pth0: [dict keys $childs $pth0]"
                puts "childs: $childs"
            }
            if {[dict keys $childs $pth0] != ""} {
                if {$debug} {
                    puts "childs(pth0): [dict get $childs $pth0]"
                }
                dict set childs $pth0 [setnode $pt $id $node [dict get $childs $pth0]]
                lset desc 3 $childs
                if {$debug} {
                    puts "childs: $childs"
                }
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                setnode {path id node {desc {}}} process!}
            }
        } else {
            dict set childs $id $node
            lset desc 3 $childs
        }
        return $desc
    }

    proc getnode {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                return [getnode $pt $id [dict get $childs $pth0]]
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                getnode {path id node {desc {}}} process!}
                exit 2
            }
        } else {
            if {[dict keys $childs $id] != ""} {
                return [dict get $childs $id]
            }
        }
    }

    proc rmnode {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                dict set childs $pth0 [rmnode $pt $id [dict get $childs $pth0]]
                lset desc 3 $childs
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                rmnode {path id node {desc {}}} process!}
                exit 2
            }
        } else {
            if {[dict keys $childs $id] != ""} {
                dict unset childs $id
                lset desc 3 $childs
            } else {
                puts "rmnode:"
                puts "WARNING, no element with id:$id found!"
            }
        }
        return $desc
    }

    proc getnchilds {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                return [getnchilds $pt $id [dict get $childs $pth0]]
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                getnode {path id node {desc {}}} process!}
                exit 2
            }
        } else {
            if {[dict keys $childs $id] != ""} {
                set node [dict get $childs $id]
                return [lindex $node 3]
            }
        }
    }

    proc rmnchilds {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                dict set childs $pth0 [rmnchilds $pt $id [dict get $childs $pth0]]
                lset desc 3 $childs
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                rmnode {path id node {desc {}}} process!}
                exit 2
            }
        } else {
            if {[dict keys $childs $id] != ""} {
                set node [dict get $childs $id]
                lset node 3 {}
                dict set childs $id $node
                lset desc 3 $childs
            } else {
                puts "rmnchilds:"
                puts "WARNING, no element with id:$id found!"
            }
        }
        return $desc
    }

    proc getatts {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        return [lindex $node 1]
    }
    proc getatt {path nodeid attid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        set atts [lindex $node 1]
        return [dict get $atts $attid]
    }
    proc setatts {path nodeid atts {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 1 $atts
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc setatt {path nodeid attid att {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        set atts [lindex $node 1]
        dict set atts $attid $att
        lset node 1 $atts
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc rmatts {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 1 {}
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc rmatt {path nodeid attid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        set atts [lindex $node 1]
        dict unset atts $attid
        lset node 1 $atts
        return [ipl::setnode $path $nodeid $node $desc]
    }

    proc getnname {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        return [lindex $node 0]
    }
    proc setnname {path nodeid nname {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 0 $nname
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc rmnname {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 0 {}
        return [ipl::setnode $path $nodeid $node $desc]
    }

    proc getncont {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        return [lindex $node 2]
    }
    proc setncont {path nodeid cont {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 2 $cont
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc rmncont {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 2 {}
        return [ipl::setnode $path $nodeid $node $desc]
    }

    proc general {args} {
        array set opt [list -ip "$::ipl::ip" \
            -vendor "analog.com" \
            -library "ip" \
            -name "" \
            -display_name "" \
            -version "1.0" \
            -category "ADI" \
            -keywords "ADI IP" \
            -min_radiant_version "2022.1" \
            -max_radiant_version "" \
            -type "" \
            -min_esi_version "2022.1" \
            -max_esi_version "" \
            -supported_products "" \
            -supported_platforms "" \
            -href "" \
        {*}$args]

        set optl {
            vendor
            library
            name
            display_name
            version
            category
            keywords
            min_radiant_version
            max_radiant_version
            type
            min_esi_version
            max_esi_version
        }
        set ip $opt(-ip)
        set href $opt(-href)
        set supported_products $opt(-supported_products)
        set supported_platforms $opt(-supported_platforms)

        if {$href != ""} {
            set ip [ipl::setncont ip_desc/lsccip:general href $href $ip]
        }

        foreach op $optl {
            set val $opt(-$op)
            if {$val != ""} {
                if {[ipl::getnname ip_desc/lsccip:general "lsccip:$op" $ip] != ""} {
                    set ip [ipl::setncont ip_desc/lsccip:general "lsccip:$op" $val $ip]
                } else {
                    set ip [ipl::setnode ip_desc/lsccip:general "lsccip:$op" [list "lsccip:$op" {} $val {}] $ip]
                }
            }
        }
        foreach family $supported_products {
            set sfamily [list lsccip:supported_family [list name "name=\"$family\""] {} {}]
            set ip [ipl::setnode ip_desc/lsccip:general/lsccip:supported_products $family $sfamily $ip]
        }
        foreach platform $supported_platforms {
            set splatform [list lsccip:supported_platform [list name "name=\"$platform\""] {} {}]
            set ip [ipl::setnode ip_desc/lsccip:general/lsccip:supported_platforms $platform $splatform $ip]
        }
        return $ip
    }

    proc set_wrapper_type {args} {
        array set opt [list -ip "$::ipl::ip" \
            -file_ext "v" \
        {*}$args]

        set ip $opt(-ip)
        set file_ext $opt(-file_ext)

        if {[ipl::getnname ip_desc lsccip:outFileConfigs $ip] == ""} {
            set ip [ipl::setnname ip_desc lsccip:outFileConfigs lsccip:outFileConfigs $ip]
        }

        if {$file_ext == "v"} {
            set atts {name {name="wrapper"} file_suffix {file_suffix="v"} file_description {file_description="top_level_verilog"}}
        } elseif {$file_ext == "sv"} {
            set atts {name {name="wrapper"} file_suffix {file_suffix="sv"} file_description {file_description="top_level_system_verilog"}}
        }
        set node [list lsccip:fileConfig $atts {} {}]
        set ip [ipl::setnode ip_desc/lsccip:outFileConfigs wrapper_type $node $ip]

        return $ip
    }

    proc set_parameter {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -id "" \
            -title "" \
            -type "" \
            -value_type "" \
            -conn_mod "" \
            -default "" \
            -value_expr "" \
            -options "" \
            -output_formatter "" \
            -bool_value_mapping "" \
            -editable "" \
            -hidden "" \
            -drc "" \
            -regex "" \
            -value_range "" \
            -config_groups "" \
            -description "" \
            -group1 "" \
            -group2 "" \
            -macro_name "" \
        {*}$args]
        # -optional for entering exact xml attribute string

        set optl {
            id
            type
            value_type
            conn_mod
            title
            default
            value_expr
            options
            output_formatter
            bool_value_mapping
            editable
            hidden
            drc
            regex
            value_range
            config_groups
            description
            group1
            group2
            macro_name
        }

        set ip $opt(-ip)
        set id $opt(-id)

        set c {"}
        set atts {}
        foreach attid $optl {
            set att $opt(-$attid)
            if {$att != ""} {
                set atts [list {*}$atts $attid "${attid}=$c$att$c"]
            }
        }
        set stnode [ipl::getnode ip_desc lsccip:settings $ip]
        if {$debug} {
            puts $stnode
        }
        if {[lindex $stnode 0] == ""} {
            lset stnode 0 {lsccip:settings}
            if {$debug} {
                puts $stnode
            }
            set ip [ipl::setnode ip_desc lsccip:settings $stnode $ip]
        }
        if {$id != ""} {
            if {[ipl::getnode ip_desc/lsccip:settings $id $ip] != ""} {
                foreach attid $optl {
                    set att $opt(-$attid)
                    if {$att != ""} {
                        set ip [ipl::setatt ip_desc/lsccip:settings $id $attid "${attid}=$c$att$c" $ip]
                    }
                }
            } else {
                set node [list lsccip:setting $atts {} {}]
                set ip [ipl::setnode ip_desc/lsccip:settings $id $node $ip]
            }
        } else {
            puts "WARNING, you must define '-id'"
        }
        return $ip
    }

    proc set_port {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -dir "" \
            -range "" \
            -conn_mod "" \
            -conn_port "" \
            -conn_range "" \
            -stick_high "" \
            -stick_low "" \
            -stick_value "" \
            -dangling "" \
            -bus_interface "" \
            -attribute "" \
            -port_type "" \
        {*}$args]
        # -optional for entering exact xml attribute string

        set ip $opt(-ip)
        set id $opt(-name)
    
        set optl {
            name
            dir
            conn_mod
            range
            conn_port
            conn_range
            stick_high
            stick_low
            stick_value
            dangling
            bus_interface
            attribute
            port_type
        }

        set c {"}
        set atts {}
        foreach attid $optl {
            set att $opt(-$attid)
            if {$att != ""} {
                set atts [list {*}$atts $attid "${attid}=$c$att$c"]
            }
        }
        set ptnode [ipl::getnode ip_desc lsccip:ports $ip]
        if {$debug} {
            puts $ptnode
        }
        if {[lindex $ptnode 0] == ""} {
            lset ptnode 0 {lsccip:ports}
            if {$debug} {
                puts $ptnode
            }
            set ip [ipl::setnode ip_desc lsccip:ports $ptnode $ip]
        }
        if {$id != ""} {
            if {[ipl::getnode ip_desc/lsccip:ports $id $ip] != ""} {
                foreach attid $optl {
                    set att $opt(-$attid)
                    if {$att != ""} {
                        set ip [ipl::setatt ip_desc/lsccip:ports $id $attid "${attid}=$c$att$c" $ip]
                    }
                }
            } else {
                set node [list lsccip:port $atts {} {}]
                set ip [ipl::setnode ip_desc/lsccip:ports $id $node $ip]
            }
        } else {
            puts "WARNING, you must define '-name'"
        }
        return $ip
    }

    proc ignore_ports {args} {
        array set opt [list -ip "$::ipl::ip" \
            -portlist "" \
            -expression "" \
        {*}$args]

        set ip $opt(-ip)
        set portlist $opt(-portlist)
        set expression $opt(-expression)

        foreach port $portlist {
            set ip [ipl::set_port -ip $ip -name $port -dangling $expression]
        }
        return $ip
    }

    proc get_ports_by_prefix {args} {
        array set opt [list -mod_data "" \
            -v_prefix "" \
            -xptn_portlist "" \
        {*}$args]

        set mod_data $opt(-mod_data)
        set v_prefix $opt(-v_prefix)
        set xptn_portlist $opt(-xptn_portlist)
        set ports [dict get $mod_data portlist]

        set portlist {}
        set regx [list ${v_prefix}_.+]
        foreach line $ports {
            set pname [dict get $line name]
            if {[lsearch $xptn_portlist $pname] == -1 && [regexp $regx $pname]} {
                set portlist [list {*}$portlist $pname]
            }
        }
        return $portlist
    }

    proc ignore_ports_by_prefix {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
            -v_prefix "" \
            -xptn_portlist "" \
            -expression "" \
        {*}$args]

        set ip $opt(-ip)
        set mod_data $opt(-mod_data)
        set expression $opt(-expression)

        set v_prefix $opt(-v_prefix)
        set xptn_portlist $opt(-xptn_portlist)

        set portlist [ipl::get_ports_by_prefix -mod_data $mod_data -v_prefix $v_prefix -xptn_portlist $xptn_portlist]

        set ip [ipl::ignore_ports -ip $ip -expression $expression -portlist $portlist]
        return $ip
    }

    proc add_component_generator {args} {
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -generator "" \
        {*}$args]

        set ip $opt(-ip)
        set name $opt(-name)
        set generator $opt(-generator)

        if {$name != ""} {
            if {[ipl::getnname ip_desc lsccip:componentGenerators $ip] == ""} {
                set ip [ipl::setnname ip_desc lsccip:componentGenerators lsccip:componentGenerators $ip]
            }
            set cpgen $::ipl::componentGenerator_desc
            set cpgen [ipl::setncont {} lsccip:name $name $cpgen]
            set cpgen [ipl::setncont {} lsccip:generatorExe $generator $cpgen]
            set ip [ipl::setnode ip_desc/lsccip:componentGenerators $name $cpgen $ip]
        }
        return $ip
    }

    proc add_address_space {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -range "" \
            -width "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-name)
        set name $opt(-name)
        set range $opt(-range)
        set width $opt(-width)

        if {$name != ""} {
            set adnode [ipl::getnode "" addressSpaces_desc $ip]
            if {$debug} {
                puts $adnode
            }
            if {[lindex $adnode 0] == ""} {
                set adnode $::ipl::addressSpaces_desc
                if {$debug} {
                    puts $adnode
                }
                set ip [ipl::setnode "" addressSpaces_desc $adnode $ip]
            }
            set addrsp $::ipl::addressSpace_desc
            set addrsp [ipl::setncont {} lsccip:name $name $addrsp]
            if {$range != ""} {
                set addrsp [ipl::setncont {} lsccip:range $range $addrsp]
            }
            if {$width != ""} {
                set addrsp [ipl::setncont {} lsccip:width $width $addrsp]
            }
   
            set ip [ipl::setnode addressSpaces_desc $id $addrsp $ip]
        }

        return $ip
    }

    proc add_memory_map {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -description "" \
            -baseAddress "" \
            -range "" \
            -width "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-name)
        set name $opt(-name)
        set description $opt(-description)
        set baseAddress $opt(-baseAddress)
        set range $opt(-range)
        set width $opt(-width)

        if {$name != ""} {
            set mmapsnode [ipl::getnode "" memoryMaps_desc $ip]
            if {$debug} {
                puts $mmapsnode
            }
            if {[lindex $mmapsnode 0] == ""} {
                set mmapsnode $::ipl::memoryMaps_desc
                if {$debug} {
                    puts $mmapsnode
                }
                set ip [ipl::setnode "" memoryMaps_desc $mmapsnode $ip]
            }
            set mmapn $::ipl::memoryMap_desc
            set mmapn [ipl::setncont {} lsccip:name $name $mmapn]
            set mmapn [ipl::setncont {} lsccip:description $description $mmapn]
            set adbln $::ipl::addressBlock_desc
            set adbln [ipl::setncont {} lsccip:name ${name}_reg_space $adbln]
            if {$baseAddress != ""} {
                set adbln [ipl::setncont {} lsccip:baseAddress $baseAddress $adbln]
            }
            if {$range != ""} {
                set adbln [ipl::setncont {} lsccip:range $range $adbln]
            }
            if {$width != ""} {
                set adbln [ipl::setncont {} lsccip:width $width $adbln]
            }
   
            set mmapn [ipl::setnode {} lsccip:addressBlock $adbln $mmapn]
            set ip [ipl::setnode memoryMaps_desc $id $mmapn $ip]
        }

        return $ip
    }

    set inclid 0
    proc include {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -id "" \
            -include "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-id)
        set include $opt(-include)
        
        if {$include != ""} {
            set c {"}
            # set include [format {parse="xml" href="%s"} $include]
            set node [list xi:include [list href href=$c$include$c parse {parse="xml"}] {} {}]
            if {$debug} {
                puts $node
            }
            if {$id == ""} {
                set ip [ipl::setnode ip_desc/xi:include $::ipl::inclid $node $ip]
                incr ipl::inclid
            } else {
                set ip [ipl::setnode ip_desc/xi:include $id $node $ip]
            }
        }
        return $ip
    }

    proc generate_ip {ip {dpath ""} {ip_name ""}} {
        if {$ip_name == ""} {
            set ip_name [ipl::getncont ip_desc/lsccip:general lsccip:name $ip]
        }
        if {$dpath == ""} {
            set dpath $ipl::PropelIPLocal_path
        }
        if {[file exist $dpath] != 1} {
            file mkdir $dpath
        }
        if {[file exist $dpath/$ip_name/doc] != 1} {
            file mkdir $dpath/$ip_name/doc
        }
        set file [open "$dpath/$ip_name/doc/introduction.html" w]
        foreach line [ipl::docsgen $ip] {
            puts $file $line
        }
        close $file
        set fdeps [ipl::getnchilds {} fdeps $ip]
        foreach {folder flist} $fdeps {
            if {$flist != ""} {
                if {[file exists $dpath/$ip_name/$folder] != 1} {
                    file mkdir $dpath/$ip_name/$folder
                }
                file copy -force {*}$flist $dpath/$ip_name/$folder
            }
        }

        set busInterfaces_desc [ipl::getnode {} busInterfaces_desc $ip]
        if {$busInterfaces_desc != ""} {
            set ip [ipl::include -ip $ip -include bus_interface.xml]
            set file [open "$dpath/$ip_name/bus_interface.xml" w]
            puts [generate_xml $busInterfaces_desc]
            puts $file [generate_xml $busInterfaces_desc]
            close $file
        } else {
            puts "WARNING, No busInterfaces_desc defined!"
        }
        set addressSpaces_desc [ipl::getnode {} addressSpaces_desc $ip]
        if {$addressSpaces_desc != ""} {
            set ip [ipl::include -ip $ip -include address_space.xml]
            set file [open "$dpath/$ip_name/address_space.xml" w]
            puts [generate_xml $addressSpaces_desc]
            puts $file [generate_xml $addressSpaces_desc]
            close $file
        } else {
            puts "WARNING, No addressSpaces_desc defined!"
        }
        set memoryMaps_desc [ipl::getnode {} memoryMaps_desc $ip]
        if {$memoryMaps_desc != ""} {
            set ip [ipl::include -ip $ip -include memory_map.xml]
            set file [open "$dpath/$ip_name/memory_map.xml" w]
            puts [generate_xml $memoryMaps_desc]
            puts $file [generate_xml $memoryMaps_desc]
            close $file
        } else {
            puts "WARNING, No memoryMaps_desc defined!"
        }
        set ip_desc [ipl::getnode {} ip_desc $ip]
        if {$ip_desc != ""} {
            set file [open "$dpath/$ip_name/metadata.xml" w]
            puts [generate_xml $ip_desc]
            puts $file [generate_xml $ip_desc]
            close $file
        } else {
            puts "ERROR, No ip_desc defined!"
        }
    }

    proc parse_module {path} {
        set debug 0
        set file [open $path]
        set data [read $file]
        close $file

        if {[regexp {\n\s*module\s+[^#(\n]+} $data match]} {
            set mod_name [string map {" " ""} [lindex $match 1]]
        } else {
            puts {ERROR, no module found in the verilog file!}
            exit 2
        }
        
        set lines [regexp -all -inline {\n\s*parameter[^,\n]+|\n\s*input[^,\n]+|\n\s*output[^,\n]+|\n\s*inout[^,\n]+} $data]
        set portlist {}
        set parlist {}
        foreach line $lines {
            set type [lindex $line 0]
            set values [lrange $line 1 end]
            if {[llength $line] == 2} {
                if {$type == "parameter"} {
                    set parameter [string map {" " ""} [lindex $values 0]]
                    set portdata [list type $type name $parameter]
                    set parlist [list {*}$parlist $portdata]
                    if {$debug} {
                        puts "$type\t$parameter"
                    }
                } else {
                    set portname [string map {" " ""} [lindex $values 0]]
                    set portdata [list type $type name $portname]
                    set portlist [list {*}$portlist $portdata]
                    if {$debug} {
                        puts "$type\t$portname"
                    }
                }
            } elseif {[llength $line] > 2} {
                if {$type == "parameter"} {
                    if {[llength $line] == 3} {
                        set parameter [string map {" " ""} [lindex $values 1]]
                        set portdata [list type $type name $parameter]
                        set parlist [list {*}$parlist $portdata]
                    }
                    if {[llength $line] == 4} {
                        set values [split $values "="]
                        set parameter [string map {" " ""} [lindex $values 0]]
                        set default_value [string map {" " ""} [lindex $values 1]]
                        set portdata [list type $type name $parameter defval $default_value]
                        set parlist [list {*}$parlist $portdata]
                        if {$debug} {
                            puts "$type\t$parameter = $default_value"
                        }
                    }
                    if {[llength $line] == 5} {
                        set values [split $values "="]
                        set valtype [string map {" " ""} [lindex [lindex $values 0] 0]]
                        set parameter [string map {" " ""} [lindex [lindex $values 0] 1]]
                        set default_value [string map {" " ""} [lindex $values 1]]
                        set portdata [list type $type name $parameter defval $default_value valtype $valtype]
                        set parlist [list {*}$parlist $portdata]
                        if {$debug} {
                            puts "$type\t$parameter = $default_value"
                        }
                    }
                } else {
                    if {[regexp {^.+\[.+$} $line]} {
                        set sep {[}
                        set values [split $line $sep]
                        set sep {]}
                        set values [split [lindex $values 1] $sep]

                        set range [string map {" " ""} [lindex $values 0]]
                        set from_to [split $range ":"]
                        set from [string map {" " ""} [lindex $from_to 0]]
                        set to [string map {" " ""} [lindex $from_to 1]]
                        set portname [string map {" " ""} [lindex $values 1]]

                        set portdata [list type $type name $portname from $from to $to]
                        set portlist [list {*}$portlist $portdata]
                        if {$debug} {
                            puts "$type\t$from\t:\t$to\t$portname"
                        }
                    } else {
                        set portname [string map {" " ""} [lindex $values 1]]
                        set portdata [list type $type name $portname]
                        set portlist [list {*}$portlist $portdata]
                    }
                }
            }
        }
        set mod_data [list portlist $portlist parlist $parlist mod_name $mod_name]
        return $mod_data
    }

    proc add_interface {args} {
        array set opt [list -ip "$::ipl::ip" \
            -vendor "" \
            -library "" \
            -name "" \
            -version "" \
            -inst_name "" \
            -display_name "" \
            -description "" \
            -abstraction_ref "" \
            -master_slave "" \
            -mem_map_ref "" \
            -addr_space_ref "" \
            -portmap "" \
        {*}$args]

        set c {"}
        set ip $opt(-ip)
        set inst_name $opt(-inst_name)
        set display_name $opt(-display_name)
        set description $opt(-description)
        set vendor $opt(-vendor)
        set library $opt(-library)
        set name $opt(-name)
        set version $opt(-version)
        set master_slave $opt(-master_slave)
        set mem_map_ref $opt(-mem_map_ref)
        set addr_space_ref $opt(-addr_space_ref)
        set portmap $opt(-portmap)

        set atts [list library "library=\"$library\"" \
            name "name=\"$name\"" \
            vendor "vendor=\"$vendor\"" \
            version "version=\"$version\""]

        set bif $::ipl::busInterface_desc
        set bif [ipl::setncont {} lsccip:name $inst_name $bif]
        set bif [ipl::setncont {} lsccip:displayName $display_name $bif]
        set bif [ipl::setncont {} lsccip:description $description $bif]
        set bif [ipl::setatts {} lsccip:busType $atts $bif]
        dict set atts name "name=\"${name}_rtl\""
        set bif [ipl::setatts lsccip:abstractionTypes/lsccip:abstractionType lsccip:abstractionRef $atts $bif]
        set bif [ipl::setnname {} lsccip:master_slave lsccip:$master_slave $bif]

        if {$master_slave == "slave" && $mem_map_ref != ""} {
            set mmap_ref_node [list lsccip:memoryMapRef [list memoryMapRef "memoryMapRef=\"$mem_map_ref\""] {} {}]
            set bif [ipl::setnode lsccip:master_slave lsccip:memoryMapRef $mmap_ref_node $bif]
        }
        if {$master_slave == "master" && $addr_space_ref != ""} {
            set aspace_ref_node [list lsccip:addressSpaceRef [list addressSpaceRef "addressSpaceRef=\"$addr_space_ref\""] {} {}]
            set bif [ipl::setnode lsccip:master_slave lsccip:addressSpaceRef $aspace_ref_node $bif]
        }

        foreach line $portmap {
            set pname [lindex $line 0]
            set logic [lindex $line 1]
            set pmap [ipl::setncont lsccip:logicalPort lsccip:name $logic $::ipl::portMap_desc]
            set pmap [ipl::setncont lsccip:physicalPort lsccip:name $pname $pmap]
            set bif [ipl::setnode lsccip:abstractionTypes/lsccip:abstractionType/lsccip:portMaps $pname $pmap $bif]
            set ip [ipl::set_port -ip $ip -name $pname -bus_interface $inst_name]
        }
        set bifs [ipl::getnode {} busInterfaces_desc $ip]
        if {$bifs == ""} {
            set bifs $::ipl::busInterfaces_desc
        }
        set bifsl [lindex $bifs 3]
        dict set bifsl $inst_name $bif
        lset bifs 3 $bifsl
        set ip [ipl::setnode {} busInterfaces_desc $bifs $ip]

        return $ip
    }

    proc add_interface_by_prefix {args} {
        array set opt [list -ip "$::ipl::ip" \
            -vendor "" \
            -library "" \
            -name "" \
            -version "" \
            -inst_name "" \
            -display_name "" \
            -description "" \
            -master_slave "" \
            -mem_map_ref "" \
            -addr_space_ref "" \
            -mod_data "" \
            -v_prefix "" \
            -xptn_portlist "" \
            -t "" \
        {*}$args]

        set optl {
            -ip
            -inst_name
            -display_name
            -description
            -vendor
            -library
            -name
            -version
            -master_slave
            -mem_map_ref
            -addr_space_ref
        }
        set argl {}
        foreach op $optl {
            set argl [list {*}$argl $op $opt($op)]
        }
 
        set mod_data $opt(-mod_data)
        set v_prefix $opt(-v_prefix)
        set xptn_portlist $opt(-xptn_portlist)
        set t $opt(-t)

        set portmap {}
        set portlist [ipl::get_ports_by_prefix -mod_data $mod_data -v_prefix $v_prefix -xptn_portlist $xptn_portlist]

        foreach pname $portlist {
            set logic [string toupper "$t[string map [list ${v_prefix}_ ""] $pname]" ]
            set portmap [list {*}$portmap [list $pname $logic]]
        }
        return [ipl::add_interface {*}$argl -portmap $portmap]
    }

    proc add_ports_from_module {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
        {*}$args]
        set ip $opt(-ip)
        set mod_data $opt(-mod_data)
        # to do: check the input parameters
        set mod_name [dict get $mod_data mod_name]

        foreach data [dict get $mod_data portlist] {
            set dir [dict get $data type]
            switch $dir {
                input {
                    set dir in
                }
                output {
                    set dir out
                }
                inout {
                    set dir inout
                }
            }
            set name [dict get $data name]
            set op {(}
            set cl {)}
            if {[llength $data] > 4} {
                set from [dict get $data from]
                set to [dict get $data to]
                set ip [ipl::set_port -ip $ip -name $name \
                    -dir $dir -range "${op}int$op$from$cl,$to$cl" \
                    -conn_port $name \
                    -conn_mod $mod_name]
            } else {
                set ip [ipl::set_port -ip $ip -name $name \
                    -dir $dir \
                    -conn_port $name \
                    -conn_mod $mod_name]
            }
        }
        return $ip
    }

    proc add_parameters_from_module {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
        {*}$args]
        set ip $opt(-ip)
        set mod_data $opt(-mod_data)

        # to do: check the input parameters
        set mod_name [dict get $mod_data mod_name]
        foreach data [dict get $mod_data parlist] {
            set name [dict get $data name]
            if {[llength $data] > 4} {
                # check if parameter type is set
                set defval [dict get $data defval]
                set regxf {^\s*-?[0-9]*\.[0-9]+\s*$}
                set regxi {^\s*-?[0-9]+\s*$}
                set regxstr {^\".*\"$}
                if {[regexp $regxf $defval]} {
                    set value_type float
                } elseif {[regexp $regxi $defval]} {
                    set value_type int
                } elseif {[regexp $regxstr $defval]} {
                    set value_type string
                }
                
                set ip [ipl::set_parameter -ip $ip -id $name \
                    -type param -value_type $value_type \
                    -conn_mod $mod_name -title $name \
                    -default $defval \
                    -output_formatter nostr \
                    -group1 PARAMS -group2 GLOB]
            } else {
                set ip [ipl::set_parameter -ip $ip -id $name \
                    -type param -value_type int \
                    -conn_mod $mod_name -title $name \
                    -output_formatter nostr \
                    -group1 PARAMS \
                    -group2 GLOB]
            }
        }
        return $ip
    }

    proc docsgen {ip} {
        set display_name [ipl::getncont ip_desc/lsccip:general lsccip:display_name $ip]
        set name [ipl::getncont ip_desc/lsccip:general lsccip:name $ip]
        set version [ipl::getncont ip_desc/lsccip:general lsccip:version $ip]
        set keywords [ipl::getncont ip_desc/lsccip:general lsccip:keywords $ip]
        set href [ipl::getncont ip_desc/lsccip:general href $ip]

        set supported_products [ipl::getnchilds ip_desc/lsccip:general lsccip:supported_products $ip]
        set devices {}
        foreach {id product} $supported_products {
            append devices $id
        }

        set doc {}
        lappend doc "<HEAD>"
        lappend doc "  <TITLE> $name </TITLE>"
        lappend doc "</HEAD>"
        lappend doc "<BODY>"
        lappend doc "  <H1> $display_name </H1>"
        lappend doc "  <H2> Keywords </H2>"
        lappend doc "  <P> $keywords </P>"
        lappend doc "  <H2> Devices Supported </H2>"
        lappend doc "  <P> $devices </P>"
        lappend doc "  <H2> Reference </H2>"
        lappend doc "  <UL>"
        lappend doc "    <P>"
        lappend doc "      <LI><A HREF=\"$href\" CLASS=\"URL\">Documentation</A>"
        lappend doc "  </UL>"
        lappend doc "  <H2> Version </H2>"
        lappend doc "  <TABLE cellpadding=\"10\">"
        lappend doc "    <TR>"
        lappend doc "      <TD><B> $version </B></TD> <TD> $keywords </TD>"
        lappend doc "    </TR>"
        lappend doc "  </TABLE>"
        lappend doc "</BODY>"
        return $doc
    }

    proc add_ip_files_auto {args} {
        array set opt [list -ip "$::ipl::ip" \
            -spath "" \
            -sdepth 0 \
            -regex "" \
            -extl {*.v} \
            -dpath "rtl" \
        {*}$args]

        set ip $opt(-ip)
        set spath $opt(-spath)
        set sdepth $opt(-sdepth)
        set regex $opt(-regex)
        set extl $opt(-extl)
        set dpath $opt(-dpath)

        if {$extl != ""} {
            set flist [ipl::get_file_list $spath $extl $sdepth]
        }

        set checkext {^.+\.sv$}
        foreach file $flist {
            if {[regexp $checkext $file]} {
                set ip [ipl::set_wrapper_type -ip $ip -file_ext sv]
            }
        }

        if {$regex != ""} {
            set flist [regexp -all -inline $regex $flist]
        }
        set node [ipl::getnode fdeps $dpath $ip]
        if {$node != ""} {
            set flist [list {*}$node {*}$flist]
        }
        return [ipl::setnode fdeps $dpath $flist $ip]
    }

    proc get_file_list {path {extension_list {*.v}} {depth 0}} {
        set file_list {}
        foreach ext $extension_list {
            set file_list [list {*}$file_list \
            {*}[glob -nocomplain -type f -directory $path $ext]]
        }
        if {$depth > 0} {
            foreach dir [glob -nocomplain -type d -directory $path *] {
            set file_list [list {*}$file_list \
                {*}[get_file_list $dir $extension_list [expr {$depth-1}]]]
            }
        }
        return $file_list
    }

    proc add_ip_files {args} {
        array set opt [list -ip "$::ipl::ip" \
            -flist "" \
            -dpath "rtl" \
        {*}$args]

        set ip $opt(-ip)
        set flist $opt(-flist)
        set dpath $opt(-dpath)

        set checkext {^.+\.sv$}
        foreach file $flist {
            if {[regexp $checkext $file]} {
                set ip [ipl::set_wrapper_type -ip $ip -file_ext sv]
            }
        }

        set node [ipl::getnode fdeps $dpath $ip]
        if {$node != ""} {
            set flist [list {*}$node {*}$flist]
        }
        return [ipl::setnode fdeps $dpath $flist $ip]
    }

    # set axis_ports {
    #     valid
    #     ready
    #     data
    #     strb
    #     keep
    #     last
    #     id
    #     dest
    #     user
    #     wakeup
    # }

    proc list_interfaces_by_clock {mod_data {clock "aclk"}} {
        set ports [dict get $mod_data portlist]
        set clk_list {}
        puts "--------------------------clocks------------------------------"
        foreach line $ports {
            set name [dict get $line name]
            set regexp ".+_${clock}$"
            if {[regexp $regexp $name]} {
                set clk_list [list {*}$clk_list $name]
                puts $name
            }
        }
        puts "-------------------------------------------------------------"

        foreach pname $clk_list {
            set interface_name [string map [list _${clock} ""] $pname]
            foreach line $ports {
                set reg [list ${interface_name}_.+]
                set name [dict get $line name]
                if {[regexp $reg $name]} {
                    puts $line
                }
            }
            puts "-------------------------------------------------------------"
        }
    }

    # to do check the ports to select the interface type
    # set up a structure with the ports and the interface type included
    proc add_axi_interfaces {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
            -clock "aclk" \
            -reset "aresetn" \
            -xptn_portlist {m_axis_xfer_req s_axis_xfer_req} \
        {*}$args]

        set ip $opt(-ip)
        set mod_data $opt(-mod_data)
        set clock $opt(-clock)
        set reset $opt(-reset)
        set xptn_portlist $opt(-xptn_portlist)

        set ports [dict get $mod_data portlist]
        set clk_list {}
        puts "--------------------------clocks------------------------------"
        foreach line $ports {
            set name [dict get $line name]
            set regexp ".+_${clock}$"
            if {[regexp $regexp $name]} {
                set clk_list [list {*}$clk_list $name]
                puts $name
            }
        }
        puts "-------------------------------------------------------------"

        foreach pname $clk_list {
            set interface_name [string map [list _${clock} ""] $pname]
            set counter 0
            foreach line $ports {
                set reg [list ${interface_name}_.+]
                set name [dict get $line name]
                if {[regexp $reg $name]} {
                    incr counter
                }
            }
            dict set ports_num $pname $counter
        }

        puts "Ports number by clocks: $ports_num\n"

        foreach pname $clk_list {
            set interface_name [string map [list _${clock} ""] $pname]

            set arid ${interface_name}_arid
            set awid ${interface_name}_awid
            set araddr ${interface_name}_araddr
            set awaddr ${interface_name}_awaddr
            set tvalid ${interface_name}_tvalid
            set tready ${interface_name}_tready
            set valid ${interface_name}_valid
            set ready ${interface_name}_ready

            set brk ""
            foreach line $ports {
                set name [dict get $line name]
                set type [dict get $line type]
                if {[regexp $arid $name]} {
                    if {$type == "input"} {set brk slave}
                    if {$type == "output"} {set brk master}
                    break
                } elseif {[regexp $awid $name]} {
                    if {$type == "input"} {set brk slave}
                    if {$type == "output"} {set brk master}
                    break
                }
            }
            if {$brk != ""} {
                if {$brk == "slave"} {
                    set ip [ipl::add_memory_map -ip $ip \
                        -name ${interface_name}_mem_map \
                        -description ${interface_name}_mem_map \
                        -baseAddress 0 \
                        -range 65536 \
                        -width 32]
                    set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name $interface_name -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist ${interface_name}_$clock ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave slave \
                        -mem_map_ref ${interface_name}_mem_map \
                        -vendor amba.com -library AMBA4 -name AXI4 -version r0p0 ]
                } elseif {$brk == "master"} {
                    set ip [ipl::add_address_space -ip $ip \
                        -name ${interface_name}_aspace \
                        -range 0x100000000 \
                        -width 32]
                    set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name $interface_name -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist ${interface_name}_$clock ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave master \
                        -addr_space_ref ${interface_name}_aspace \
                        -vendor amba.com -library AMBA4 -name AXI4 -version r0p0 ]
                }
                continue
            }

            foreach line $ports {
                set name [dict get $line name]
                set type [dict get $line type]
                if {[regexp $araddr $name]} {
                    if {$type == "input"} {set brk slave}
                    if {$type == "output"} {set brk master}
                    break
                } elseif {[regexp $awaddr $name]} {
                    if {$type == "input"} {set brk slave}
                    if {$type == "output"} {set brk master}
                    break
                }
            }
            if {$brk != ""} {
                if {$brk == "slave"} {
                    set ip [ipl::add_memory_map -ip $ip \
                        -name ${interface_name}_mem_map \
                        -description ${interface_name}_mem_map \
                        -baseAddress 0 \
                        -range 65536 \
                        -width 32]
                    set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name $interface_name -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist ${interface_name}_$clock ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave slave \
                        -mem_map_ref ${interface_name}_mem_map \
                        -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]
                } elseif {$brk == "master"} {
                    set ip [ipl::add_address_space -ip $ip \
                        -name ${interface_name}_aspace \
                        -range 0x100000000 \
                        -width 32]
                    set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name $interface_name -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist ${interface_name}_$clock ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave master \
                        -addr_space_ref ${interface_name}_aspace \
                        -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]
                }
                continue
            }

            foreach line $ports {
                set name [dict get $line name]
                set type [dict get $line type]
                if {[regexp $tvalid $name]} {
                    if {$type == "input"} {set brk slave}
                    if {$type == "output"} {set brk master}
                    break
                } elseif {[regexp $tready $name]} {
                    if {$type == "input"} {set brk master}
                    if {$type == "output"} {set brk slave}
                    break
                }
            }
            if {$brk != ""} {
                if {$brk == "slave"} {
                    set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name $interface_name -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist ${interface_name}_$clock ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave slave \
                        -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0 ]
                } elseif {$brk == "master"} {
                    set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name $interface_name -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist ${interface_name}_$clock ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave master \
                        -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0 ]
                }
                continue
            }

            foreach line $ports {
                set name [dict get $line name]
                set type [dict get $line type]
                if {[regexp $valid $name]} {
                    if {$type == "input"} {set brk slave}
                    if {$type == "output"} {set brk master}
                    break
                } elseif {[regexp $ready $name]} {
                    if {$type == "input"} {set brk master}
                    if {$type == "output"} {set brk slave}
                    break
                }
            }
            if {$brk != ""} {
                if {$brk == "slave"} {
                    set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name $interface_name -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist ${interface_name}_$clock ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave slave \
                        -t t \
                        -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0 ]
                } elseif {$brk == "master"} {
                    set ip [ipl::add_interface_by_prefix -ip $ip -mod_data $mod_data -inst_name $interface_name -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist ${interface_name}_$clock ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave master \
                        -t t \
                        -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0 ]
                }
                continue
            }

            # puts " "
        }

        return $ip
    }

    # -create make script.
}
# TODO:
# add lists for axi and other interfaces standard ports to be able to check them and read them automatically
# comment the code
# I should add something like this to be able to read the path and clear the
# library IPs from the output library directory of propel builder:
# output := $(shell propelbld readpath.tcl)
# all:
#     @echo "Captured output: $(output)"
#     @for item in $(output); do \
#         echo $$item; \
#     done
# then write a rule for clearing these IPs or edit the clear targets and add the specified file paths dinamically