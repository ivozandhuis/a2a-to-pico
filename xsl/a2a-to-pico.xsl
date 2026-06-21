<?xml version="1.0" encoding="UTF-8"?>
<!-- Ivo Zandhuis (ivo@zandhuis.nl) -->
<xsl:stylesheet xmlns:a2a="http://Mindbus.nl/A2A" xmlns:a2arc="http://Mindbus.nl/RecordCollectionA2A" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:pnv="https://w3id.org/pnv#" xmlns:prov="http://www.w3.org/ns/prov#" xmlns:sdo="https://schema.org/" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:picom="https://personsincontext.org/model#" xmlns:picot="https://terms.personsincontext.org/" version="1.0" exclude-result-prefixes="xsl a2a a2arc">
	<xsl:import href="person.xsl"/>
	<xsl:import href="object.xsl"/>
	<xsl:import href="source.xsl"/>
	<xsl:import href="relations.xsl"/>
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="baseUri">
		<xsl:text>https://ex.org/</xsl:text>
	</xsl:param>
	<xsl:param name="lang">
		<xsl:choose>
			<xsl:when test="contains(/a2arc:A2ACollection/a2a:A2A/a2a:Source/a2a:SourceReference/a2a:InstitutionName, 'INSEE')        or contains(/a2a:A2A/a2a:Source/a2a:SourceReference/a2a:InstitutionName, 'INSEE')">
				<xsl:text>fr</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>nl</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	<xsl:template match="/a2arc:A2ACollection">
		<rdf:RDF>
			<!-- skip records whose RecordIdentifier contains a quote (it happens!) as it breaks URIs based on the RecordIdentifier -->
			<xsl:if test="not(contains(a2a:A2A/a2a:Source/a2a:RecordIdentifier, '&quot;'))">
				<xsl:apply-templates select="a2a:A2A/a2a:Person"/>
				<xsl:apply-templates select="a2a:A2A/a2a:Source"/>
			</xsl:if>
		</rdf:RDF>
	</xsl:template>
	<xsl:template match="/a2a:A2A">
		<rdf:RDF>
			<!-- skip records whose RecordIdentifier contains a quote (it happens!) as it breaks URIs based on the RecordIdentifier -->
			<xsl:if test="not(contains(a2a:Source/a2a:RecordIdentifier, '&quot;'))">
				<xsl:apply-templates select="a2a:Person"/>
				<xsl:apply-templates select="a2a:Source"/>
			</xsl:if>
		</rdf:RDF>
	</xsl:template>
</xsl:stylesheet>
