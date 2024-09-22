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
            <xsl:call-template name="concat-full-name"/>
        </sdo:name>
        <sdo:familyName>
            <xsl:apply-templates select="a2a:PersonNamePrefixLastName" mode="concat"/>
            <xsl:apply-templates select="a2a:PersonNameLastName" mode="concat"/>
        </sdo:familyName>
        <xsl:apply-templates select="a2a:PersonNameFirstName" mode="sdo"/>
        <xsl:if test="a2a:PersonNamePrefixLastName/text() | a2a:PersonNamePatronym/text()">
            <sdo:additionalName>
                <pnv:PersonName>
                    <pnv:literalName>
                        <xsl:call-template name="concat-full-name"/>
                    </pnv:literalName>
                    <xsl:apply-templates select="a2a:PersonNameFirstName" mode="pnv"/>    
                    <xsl:apply-templates select="a2a:PersonNamePatronym" mode="pnv" />
                    <xsl:apply-templates select="a2a:PersonNamePrefixLastName" mode="pnv" />
                    <xsl:apply-templates select="a2a:PersonNameLastName" mode="pnv"/>    
                </pnv:PersonName>
            </sdo:additionalName>
        </xsl:if>
    </xsl:template>

<!-- level 2: START subelements of PersonName-->

    <xsl:template match="a2a:PersonNameLiteral"/>
    <xsl:template match="a2a:PersonNameTitle"/>
    <xsl:template match="a2a:PersonNameTitleOfNobility"/>


    <xsl:template match="a2a:PersonNameFirstName/text()" mode="sdo">
        <sdo:givenName>
            <xsl:value-of select="."/>
        </sdo:givenName>
    </xsl:template>
    <xsl:template match="a2a:PersonNameFirstName/text()" mode="pnv">
        <pnv:givenName>
            <xsl:value-of select="."/>
        </pnv:givenName>
    </xsl:template>


    <xsl:template match="a2a:PersonNameNickName"/>
    <xsl:template match="a2a:PersonNameAlias"/>


    <xsl:template match="a2a:PersonNamePatronym/text()" mode="pnv">
        <pnv:patronym>
            <xsl:value-of select="."/>
        </pnv:patronym>
    </xsl:template>


    <xsl:template match="a2a:PersonNamePrefixLastName/text()" mode="pnv">
        <pnv:surnamePrefix>
            <xsl:value-of select="."/>
        </pnv:surnamePrefix>
    </xsl:template>


    <xsl:template match="a2a:PersonNameLastName/text()" mode="pnv">
        <pnv:baseSurname>
            <xsl:value-of select="."/>
        </pnv:baseSurname>
    </xsl:template>


    <xsl:template match="a2a:PersonNameFamilyName"/>
    <xsl:template match="a2a:PersonNameInitials"/>
    <xsl:template match="a2a:PersonNameRemark"/>

<!-- level 2: END subelements of PersonName-->

    <xsl:template name="concat-full-name">
        <!-- Parameters for the strings -->
        <xsl:variable name="str1" select="a2a:PersonNameFirstName" />
        <xsl:variable name="str2" select="a2a:PersonNamePatronym" />
        <xsl:variable name="str3" select="a2a:PersonNamePrefixLastName" />
        <xsl:variable name="str4" select="a2a:PersonNameLastName" />
    
        <!-- Concatenate strings with spaces and normalize to avoid trailing spaces -->
        <xsl:value-of select="normalize-space(concat($str1, ' ', $str2, ' ', $str3, ' ', $str4))" />
    </xsl:template>

</xsl:stylesheet>
