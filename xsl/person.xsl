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

    <xsl:template match="a2a:Person">
        <pico:PersonObservation>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$baseUri"/>
                <xsl:value-of select="@pid"/>
            </xsl:attribute>
            <xsl:apply-templates select="a2a:PersonName"/>
        </pico:PersonObservation>
    </xsl:template>

    <!-- PersonName-->
    <xsl:template match="a2a:PersonName">
        <schema:name>
            <xsl:apply-templates select="a2a:PersonNameFirstName" mode="person-schema"/>
            <xsl:apply-templates select="a2a:PersonNamePrefixLastName" mode="person-schema"/>
            <xsl:apply-templates select="a2a:PersonNameLastName" mode="person-schema"/>
        </schema:name>
        <schema:givenName>
            <xsl:apply-templates select="a2a:PersonNameFirstName" mode="person-schema"/>
        </schema:givenName>
        <schema:familyName>
            <xsl:apply-templates select="a2a:PersonNamePrefixLastName" mode="person-schema"/>
            <xsl:apply-templates select="a2a:PersonNameLastName" mode="person-schema"/>
        </schema:familyName>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="a2a:PersonNameLiteral"/>
    <xsl:template match="a2a:PersonNameTitle"/>
    <xsl:template match="a2a:PersonNameTitleOfNobility"/>

    <xsl:template match="a2a:PersonNameFirstName" mode="person-schema">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:PersonNameNickName"/>
    <xsl:template match="a2a:PersonNameAlias"/>
    <xsl:template match="a2a:PersonNamePatronym"/>

    <xsl:template match="a2a:PersonNamePrefixLastName" mode="person-schema">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:PersonNameLastName">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>    
    </xsl:template>

    <xsl:template match="a2a:PersonNameFamilyName"/>
    <xsl:template match="a2a:PersonNameInitials"/>
    <xsl:template match="a2a:PersonNameRemark"/>

    <!-- Gender-->
    <xsl:template match="a2a:Gender"/>
    <xsl:template match="a2a:Residence"/>
    <xsl:template match="a2a:Religion"/>
    <xsl:template match="a2a:Origin"/>
    <xsl:template match="a2a:Age"/>
    <xsl:template match="a2a:BirthDate"/>
    <xsl:template match="a2a:BirthPlace"/>
    <xsl:template match="a2a:Profession"/>
    <xsl:template match="a2a:MaritalStatus"/>
    <xsl:template match="a2a:PersonRemark"/>





</xsl:stylesheet>
