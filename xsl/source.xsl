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

    <xsl:template match="a2a:Source">
        <schema:ArchiveComponent>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$baseUri"/>
                <xsl:value-of select="a2a:RecordIdentifier"/>
            </xsl:attribute>
            <xsl:apply-templates select="a2a:SourceReference"/>
			<xsl:apply-templates select="a2a:SourceDate"/>
			<xsl:apply-templates select="a2a:SourcePlace"/>
			<xsl:apply-templates select="a2a:SourceAvailableScans"/>
			<xsl:apply-templates select="a2a:SourceDigitalOriginal"/>		
			<xsl:apply-templates select="a2a:SourceLastChangeDate"/>
        </schema:ArchiveComponent>
    </xsl:template>


<!-- level 1: subelements of a2a:Source -->
    <xsl:template match="a2a:SourcePlace">
		<schema:locationCreated>
			<xsl:value-of select="./a2a:Place"/>
		</schema:locationCreated>
	</xsl:template>	
	
    <xsl:template match="a2a:SourceIndexDate"/>

    <xsl:template match="a2a:SourceDate">
		<schema:dateCreated rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
			<xsl:value-of select="./a2a:Year"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="./a2a:Month"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="./a2a:Day"/>
        </schema:dateCreated>
	</xsl:template>
	
    <xsl:template match="a2a:SourceType"/>
    <xsl:template match="a2a:EAD"/>
    <xsl:template match="a2a:EAC"/>

    <xsl:template match="a2a:SourceReference">
        <schema:name xml:lang="nl">
            <!-- cf. Kamp et al, Geschiedenis schrijven!, Amsterdam 2016, p.150-151 -->
            <xsl:apply-templates select="a2a:InstitutionName" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Place" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Collection" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Archive" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:RegistryNumber" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Book" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:Folio" mode="schema-name-nl"/>
            <xsl:apply-templates select="a2a:DocumentNumber"/>
        </schema:name>
    </xsl:template>

    <xsl:template match="a2a:SourceAvailableScans">
		<schema:associatedMedia>		
			<xsl:apply-templates select="a2a:Scan"/>
		</schema:associatedMedia>		
	</xsl:template>
	
	<xsl:template match="a2a:Scan">
		<schema:ImageObject>
			<xsl:apply-templates select="a2a:OrderSequenceNumber" /> 
			<xsl:apply-templates select="a2a:Uri" /> 
			<xsl:apply-templates select="a2a:UriViewer" /> 
			<xsl:apply-templates select="a2a:UriPreview" /> 
		</schema:ImageObject>
	</xsl:template>	

	<xsl:template match="a2a:Uri">
		<schema:url>
			<xsl:value-of select="."/>
		</schema:url>
    </xsl:template>
	
	<xsl:template match="a2a:OrderSequenceNumber">
		<schema:position>
			<xsl:value-of select="."/>
		</schema:position>
    </xsl:template>

	<xsl:template match="a2a:UriViewer">
		<schema:embedUrl>
			<xsl:value-of select="."/>
		</schema:embedUrl>
    </xsl:template>
	
	<xsl:template match="a2a:UriPreview">
		<schema:thumbnail>
			<xsl:value-of select="."/>
		</schema:thumbnail>
    </xsl:template>
	
    <xsl:template match="a2a:SourceDigitalizationDate"/>

    <xsl:template match="a2a:SourceLastChangeDate">
		<schema:dateModified>
			<xsl:value-of select="."/>
		</schema:dateModified>
	</xsl:template>

	<xsl:template match="a2a:SourceDigitalOriginal">
		<schema:url>
			<xsl:value-of select="."/>
		</schema:url> 
    </xsl:template>
	
    <xsl:template match="a2a:RecordIdentifier"/>
    <xsl:template match="a2a:RecordGUID"/>
    <xsl:template match="a2a:SourceRemark"/>

<!-- level 2: START subelements of a2a:SourceReference -->

    <xsl:template match="a2a:Place" mode="schema-name-nl">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>), </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:InstitutionName/text()" mode="schema-name-nl">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Archive/text()" mode="schema-name-nl">
        <xsl:text>(toegangsnr. </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>), </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Collection/text()"  mode="schema-name-nl">
        <xsl:value-of select="."/>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Section"/>

    <xsl:template match="a2a:Book/text()" mode="schema-name-nl">
        <xsl:value-of select="."/>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Folio/text()" mode="schema-name-nl">
        <xsl:value-of select="."/>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:Rolodeck"/>
    <xsl:template match="a2a:Stack"/>

    <xsl:template match="a2a:RegistryNumber/text()" mode="schema-name-nl">
        <xsl:text>inv.nr. </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="a2a:DocumentNumber/text()">
        <xsl:value-of select="."/>
    </xsl:template>

<!-- level 2: END subelements of a2a:SourceReference -->


</xsl:stylesheet>
