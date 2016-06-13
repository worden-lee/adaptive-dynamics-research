# helper makefile automatically generated from sea-down-plot.sage.step
sea-down-plot.sage sea-down-plot.sage.out sea-down-plot.sage.tried : sea-down.sobj
sea-down-test.svg : sea-down-plot.sage.out ;
sea-vf-X.svg sea-vf-x.svg sea-vf-c.svg sea-vf-m.svg : sea-down-plot.sage.out ;
sea-down-plot.sage sea-down-plot.sage.out sea-down-plot.sage.tried : STEP_PRODUCTS= sea-down-test.svg sea-vf-X.svg sea-vf-x.svg sea-vf-c.svg sea-vf-m.svg
