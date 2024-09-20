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

    <xsl:template match="a2a:Person">
        <xsl:param name="pid" select="@pid"/>
        <pico:PersonObservation>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$baseUri"/>
                <xsl:value-of select="$pid"/>
            </xsl:attribute>
            <prov:hadPrimarySource>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="../a2a:Source/a2a:RecordIdentifier"/>
                </xsl:attribute>    
            </prov:hadPrimarySource>
            <xsl:apply-templates select="../a2a:RelationEP[a2a:PersonKeyRef = $pid]"/>
            <xsl:apply-templates select="a2a:PersonName"/>
        </pico:PersonObservation>
    </xsl:template>

<!-- level 1: subelements of Person -->
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

    <xsl:template match="a2a:PersonName">
        <sdo:name>
            <xsl:apply-templates select="a2a:PersonNameFirstName" mode="schema-name"/>
            <xsl:apply-templates select="a2a:PersonNamePrefixLastName" mode="schema-name"/>
            <xsl:apply-templates select="a2a:PersonNameLastName"/>
        </sdo:name>
        <sdo:givenName>
            <xsl:apply-templates select="a2a:PersonNameFirstName"/>
        </sdo:givenName>
        <sdo:familyName>
            <xsl:apply-templates select="a2a:PersonNamePrefixLastName" mode="schema-name"/>
            <xsl:apply-templates select="a2a:PersonNameLastName"/>
        </sdo:familyName>
        <xsl:if test="a2a:PersonNamePrefixLastName/text()">
            <sdo:additionalName>
                <pnv:PersonName>
                    <pnv:literalName>
                        <xsl:apply-templates select="a2a:PersonNameFirstName" mode="schema-name"/>
                        <xsl:apply-templates select="a2a:PersonNamePrefixLastName" mode="schema-name"/>
                        <xsl:apply-templates select="a2a:PersonNameLastName"/>    
                    </pnv:literalName>
                    <pnv:givenName>
                        <xsl:apply-templates select="a2a:PersonNameFirstName" />    
                    </pnv:givenName>					
                    <pnv:surnamePrefix>
                        <xsl:apply-templates select="a2a:PersonNamePrefixLastName" />
                    </pnv:surnamePrefix>
                    <pnv:baseSurname>
                        <xsl:apply-templates select="a2a:PersonNameLastName" />    
                    </pnv:baseSurname>
                </pnv:PersonName>
            </sdo:additionalName>
        </xsl:if>
    </xsl:template>

<!-- level 2: START subelements of PersonName-->

    <xsl:template match="a2a:PersonNameLiteral"/>
    <xsl:template match="a2a:PersonNameTitle"/>
    <xsl:template match="a2a:PersonNameTitleOfNobility"/>

    <xsl:template match="a2a:PersonNameFirstName/text()" mode="schema-name">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="a2a:PersonNameFirstName/text()">
        <xsl:value-of select="."/>
    </xsl:template>


    <xsl:template match="a2a:PersonNameNickName"/>
    <xsl:template match="a2a:PersonNameAlias"/>
    <xsl:template match="a2a:PersonNamePatronym"/>


    <xsl:template match="a2a:PersonNamePrefixLastName/text()" mode="schema-name">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="a2a:PersonNamePrefixLastName/text()">
        <xsl:value-of select="."/>
    </xsl:template>


    <xsl:template match="a2a:PersonNameLastName/text()" mode="schema-name">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>    
    </xsl:template>
    <xsl:template match="a2a:PersonNameLastName/text()">
        <xsl:value-of select="."/>
    </xsl:template>


    <xsl:template match="a2a:PersonNameFamilyName"/>
    <xsl:template match="a2a:PersonNameInitials"/>
    <xsl:template match="a2a:PersonNameRemark"/>

<!-- level 2: END subelements of PersonName-->

</xsl:stylesheet>
