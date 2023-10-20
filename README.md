# A2A to PiCo

Transforms 
* Archives To Archives (A2A) XML format 
into 
* Persons in Context (PiCo) RDF/XML 
with the 
* XML Stylesheet Language Transformation (XSLT) 1.0.

## Usage
Use the stylesheet a2a-to-pico.xslt, which imports all relevant sub-stylesheets.

The stylesheet should be usable with any XSLT 1.0 engine, but is tested with the Python port of SAXON-C Home Edition in ```run_examples.py```. To use this script pip-install: pathlib, saxonche and rdflib.

## Prerequisites

## Documentation

## Status
Not all elements are implemented yet, especially the difficult but important mixed-content elements (inline, names) need attention.

## Acknowledgement
This work was done 
* as part of the HackaLOD (Gouda, NL 2023).



