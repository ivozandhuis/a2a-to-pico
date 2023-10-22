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
    xmlns:schema="http://schema.org/"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:pico="https://data.cbg.nl/pico#"
    xmlns:picot="https://data.cbg.nl/pico-terms#"

    exclude-result-prefixes="xsl a2a a2arc">

    <xsl:template match="a2a:RelationEP">
        <pico:hasRole>
            <xsl:value-of select="a2a:RelationType"/>
        </pico:hasRole>
        <xsl:call-template name="determine-relation-property">
            <xsl:with-param name="rel-type" select="a2a:RelationType"/>
        </xsl:call-template>
        <xsl:call-template name="determine-gender">
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
        <xsl:variable name="RelationMap">relation-map.xml</xsl:variable>
        <xsl:variable name="children-related" select="document($RelationMap)/items/item[name=$rel-type]/relation[property='children']/related"/>
        <xsl:variable name="parent-related" select="document($RelationMap)/items/item[name=$rel-type]/relation[property='parent']/related"/>
        <xsl:variable name="spouse-related" select="document($RelationMap)/items/item[name=$rel-type]/relation[property='spouse']/related"/>
        <xsl:if test="$children-related">
            <schema:children>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:RelationEP[a2a:RelationType = $children-related]/a2a:PersonKeyRef"/>
                </xsl:attribute>
            </schema:children>
        </xsl:if>
        <xsl:if test="$parent-related">
            <schema:parent>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:RelationEP[a2a:RelationType = $parent-related]/a2a:PersonKeyRef"/>
                </xsl:attribute>
            </schema:parent>
        </xsl:if>
        <xsl:if test="$spouse-related">
            <schema:spouse>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:RelationEP[a2a:RelationType = $spouse-related]/a2a:PersonKeyRef"/>
                </xsl:attribute>
            </schema:spouse>
        </xsl:if>
    </xsl:template>


    <xsl:template name="determine-gender">
        <xsl:param name="rel-type"/>
        <xsl:variable name="RelationMap">relation-map.xml</xsl:variable>
        <xsl:variable name="gender" select="document($RelationMap)/items/item[name=$rel-type]/gender"/>
        <xsl:if test="$gender">
            <schema:gender>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$gender"/>
                </xsl:attribute>
            </schema:gender>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
