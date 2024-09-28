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
    xmlns:bio="http://purl.org/vocab/bio/0.1/"
    xmlns:sdo="https://schema.org/"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:pico="https://personsincontext.org/model/"
    xmlns:picot="https://terms.personsincontext.org/"

    exclude-result-prefixes="xsl a2a a2arc">

    <xsl:template match="a2a:Event[a2a:EventType='Huwelijk']">
        <xsl:param name="eid" select="@eid"/>
        <bio:Marriage>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$baseUri"/>
                <xsl:value-of select="$eid"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="../a2a:Source/a2a:RecordIdentifier"/>
            </xsl:attribute>
            <prov:hadPrimarySource>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:Source/a2a:RecordIdentifier"/>
                </xsl:attribute>    
            </prov:hadPrimarySource>
            <bio:date rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                <xsl:value-of select="a2a:EventDate/a2a:Year"/>
                <xsl:text>-</xsl:text>
				<xsl:choose>
					 <xsl:when test="a2a:EventDate/a2a:Month &lt; 10">
						 <xsl:text>0</xsl:text>
					 </xsl:when>
				</xsl:choose>		
                <xsl:value-of select="a2a:EventDate/a2a:Month"/>
                <xsl:text>-</xsl:text>
				<xsl:choose>
					 <xsl:when test="a2a:EventDate/a2a:Day &lt; 10">
						 <xsl:text>0</xsl:text>
					 </xsl:when>
				</xsl:choose>		
                <xsl:value-of select="a2a:EventDate/a2a:Day"/>
            </bio:date>
            <bio:place>
                <xsl:value-of select="a2a:EventPlace"/>
            </bio:place>
            <bio:partner>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:RelationEP[a2a:RelationType='Bruid']/a2a:PersonKeyRef"/>
                </xsl:attribute>
            </bio:partner>
            <bio:partner>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:RelationEP[a2a:RelationType='Bruidegom']/a2a:PersonKeyRef"/>
                </xsl:attribute>
            </bio:partner>
        </bio:Marriage>
    </xsl:template>

</xsl:stylesheet>
