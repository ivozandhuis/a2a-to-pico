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
    xmlns:picom="https://personsincontext.org/model#"
    xmlns:picot="https://terms.personsincontext.org/"

    exclude-result-prefixes="xsl a2a a2arc">

    <xsl:template match="a2a:RelationEP">
        <picom:hasRole>
            <xsl:value-of select="a2a:RelationType"/>
        </picom:hasRole>
        <xsl:call-template name="determine-relation-property">
            <xsl:with-param name="rel-type" select="a2a:RelationType"/>
        </xsl:call-template>
        <xsl:call-template name="determine-gender">
            <xsl:with-param name="rel-type" select="a2a:RelationType"/>
        </xsl:call-template>
        <xsl:call-template name="determine-event">
            <xsl:with-param name="rel-type" select="a2a:RelationType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="a2a:RelationPP"/>
    <xsl:template match="a2a:RelationPO"/>
    <xsl:template match="a2a:RelationEO"/>
    <xsl:template match="a2a:RelationP"/>
    <xsl:template match="a2a:RelationOO"/>
    <xsl:template match="a2a:RelationO"/>

<!-- named template for relation property-->

    <xsl:template name="determine-relation-property">
    <!-- TBD: multiple parent-relations-->
    <xsl:param name="rel-type"/>
        <xsl:variable name="RelationTypeMap">maps/relationtypes.xml</xsl:variable>
        <xsl:variable name="children-related" select="document($RelationTypeMap)/items/item[name=$rel-type]/relation[property='children']/related"/>
        <xsl:variable name="parent-related" select="document($RelationTypeMap)/items/item[name=$rel-type]/relation[property='parent']/related"/>
        <xsl:variable name="spouse-related" select="document($RelationTypeMap)/items/item[name=$rel-type]/relation[property='spouse']/related"/>
        <xsl:if test="$children-related">
            <sdo:children>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:RelationEP[a2a:RelationType = $children-related]/a2a:PersonKeyRef"/>
                </xsl:attribute>
            </sdo:children>
        </xsl:if>
        <xsl:if test="$parent-related">
            <sdo:parent>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:RelationEP[a2a:RelationType = $parent-related]/a2a:PersonKeyRef"/>
                </xsl:attribute>
            </sdo:parent>
        </xsl:if>
        <xsl:if test="$spouse-related">
            <sdo:spouse>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:RelationEP[a2a:RelationType = $spouse-related]/a2a:PersonKeyRef"/>
                </xsl:attribute>
            </sdo:spouse>
        </xsl:if>
    </xsl:template>


    <xsl:template name="determine-gender">
        <xsl:param name="rel-type"/>
        <xsl:variable name="RelationTypeMap">maps/relationtypes.xml</xsl:variable>
        <xsl:variable name="gender" select="document($RelationTypeMap)/items/item[name=$rel-type]/gender"/>
        <xsl:if test="$gender">
            <sdo:gender>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$gender"/>
                </xsl:attribute>
            </sdo:gender>
        </xsl:if>
    </xsl:template>


    <xsl:template name="determine-event">
        <xsl:param name="rel-type"/>
        <xsl:choose>
            <xsl:when test="$rel-type = 'Kind'">
                <sdo:birthDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                    <xsl:value-of select="../a2a:Event/a2a:EventDate/a2a:Year"/>
                    <xsl:text>-</xsl:text>
                    <xsl:if test="string-length(../a2a:Event/a2a:EventDate/a2a:Month) &lt; 2">
                        <xsl:text>0</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="../a2a:Event/a2a:EventDate/a2a:Month"/>
                    <xsl:text>-</xsl:text>
                    <xsl:if test="string-length(../a2a:Event/a2a:EventDate/a2a:Day) &lt; 2">
                        <xsl:text>0</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="../a2a:Event/a2a:EventDate/a2a:Day"/>                      
                </sdo:birthDate>
                <sdo:birthPlace>
                    <xsl:value-of select="../a2a:Event/a2a:EventPlace/a2a:Place"/>
                </sdo:birthPlace>
            </xsl:when>
            <xsl:when test="$rel-type = 'Overledene'">
                <sdo:deathDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                    <xsl:value-of select="../a2a:Event/a2a:EventDate/a2a:Year"/>
                    <xsl:text>-</xsl:text>
                    <xsl:if test="string-length(../a2a:Event/a2a:EventDate/a2a:Month) &lt; 2">
                        <xsl:text>0</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="../a2a:Event/a2a:EventDate/a2a:Month"/>
                    <xsl:text>-</xsl:text>
                    <xsl:if test="string-length(../a2a:Event/a2a:EventDate/a2a:Day) &lt; 2">
                        <xsl:text>0</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="../a2a:Event/a2a:EventDate/a2a:Day"/>                      
                </sdo:deathDate>
                <sdo:deathPlace>
                    <xsl:value-of select="../a2a:Event/a2a:EventPlace/a2a:Place"/>
                </sdo:deathPlace>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
