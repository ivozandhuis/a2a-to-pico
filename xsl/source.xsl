<?xml version="1.0" encoding="utf-8"?>
<!-- Ivo Zandhuis (ivo@zandhuis.nl) -->
<xsl:stylesheet xmlns:a2a="http://Mindbus.nl/A2A" xmlns:a2arc="http://Mindbus.nl/RecordCollectionA2A" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:pnv="https://w3id.org/pnv#" xmlns:prov="http://www.w3.org/ns/prov#" xmlns:sdo="https://schema.org/" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:picom="https://personsincontext.org/model#" xmlns:picot="https://terms.personsincontext.org/" version="1.0" exclude-result-prefixes="xsl a2a a2arc">
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
		<sdo:locationCreated xml:lang="{$lang}">
			<xsl:value-of select="./a2a:Place"/>
		</sdo:locationCreated>
	</xsl:template>
	<xsl:template match="a2a:SourceIndexDate"/>
	<xsl:template match="a2a:SourceDate">
		<!--
-->
		<xsl:variable name="year" select="./a2a:Year"/>
		<xsl:variable name="month" select="number(./a2a:Month)"/>
		<xsl:variable name="day" select="number(./a2a:Day)"/>
		<xsl:variable name="monthElement" select="./a2a:Month"/>
		<xsl:variable name="dayElement" select="./a2a:Day"/>
		<sdo:dateCreated>
			<xsl:choose>
				<xsl:when test="($month = 0 or not($monthElement)) and ($day = 0 or not($dayElement))">
					<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#gYear</xsl:attribute>
					<xsl:value-of select="$year"/>
				</xsl:when>
				<xsl:when test="($month &gt; 0 and $month &lt; 13) and ($day = 0 or not($dayElement))">
					<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#gYearMonth</xsl:attribute>
					<xsl:value-of select="$year"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="format-number($month, '00')"/>
				</xsl:when>
				<xsl:when test="$month &gt; 12 or $day &gt; 31 or $month &lt; 1 or $day &lt; 1">
					<xsl:value-of select="$year"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="format-number($month, '00')"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="format-number($day, '00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#date</xsl:attribute>
					<xsl:value-of select="$year"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="format-number($month, '00')"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="format-number($day, '00')"/>
				</xsl:otherwise>
			</xsl:choose>
		</sdo:dateCreated>
		<!--
    <sdo:dateCreated rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
      <xsl:value-of select="./a2a:Year"/>
      <xsl:text>-</xsl:text>
      <xsl:if test="string-length(./a2a:Month) &lt; 2">
        <xsl:text>0</xsl:text>
      </xsl:if>
      <xsl:value-of select="./a2a:Month"/>
      <xsl:text>-</xsl:text>
      <xsl:if test="string-length(./a2a:Day) &lt; 2">
        <xsl:text>0</xsl:text>
      </xsl:if>
      <xsl:value-of select="./a2a:Day"/>
    </sdo:dateCreated>
-->
	</xsl:template>
	<xsl:template match="a2a:SourceType">
		<xsl:variable name="SourceTypeMap">maps/sourcetypes.xml</xsl:variable>
		<xsl:variable name="source-type" select="text()"/>
		<xsl:variable name="source-type-id" select="document($SourceTypeMap)/items/item[name=$source-type]/id"/>
		<sdo:additionalType>
			<xsl:choose>
				<xsl:when test="$source-type-id != ''">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="$source-type-id"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
					<xsl:value-of select="$source-type"/>
				</xsl:otherwise>
			</xsl:choose>
		</sdo:additionalType>
	</xsl:template>
	<xsl:template match="a2a:EAD"/>
	<xsl:template match="a2a:EAC"/>
	<xsl:template match="a2a:SourceReference">
		<sdo:name xml:lang="{$lang}">
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
		<xsl:apply-templates select="a2a:InstitutionName"/>
	</xsl:template>
	<xsl:template match="a2a:SourceAvailableScans">
		<sdo:associatedMedia>
			<xsl:apply-templates select="a2a:Scan"/>
		</sdo:associatedMedia>
	</xsl:template>
	<xsl:template match="a2a:Scan">
		<sdo:ImageObject>
			<xsl:apply-templates select="a2a:OrderSequenceNumber"/>
			<xsl:apply-templates select="a2a:Uri"/>
			<xsl:apply-templates select="a2a:UriViewer"/>
			<xsl:apply-templates select="a2a:UriPreview"/>
		</sdo:ImageObject>
	</xsl:template>
	<xsl:template match="a2a:Uri">
		<sdo:contentUrl rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:contentUrl>
	</xsl:template>
	<xsl:template match="a2a:OrderSequenceNumber">
		<sdo:position>
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:position>
	</xsl:template>
	<xsl:template match="a2a:UriViewer">
		<sdo:embedUrl rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:embedUrl>
	</xsl:template>
	<xsl:template match="a2a:UriPreview">
		<sdo:thumbnailUrl rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:thumbnailUrl>
	</xsl:template>
	<xsl:template match="a2a:SourceDigitalizationDate"/>
	<xsl:template match="a2a:SourceLastChangeDate">
		<sdo:dateModified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
			<xsl:value-of select="normalize-space(.)"/>
		</sdo:dateModified>
	</xsl:template>
	<xsl:template match="a2a:SourceDigitalOriginal">
		<sdo:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
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
	<!-- view-source:https://www.openarchieven.nl/includes/archives-xsl.php -->
	<xsl:template match="a2a:InstitutionName">
		<xsl:param name="apos">'</xsl:param>
		<xsl:choose>
			<xsl:when test="text() = &quot;Archief Delft&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.stadsarchiefdelft.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Brabants Historisch Informatie Centrum&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.bhic.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Erfgoed Leiden en omstreken&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.erfgoedleiden.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Nederlands Militair Erfgoed&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://nlme.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Archief Eemland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.archiefeemland.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Ede&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://gemeentearchief.ede.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Drents Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.drentsarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Tholen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.archieftholen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Wassenaar&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://gemeentearchief.wassenaar.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Noord-Beveland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.noord-beveland.nl/historie</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Nationaal Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.nationaalarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Collectie Overijssel&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.historischcentrumoverijssel.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historisch Centrum Leeuwarden&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://historischcentrumleeuwarden.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Noord-Hollands Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.noord-hollandsarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Borne&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.borne.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal Archief Alkmaar&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.regionaalarchiefalkmaar.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal Archief Nijmegen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://studiezaal.nijmegen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal Archief Tilburg&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.regionaalarchieftilburg.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal Historisch Centrum Eindhoven&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.rhc-eindhoven.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal Historisch Centrum Vecht en Venen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.rhcvechtenvenen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Goes&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.goes.nl/gemeentearchief/nieuws_42833/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Streekarchief Langstraat Heusden Altena&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.salha.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Streekarchief Rijnlands Midden&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">http://www.groenehartarchieven.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Zeeuws Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.zeeuwsarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Enschede&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://stadsarchief.enschede.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Nationaal Archief Rijksarchief Zuid-Holland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.nationaalarchief.nl/onderzoeken/zoekhulpen/zuid-holland/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Rotterdam&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.stadsarchief.rotterdam.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Het Flevolands Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://hetflevolandsarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historisch Centrum Limburg&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.historischcentrumlimburg.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Borsele&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.borsele.nl/home/gemeentearchief_44987/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Deventer&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://collectieoverijssel.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gelders Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.geldersarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Nederlands Instituut voor Militaire Historie&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.nimh.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal Archief Rivierenland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://regionaalarchiefrivierenland.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Hengelo&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://archief.hengelo.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Venlo&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://archief.venlo.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;AlleFriezen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.allefriezen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;AlleGroningers&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.allegroningers.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal archief Zutphen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://erfgoedcentrumzutphen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeente Venray, gemeentearchief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://rooynet.nl/gemeentearchiefvenray</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Amsterdam&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.amsterdam.nl/stadsarchief/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Erfgoedcentrum Achterhoek en Liemers&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.ecal.nu/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Kerkrade&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.kerkrade.nl/wonen-en-leven/gemeentearchief_41450/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Steenwijkerland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.steenwijkerland.nl/Over_Steenwijkerland/Gemeentearchief</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal Archief Dordrecht&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.regionaalarchiefdordrecht.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Het Utrechts Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://hetutrechtsarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Schiedam&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.schiedam.nl/gemeentearchief</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Breda&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://stadsarchief.breda.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;West Brabants Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://westbrabantsarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Waterlands Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.waterlandsarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Zeist&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.zeist.nl/inwoner/cultuur-sport-en-recreatie/gemeentearchief/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Zaanstad&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://archief.zaanstad.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Westfries Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.westfriesarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Roermond&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.roermond.nl/gemeentearchief</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Haags Gemeentearchief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://haagsgemeentearchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Zoetermeer&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.geheugenvanzoetermeer.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Streekarchief Voorne-Putten&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.streekarchiefvp.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;RHC Rijnstreek en Lopikerwaard&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://rhcrijnstreek.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Streekarchief Epe, Hattem en Heerde&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.streekarchiefepe.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Ministerie van Defensie (SIB)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.defensie.nl/onderwerpen/archief</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Vlissingen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.gemeentearchiefvlissingen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Hasselt)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=hasselt</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Aarlen)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=aarlen</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Mechelen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://stadsarchief.mechelen.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;New York City Municipal Archives&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.nyc.gov/site/records/about/municipal-archives.page</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Leuven)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=leuven</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Antwerpen-Beveren)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=beveren</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Brugge)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=brugge</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Louvain-la-Neuve)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=lln</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Nederlands Bidprentjes Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://bidprentjesarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeente Zederik&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://historie.zederik.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Het Land van Gastel&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundekringhetlandvangastel.nl/referenties/bidprentjes/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Vrijheijt van Rosendale&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundekringroosendaal.nl/Collecties/Bidprentjes/Hoofdpagina%20bidprentjes.html</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Ommen-Hardenberg&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.hardenbergsarchief.nl</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Archief RK Friesland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://archiefrkfriesland.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Weerderheem&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://weerderheemcollecties.nl/cgi-bin/bidprent.pl</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Documentatiecentrum Maaseik&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://sites.google.com/site/dcmaaseik/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historisch Archief Midden-Groningen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://historischarchief.midden-groningen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = concat(&quot;Heemkundekring Loon op &quot;,$apos,&quot;t Sandt&quot;)">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://heemkundekringloonoptsandt.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Genealogisch Centrum Zeeland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://genealogischcentrumzeeland.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundevereniging Medelo&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://medelo.nl/home/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Barneveld&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://gemeentearchief.barneveld.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;RHC Zuidoost Utrecht&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.razu.nl</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundevereniging Helden&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.moennik.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Alphen aan den Rijn&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://gemeentearchief.alphenaandenrijn.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Nationaal Archief Suriname&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://nationaalarchief.sr/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stad Lommel - Archiefdienst&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.lommel.be/product/66/genealogische-opzoekingen</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Erfgoed Lommel&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://erfgoedlommel.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundevereniging Roerstreek&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.roerstreekmuseum.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Koninklijke Bibliotheek&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.delpher.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeente Oldenzaal&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://genealogie.oldenzaal.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historisch Archief Westland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.historischarchiefwestland.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Tweede Kamer der Staten-Generaal&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.erelijst.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeente Hof van Twente&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.hofvantwente.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Streekarchief Gooi en Vechtstreek&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.gooienvechthistorisch.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regioarchief Sittard-Geleen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://regioarchiefsittard-geleen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkring Molenheide&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkringmolenheide.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Paulus van Daesdonck&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.paulusvandaesdonck.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Vehchele&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://vehchele.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Kommanderij Gemert&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundekringgemert.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring de Heerlijkheid Oirschot&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.deheerlijkheidoirschot.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundige Kring De Oude Vrijheid&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.oudevrijheid.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Zeelst Schrijft Geschiedenis&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.zeelstschrijftgeschiedenis.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundevereniging Op die Dunghen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundedendungen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting De Oude Schoenendoos&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.stichtingdeoudeschoenendoos.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Zeeland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://heemkundekringzeeland.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Zevenbergen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundezevenbergen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Schijndel&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundekringschijndel.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;FelixArchief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://felixarchief.antwerpen.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Brussel)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=brussel</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Bergen)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=bergen</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Rijksarchief België (Gent)&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=gent</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = concat(&quot;L&quot;,$apos,&quot;Institut national de la statistique et des études économiques (INSEE)&quot;)">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://insee.fr/fr/accueil</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;gemeente Peel en Maas&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://peelenmaasnet.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;CODA&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.coda-apeldoorn.nl/nl/archief</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historische Vereniging Tweestromenland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://tweestromenland.com/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Waalres Erfgoed&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.waalreserfgoed.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkunde kring Amalia van Solms&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.amaliavansolms.org/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = concat(&quot;Erfgoed &quot;,$apos,&quot;s-Hertogenbosch&quot;)">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.erfgoedshertogenbosch.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkunde Boxtel&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://heemkundeboxtel.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Erfgoedvereniging Dye van Best&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://sites.google.com/a/dyevanbest.nl/dyevanbest/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Museum Greccio&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.museumgreccio.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundevereniging Berchs-Heem Berghem&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://berchs-heem.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Plaets&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://deplaets.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historische Kring Heemskerk&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.historischekringheemskerk.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;HKK De Elf Rotten&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.de-elf-rotten.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkring Glatbeke&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.glatbeke.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkunde Schaijk-Reek&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundeschaijkreek.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historische Kring Voorhout&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.hkv-voorhout.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Wojstap&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.dewojstap.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = concat(&quot;Heemkundige Kring &quot;,$apos,&quot;t Sireentje&quot;)">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://sireentje.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Kleine Meijerij&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.dekleinemeijerij.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundevereniging De Heerlijkheid Herlaar&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://deheerlijkheidherlaar.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundige Kring Braem&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.hkbraem.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundevereniging Helden&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://moennik.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Historisch Egmond&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.historischegmond.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Jan uten Houte&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.janutenhoute.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundewerkgroep Nuwelant&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.nuwelant.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Noordwijkerhout Van Toen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.noordwijkerhoutvantoen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Oud Zoeterwoude&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.oudzoeterwoude.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Rosmalen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundekringrosmalen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Steenen Kamer&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.hkkdesteenenkamer.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Oud Wervershoof&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.oudwervershoof.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historische Vereniging Oud Uitgeest&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.ouduitgeest.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historische Kring Ursem&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.historischekringursem.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Werkgroep Oud-Castricum&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.oud-castricum.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Nistelvorst&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://nistelvorst.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Regionaal Archief Gorinchem&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.regionaalarchiefgorinchem.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Archief Gent&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://stad.gent/nl/cultuur-sport-vrije-tijd/cultuur/archief-gent</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Particuliere prentjescollecties&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.openarchieven.nl/prentjes/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Gemeentearchief Gemert-Bakel&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.gemeentearchiefgemert-bakel.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Noord-Veluws Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://noordveluwsarchief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stedelijk Archief en Documentatiecentrum Aarschot&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://archiefbankhageland.atomis.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Tongeren&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.beeldbanktongeren.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Kortrijk&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.kortrijk.be/stadsarchief</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Streekarchief Midden-Holland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://samh.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stadsarchief Aalst&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://madeinaalst.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Erfgoedcel Denderland&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://madeindenderland.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Internationaal instituut voor sociale geschiedenis&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://iisg.amsterdam/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Amsab-Instituut voor Sociale Geschiedenis&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.amsab.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Erfgoedcentrum Tongerlohuys&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.tongerlohuys.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Erfgoed Goirle - De Vyer Heertganghen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://erfgoedgoirle.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Erthepe&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.erthepe.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkunde De Heerlyckheit Plo&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://heemkundeoploo.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Heem en Historie Oeffelt&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemhistorieoeffelt.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Erfgoedvereniging Heerlijkheid Hooge- en Lage Zwaluwe&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://erfgoedzwaluwe.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Megen, Haren en Macharen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.tongerlohuys.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Carel de Roy&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.alphenserfgoed.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkunde Werkgroep Reusel&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://heemkundereusel.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = concat(&quot;Heemkundekring &quot;,$apos,&quot;t Hof van Liessent&quot;)">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.hofvanliessent.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Princenhaags museum&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://princenhaagsmuseum.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Heerlijckheijd Nispen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundenispen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Vughts Museum&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.vughtsmuseum.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = concat(&quot;Museum &quot;,$apos,&quot;t Oude Slot&quot;)">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.museumoudeslot.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Stichting Erfgoed Gennep&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.stichtingerfgoedgennep.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Op de Beek&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://hk-opdebeek.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historische Vereniging Binnenwaard&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.binnenwaard.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historische Vereniging Oud-Akersloot&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.oudakersloot.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Indisch Herinneringscentrum&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.indischherinneringscentrum.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Drie Heerlijkheden&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.dedrieheerlijkheden.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring De Drijehornick&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://drijehornick.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Streekarchief Goeree-Overflakkee&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.streekarchiefgo.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Made en Drimmelen&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.heemkundekring-made-en-drimmelen.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Dendermonde&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://familiekunde-dendermonde.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Arsip Nasional Republik Indonesia&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://anri.go.id/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Geschied- en Heemkundige Kring De Goede Stede Hamont&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.hamontachel.com/bidprentjes-opzoeken/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Doodsprentjes.be&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.doodsprentjes.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Indeken.be&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.indeken.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Bidprentjesverzameling van Jacques Bogaerts&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://wb-stamboom-bidprenten-jacques.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Vlaanderen - Centrum voor Familiegeschiedenis&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://centrumfamiliegeschiedenis.be/bidprentjes</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Vlaanderen - regio Ieper-Diksmuide&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.familiekunde-ieperdiksmuide.be/bidprentjes/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkring Spaenhiers&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://spaenhiers.be/archief/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundige Kring Ten Mandere&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.tenmandere.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Vlaanderen - regio Westkust&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://familiekunde-westkust.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Euregionaal Bidprentjes Archief&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://bidprentjes-archief.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Oudheidkundige Kring De Vier Ambachten&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://devierambachten.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Vlaanderen - regio Brugge&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://fvbrugge.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Vlaanderen - regio Gent&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.familiekunde-gent.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Vlaanderen - regio Oostende&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.familiekunde-oostende.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Vlaanderen - regio Mandel en Leie&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://fv-mandelleie.familiekunde-vlaanderen.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Familiekunde Vlaanderen - regio Leuven&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://familiekundevlaanderen-leuven.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkring Zonnebeke&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://familiekundevlaanderen-leuven.be/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;de ziel van Neerkant&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://nheneerkant.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Heemkundekring Sint Tunnis in Oelbroeck&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://heemkundesinttunnis.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Historische Vereniging Soest/Soesterberg&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.hvsoest.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Bidprentjesverzameling Willy Ribbers&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://willyribbers.nl/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
			<xsl:when test="text() = &quot;Reclaim The Records&quot;">
				<sdo:holdingArchive>
					<xsl:attribute name="rdf:resource">https://www.reclaimtherecords.org/</xsl:attribute>
				</sdo:holdingArchive>
			</xsl:when>
		</xsl:choose>
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
	<xsl:template match="a2a:Collection/text()" mode="schema-name-nl">
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
