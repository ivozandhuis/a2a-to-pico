<?xml version="1.0" encoding="UTF-8"?>
<!-- Ivo Zandhuis (ivo@zandhuis.nl) -->

<xsl:stylesheet version="1.0"
    xmlns:a2a="http://Mindbus.nl/A2A"
    xmlns:a2arc="http://Mindbus.nl/RecordCollectionA2A"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:pnv="https://w3id.org/pnv#"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:sdo="https://schema.org/"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:pico="https://personsincontext.org/model/"
    xmlns:picot="https://terms.personsincontext.org/"

    exclude-result-prefixes="xsl a2a a2arc">

<xsl:import href="person.xsl"/>
<xsl:import href="event.xsl"/>
<xsl:import href="object.xsl"/>
<xsl:import href="source.xsl"/>
<xsl:import href="relations.xsl"/>

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<xsl:param name="baseUri">
    <xsl:text>https://ex.org/</xsl:text>
</xsl:param>

<!-- ignore empty elements-->
<!-- HOE!? -->

<!-- RDF wrap -->
<xsl:template match="a2arc:A2ACollection">
    <rdf:RDF>
        <xsl:apply-templates select="a2a:A2A/a2a:Person"/>
        <xsl:apply-templates select="a2a:A2A/a2a:Event[a2a:EventType='Huwelijk']"/>
        <xsl:apply-templates select="a2a:A2A/a2a:Source"/>
    </rdf:RDF>
</xsl:template>

</xsl:stylesheet>
