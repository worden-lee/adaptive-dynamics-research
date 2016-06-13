# helper makefile automatically generated from sea-zero-test.sage.step
sea-zero-test.sage sea-zero-test.sage.out sea-zero-test.sage.tried : sea-down.sobj
sea-zero.sage.out.tex : sea-zero-test.sage.out ;
sea-zero-ts.svg : sea-zero-test.sage.out ;
sea-zero-test.sage sea-zero-test.sage.out sea-zero-test.sage.tried : STEP_PRODUCTS= sea-zero.sage.out.tex sea-zero-ts.svg
