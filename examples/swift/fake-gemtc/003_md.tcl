
# Generated by stc version 0.2.0
# date                    : 2014/01/13 12:55:23
# Turbine version         : 0.3.0
# Input filename          : /home/skrieder/exm/apps/fake-gemtc/003_md.swift
# Output filename         : /home/skrieder/exm/apps/fake-gemtc
# STC home                : /home/skrieder/sfw/stc
# Turbine home            : /home/skrieder/sfw/turbine
# Compiler settings:
# stc.auto-declare              : true
# stc.c_preprocess              : true
# stc.checkpointing             : true
# stc.codegen.no-stack          : true
# stc.codegen.no-stack-vars     : true
# stc.compiler-debug            : true
# stc.debugging                 : COMMENTS
# stc.ic.output-file            : 
# stc.input_filename            : 003_md.swift
# stc.log.file                  : 
# stc.log.trace                 : false
# stc.must_pass_wait_vars       : true
# stc.opt.algebra               : false
# stc.opt.array-build           : true
# stc.opt.batch-refcounts       : true
# stc.opt.cancel-refcounts      : true
# stc.opt.constant-fold         : true
# stc.opt.controlflow-fusion    : true
# stc.opt.dead-code-elim        : true
# stc.opt.disable-asserts       : false
# stc.opt.expand-dataflow-ops   : true
# stc.opt.expand-loop-threshold-insts: 256
# stc.opt.expand-loop-threshold-iters: 16
# stc.opt.expand-loops          : true
# stc.opt.finalized-var         : true
# stc.opt.flatten-nested        : true
# stc.opt.full-unroll           : false
# stc.opt.function-inline       : false
# stc.opt.function-inline-threshold: 500
# stc.opt.function-signature    : true
# stc.opt.hoist                 : true
# stc.opt.hoist-refcounts       : true
# stc.opt.loop-simplify         : true
# stc.opt.max-iterations        : 10
# stc.opt.merge-refcounts       : true
# stc.opt.piggyback-refcounts   : true
# stc.opt.pipeline              : false
# stc.opt.reorder-insts         : false
# stc.opt.shared-constants      : true
# stc.opt.unroll-loop-threshold-insts: 192
# stc.opt.unroll-loop-threshold-iters: 8
# stc.opt.unroll-loops          : true
# stc.opt.value-number          : true
# stc.opt.wait-coalesce         : true
# stc.output_filename           : 
# stc.preproc.force-cpp         : false
# stc.preproc.force-gcc         : false
# stc.preprocess_only           : false
# stc.profile                   : false
# stc.refcounting               : true
# stc.rpath                     : 
# stc.stc_home                  : /home/skrieder/sfw/stc
# stc.turbine.version           : 0.3.0
# stc.turbine_home              : /home/skrieder/sfw/turbine
# stc.version                   : 0.2.0

# Metadata:

package require turbine 0.3.0
namespace import turbine::*


proc swift:constants {  } {
    turbine::c::log "function:swift:constants"
    global c:f_1.9
    turbine::allocate_custom c:f_1.9 float 1 1 1
    turbine::store_float ${c:f_1.9} 1.9
}

package require gemtc 0.0


proc swift:main {  } {
    turbine::c::log "enter function: main"
    set stack 0
    # Var: int u:np 003_md.swift:main():11:2
    # Var: float[int] u:T 003_md.swift:main():20:2
    # Var: blob t:18 EXPR_TEMPORARY 003_md.swift:main():35:2
    # Var: $string optv:__t0 VALUE_OF [string:__t0]
    # Var: $int optv:np VALUE_OF [int:np]
    # Var: $string optv:__t2 VALUE_OF [string:__t2]
    # Var: $int optv:loopCount VALUE_OF [int:loopCount]
    # Var: $int optv:n VALUE_OF [int:n]
    # Var: $int optv:__t5 VALUE_OF [int:__t5]
    # Var: $void optv:__t12 VALUE_OF [void:__t12]
    # Var: $void optv:__t14 VALUE_OF [void:__t14]
    # Var: $void optv:__t16 VALUE_OF [void:__t16]
    # Var: $void optv:__t20 VALUE_OF [void:__t20]
    # Var: $void optv:__t22 VALUE_OF [void:__t22]
    # Var: $void optv:__t28 VALUE_OF [void:__t28]
    # Var: $void optv:__t30 VALUE_OF [void:__t30]
    # Var: $void optv:__t37 VALUE_OF [void:__t37]
    lassign [ adlb::multicreate [ list integer 1 ] [ list container integer ref 2 1 ] [ list blob 1 ] ] u:np u:T t:18
    turbine::c::log "allocated u:np=<${u:np}> u:T=<${u:T}> t:18=<${t:18}>"
    # Swift l.11: assigning expression to np
    set optv:__t0 [ turbine::argv_get_impl "array_size" ]
    set optv:np [ turbine::check_str_int ${optv:__t0} ]
    turbine::store_integer ${u:np} ${optv:np}
    # Swift l.12: assigning expression to loopCount
    set optv:__t2 [ turbine::argv_get_impl "bound" ]
    set optv:loopCount [ turbine::check_str_int ${optv:__t2} ]
    # Swift l.13: assigning expression to nd
    # Swift l.14: assigning expression to n
    set optv:n [ expr { ${optv:np} * 3 } ]
    # Swift l.15: assigning expression to mass
    # Swift l.23: assigning expression to T
    set optv:__t5 [ expr { ${optv:n} - 1 } ]
    # Swift l.30 evaluating  expression and throwing away 1 results
    set optv:__t12 [ turbine::printf_local "Setting A to T" ]
    # Swift l.31: assigning expression to A[_]
    # Swift l.32 evaluating  expression and throwing away 1 results
    set optv:__t14 [ turbine::printf_local "Complete" ]
    # Swift l.34 evaluating  expression and throwing away 1 results
    set optv:__t16 [ turbine::printf_local "Setting B to blob of A" ]
    # Swift l.35: assigning expression to B[_]
    # Swift l.36 evaluating  expression and throwing away 1 results
    set optv:__t20 [ turbine::printf_local "Complete" ]
    # Swift l.38 evaluating  expression and throwing away 1 results
    set optv:__t22 [ turbine::printf_local "Duplicate B" ]
    # Swift l.43 evaluating  expression and throwing away 1 results
    set optv:__t28 [ turbine::printf_local "Complete" ]
    # Swift l.45 evaluating  expression and throwing away 1 results
    set optv:__t30 [ turbine::printf_local "run gemtc" ]
    # Swift l.50 evaluating  expression and throwing away 1 results
    set optv:__t37 [ turbine::printf_local "Complete" ]
    # Swift l.27 evaluating  expression and throwing away 1 results
    # Swift l.41: assigning expression to B[_]
    # Swift l.48: assigning expression to R[_]
    turbine::blob_from_floats [ list ${t:18} ] [ list ${u:T} ]
    set tcltmp:prio [ turbine::get_priority ]
    turbine::set_priority ${tcltmp:prio}
    adlb::spawn 1 "command f:constructArray-1 ${stack} ${u:T} ${optv:n}"
    turbine::reset_priority
    set tcltmp:iterstotal [ expr { max(0,${optv:__t5} - 0 + 1) } ]
    turbine::read_refcount_incr ${u:T} [ expr { ${tcltmp:iterstotal} - 1 } ]
    main-range0:outer ${stack} ${u:T} 0 ${optv:__t5} 1
    set tcltmp:iterstotal [ expr { max(0,${optv:loopCount} - 1 + 1) } ]
    turbine::read_refcount_incr ${t:18} [ expr { ${tcltmp:iterstotal} - 1 } ]
    turbine::read_refcount_incr ${u:np} [ expr { ${tcltmp:iterstotal} - 1 } ]
    main-range2:outer ${stack} ${t:18} ${u:np} 1 ${optv:loopCount} 1
}


proc main-range0:outer { stack u:T tcltmp:lo tcltmp:hi tcltmp:inc } {
    if { [ expr { ${tcltmp:lo} > ${tcltmp:hi} } ] } {
        return
    }
    while {1} {
        set tcltmp:itersleft [ expr { max(0,(${tcltmp:hi} - ${tcltmp:lo}) / ${tcltmp:inc} + 1) } ]
        if { [ expr { ${tcltmp:itersleft} <= 64 } ] } {
            main-range0:inner ${stack} ${u:T} ${tcltmp:lo} ${tcltmp:hi} ${tcltmp:inc}
            return
        } else {
            set tcltmp:skip [ expr { ${tcltmp:inc} * max(64,((${tcltmp:itersleft} - 1) / 16) + 1) } ]
            for { set tcltmp:splitstart [ expr { ${tcltmp:lo} + ${tcltmp:skip} } ] } { ${tcltmp:splitstart} <= ${tcltmp:hi} } { incr tcltmp:splitstart ${tcltmp:skip} } {
                set tcltmp:splitend [ expr { min(${tcltmp:hi},${tcltmp:splitstart} + ${tcltmp:skip} - 1) } ]
                set tcltmp:prio [ turbine::get_priority ]
                turbine::set_priority ${tcltmp:prio}
                adlb::spawn 1 "command main-range0:outer ${stack} ${u:T} ${tcltmp:splitstart} ${tcltmp:splitend} ${tcltmp:inc}"
                turbine::reset_priority
            }
            set tcltmp:hi [ expr { ${tcltmp:lo} + ${tcltmp:skip} - 1 } ]
        }
    }
}


proc main-range0:inner { stack u:T tcltmp:lo tcltmp:hi tcltmp:inc } {
    for { set v:i ${tcltmp:lo} } { ${v:i} <= ${tcltmp:hi} } { incr v:i ${tcltmp:inc} } {
        # Var: float t:10 EXPR_TEMPORARY 003_md.swift:main():27:28
        # Var: *(float) t:11 EXPR_TEMPORARY 003_md.swift:main():27:28
        lassign [ adlb::multicreate [ list float 1 ] [ list ref 1 ] ] t:10 t:11
        turbine::c::log "allocated t:10=<${t:10}> t:11=<${t:11}>"
        turbine::container_reference ${u:T} ${v:i} ${t:11} ref
        turbine::dereference_float ${t:10} ${t:11}
        turbine::rule [ list ${t:10} ] "main-call_foreign-printf ${stack} ${t:10} ${v:i}"
    }
}


proc main-call_foreign-printf { stack t:10 v:i } {
    # Var: $float optv:__t10 VALUE_OF [float:__t10]
    # Var: $void optv:__t8 VALUE_OF [void:__t8]
    set optv:__t10 [ turbine::retrieve_float ${t:10} CACHED 1 ]
    set optv:__t8 [ turbine::printf_local "T\[%d\] = %f" ${v:i} ${optv:__t10} ]
}


proc main-range2:outer { stack t:18 u:np tcltmp:lo tcltmp:hi tcltmp:inc } {
    if { [ expr { ${tcltmp:lo} > ${tcltmp:hi} } ] } {
        return
    }
    while {1} {
        set tcltmp:itersleft [ expr { max(0,(${tcltmp:hi} - ${tcltmp:lo}) / ${tcltmp:inc} + 1) } ]
        if { [ expr { ${tcltmp:itersleft} <= 64 } ] } {
            main-range2:inner ${stack} ${t:18} ${u:np} ${tcltmp:lo} ${tcltmp:hi} ${tcltmp:inc}
            return
        } else {
            set tcltmp:skip [ expr { ${tcltmp:inc} * max(64,((${tcltmp:itersleft} - 1) / 16) + 1) } ]
            for { set tcltmp:splitstart [ expr { ${tcltmp:lo} + ${tcltmp:skip} } ] } { ${tcltmp:splitstart} <= ${tcltmp:hi} } { incr tcltmp:splitstart ${tcltmp:skip} } {
                set tcltmp:splitend [ expr { min(${tcltmp:hi},${tcltmp:splitstart} + ${tcltmp:skip} - 1) } ]
                set tcltmp:prio [ turbine::get_priority ]
                turbine::set_priority ${tcltmp:prio}
                adlb::spawn 1 "command main-range2:outer ${stack} ${t:18} ${u:np} ${tcltmp:splitstart} ${tcltmp:splitend} ${tcltmp:inc}"
                turbine::reset_priority
            }
            set tcltmp:hi [ expr { ${tcltmp:lo} + ${tcltmp:skip} - 1 } ]
        }
    }
}


proc main-range2:inner { stack t:18 u:np tcltmp:lo tcltmp:hi tcltmp:inc } {
    for { set v:i:2 ${tcltmp:lo} } { ${v:i:2} <= ${tcltmp:hi} } { incr v:i:2 ${tcltmp:inc} } {
        # Var: blob t:34 EXPR_TEMPORARY 003_md.swift:main():48:4
        lassign [ adlb::multicreate [ list blob 0 ] ] t:34
        turbine::c::log "allocated t:34=<${t:34}>"
        gemtc::gemtc_mdproxy [ list ${t:34} ] [ list ${u:np} ${t:18} ]
    }
}


proc f:constructArray-1 { stack u:A optv:n } {
    turbine::c::log "enter function: constructArray-1"
    # Swift l.55: assigning expression to A[_]
    set tcltmp:iterstotal [ expr { max(0,${optv:n} - 0 + 1) } ]
    adlb::write_refcount_incr ${u:A} [ expr { ${tcltmp:iterstotal} - 1 } ]
    constructArray-range0:outer ${stack} ${u:A} 0 ${optv:n} 1
}


proc constructArray-range0:outer { stack u:A tcltmp:lo tcltmp:hi tcltmp:inc } {
    if { [ expr { ${tcltmp:lo} > ${tcltmp:hi} } ] } {
        return
    }
    while {1} {
        set tcltmp:itersleft [ expr { max(0,(${tcltmp:hi} - ${tcltmp:lo}) / ${tcltmp:inc} + 1) } ]
        if { [ expr { ${tcltmp:itersleft} <= 64 } ] } {
            constructArray-range0:inner ${stack} ${u:A} ${tcltmp:lo} ${tcltmp:hi} ${tcltmp:inc}
            return
        } else {
            set tcltmp:skip [ expr { ${tcltmp:inc} * max(64,((${tcltmp:itersleft} - 1) / 16) + 1) } ]
            for { set tcltmp:splitstart [ expr { ${tcltmp:lo} + ${tcltmp:skip} } ] } { ${tcltmp:splitstart} <= ${tcltmp:hi} } { incr tcltmp:splitstart ${tcltmp:skip} } {
                set tcltmp:splitend [ expr { min(${tcltmp:hi},${tcltmp:splitstart} + ${tcltmp:skip} - 1) } ]
                set tcltmp:prio [ turbine::get_priority ]
                turbine::set_priority ${tcltmp:prio}
                adlb::spawn 1 "command constructArray-range0:outer ${stack} ${u:A} ${tcltmp:splitstart} ${tcltmp:splitend} ${tcltmp:inc}"
                turbine::reset_priority
            }
            set tcltmp:hi [ expr { ${tcltmp:lo} + ${tcltmp:skip} - 1 } ]
        }
    }
}


proc constructArray-range0:inner { stack u:A tcltmp:lo tcltmp:hi tcltmp:inc } {
    for { set v:i ${tcltmp:lo} } { ${v:i} <= ${tcltmp:hi} } { incr v:i ${tcltmp:inc} } {
        # Var: float c:f_1.9 OPT_TEMPORARY
        global c:f_1.9
        turbine::container_insert ${u:A} ${v:i} ${c:f_1.9} ref 1
    }
}

turbine::defaults
turbine::init $engines $servers "Swift"
turbine::enable_read_refcount
turbine::xpt_init
turbine::check_constants "WORKER" ${turbine::WORK_TASK} 0 "CONTROL" ${turbine::CONTROL_TASK} 1 "ADLB_RANK_ANY" ${adlb::RANK_ANY} -100
turbine::start swift:main swift:constants
turbine::finalize
turbine::xpt_finalize
