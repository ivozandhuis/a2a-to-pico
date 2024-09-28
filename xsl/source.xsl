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

    <xsl:template match="a2a:Source">
        <sdo:ArchiveComponent>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$baseUri"/>
                <xsl:value-of select="a2a:RecordIdentifier"/>
            </xsl:attribute>
            <xsl:apply-templates select="a2a:SourceType"/>
            <xsl:apply-templates select="a2a:SourceReference"/>
			<xsl:apply-templates select="a2a:SourceDate"/>
			<xsl:apply-templates select="a2a:SourcePlace"/>
			<xsl:apply-templates select="a2a:SourceAvailableScans"/>
			<xsl:apply-templates select="a2a:SourceDigitalOriginal"/>		
			<xsl:apply-templates select="a2a:SourceLastChangeDate"/>
        </sdo:ArchiveComponent>
    </xsl:template>


<!-- level 1: subelements of a2a:Source -->
    <xsl:template match="a2a:SourcePlace">
		<sdo:locationCreated>
			<xsl:value-of select="./a2a:Place"/>
		</sdo:locationCreated>
	</xsl:template>	
	
    <xsl:template match="a2a:SourceIndexDate"/>

    <xsl:template match="a2a:SourceDate">
		<sdo:dateCreated rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
			<xsl:value-of select="./a2a:Year"/>
			<xsl:text>-</xsl:text>
			<xsl:choose>
				<xsl:when test="./a2a:Month &lt; 10">
					<xsl:text>0</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="./a2a:Month"/>
			<xsl:text>-</xsl:text>
			<xsl:choose>
				<xsl:when test="../a2a:Day &lt; 10">
					<xsl:text>0</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="./a2a:Day"/>
        </sdo:dateCreated>
	</xsl:template>
	

    <xsl:template match="a2a:SourceType">
        <xsl:variable name="SourceTypeMap">maps/sourcetypes.xml</xsl:variable>
        <xsl:variable name="source-type" select="text()"/>
        <xsl:variable name="source-type-id" select="document($SourceTypeMap)/items/item[name=$source-type]/id"/>
        <sdo:additionalType>
            <xsl:choose>
                <xsl:when test="$source-type-id != ''">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="$source-type-id"></xsl:value-of>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$source-type"></xsl:value-of>
                </xsl:otherwise>
            </xsl:choose> 
        </sdo:additionalType>
    </xsl:template>


    <xsl:template match="a2a:EAD"/>
    <xsl:template match="a2a:EAC"/>

    <xsl:template match="a2a:SourceReference">
        <sdo:name xml:lang="nl">
            <!-- cf. Kamp et al, Geschiedenis schrijven!, Amsterdam 2016, p.150-151 -->
            <xsl:apply-templates select="a2a:InstitutionName" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Place" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Collection" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Archive" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:RegistryNumber" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Book" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Folio" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:DocumentNumber"/>
        </sdo:name>
    </xsl:template>

    <xsl:template match="a2a:SourceAvailableScans">
		<sdo:associatedMedia>		
			<xsl:apply-templates select="a2a:Scan"/>
		</sdo:associatedMedia>		
	</xsl:template>
	
	<xsl:template match="a2a:Scan">
		<sdo:ImageObject>
			<xsl:apply-templates select="a2a:OrderSequenceNumber" /> 
			<xsl:apply-templates select="a2a:Uri" /> 
			<xsl:apply-templates select="a2a:UriViewer" /> 
			<xsl:apply-templates select="a2a:UriPreview" /> 
		</sdo:ImageObject>
	</xsl:template>	

	<xsl:template match="a2a:Uri">
		<sdo:url>
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:url>
    </xsl:template>
	
	<xsl:template match="a2a:OrderSequenceNumber">
		<sdo:position>
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:position>
    </xsl:template>

	<xsl:template match="a2a:UriViewer">
		<sdo:embedUrl>
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:embedUrl>
    </xsl:template>
	
	<xsl:template match="a2a:UriPreview">
		<sdo:thumbnail>
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:thumbnail>
    </xsl:template>
	
    <xsl:template match="a2a:SourceDigitalizationDate"/>

    <xsl:template match="a2a:SourceLastChangeDate">
		<sdo:dateModified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:dateModified>
	</xsl:template>

	<xsl:template match="a2a:SourceDigitalOriginal">
		<sdo:url>
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:url> 
    </xsl:template>
	
    <xsl:template match="a2a:RecordIdentifier"/>
    <xsl:template match="a2a:RecordGUID"/>
    <xsl:template match="a2a:SourceRemark"/>

<!-- level 2: START subelements of a2a:SourceReference -->

    <xsl:template match="a2a:Place" mode="schema-name-nl">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>), </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:InstitutionName/text()" mode="schema-name-nl">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Archive/text()" mode="schema-name-nl">
        <xsl:text>(toegangsnr. </xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>), </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Collection/text()"  mode="schema-name-nl">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Section"/>

    <xsl:template match="a2a:Book/text()" mode="schema-name-nl">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Folio/text()" mode="schema-name-nl">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Rolodeck"/>
    <xsl:template match="a2a:Stack"/>

    <xsl:template match="a2a:RegistryNumber/text()" mode="schema-name-nl">
        <xsl:text>inv.nr. </xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:DocumentNumber/text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

<!-- level 2: END subelements of a2a:SourceReference -->


</xsl:stylesheet>
