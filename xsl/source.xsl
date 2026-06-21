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
    <sdo:url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
      <xsl:value-of select="normalize-space(.)"/>
    </sdo:url>
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
    <sdo:thumbnail rdf:resource="{normalize-space(.)}"/>
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
        <xsl:when test='text() = "Archief Delft"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.stadsarchiefdelft.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Brabants Historisch Informatie Centrum"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.bhic.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Erfgoed Leiden en omstreken"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.erfgoedleiden.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Nederlands Militair Erfgoed"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://nlme.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Archief Eemland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.archiefeemland.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Ede"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://gemeentearchief.ede.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Drents Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.drentsarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Tholen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.archieftholen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Wassenaar"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://gemeentearchief.wassenaar.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Noord-Beveland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.noord-beveland.nl/historie</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Nationaal Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.nationaalarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Collectie Overijssel"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.historischcentrumoverijssel.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historisch Centrum Leeuwarden"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://historischcentrumleeuwarden.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Noord-Hollands Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.noord-hollandsarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Borne"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.borne.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal Archief Alkmaar"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.regionaalarchiefalkmaar.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal Archief Nijmegen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://studiezaal.nijmegen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal Archief Tilburg"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.regionaalarchieftilburg.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal Historisch Centrum Eindhoven"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.rhc-eindhoven.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal Historisch Centrum Vecht en Venen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.rhcvechtenvenen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Goes"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.goes.nl/gemeentearchief/nieuws_42833/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Streekarchief Langstraat Heusden Altena"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.salha.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Streekarchief Rijnlands Midden"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">http://www.groenehartarchieven.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Zeeuws Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.zeeuwsarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stadsarchief Enschede"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://stadsarchief.enschede.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Nationaal Archief Rijksarchief Zuid-Holland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.nationaalarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stadsarchief Rotterdam"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.stadsarchief.rotterdam.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Het Flevolands Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://hetflevolandsarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historisch Centrum Limburg"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.historischcentrumlimburg.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Borsele"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.borsele.nl/home/gemeentearchief_44987/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stadsarchief Deventer"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://collectieoverijssel.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gelders Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.geldersarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Nederlands Instituut voor Militaire Historie"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.nimh.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal Archief Rivierenland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://regionaalarchiefrivierenland.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Hengelo"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://archief.hengelo.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Venlo"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://archief.venlo.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "AlleFriezen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.allefriezen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "AlleGroningers"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.allegroningers.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal archief Zutphen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://erfgoedcentrumzutphen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeente Venray, gemeentearchief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://rooynet.nl/gemeentearchiefvenray</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stadsarchief Amsterdam"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.amsterdam.nl/stadsarchief/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Erfgoedcentrum Achterhoek en Liemers"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.ecal.nu/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Kerkrade"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.kerkrade.nl/wonen-en-leven/gemeentearchief_41450/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Steenwijkerland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.steenwijkerland.nl/Over_Steenwijkerland/Gemeentearchief</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal Archief Dordrecht"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.regionaalarchiefdordrecht.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Het Utrechts Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://hetutrechtsarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Rijckheyt, centrum voor regionale geschiedenis"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.rijckheyt.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Schiedam"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.schiedam.nl/gemeentearchief</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stadsarchief Breda"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://stadsarchief.breda.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "West Brabants Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://westbrabantsarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Waterlands Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.waterlandsarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Zeist"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.zeist.nl/inwoner/cultuur-sport-en-recreatie/gemeentearchief/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Zaanstad"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://archief.zaanstad.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Westfries Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.westfriesarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Roermond"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.roermond.nl/gemeentearchief</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Haags Gemeentearchief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://haagsgemeentearchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Zoetermeer"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.zoetermeer.nl/inwoners/stadsarchief_46467/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Streekarchief Voorne-Putten"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.streekarchiefvp.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "RHC Rijnstreek en Lopikerwaard"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://rhcrijnstreek.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Streekarchief Epe, Hattem en Heerde"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.streekarchiefepe.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Ministerie van Defensie (SIB)"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.defensie.nl/onderwerpen/archief</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Vlissingen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.gemeentearchiefvlissingen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Rijksarchief België (Hasselt)"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=hasselt</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Rijksarchief België (Leuven)"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=leuven</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Rijksarchief België (Antwerpen-Beveren)"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=beveren</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Nederlands Bidprentjes Archief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://bidprentjesarchief.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeente Zederik"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://historie.zederik.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Het Land van Gastel"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundekringhetlandvangastel.nl/referenties/bidprentjes/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring De Vrijheijt van Rosendale"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundekringroosendaal.nl/Collecties/Bidprentjes/Hoofdpagina%20bidprentjes.html</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Ommen-Hardenberg"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.hardenbergsarchief.nl</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Archief RK Friesland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://archiefrkfriesland.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Weerderheem"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://weerderheemcollecties.nl/cgi-bin/bidprent.pl</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Documentatiecentrum Maaseik"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://sites.google.com/site/dcmaaseik/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historisch Archief Midden-Groningen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://historischarchief.midden-groningen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = concat("Heemkundekring Loon op ",$apos,"t Sandt")'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://heemkundekringloonoptsandt.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Genealogisch Centrum Zeeland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://genealogischcentrumzeeland.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundevereniging Medelo"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://medelo.nl/home/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Barneveld"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://gemeentearchief.barneveld.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "RHC Zuidoost Utrecht"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.razu.nl</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundevereniging Helden"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.moennik.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Alphen aan den Rijn"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://gemeentearchief.alphenaandenrijn.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Nationaal Archief Suriname"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://nationaalarchief.sr/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stad Lommel - Archiefdienst"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.lommel.be/product/66/genealogische-opzoekingen</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Erfgoed Lommel"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://erfgoedlommel.be/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundevereniging Roerstreek"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.roerstreekmuseum.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Koninklijke Bibliotheek"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.delpher.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeente Oldenzaal"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://genealogie.oldenzaal.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historisch Archief Westland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.historischarchiefwestland.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Tweede Kamer der Staten-Generaal"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.erelijst.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeente Hof van Twente"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.hofvantwente.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Streekarchief Gooi en Vechtstreek"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.gooienvechthistorisch.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Archief De Domijnen Sittard-Geleen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.dedomijnen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkring Molenheide"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkringmolenheide.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Paulus van Daesdonck"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.paulusvandaesdonck.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Vehchele"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://vehchele.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring De Kommanderij Gemert"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundekringgemert.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring de Heerlijkheid Oirschot"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.deheerlijkheidoirschot.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundige Kring De Oude Vrijheid"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.oudevrijheid.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stichting Zeelst Schrijft Geschiedenis"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.zeelstschrijftgeschiedenis.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundevereniging Op die Dunghen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundedendungen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stichting De Oude Schoenendoos"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.stichtingdeoudeschoenendoos.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Zeeland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://heemkundekringzeeland.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Zevenbergen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundezevenbergen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Schijndel"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundekringschijndel.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "FelixArchief"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://felixarchief.antwerpen.be/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Rijksarchief België (Brussel)"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=brussel</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Rijksarchief België (Bergen)"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=bergen</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Rijksarchief België (Gent)"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.arch.be/index.php?l=nl&amp;m=praktische-info&amp;r=onze-leeszalen&amp;d=gent</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = concat("L",$apos,"Institut national de la statistique et des études économiques (INSEE)")'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://insee.fr/fr/accueil</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "gemeente Peel en Maas"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://peelenmaasnet.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "CODA"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.coda-apeldoorn.nl/nl/archief</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historische Vereniging Tweestromenland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://tweestromenland.com/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Waalres Erfgoed"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.waalreserfgoed.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkunde kring Amalia van Solms"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.amaliavansolms.org/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = concat("Erfgoed ",$apos,"s-Hertogenbosch")'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.erfgoedshertogenbosch.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkunde Boxtel"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://heemkundeboxtel.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Erfgoedvereniging Dye van Best"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://sites.google.com/a/dyevanbest.nl/dyevanbest/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Museum Greccio"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.museumgreccio.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundevereniging Berchs-Heem Berghem"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://berchs-heem.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring De Plaets"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://deplaets.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historische Kring Heemskerk"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.historischekringheemskerk.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "HKK De Elf Rotten"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.de-elf-rotten.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkring Glatbeke"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.glatbeke.be/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkunde Schaijk-Reek"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundeschaijkreek.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Jan uten Houte"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.janutenhoute.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundewerkgroep Nuwelant"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.nuwelant.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Noordwijkerhout Van Toen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.noordwijkerhoutvantoen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stichting Oud Zoeterwoude"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.oudzoeterwoude.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Rosmalen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundekringrosmalen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stichting Oud Wervershoof"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.oudwervershoof.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historische Vereniging Oud Uitgeest"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.ouduitgeest.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historische Kring Ursem"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.historischekringursem.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stichting Werkgroep Oud-Castricum"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.oud-castricum.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Nistelvorst"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://nistelvorst.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Regionaal Archief Gorinchem"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.regionaalarchiefgorinchem.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Archief Gent"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://stad.gent/nl/cultuur-sport-vrije-tijd/cultuur/archief-gent</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Particuliere prentjescollecties"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.openarchieven.nl/prentjes/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Gemeentearchief Gemert-Bakel"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.gemeentearchiefgemert-bakel.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Streekarchivariaat Noordwest-Veluwe"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.snwv.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stedelijk Archief en Documentatiecentrum Aarschot"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://archiefbankhageland.atomis.be/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stadsarchief Tongeren"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.beeldbanktongeren.be/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stadsarchief Kortrijk"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.kortrijk.be/stadsarchief</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Streekarchief Midden-Holland"'>
          <sdo:holdingArchive rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">https://samh.nl/</sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stadsarchief Aalst"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://madeinaalst.be/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Erfgoedcel Denderland"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://madeindenderland.be/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Internationaal instituut voor sociale geschiedenis"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://iisg.amsterdam/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Amsab-Instituut voor Sociale Geschiedenis"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.amsab.be/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stichting Erfgoedcentrum Tongerlohuys"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.tongerlohuys.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Carel de Roy"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.alphenserfgoed.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkunde Werkgroep Reusel"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://heemkundereusel.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = concat("Heemkundekring ",$apos,"t Hof van Liessent")'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.hofvanliessent.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Princenhaags museum"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://princenhaagsmuseum.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring De Heerlijckheijd Nispen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundenispen.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Vughts Museum"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.vughtsmuseum.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = concat("Museum ",$apos,"t Oude Slot")'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.museumoudeslot.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Stichting Erfgoed Gennep"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.stichtingerfgoedgennep.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Op de Beek"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://hk-opdebeek.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historische Vereniging Binnenwaard"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.binnenwaard.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Historische Vereniging Oud-Akersloot"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.oudakersloot.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Indisch Herinneringscentrum"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.indischherinneringscentrum.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring De Drie Heerlijkheden"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.dedrieheerlijkheden.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring De Drijehornick"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://drijehornick.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Streekarchief Goeree-Overflakkee"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.streekarchiefgo.nl/</xsl:attribute>
          </sdo:holdingArchive>
        </xsl:when>
        <xsl:when test='text() = "Heemkundekring Made en Drimmelen"'>
          <sdo:holdingArchive>
            <xsl:attribute name="rdf:resource">https://www.heemkundekring-made-en-drimmelen.nl/</xsl:attribute>
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
