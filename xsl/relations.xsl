<?xml version="1.0" encoding="UTF-8"?>
<!-- Ivo Zandhuis (ivo@zandhuis.nl) -->
<xsl:stylesheet xmlns:a2a="http://Mindbus.nl/A2A" xmlns:a2arc="http://Mindbus.nl/RecordCollectionA2A" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:pnv="https://w3id.org/pnv#" xmlns:prov="http://www.w3.org/ns/prov#" xmlns:sdo="https://schema.org/" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:picom="https://personsincontext.org/model#" xmlns:picot="https://terms.personsincontext.org/" xmlns:picot_roles="https://terms.personsincontext.org/roles/" xmlns:picot_eventtypes="https://terms.personsincontext.org/eventtypes/" version="1.0" exclude-result-prefixes="xsl a2a a2arc">
	<xsl:template match="a2a:RelationEP">
		<!-- picom:hasRole only for specific RelationType values -->
		<xsl:choose>
			<!-- Kind → picot:575 -->
			<xsl:when test="a2a:RelationType = 'Kind'">
				<picom:hasRole rdf:resource="https://terms.personsincontext.org/roles/575"/>
			</xsl:when>
			<!-- Bruid → picot:574 -->
			<xsl:when test="a2a:RelationType = 'Bruid'">
				<picom:hasRole rdf:resource="https://terms.personsincontext.org/roles/574"/>
			</xsl:when>
			<!-- Bruidegom → picot:574 -->
			<xsl:when test="a2a:RelationType = 'Bruidegom'">
				<picom:hasRole rdf:resource="https://terms.personsincontext.org/roles/574"/>
			</xsl:when>
			<!-- Getuige → picot:573 -->
			<xsl:when test="a2a:RelationType = 'Getuige'">
				<picom:hasRole rdf:resource="https://terms.personsincontext.org/roles/573"/>
			</xsl:when>
			<xsl:when test="a2a:RelationType = 'other:Getuige'">
				<picom:hasRole rdf:resource="https://terms.personsincontext.org/roles/573"/>
			</xsl:when>
			<!-- Overledene → picot:479 -->
			<xsl:when test="a2a:RelationType = 'Overledene'">
				<picom:hasRole rdf:resource="https://terms.personsincontext.org/roles/479"/>
			</xsl:when>
			<!-- Aangever → picot:489 -->
			<xsl:when test="a2a:RelationType = 'Aangever'">
				<picom:hasRole rdf:resource="https://terms.personsincontext.org/roles/489"/>
			</xsl:when>
			<xsl:when test="a2a:RelationType = 'other:Aangever'">
				<picom:hasRole rdf:resource="https://terms.personsincontext.org/roles/489"/>
			</xsl:when>
			<!-- otherwise: nothing -->
		</xsl:choose>
		<xsl:call-template name="determine-relation-property">
			<xsl:with-param name="rel-type" select="a2a:RelationType"/>
		</xsl:call-template>
		<xsl:call-template name="determine-gender">
			<xsl:with-param name="rel-type" select="a2a:RelationType"/>
		</xsl:call-template>
		<xsl:call-template name="determine-event">
			<xsl:with-param name="rel-type" select="a2a:RelationType"/>
		</xsl:call-template>
		<xsl:call-template name="determine-sibling">
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
		<xsl:param name="rel-type"/>
		<xsl:variable name="RelationTypeMap">maps/relationtypes.xml</xsl:variable>
		<xsl:variable name="relations-parent" select=".."/>
		<xsl:variable name="children-related" select="document($RelationTypeMap)/items/item[name=$rel-type]/relation[property='children']/related"/>
		<xsl:variable name="parent-related" select="document($RelationTypeMap)/items/item[name=$rel-type]/relation[property='parent']/related"/>
		<xsl:variable name="spouse-related" select="document($RelationTypeMap)/items/item[name=$rel-type]/relation[property='spouse']/related"/>
		<xsl:for-each select="$children-related">
			<xsl:variable name="current-child-type" select="."/>
			<xsl:variable name="child-ref" select="$relations-parent/a2a:RelationEP[a2a:RelationType = $current-child-type]/a2a:PersonKeyRef"/>
			<xsl:if test="$child-ref">
				<sdo:children>
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="$baseUri"/>
						<xsl:value-of select="$child-ref"/>
					</xsl:attribute>
				</sdo:children>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="$parent-related">
			<xsl:variable name="current-parent-type" select="."/>
			<xsl:variable name="parent-ref" select="$relations-parent/a2a:RelationEP[a2a:RelationType = $current-parent-type]/a2a:PersonKeyRef"/>
			<xsl:if test="$parent-ref">
				<sdo:parent>
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="$baseUri"/>
						<xsl:value-of select="$parent-ref"/>
					</xsl:attribute>
				</sdo:parent>
			</xsl:if>
		</xsl:for-each>
		<!-- Simple spouse link (for birth records with Vader/Moeder) -->
		<xsl:if test="normalize-space($spouse-related) != '' and not(normalize-space($parent-related) != '')">
			<xsl:for-each select="$spouse-related">
				<xsl:variable name="current-spouse-type" select="."/>
				<xsl:variable name="spouse-ref" select="$relations-parent/a2a:RelationEP[a2a:RelationType = $current-spouse-type]/a2a:PersonKeyRef"/>
				<xsl:if test="$spouse-ref">
					<sdo:spouse>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$baseUri"/>
							<xsl:value-of select="$spouse-ref"/>
						</xsl:attribute>
					</sdo:spouse>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!-- Marriage records: simple spouse link + life event (for Bruid/Bruidegom) -->
		<xsl:if test="normalize-space($spouse-related) != '' and normalize-space($parent-related) != ''">
			<!-- Simple spouse link -->
			<xsl:for-each select="$spouse-related">
				<xsl:variable name="current-spouse-type" select="."/>
				<xsl:variable name="spouse-ref" select="$relations-parent/a2a:RelationEP[a2a:RelationType = $current-spouse-type]/a2a:PersonKeyRef"/>
				<xsl:if test="$spouse-ref">
					<sdo:spouse>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$baseUri"/>
							<xsl:value-of select="$spouse-ref"/>
						</xsl:attribute>
					</sdo:spouse>
				</xsl:if>
			</xsl:for-each>
			<!-- Marriage life event -->
			<picom:hasLifeEvent>
				<rdf:Description>
					<rdf:type rdf:resource="https://personsincontext.org/model#LifeEvent"/>
					<picom:eventType rdf:resource="https://terms.personsincontext.org/eventtypes/83"/>
					<xsl:variable name="eventDate" select="$relations-parent/a2a:Event[a2a:EventType='Huwelijk']/a2a:EventDate"/>
					<xsl:variable name="year" select="$eventDate/a2a:Year"/>
					<xsl:variable name="month" select="number($eventDate/a2a:Month)"/>
					<xsl:variable name="day" select="number($eventDate/a2a:Day)"/>
					<xsl:variable name="monthElement" select="$eventDate/a2a:Month"/>
					<xsl:variable name="dayElement" select="$eventDate/a2a:Day"/>
					<picom:eventDate>
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
					</picom:eventDate>
					<xsl:if test="$relations-parent/a2a:Event[a2a:EventType='Huwelijk']/a2a:EventPlace/a2a:Place != ''">
						<picom:eventPlace xml:lang="{$lang}">
							<xsl:value-of select="$relations-parent/a2a:Event[a2a:EventType='Huwelijk']/a2a:EventPlace/a2a:Place"/>
						</picom:eventPlace>
					</xsl:if>
				</rdf:Description>
			</picom:hasLifeEvent>
		</xsl:if>
	</xsl:template>
	<xsl:template name="determine-gender">
		<xsl:param name="rel-type"/>
		<xsl:variable name="RelationTypeMap">maps/relationtypes.xml</xsl:variable>
		<xsl:variable name="gender" select="document($RelationTypeMap)/items/item[name=$rel-type]/gender"/>
		<!-- explicit gender on the person (person.xsl emits sdo:gender only for Man/Vrouw) -->
		<xsl:variable name="explicitGender" select="../a2a:Person[@pid = current()/a2a:PersonKeyRef]/a2a:Gender"/>
		<!-- only emit relation-derived gender when no explicit gender triple will be produced -->
		<xsl:if test="$gender and not($explicitGender = 'Man' or $explicitGender = 'Vrouw')">
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
				<xsl:variable name="eventDate" select="../a2a:Event/a2a:EventDate"/>
				<xsl:variable name="year" select="$eventDate/a2a:Year"/>
				<xsl:variable name="month" select="number($eventDate/a2a:Month)"/>
				<xsl:variable name="day" select="number($eventDate/a2a:Day)"/>
				<xsl:variable name="monthElement" select="$eventDate/a2a:Month"/>
				<xsl:variable name="dayElement" select="$eventDate/a2a:Day"/>
				<sdo:birthDate>
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
				</sdo:birthDate>
				<xsl:if test="../a2a:Event/a2a:EventPlace/a2a:Place != ''">
					<sdo:birthPlace xml:lang="{$lang}">
						<xsl:value-of select="../a2a:Event/a2a:EventPlace/a2a:Place"/>
					</sdo:birthPlace>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$rel-type = 'Overledene'">
				<xsl:variable name="eventDate" select="../a2a:Event/a2a:EventDate"/>
				<xsl:variable name="year" select="$eventDate/a2a:Year"/>
				<xsl:variable name="month" select="number($eventDate/a2a:Month)"/>
				<xsl:variable name="day" select="number($eventDate/a2a:Day)"/>
				<xsl:variable name="monthElement" select="$eventDate/a2a:Month"/>
				<xsl:variable name="dayElement" select="$eventDate/a2a:Day"/>
				<xsl:choose>
					<xsl:when test="$year != ''">
						<sdo:deathDate>
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
						</sdo:deathDate>
					</xsl:when>
					<!-- death date unknown: assert deceased per PiCo scopeNote (otherwise person is considered alive) -->
					<xsl:otherwise>
						<picom:deceased rdf:datatype="http://www.w3.org/2001/XMLSchema#boolean">true</picom:deceased>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="../a2a:Event/a2a:EventPlace/a2a:Place != ''">
					<sdo:deathPlace xml:lang="{$lang}">
						<xsl:value-of select="../a2a:Event/a2a:EventPlace/a2a:Place"/>
					</sdo:deathPlace>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- sibling link: only in death (BS Overlijden) / burial (DTB Begraven) records,
	     between the Overledene and any other:Broer / other:Zus -->
	<xsl:template name="determine-sibling">
		<xsl:param name="rel-type"/>
		<xsl:variable name="sourceType" select="../a2a:Source/a2a:SourceType"/>
		<xsl:if test="$sourceType = 'BS Overlijden' or $sourceType = 'DTB Begraven'">
			<xsl:choose>
				<!-- the deceased -> link to every brother / sister in the record -->
				<xsl:when test="$rel-type = 'Overledene'">
					<xsl:for-each select="../a2a:RelationEP[a2a:RelationType = 'other:Broer' or a2a:RelationType = 'other:Zus']">
						<sdo:sibling>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="$baseUri"/>
								<xsl:value-of select="a2a:PersonKeyRef"/>
							</xsl:attribute>
						</sdo:sibling>
					</xsl:for-each>
				</xsl:when>
				<!-- a brother / sister -> link back to the deceased -->
				<xsl:when test="$rel-type = 'other:Broer' or $rel-type = 'other:Zus'">
					<xsl:for-each select="../a2a:RelationEP[a2a:RelationType = 'Overledene']">
						<sdo:sibling>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="$baseUri"/>
								<xsl:value-of select="a2a:PersonKeyRef"/>
							</xsl:attribute>
						</sdo:sibling>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
