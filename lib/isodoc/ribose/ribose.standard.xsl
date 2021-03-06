<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:rsd="https://www.metanorma.org/ns/rsd" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:param name="svg_images"/>
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:variable name="images" select="document($svg_images)"/>
	
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="copyright">
	<xsl:value-of select="/rsd:rsd-standard/rsd:boilerplate/rsd:copyright-statement/rsd:clause[1]"/>
	<xsl:text> – All rights reserved</xsl:text>
	</xsl:variable>
		
	<xsl:variable name="color-link">blue</xsl:variable>
	
	<xsl:variable name="doctitle" select="/rsd:rsd-standard/rsd:bibdata/rsd:title[@language = 'en']"/>

	<xsl:variable name="doctype">
		<xsl:call-template name="capitalizeWords">
			<xsl:with-param name="str" select="/rsd:rsd-standard/rsd:bibdata/rsd:ext/rsd:doctype"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="header">
		<xsl:text>Ribose Whitepaper </xsl:text>
		<xsl:value-of select="/rsd:rsd-standard/rsd:bibdata/rsd:docidentifier[@type = 'rsd']"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/rsd:rsd-standard/rsd:bibdata/rsd:copyright/rsd:from"/>
	</xsl:variable>
	
	<xsl:variable name="contents">
		<contents>
		
			<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:abstract" mode="contents"/>
			<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:foreword" mode="contents"/>
			<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:executivesummary" mode="contents"/>
			<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:introduction" mode="contents"/>
			<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:clause" mode="contents"/>
			<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:acknowledgements" mode="contents"/>
					
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
			
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root font-family="Source Sans Pro, STIX Two Math" font-weight="300" font-size="10.5pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="22mm" margin-bottom="22mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="22mm"/> 
					<fo:region-after region-name="footer-odd" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="22mm" margin-bottom="22mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="22mm"/> 
					<fo:region-after region-name="footer-even" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="22mm" margin-bottom="22mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header" extent="22mm"/> 
					<fo:region-after region-name="footer" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>				
			</fo:layout-master-set>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>
			
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<fo:page-sequence master-reference="document" format="i" force-page-count="end-on-even">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter">
					<xsl:with-param name="font-weight">normal</xsl:with-param>
				</xsl:call-template>
				<fo:flow flow-name="xsl-region-body">
					<fo:block font-size="16pt" margin-bottom="16pt"> </fo:block>
					<fo:block font-size="16pt" margin-bottom="16pt"> </fo:block>
					<fo:block font-size="22pt" font-weight="normal" margin-bottom="12pt"><xsl:value-of select="$doctitle"/></fo:block>
					<fo:block font-size="22pt" margin-bottom="14pt"> </fo:block>
					<fo:block font-size="22pt" margin-bottom="14pt"> </fo:block>
					<fo:block font-size="22pt" margin-bottom="6pt"> </fo:block>
					
					<fo:block font-family="Source Serif Pro" font-size="12pt" line-height="230%">
						<fo:block>Ronald Tse</fo:block>
						<fo:block>Wai Kit Wong</fo:block>
						<fo:block>Daniel Wyatt</fo:block>
						<fo:block>Nickolay Olshevsky</fo:block>
						<fo:block>Jeffrey Lau</fo:block>
					</fo:block>
					<fo:block margin-top="24pt" font-size="22pt" margin-left="1mm">
						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($rnp-Logo))}" width="28.8mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="rnp Logo"/><!--  vertical-align="middle" -->
					</fo:block>
					<fo:block font-size="16pt" margin-bottom="12pt"> </fo:block>
					<fo:block font-size="12pt" margin-bottom="12pt">RNP and Confium team, Ribose Inc.</fo:block>
					
					<fo:block font-size="12pt" margin-bottom="12pt">
						<xsl:value-of select="/rsd:rsd-standard/rsd:bibdata/rsd:docidentifier[@type = 'rsd']"/>
						<xsl:text>:</xsl:text>
						<xsl:value-of select="/rsd:rsd-standard/rsd:bibdata/rsd:copyright/rsd:from"/>
						<xsl:variable name="title-edition">
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name" select="'title-edition'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:text>, </xsl:text><xsl:value-of select="$title-edition"/><xsl:text> </xsl:text>						
						<xsl:value-of select="/rsd:rsd-standard/rsd:bibdata/rsd:edition"/>
					</fo:block>
					
					<fo:block font-size="12pt" margin-bottom="12pt">
						<xsl:call-template name="formatDate">
							<xsl:with-param name="date" select="/rsd:rsd-standard/rsd:bibdata/rsd:date[@type = 'published']/rsd:on"/>
						</xsl:call-template>
					</fo:block>
					
					<fo:block font-size="12pt" font-weight="normal" font-style="italic" margin-bottom="12pt">
						<xsl:text>Unrestricted</xsl:text>
					</fo:block>
					
					<fo:block font-size="13pt" margin-bottom="12pt"> </fo:block>
					
					<fo:block font-size="13pt">Delivered to <fo:inline color="blue" text-decoration="underline">nistir-8214A-comments@nist.gov</fo:inline></fo:block>
					
					<fo:block-container position="absolute" left="1.5mm" top="243.5mm">
						<fo:block>
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Ribose-Logo))}" width="44.7mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="rnp Logo"/>
						</fo:block>
					</fo:block-container>
					
					<fo:block break-after="page"/>
					
					<xsl:variable name="title-toc">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-toc'"/>
						</xsl:call-template>
					</xsl:variable>
					<fo:block font-size="14pt" font-weight="normal" margin-bottom="15.5pt"><xsl:value-of select="$title-toc"/></fo:block>
					<fo:block font-weight="normal" line-height="125%">
						<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true']">
							<fo:block>
								<xsl:if test="@level = 1">
									<xsl:attribute name="margin-top">6pt</xsl:attribute>
								</xsl:if>
								<fo:list-block>
									<xsl:attribute name="provisional-distance-between-starts">
										<xsl:choose>
											<!-- skip 0 section without subsections -->
											<xsl:when test="@section != ''">7.5mm</xsl:when>
											<xsl:otherwise>0mm</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<fo:list-item>
										<fo:list-item-label end-indent="label-end()">
											<fo:block>												
												<xsl:value-of select="@section"/>
											</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
												
													<xsl:apply-templates select="title"/>
													
													<fo:inline keep-together.within-line="always">
														<fo:leader leader-pattern="dots"/>
														<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
													</fo:inline>
												</fo:basic-link>
											</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</fo:list-block>
							</fo:block>
						</xsl:for-each>
					</fo:block>
					
					<fo:block margin-top="6pt"> </fo:block>
					<fo:block margin-bottom="12pt"> </fo:block>
					
					<xsl:apply-templates select="/rsd:rsd-standard/rsd:boilerplate/rsd:legal-statement"/>
					
				</fo:flow>
			</fo:page-sequence>

			
			<fo:page-sequence master-reference="document" format="1" initial-page-number="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
				
					<fo:block line-height="130%">
					
						<fo:block font-size="16pt" font-weight="normal" margin-bottom="18pt"><xsl:value-of select="$doctitle"/></fo:block>
					
						<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:abstract"/>
						<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:foreword"/>
						<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:executivesummary"/>
						<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:introduction"/>
						<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:clause"/>
						<xsl:apply-templates select="/rsd:rsd-standard/rsd:preface/rsd:acknowledgements"/>
					
						<xsl:call-template name="processMainSectionsDefault"/>
						
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
		</fo:root>
	</xsl:template> 


	<xsl:template match="node()">		
		<xsl:apply-templates/>			
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">		
		<xsl:apply-templates mode="contents"/>			
	</xsl:template>


	<!-- element with title -->
	<xsl:template match="*[rsd:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="rsd:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="$level &gt;= 3">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::rsd:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::rsd:term">true</xsl:when>				
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates mode="contents"/>
			</item>
			
		</xsl:if>	
		
	</xsl:template>	
	
	<!-- ============================= -->
	<!-- ============================= -->
	
	<xsl:template match="/rsd:rsd-standard/rsd:bibdata/rsd:uri[not(@type)]">
		<fo:block margin-bottom="12pt">
			<xsl:text>URL for this RSD® document: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="/rsd:rsd-standard/rsd:bibdata/rsd:edition">
		<fo:block margin-bottom="12pt">
			<xsl:variable name="title-edition">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-edition'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$title-edition"/><xsl:text>: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="rsd:license-statement//rsd:title">
		<fo:block text-align="center" font-weight="normal" margin-top="4pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="rsd:license-statement//rsd:p">
		<fo:block font-size="8pt" margin-top="14pt" line-height="115%">
			<xsl:if test="following-sibling::rsd:p">
				<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="rsd:feedback-statement">
		<fo:block margin-top="12pt" margin-bottom="12pt">
			<xsl:apply-templates select="rsd:clause[1]"/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="rsd:copyright-statement//rsd:title">
		<fo:block font-weight="normal" text-align="center">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="rsd:copyright-statement//rsd:p">
		<fo:block margin-bottom="12pt">
			<xsl:if test="not(following-sibling::p)">
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="rsd:legal-statement">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="rsd:legal-statement//rsd:title">
		<fo:block font-weight="normal" padding-top="2mm" margin-bottom="6pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		
	
	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<xsl:template match="rsd:annex/rsd:title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$level &gt;= 1">rgb(14, 26, 133)</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="12pt" text-align="center" margin-bottom="12pt" keep-with-next="always" color="{$color}">			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="rsd:title">
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::rsd:preface and $level &gt;= 2">12pt</xsl:when>
				<xsl:when test="ancestor::rsd:preface">13pt</xsl:when>
				<xsl:when test="$level = 1">13pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::rsd:terms">11pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>16pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$level &gt;= 1">rgb(14, 26, 133)</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="space-before">13.5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
			
			<xsl:apply-templates/>
			
		</xsl:element>
			
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	<xsl:template match="rsd:p">
		<xsl:param name="inline" select="'false'"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::rsd:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise><!-- justify -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="ancestor::rsd:li">0pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- <xsl:attribute name="line-height">155%</xsl:attribute> -->
			<xsl:apply-templates/>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::rsd:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block> </fo:block>
		</xsl:if>
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="rsd:title/rsd:fn | rsd:p/rsd:fn[not(ancestor::rsd:table)]" priority="2">
		<fo:footnote keep-with-previous.within-line="always">
			<xsl:variable name="number" select="@reference"/>
			
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}" fox:alt-text="footnote {@reference}">
					<xsl:value-of select="$number"/><!--  + count(//rsd:bibitem/rsd:note) -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt" font-weight="normal" text-indent="0" start-indent="0" color="rgb(168, 170, 173)" text-align="left">
					<fo:inline id="footnote_{@reference}" keep-with-next.within-line="always" font-size="60%" vertical-align="super">
						<xsl:value-of select="$number "/><!-- + count(//rsd:bibitem/rsd:note) -->
					</fo:inline>
					<xsl:for-each select="rsd:p">
							<xsl:apply-templates/>
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="rsd:fn/rsd:p">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	
	
	<xsl:template match="rsd:bibitem">
		<fo:block font-family="Source Sans Pro" font-size="11pt" id="{@id}" margin-bottom="12pt" start-indent="12mm" text-indent="-12mm">
			<xsl:if test=".//rsd:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
			<xsl:if test="rsd:docidentifier">
				<xsl:value-of select="rsd:docidentifier/@type"/><xsl:text> </xsl:text>
				<xsl:value-of select="rsd:docidentifier"/>
			</xsl:if>
			<xsl:apply-templates select="rsd:note"/>
			<xsl:if test="rsd:docidentifier">, </xsl:if>
			<xsl:choose>
				<xsl:when test="rsd:formattedref">
					<xsl:apply-templates select="rsd:formattedref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="rsd:contributor[rsd:role/@type='publisher']/rsd:organization/rsd:name">
						<xsl:apply-templates/>
						<xsl:if test="position() != last()">, </xsl:if>
						<xsl:if test="position() = last()">: </xsl:if>
					</xsl:for-each>
						<!-- rsd:docidentifier -->
					
					
					<fo:inline font-style="italic">
						<xsl:choose>
							<xsl:when test="rsd:title[@type = 'main' and @language = 'en']">
								<xsl:value-of select="rsd:title[@type = 'main' and @language = 'en']"/><xsl:text>. </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="rsd:title"/><xsl:text>. </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:for-each select="rsd:contributor[rsd:role/@type='publisher']/rsd:organization/rsd:name">
						<xsl:apply-templates/>
						<xsl:if test="position() != last()">, </xsl:if>
					</xsl:for-each>
					<xsl:if test="rsd:date[@type='published']/rsd:on">
						<xsl:text>(</xsl:text><xsl:value-of select="rsd:date[@type='published']/rsd:on"/><xsl:text>)</xsl:text>
					</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="rsd:bibitem/rsd:note" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:choose>
					<xsl:when test="ancestor::rsd:references[preceding-sibling::rsd:references]">
						<xsl:number level="any" count="rsd:references[preceding-sibling::rsd:references]//rsd:bibitem/rsd:note"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number level="any" count="rsd:bibitem/rsd:note"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super"> <!--  60% baseline-shift="35%"   -->
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt" start-indent="0pt" color="rgb(168, 170, 173)">
					<fo:inline id="{generate-id()}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"><!-- baseline-shift="30%" padding-right="9mm"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:apply-templates/>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	<xsl:template match="rsd:references[not(@normative='true')]/rsd:bibitem">
		<fo:list-block margin-bottom="12pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline id="{@id}">
							<xsl:number format="[1]"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:if test="rsd:docidentifier">
							<xsl:choose>
								<xsl:when test="rsd:docidentifier/@type = 'metanorma'"/>
								<xsl:otherwise><fo:inline><xsl:value-of select="rsd:docidentifier"/>, </fo:inline></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="rsd:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="rsd:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="rsd:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="rsd:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>

	
	
	<xsl:template match="rsd:ul | rsd:ol" mode="ul_ol">
		<xsl:choose>
			<xsl:when test="not(ancestor::rsd:ul) and not(ancestor::rsd:ol)">
				<fo:block padding-bottom="12pt">
					<xsl:call-template name="listProcessing"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="listProcessing"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="listProcessing">
		<fo:list-block provisional-distance-between-starts="6.5mm">
			<xsl:if test="ancestor::rsd:ul | ancestor::rsd:ol">
				<!-- <xsl:attribute name="margin-bottom">0pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="following-sibling::*[1][local-name() = 'ul' or local-name() = 'ol']">
				<!-- <xsl:attribute name="margin-bottom">0pt</xsl:attribute> -->
			</xsl:if>
			<xsl:apply-templates/>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="rsd:li">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:choose>
						<xsl:when test="local-name(..) = 'ul' and (../ancestor::rsd:ul or ../ancestor::rsd:ol)">-</xsl:when> <!-- &#x2014; dash -->
						<xsl:when test="local-name(..) = 'ul'">—</xsl:when> <!-- • &#x2014; dash -->
						<xsl:otherwise> <!-- for ordered lists -->
							<xsl:choose>
								<xsl:when test="../@type = 'arabic'">
									<xsl:number format="a)" lang="en"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet'">
									<xsl:number format="1)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet_upper'">
									<xsl:number format="A)" lang="en"/>
								</xsl:when>
								
								<xsl:when test="../@type = 'roman'">
									<xsl:number format="i)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="1)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="rsd:ul/rsd:note | rsd:ol/rsd:note" priority="2">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block/></fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates select="rsd:name" mode="presentation"/>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	
	
	<xsl:template match="rsd:preferred">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">11pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}">
			<fo:block font-weight="normal" keep-with-next="always">
				<xsl:apply-templates select="ancestor::rsd:term/rsd:name" mode="presentation"/>
			</fo:block>
			<fo:block font-weight="normal" keep-with-next="always" line-height="1">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>
	

	
	<!-- [position() &gt; 1] -->
	<xsl:template match="rsd:references[not(@normative='true')]">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="rsd:references[not(@normative='true')]/rsd:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="rsd:references[@id = '_bibliography']/rsd:bibitem/rsd:title"> [position() &gt; 1]-->
	<xsl:template match="rsd:references[not(@normative='true')]/rsd:bibitem/rsd:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	
	
<!-- 	<xsl:template match="rsd:note/rsd:p" name="note">
		<fo:block font-size="10pt" margin-top="12pt" margin-bottom="12pt" line-height="115%">
			<xsl:if test="ancestor::rsd:ul or ancestor::rsd:ol and not(ancestor::rsd:note[1]/following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>			
			<fo:inline padding-right="4mm">
				<xsl:apply-templates select="../rsd:name" mode="presentation"/>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
 -->

	
	<xsl:template match="rsd:admonition">
		<fo:block-container border="0.5pt solid rgb(79, 129, 189)" color="rgb(79, 129, 189)" margin-left="16mm" margin-right="16mm" margin-bottom="12pt">
			<fo:block-container margin-left="0mm" margin-right="0mm" padding="2mm" padding-top="3mm">
				<fo:block font-size="11pt" margin-bottom="6pt" font-weight="normal" font-style="italic" text-align="center">					
					<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/>
				</fo:block>
				<fo:block font-style="italic">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
		
		
	</xsl:template>
	


	<xsl:template match="rsd:formula/rsd:stem">
		<fo:block margin-top="6pt" margin-bottom="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="left" margin-left="5mm">
								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="right">
								<xsl:apply-templates select="../rsd:name" mode="presentation"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>			
		</fo:block>
	</xsl:template>
	

	
	<xsl:template match="rsd:pagebreak">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>
		
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="font-weight" select="'normal'"/>
		<fo:static-content flow-name="header-odd">
			<fo:block-container height="100%" display-align="after">
				<fo:block text-align="right">
					<xsl:value-of select="$header"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd">
			<fo:block-container font-size="10pt" height="100%">
				<fo:block text-align-last="justify">
					<xsl:value-of select="$copyright"/>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline padding-right="2mm" font-weight="{$font-weight}"><fo:page-number/></fo:inline>
					</fo:inline>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even">
			<fo:block-container height="100%" display-align="after">
				<fo:block>
					<xsl:value-of select="$header"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even">
			<fo:block-container font-size="10pt" height="100%">
				<fo:block text-align-last="justify">
					<fo:inline font-weight="{$font-weight}"><fo:page-number/></fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline padding-right="2mm"><xsl:value-of select="$copyright"/></fo:inline>
					</fo:inline>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	
	<xsl:variable name="rnp-Logo">
		<xsl:text>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14/vD9m1+hIyJECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIFBNgbyolBsBAgR2LpAWTT0o7DNyTKg1xuTisDEh1PJjyo/999roXz/m4zGMyr0ckFfU2WfnvbXllVznkLbkkTfm4r61Od61uRBkXb7/9/P8mI931deGHY11uW5wdZyyrKctkRqUAAECgysQx1y4Jl/Lw9ghjTAuxa6xKaZxeaW5sblYbGy+Zo7J189n5OKxg/N18uB87KD8g2N+uVi3/s2qc4wbcqzrc8zrH3sMcX0j5q9TWB9DXNVohJVduQhu+5YNKx/+9MS8yqcbAQIECBAgQIAAAQIECBAgQIAAAQIEqiHw3BPPeEetFr9QjWyqlkXauHjBnIOqlpV8CBAgUAYBK8SVYZbESKCNAr9ZDe2RHMJvrz70FHGl66cOCc/s2z907bN/GNa1f66d2D+XKuTHRn4M++dSin3z1q1D84p0Q3PRwpB8bEguYOjftjU/5vtjx/LXMdXy8b78et66Lvbm1/Lzxq+f9x977LX+r8OOPMbm3H5zLnbLj43NoXfI5pDq+TFvbXr8vK2PbSf7FLE6RIAAgQ4XSGtnj12TDfrviwdgEQ8+764DhtX3fUZjWO3AofWwX+pK+Zqer+uhK9/TyNzHY4959blheevWITGmoSnFoTE0hj72dT7WP06uYWvk63p+yP+Xv0H8+jqdGrmyLV/T4/b8bEf+JrA9xcaO/D1ke262PTffnAvfNtfzttW1emPTjpCv99u2bcoFbvn6/1g//V27ESBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECDQ4QIK4jr8DSB9As0WiNPm9xepbfjNvdnd648AAQIE2ieQNlx61MY8fP/djQABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAoUUKNy2V4VUEhQBAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIFF5AQVzhp0iABAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIDAQAQVxA1HShgABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQKL6AgrvBTJEACBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQGIiAgriBKGlDgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAoUXUBBX+CkSIAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgMREBB3ECUtCFAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBwgsoiCv8FAmQAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAYioCBuIEraECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgEDhBRTEFX6KBEiAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECAxFQEDcQJW0IECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAoPACCuIKP0UCJECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIGBCCiIG4iSNgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBQeAEFcYWfIgESIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAwEAEFMQNREkbAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECi8gIK4wk+RAAkQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIEBgIAIK4gaipA0BAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIFF5AQVzhp0iABAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIDAQAQVxA1HShgABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQKL6AgrvBTJEACBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQGIiAgriBKGlDgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAoUXUBBX+CkSIAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgMREBB3ECUtCFAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBwgsoiCv8FAmQAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAYioCBuIEraECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgEDhBRTEFX6KBEiAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECAxFQEDcQJW0IECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAoPACCuIKP0UCJECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIGBCCiIG4iSNgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBQeAEFcYWfIgESIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAwEAEFMQNREkbAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECi8gIK4wk+RAAkQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIEBgIAIK4gaipA0BAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIFF5AQVzhp0iABAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIDAQAQVxA1HShgABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQKL6AgrvBTJEACBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQGIiAgriBKGlDgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAoUXUBBX+CkSIAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgMREBB3ECUtCFAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBwgsoiCv8FAmQAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAYioCBuIEraECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgEDhBRTEFX6KBEiAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECAxFQEDcQJW0IECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAoPACCuIKP0UCJECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIGBCCiIG4iSNgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBQeAEFcYWfIgESIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAwEAEFMQNREkbAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECi8gIK4wk+RAAkQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIEBgIAIK4gaipA0BAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIFF5AQVzhp0iABAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIDAQAQVxA1HShgABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQKL6AgrvBTJEACBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQGIiAgriBKGlDgAABAgQIECBA4P9v146RKgSCIICyVd7/rN4Awc8uUCYdWR08ExF6YXyTNgECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBOoFFOLqV2RAAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEEgEFOISJRkCBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQqBdQiKtfkQEJECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAIBFQiEuUZAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECgXkAhrn5FBiRAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBREAhLlGSIUCAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIF6AYW4+hUZkAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQSAYW4REmGAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBOoFFOLqV2RAAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEEgEFOISJRkCBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQqBdQiKtfkQEJECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAIBFQiEuUZAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECgXkAhrn5FBiRAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBREAhLlGSIUCAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIF6AYW4+hUZkAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQSAYW4REmGAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBOoFFOLqV2RAAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEEgEFOISJRkCBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQqBdQiKtfkQEJECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAIBFQiEuUZAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECgXkAhrn5FBiRAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBREAhLlGSIUCAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIF6AYW4+hUZkAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQSAYW4REmGAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBOoFFOLqV2RAAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEEgEFOISJRkCBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQqBdQiKtfkQEJECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAIBFQiEuUZAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECgXkAhrn5FBiRAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBREAhLlGSIUCAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIF6AYW4+hUZkAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQSAYW4REmGAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBOoFFOLqV2RAAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEEgEFOISJRkCBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQqBdQiKtfkQEJECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAIBFQiEuUZAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECgXkAhrn5FBiRAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBREAhLlGSIUCAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIF6AYW4+hUZkAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQSga8kJEOAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAj0CuzHzz3dWNdjbNf18/m8t237vrLrzDbu7Dj+uN47f5+H1vVx8bkeK3fE7+djPr+/cx5Y5x/fWvce3zxfNe/P39v++tZ818qdE6/sds1/fP5x7+/z95lH9vLbb4fX/3e86fe9r5k/Z77vfbgiQIAAgf8U+AGe79qHe6AHtwAAAABJRU5ErkJggg==</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Ribose-Logo">
		<xsl:text>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TqySQ2y9BSYm8i5v77xpqmyVrYWZD+fn2qfLxosbHoH8/42rw8LsV4enYpUSIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECdRLo2UBcmD/uGyHFt9epWbV0XyCm8O7mutkvlc689danphBfWzpe4HAIxHhc4+ee8ntVii2aaUNn97AqOcTWWyBf33tbu/ddVO8qVUeAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAjUWaB3A3G562Lffa/Nu/38sM4AaisvkG+V+mBzd7qgfIYQJsMTXhdjeGqVHGKHRGAiviZ8ZttPla725Olb8i5x7yodL7D2AjGmi8KpJ9xd+0IVSIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECNRWoKcDcWHpBffFFC+sbfcKqypwcTh1+q7SSTZvOzGGcHrpeIFDJRBDfPJUY/KSKkW39i2/Ou8idl+VHGJrK/C15t7b31Hb6hRGgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIDIVAbwfiMkFz1xevCSHdMhQaily5QErbi117rlp5wIFnNiYmr4wxNg58xJFRFUgx/o/w2Z3PL93f0nE/jKHtFrulAesbmFppY1haKupbocoIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBYRDo+UBcWL++lYrWhmHAUOPKBdrtcFZYf+LyyiMefebkltv+Qx6GO/XRR3016gJ5R8CJxmSoNEjZ/Mq9bw8pfGPUrcapv3xr7Y8Wi9OfHKee9UqAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAj0RqD3A3G57mLd3KfzwMOHe9OCrP0WyNfyk63F6Y+WXvfaW4+YiOHy0vECh1ogD0KeMrll56+XbuL0k5rtduvM0vECayWQv58sF6l9Vq2KUgwBAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECAwtAJ9GYjr6BR7952dUtg7tFIKf0QgpVQUrdYZVTgazz56Y4hhpkoOscMtMDER3xyuv+2osl20Fmf/JoXw8bLx4mokkPKOgfOz22tUkVIIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBIRbo20BcWDrh2yEmu4IN8ZOlU3oeanxHWJy7tXQbn9r5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CBAgQIAAAQIECBA4pICBuEPyeHB/gWLfvnNSCnv3P+ZzAgMVaKcrw/zs9oHWYHECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIHaCBiIq82lGIJClk74dojpLUNQqRLHQCDvDndXkZqXjEGrWiRAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEFihgIG4FUI57UcCxQMPXpZ3ifsODwKDFkjt9MqwePyDg67D+gQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAvURMBBXn2sxHJW8+PkPp5TOH45iVTnCAl9qffJ97xnh/rRGgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBQQsBAXAm0cQ9pLUx/IIXwuXF30P/gBFJobQibNrUHV4GVCRAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIE6ihgIK6OV6X+NaWY0oY8FJf/80agzwIp/GmxdnZLn1e1HAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAwBAIGIgbgotUxxKb89NfyENx761jbWoaXYE8gbm72WydN7od6owAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQKCKgIG4KnpjHtss9r4ypfTQmDNov58CKbwxnDJ7Rz+XtBYBAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgMDwCBiIG55rVb9KT37enfmuqW+oX2EqGk2BdEcR7nzzaPamKwIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAgW4IGIjrhuIY5yjua1+R279tjAm03ieBdiueE+bn9/RpOcsQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgMoYCBuCG8aLUq+bS5fe3UOqtWNSlm5ARSSJtbi2v+bOQa0xABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgEBXBQzEdZVzPJO15mf/MoVw/Xh2r+teC+TnVrsIrQ29Xkd+AgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACB4RcwEDf817AWHRTNtDGl0KpFMYoYKYGY0p+EtXN/P1JNaYYAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQKAnAgbiesI6hklPnr4lxfBHY9i5lnsokG+V+kBzd3hVD5eQmgABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAYIQEDMSN0MUcdCutvcuvybvE3TfoOqw/QgIpXBxOnb5rhDrSCgECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAQA8FDMT1EHfsUi8d98MYwqax61vDvRFIaXuxa8/bepNcVgIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAgVEUMBA3ild1gD0193377SGFbwywBEuPiEA7hjPD+hOXR6QdbRAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECPRBwEBcH5DHaomlpSKF1hlj1bNmuy6QUrqutXb6Y11PLCEBAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgMBICxiIG+nLO5jmivnZv80DTX89mNWtOuwC+blTFIWhymG/juonQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECAxCwEDcINTHYM2ilc5KITXHoFUtdlsghj8MJ899rdtp5SNAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEBh9AQNxo3+NB9Phuplv5YXfNpjFrTqsAimEu4vioU3DWr+6CRAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIEBitgIG6w/iO9evFQujjf/vL7I92k5roqENvt14R1//LeriaVjAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAYGwEDMSNzaUeQKO/PHN/iuFVA1jZksMokNJXm9/50juHsXQ1EyBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQI1EPAQFw9rsPIVtH6xHv/OKRw88g2qLGuCaSQNob161tdSygRAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIDA2AkYiBu7S97nhjdtaufbpm7s86qWGzKBlMJfFfMzfzdkZSuXAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECgZgIG4mp2QUaxnGJh+jMhpWtHsTc9VRfIA5P7ilbzrOqZZCBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEBh3AQNx4/4M6FP/zRTOzbuA7enTcpYZKoH41rDuuTuHqmTFEiBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQI1FLAQFwtL8sIFrUwfXsI6S0j2JmWKgikEL5XtPe9oUIKoQQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgT+ScBA3D9R+KTXAsXd91yWQtrV63XkHx6B1G69Miwe/+DwVKxSAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBOgsYiKvz1Rm12l5y0u6U0nmj1pZ+ygnk58JNrYXZ95SLFkWAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIEDgQAEDcQeaONJDgdb8zAdTCjf2cAmph0UgtV6RS813TfVGgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAoDsCBuK64yjLKgRiam/IU1AGoVZhNnKnttMHioU5g5Ejd2E1RIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAYrICBuMH6j+XqzYWZL8YQ3CpzLK/+I5OQu5vLrfPHtH1tEyBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQI9FCg0cPcUhN4XIHm3t2vbBz5hF+PMR7zuCd5YDQFUrosLM3tGs3mdEWAAAECBAgQIECAAAECBAgQIECAAAECBAgQGD2Boii+1Wg0ruhHZ521+rGONQgQIECAAIHRFcgbdXkjMBiBxpbbzosT4bLBrG7VgQikdHszfO+EMD+/ZyDrW5QAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQGCkBdwydaQvb72bK+4vrgwp7Kx3larrpkA7hHMMw3VTVC4CBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIH9BQzE7a/h8/4KnDa3rx1aZ/V3UasNSiCl9JnW/PSfD2p96xIgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECIy+gIG40b/Gte6wNT/7V3lQ6u9qXaTiKgukENpFaG2snEgCAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAocQMBB3CBwP9UegSO2NKYVWf1azyiAEYkj/J8zP3TyIta1JgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECAwPgIG4sbnWte304XZr6aY3lnfAlVWRSCFdH+z3b6wSg6xBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBFYiYCBuJUrO6blA6+F9r8m7xN3b84Us0H+Bdrg4LMx+v/8LW5EAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQGDcBAzEjdsVr2u/p55wd4zporqWp66yAulbxVfveVvZaHEECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIEViNgIG41Ws7tqUBz7+3vyAt8raeLSN5XgXY7nRlOP6nZ10UtRoAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgMLYCcWw713gtBRpbdr4oTsRP1LI4Ra1KIKX0iWJ++t+tKsjJBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBCoI2CGuAp7Q7gsUC9PX5UGqj3U/s4z9FMjXsChicUY/17QWAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQNxngO1Eyia6awU0nLtClPQKgTS28Pa5359FQFOJUCAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIFBZwEBcZUIJui5wysy2kMJVXc8rYV8E8jDjD4t9D2zqy2IWIUCAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQILCfgIG4/TB8Wh+B4r7WJXmw6q76VKSSlQrEkF4dll5w30rPdx4BAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBbgkYiOuWpDzdFTht7oGUwqu6m1S2nguk9JXmHV96V8/XsQABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBgwhMHuSYQwRqIZCe/ZQvT878q5eEGJ5Zi4IUcViB1G6/tP0r63Ye9kQnECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIEOiBQOxBTikJdE2gsXnHYpyc+GzXEkrUM4EUwv8t1q75tZ4tIDEBAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBwwi4ZephgDw8WIFicWZzCOnPBluF1Q8nkFLaVyzvO/tw53mcAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAQC8FDMT1Ulfurgg0W+nclMKeriSTpEcC8YpwyvG39Si5tAQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgRWJGAgbkVMThqowOLMP4bUftNAa7D44wrkYcU7i3273/C4J3iAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAQJ8EDMT1Cdoy1QSKe+7NA3HpjmpZRPdCIIV0flg68aFe5JaTAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAwGoE4mpOdi6BQQpMbt3x0ok48cFB1mDtRwuklL5QzE//Yj6aHv2IrwgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAj0X8AOcf03t2JJgdb8zJ/mAawtJcOFdVkgT8Cl2G5tyGkNw3XZVjoCBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAIFyAgbiyrmJGpBAbLU3dAaxBrS8ZfcTiCF9oLk497n9DvmUAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAwEAFDMQNlN/iqxVorpv9UkzhT1Yb5/zuCuSJxIebqXl+d7PKRoAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQKCagIG4an6iByDQ3J0uyLdOfXAAS1vyxwLtdGmYP+47P/7SRwIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQJ1EDAQV4eroIbVCZw6fVeI8ZLVBTm7iwLfLpbj5V3MJxUBAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgACBrggYiOsKoyT9Fiju2H1lSGl7v9e1XgjtdjonLK3Zy4IAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIBA3QRi3QpSD4GVCkxu3vmrE5PxIys933nVBfKtam8o5qd/qXomGQgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAh0X8AOcd03lbFPAq3F6Y/mAa1P9Wm5sV8m5c3hilbYMPYQAAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBGorYCCutpdGYSsRKNqtjXkorljJuc6pJhBTuiasm/5ytSyiCRAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECPROwEBc72xl7ofA4tyteeeyq/ux1DivkUK6v1m0LhxnA70TIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAjUX8BAXP2vkQoPI9AKey5KKdxzmNM8XEEghvTacPLcDyqkEEqAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECg5wIG4npObIGeC8yfeE8e2Lqo5+uM6wIpfbN5y71/MK7t65sAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQGB4BAzEDc+1UukhBJq7bnpHSOHWQ5zioZIC7XY6M5x+UrNkuDACBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECfROIfVvJQgR6LNC4ccepMUx8ssfLjFX6FMLfFGvXnDZWTWuWAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIEBgaAUMxA3tpVP4wQQmt+x4eX5SP+Vgjzm2eoGiaP5lOOX421YfKYIAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIBA/wX+P2LQwcW0LU8pAAAAAElFTkSuQmCC</xsl:text>
	</xsl:variable>
	
	<!-- convert YYYY-MM-DD to (Month Day, YYYY) -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'">January</xsl:when>
				<xsl:when test="$month = '02'">February</xsl:when>
				<xsl:when test="$month = '03'">March</xsl:when>
				<xsl:when test="$month = '04'">April</xsl:when>
				<xsl:when test="$month = '05'">May</xsl:when>
				<xsl:when test="$month = '06'">June</xsl:when>
				<xsl:when test="$month = '07'">July</xsl:when>
				<xsl:when test="$month = '08'">August</xsl:when>
				<xsl:when test="$month = '09'">September</xsl:when>
				<xsl:when test="$month = '10'">October</xsl:when>
				<xsl:when test="$month = '11'">November</xsl:when>
				<xsl:when test="$month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result" select="normalize-space(concat($monthStr, ' ', $day, ', ', $year))"/>
		<xsl:value-of select="$result"/>
	</xsl:template>

	
<xsl:variable name="titles" select="xalan:nodeset($titles_)"/><xsl:variable name="titles_">
				
		<title-annex lang="en">Annex </title-annex>
		<title-annex lang="fr">Annexe </title-annex>
		
			<title-annex lang="zh">Annex </title-annex>
		
		
				
		<title-edition lang="en">
			
			
				<xsl:text>Version</xsl:text>
			
		</title-edition>
		
		<title-edition lang="fr">
			
				<xsl:text>Édition </xsl:text>
			
		</title-edition>
		

		<title-toc lang="en">
			
				<xsl:text>Contents</xsl:text>
			
			
			
		</title-toc>
		<title-toc lang="fr">
			
				<xsl:text>Sommaire</xsl:text>
			
			
			</title-toc>
		
			<title-toc lang="zh">Contents</title-toc>
		
		
		
		<title-page lang="en">Page</title-page>
		<title-page lang="fr">Page</title-page>
		
		<title-key lang="en">Key</title-key>
		<title-key lang="fr">Légende</title-key>
			
		<title-where lang="en">where</title-where>
		<title-where lang="fr">où</title-where>
					
		<title-descriptors lang="en">Descriptors</title-descriptors>
		
		<title-part lang="en">
			
			
			
		</title-part>
		<title-part lang="fr">
			
			
			
		</title-part>		
		<title-part lang="zh">第 # 部分:</title-part>
		
		<title-subpart lang="en">			
			
		</title-subpart>
		<title-subpart lang="fr">		
			
		</title-subpart>
		
		<title-modified lang="en">modified</title-modified>
		<title-modified lang="fr">modifiée</title-modified>
		
			<title-modified lang="zh">modified</title-modified>
		
		
		
		<title-source lang="en">
			
				<xsl:text>SOURCE</xsl:text>
						
			 
		</title-source>
		
		<title-keywords lang="en">Keywords</title-keywords>
		
		<title-deprecated lang="en">DEPRECATED</title-deprecated>
		<title-deprecated lang="fr">DEPRECATED</title-deprecated>
				
		<title-list-tables lang="en">List of Tables</title-list-tables>
		
		<title-list-figures lang="en">List of Figures</title-list-figures>
		
		<title-list-recommendations lang="en">List of Recommendations</title-list-recommendations>
		
		<title-acknowledgements lang="en">Acknowledgements</title-acknowledgements>
		
		<title-abstract lang="en">Abstract</title-abstract>
		
		<title-summary lang="en">Summary</title-summary>
		
		<title-in lang="en">in </title-in>
		
		<title-partly-supercedes lang="en">Partly Supercedes </title-partly-supercedes>
		<title-partly-supercedes lang="zh">部分代替 </title-partly-supercedes>
		
		<title-completion-date lang="en">Completion date for this manuscript</title-completion-date>
		<title-completion-date lang="zh">本稿完成日期</title-completion-date>
		
		<title-issuance-date lang="en">Issuance Date: #</title-issuance-date>
		<title-issuance-date lang="zh"># 发布</title-issuance-date>
		
		<title-implementation-date lang="en">Implementation Date: #</title-implementation-date>
		<title-implementation-date lang="zh"># 实施</title-implementation-date>

		<title-obligation-normative lang="en">normative</title-obligation-normative>
		<title-obligation-normative lang="zh">规范性附录</title-obligation-normative>
		
		<title-caution lang="en">CAUTION</title-caution>
		<title-caution lang="zh">注意</title-caution>
			
		<title-warning lang="en">WARNING</title-warning>
		<title-warning lang="zh">警告</title-warning>
		
		<title-amendment lang="en">AMENDMENT</title-amendment>
		
		<title-continued lang="en">(continued)</title-continued>
		<title-continued lang="fr">(continué)</title-continued>
		
	</xsl:variable><xsl:variable name="tab_zh">　</xsl:variable><xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable><xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable><xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/><xsl:variable name="linebreak" select="'&#8232;'"/><xsl:attribute-set name="root-style">
		
	</xsl:attribute-set><xsl:attribute-set name="link-style">
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		
		
			<xsl:attribute name="font-family">Source Code Pro</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		
		
		
		
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="permission-style">
		
	</xsl:attribute-set><xsl:attribute-set name="permission-name-style">
		
	</xsl:attribute-set><xsl:attribute-set name="permission-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-name-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-subject-style">
	</xsl:attribute-set><xsl:attribute-set name="requirement-inherit-style">
	</xsl:attribute-set><xsl:attribute-set name="recommendation-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-name-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-style">
		
		
		
		
		
		
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-style">
		
		
		
		
		
		
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-body-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-name-style">
		
		
		
		
		
		
		
		
		
		
		
		
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>			 
		
		
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-p-style">
		
		
		
		
		
		
		
		
					
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-name-style">
		
			<xsl:attribute name="padding-right">10mm</xsl:attribute>
		
		
		
				
	</xsl:attribute-set><xsl:attribute-set name="table-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		
		
		
		
				
		
		
		
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-style">
		
		
		
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-example-style">
		
		
		
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="xref-style">
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="eref-style">
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-style">
		
		
		
				
		
		
		
		
		
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
			<xsl:attribute name="line-height">115%</xsl:attribute>
		
		
		
		
	</xsl:attribute-set><xsl:variable name="note-body-indent">10mm</xsl:variable><xsl:variable name="note-body-indent-table">5mm</xsl:variable><xsl:attribute-set name="note-name-style">
		
		
		
		
		
		
		
		
		
		
			<xsl:attribute name="padding-right">4mm</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-p-style">
		
		
		
				
		
		
		
		
		
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-style">
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-name-style">		
				
		
	</xsl:attribute-set><xsl:attribute-set name="quote-style">		
		
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">13mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="quote-source-style">		
		
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
		
				
				
	</xsl:attribute-set><xsl:attribute-set name="termsource-style">
		
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="origin-style">
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="term-style">
		
	</xsl:attribute-set><xsl:attribute-set name="figure-name-style">
		
				
		
		
		
		
		
		
		
		
		
		
		
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
		
		
		
		
			
	</xsl:attribute-set><xsl:attribute-set name="formula-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="figure-pseudocode-p-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-graphic-style">
		
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
		
		
		
				

	</xsl:attribute-set><xsl:attribute-set name="tt-style">
		
			<xsl:attribute name="font-family">Source Code Pro</xsl:attribute>			
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="domain-style">
				
	</xsl:attribute-set><xsl:attribute-set name="admitted-style">
		
	
	</xsl:attribute-set><xsl:attribute-set name="deprecates-style">
		
	</xsl:attribute-set><xsl:attribute-set name="definition-style">
		
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="contents"/>
	</xsl:template><xsl:template name="processMainSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" mode="contents"/>			
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']" mode="contents"/>	
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]" mode="contents"/>		
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']" mode="contents"/>		
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]" mode="contents"/>
	</xsl:template><xsl:template name="processPrefaceSectionsDefault">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']"/>
	</xsl:template><xsl:template name="processMainSectionsDefault">			
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']"/>
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']"/>
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]"/>
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']"/>
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]"/>
	</xsl:template><xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template><xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
		<!-- <xsl:call-template name="add-zero-spaces"/> -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template><xsl:template match="*[local-name()='table']" name="table">
	
		<xsl:variable name="table">
	
			<xsl:variable name="simple-table">	
				<xsl:call-template name="getSimpleTable"/>			
			</xsl:variable>
		
			
			
			
			
			<!-- <xsl:if test="$namespace = 'bipm'">
				<fo:block>&#xA0;</fo:block>				
			</xsl:if> -->
			
			<!-- $namespace = 'iso' or  -->
			
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
					
			
				
			
			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
			
			<!-- <xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="*[local-name()='thead']">
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='thead']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='tbody']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable> -->
			<!-- cols-count=<xsl:copy-of select="$cols-count"/> -->
			<!-- cols-count2=<xsl:copy-of select="$cols-count2"/> -->
			
			
			
			<xsl:variable name="colwidths">
				<xsl:if test="not(*[local-name()='colgroup']/*[local-name()='col'])">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
			
			<!-- <xsl:variable name="colwidths2">
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:call-template>
			</xsl:variable> -->
			
			<!-- cols-count=<xsl:copy-of select="$cols-count"/>
			colwidthsNew=<xsl:copy-of select="$colwidths"/>
			colwidthsOld=<xsl:copy-of select="$colwidths2"/>z -->
			
			<xsl:variable name="margin-left">
				<xsl:choose>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">			
				
				
							
							
							
				
				
										
				
				
				
				
				
				
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->
					100%
							
					
				</xsl:variable>
				
				<xsl:variable name="table_attributes">
					<attribute name="table-layout">fixed</attribute>
					<attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></attribute>
					<attribute name="margin-left"><xsl:value-of select="$margin-left"/>mm</attribute>
					<attribute name="margin-right"><xsl:value-of select="$margin-left"/>mm</attribute>
					
					
					
					
									
									
									
					
									
					
				</xsl:variable>
				
				
				<fo:table id="{@id}" table-omit-footer-at-break="true">
					
					<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">					
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'] or .//*[local-name()='fn'][local-name(..) != 'name']"/>				
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> <!-- set 0pt border, because there is a separete table below for footer  -->
					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="*[local-name()='colgroup']/*[local-name()='col']">
							<xsl:for-each select="*[local-name()='colgroup']/*[local-name()='col']">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="xalan:nodeset($colwidths)//column">
								<xsl:choose>
									<xsl:when test=". = 1 or . = 0">
										<fo:table-column column-width="proportional-column-width(2)"/>
									</xsl:when>
									<xsl:otherwise>
										<fo:table-column column-width="proportional-column-width({.})"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
							<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:table>
				
				<xsl:variable name="colgroup" select="*[local-name()='colgroup']"/>				
				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>				
						<xsl:with-param name="colgroup" select="$colgroup"/>				
					</xsl:call-template>
				</xsl:for-each>
				
				<!-- insert footer as table -->
				<!-- <fo:table>
					<xsl:for-each select="xalan::nodeset($table_attributes)/attribute">
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:for-each select="xalan:nodeset($colwidths)//column">
						<xsl:choose>
							<xsl:when test=". = 1 or . = 0">
								<fo:table-column column-width="proportional-column-width(2)"/>
							</xsl:when>
							<xsl:otherwise>
								<fo:table-column column-width="proportional-column-width({.})"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</fo:table>-->
				
				
				
				
				
			</fo:block-container>
		</xsl:variable>
		
		
		
		<xsl:choose>
			<xsl:when test="@width">
	
				<!-- centered table when table name is centered (see table-name-style) -->
				
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{@width}"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<fo:block><xsl:copy-of select="$table"/></fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				
				
				
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$table"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name() = 'name']"/><xsl:template match="*[local-name()='table']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="table-name-style">
				
				
				<xsl:apply-templates/>				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template><xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
							
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($table)//tr">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
								
								<!-- <xsl:if test="$namespace = 'bipm'">
									<xsl:for-each select="*[local-name()='td'][$curr-col]//*[local-name()='math']">									
										<word><xsl:value-of select="normalize-space(.)"/></word>
									</xsl:for-each>
								</xsl:if> -->
								
							</xsl:variable>
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​', ' '))"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="td[$curr-col]/@divide">
											<xsl:value-of select="td[$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>
							
						</xsl:for-each>
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="text()" mode="td_text">
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:value-of select="translate(., $zero-space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template><xsl:template match="*[local-name()='link']" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template><xsl:template match="*[local-name()='math']" mode="td_text">
		<xsl:variable name="math_text" select="normalize-space(.)"/>
		<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
	</xsl:template><xsl:template match="*[local-name()='table2']"/><xsl:template match="*[local-name()='thead']"/><xsl:template match="*[local-name()='thead']" mode="process">
		<xsl:param name="cols-count"/>
		<!-- font-weight="bold" -->
		<fo:table-header>
			
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template><xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>		
		<!-- row for title -->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black">
				<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']" mode="presentation"/>
				<xsl:for-each select="ancestor::*[local-name()='table'][1]">
					<xsl:call-template name="fn_name_display"/>
				</xsl:for-each>				
				<fo:block text-align="right" font-style="italic">
					<xsl:text> </xsl:text>
					<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="process_tbody">		
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tfoot']"/><xsl:template match="*[local-name()='tfoot']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooter2">
		<xsl:param name="cols-count"/>
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		<xsl:if test="../*[local-name()='tfoot'] or           $isNoteOrFnExist = 'true'">
		
			<fo:table-footer>
			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
				
				<!-- if there are note(s) or fn(s) then create footer row -->
				<xsl:if test="$isNoteOrFnExist = 'true'">
				
					
				
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
							
							
							
							<!-- except gb -->
							
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							
							
							<!-- show Note under table in preface (ex. abstract) sections -->
							<!-- empty, because notes show at page side in main sections -->
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">										
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>										
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
						</fo:table-cell>
					</fo:table-row>
					
				</xsl:if>
			</fo:table-footer>
		
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>
		
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		
		<xsl:if test="$isNoteOrFnExist = 'true'">
		
			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//*[local-name()='col'])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<fo:table keep-with-previous="always">
				<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">
					<xsl:choose>
						<xsl:when test="@name = 'border-top'">
							<xsl:attribute name="{@name}">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:when test="@name = 'border'">
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:for-each select="xalan:nodeset($colgroup)//*[local-name()='col']">
							<fo:table-column column-width="{@width}"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
							
							
							
							
							<!-- except gb  -->
							
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							
							
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">
										show Note under table in preface (ex. abstract) sections
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>
										empty, because notes show at page side in main sections
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
				
			</fo:table>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='tbody']">
		
		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:apply-templates select="../*[local-name()='thead']" mode="process">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>
		
		<fo:table-body>
			

			<xsl:apply-templates/>
			<!-- <xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/> -->
		
		</fo:table-body>
		
	</xsl:template><xsl:template match="*[local-name()='tr']">
		<xsl:variable name="parent-name" select="local-name(..)"/>
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:table-row min-height="4mm">
				<xsl:if test="$parent-name = 'thead'">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					
					
					
					
					
				</xsl:if>
				<xsl:if test="$parent-name = 'tfoot'">
					
					
				</xsl:if>
				
				
				
				
				<!-- <xsl:if test="$namespace = 'bipm'">
					<xsl:attribute name="height">8mm</xsl:attribute>
				</xsl:if> -->
				
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" font-weight="bold" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>center</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			
			
			
			
			
			
			
			
			
			
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>					
			</xsl:attribute>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='td']">
		<fo:table-cell text-align="{@align}" display-align="center" border="solid black 1pt" padding-left="1mm">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			
			
			
			
			
			
			
			
			
			
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			<fo:block>
								
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']" priority="2"/><xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				
				
				
				
				
				
				<fo:inline padding-right="2mm">
					
					
					
					
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						
				</fo:inline>
				
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='name']" mode="process"/><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="fn_display">
		<xsl:variable name="references">
			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					
					
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
					
					
					
					
					
					<fo:inline font-size="80%" padding-right="5mm" id="{@id}">
						
						
						
						
						
						
						
						<xsl:value-of select="@reference"/>
						
						
					</fo:inline>
					<fo:inline>
						
						<!-- <xsl:apply-templates /> -->
						<xsl:copy-of select="./node()"/>
					</fo:inline>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_name_display">
		<!-- <xsl:variable name="references">
			<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		$references=<xsl:copy-of select="$references"/> -->
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_display_figure">
		<xsl:variable name="key_iso">
			 <!-- and (not(@class) or @class !='pseudocode') -->
		</xsl:variable>
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- current hierarchy is 'figure' element -->
		<xsl:variable name="following_dl_colwidths">
			<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
				<xsl:variable name="html-table">
					<xsl:variable name="doc_ns">
						
					</xsl:variable>
					<xsl:variable name="ns">
						<xsl:choose>
							<xsl:when test="normalize-space($doc_ns)  != ''">
								<xsl:value-of select="normalize-space($doc_ns)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-before(name(/*), '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
					<xsl:element name="{$ns}:table">
						<xsl:for-each select="*[local-name() = 'dl'][1]">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:for-each>
					</xsl:element>
				</xsl:variable>
				
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="2"/>
					<xsl:with-param name="table" select="$html-table"/>
				</xsl:call-template>
				
			</xsl:if>
		</xsl:variable>
		
		
		<xsl:variable name="maxlength_dt">
			<xsl:for-each select="*[local-name() = 'dl'][1]">
				<xsl:call-template name="getMaxLength_dt"/>			
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:if test="xalan:nodeset($references)//fn">
			<fo:block>
				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>								
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>								
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="85%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<xsl:for-each select="xalan:nodeset($references)//fn">
							<xsl:variable name="reference" select="@reference"/>
							<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@id}">
												
												<xsl:value-of select="@reference"/>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block text-align="justify" margin-bottom="12pt">
											
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											
											<!-- <xsl:apply-templates /> -->
											<xsl:copy-of select="./node()"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
		
	</xsl:template><xsl:template match="*[local-name()='fn']">
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:inline font-size="80%" keep-with-previous.within-line="always">
			
			
			
			
			
			
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				
				
				<xsl:value-of select="@reference"/>
				
			</fo:basic-link>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='dl']">
		<fo:block-container>
			
				<xsl:if test="not(ancestor::*[local-name() = 'quote'])">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			
			
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container>
				
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				
				
				<xsl:variable name="parent" select="local-name(..)"/>
				
				<xsl:variable name="key_iso">
					 <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$parent = 'formula' and count(*[local-name()='dt']) = 1"> <!-- only one component -->
						
						
							<fo:block margin-bottom="12pt" text-align="left">
								
								<xsl:variable name="title-where">
									
									
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-where'"/>
										</xsl:call-template>
									
								</xsl:variable>
								<xsl:value-of select="$title-where"/><xsl:text> </xsl:text>
								<xsl:apply-templates select="*[local-name()='dt']/*"/>
								<xsl:text/>
								<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
							</fo:block>
						
					</xsl:when>
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">
							
							
							
							
							<xsl:variable name="title-where">
								
								
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-where'"/>
									</xsl:call-template>
																
							</xsl:variable>
							<xsl:value-of select="$title-where"/>
						</fo:block>
					</xsl:when>
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
							
							
							
							<xsl:variable name="title-key">
								
								
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-key'"/>
									</xsl:call-template>
								
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>
				</xsl:choose>
				
				<!-- a few components -->
				<xsl:if test="not($parent = 'formula' and count(*[local-name()='dt']) = 1)">
					<fo:block>
						
						
						
						
						<fo:block>
							
							
							
							
							<fo:table width="95%" table-layout="fixed">
								
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'">
										<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
									</xsl:when>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
										
									</xsl:when>
								</xsl:choose>
								<!-- create virtual html table for dl/[dt and dd] -->
								<xsl:variable name="html-table">
									<xsl:variable name="doc_ns">
										
									</xsl:variable>
									<xsl:variable name="ns">
										<xsl:choose>
											<xsl:when test="normalize-space($doc_ns)  != ''">
												<xsl:value-of select="normalize-space($doc_ns)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring-before(name(/*), '-')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
									<xsl:element name="{$ns}:table">
										<tbody>
											<xsl:apply-templates mode="dl"/>
										</tbody>
									</xsl:element>
								</xsl:variable>
								<!-- html-table<xsl:copy-of select="$html-table"/> -->
								<xsl:variable name="colwidths">
									<xsl:call-template name="calculate-column-widths">
										<xsl:with-param name="cols-count" select="2"/>
										<xsl:with-param name="table" select="$html-table"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
								<xsl:variable name="maxlength_dt">							
									<xsl:call-template name="getMaxLength_dt"/>							
								</xsl:variable>
								<xsl:call-template name="setColumnWidth_dl">
									<xsl:with-param name="colwidths" select="$colwidths"/>							
									<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
								</xsl:call-template>
								<fo:table-body>
									<xsl:apply-templates>
										<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
									</xsl:apply-templates>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>		
		<xsl:param name="maxlength_dt"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!-- to set width check most wide chars like `W` -->
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="93%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like ABC, etc -->
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 7"> <!-- if dt contains short text like ABCDEF, etc -->
						<fo:table-column column-width="20%"/>
						<fo:table-column column-width="80%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 10"> <!-- if dt contains short text like ABCDEFEF, etc -->
						<fo:table-column column-width="25%"/>
						<fo:table-column column-width="75%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <fo:table-column column-width="15%"/>
				<fo:table-column column-width="85%"/> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getMaxLength_dt">
		<xsl:variable name="lengths">
			<xsl:for-each select="*[local-name()='dt']">
				<xsl:variable name="maintext_length" select="string-length(normalize-space(.))"/>
				<xsl:variable name="attributes">
					<xsl:for-each select=".//@open"><xsl:value-of select="."/></xsl:for-each>
					<xsl:for-each select=".//@close"><xsl:value-of select="."/></xsl:for-each>
				</xsl:variable>
				<length><xsl:value-of select="string-length(normalize-space(.)) + string-length($attributes)"/></length>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<!-- <xsl:for-each select="*[local-name()='dt']">
				<xsl:sort select="string-length(normalize-space(.))" data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="string-length(normalize-space(.))"/>
				</xsl:if>
			</xsl:for-each> -->
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template><xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
		<xsl:param name="key_iso"/>
		
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='dt']" mode="dl">
		<tr>
			<td>
				<xsl:apply-templates/>
			</td>
			<td>
				
				
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				
			</td>
		</tr>
		
	</xsl:template><xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		
		<fo:table-row>
			
			<fo:table-cell>
				
				<fo:block margin-top="6pt">
					
					
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
						
					</xsl:if>
					
					
					
					
					
					
					<xsl:apply-templates/>
					<!-- <xsl:if test="$namespace = 'gb'">
						<xsl:if test="ancestor::*[local-name()='formula']">
							<xsl:text>—</xsl:text>
						</xsl:if>
					</xsl:if> -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					
					<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:if>
					</xsl:if> -->
					
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="local-name(*[1]) = 'stem'">
				<fo:table-row>
				<fo:table-cell>
					<fo:block margin-top="6pt">
						<xsl:if test="normalize-space($key_iso) = 'true'">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>
						<xsl:text>&#xA0;</xsl:text>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell>
					<fo:block>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
			</xsl:if>
		</xsl:if> -->
	</xsl:template><xsl:template match="*[local-name()='dd']" mode="dl"/><xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']"/><xsl:template match="*[local-name()='dd']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']/*[local-name()='p']" mode="inline">
		<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<fo:inline font-weight="bold">
			
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='tt']">
		<fo:inline xsl:use-attribute-sets="tt-style">
			<xsl:variable name="_font-size">
				
				
				
				
				
				
				
				
				
				
				
				
				
				10
						
			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='underline']">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='del']">
		<fo:inline font-size="10pt" color="red" text-decoration="line-through">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='hi']">
		<fo:inline background-color="yellow">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</fo:inline> 
	</xsl:template><xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div 0.75}%">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template><xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
					<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:variable name="len_str">
						<xsl:choose>
							<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
								<xsl:value-of select="$len_str_tmp * 1.5"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$len_str_tmp"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable> 
					
					<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
						<xsl:message>
							div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
							len_str=<xsl:value-of select="$len_str"/>
							len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
						</xsl:message>
					</xsl:if> -->
					<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
					<len_str><xsl:value-of select="$len_str"/></len_str> -->
					<xsl:choose>
						<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
							<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$len_str"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))"/>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| )','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| |,)','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">-</xsl:variable>
		<xsl:variable name="zero-space-after-dot">.</xsl:variable>
		<xsl:variable name="zero-space-after-colon">:</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space-after-underscore">_</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-dot)">
				<xsl:value-of select="substring-before($text, $zero-space-after-dot)"/>
				<xsl:value-of select="$zero-space-after-dot"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-dot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-colon)">
				<xsl:value-of select="substring-before($text, $zero-space-after-colon)"/>
				<xsl:value-of select="$zero-space-after-colon"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-underscore)">
				<xsl:value-of select="substring-before($text, $zero-space-after-underscore)"/>
				<xsl:value-of select="$zero-space-after-underscore"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-underscore)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getSimpleTable">
		<xsl:variable name="simple-table">
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-rowspan)"/>
					
			<!-- <xsl:choose>
				<xsl:when test="current()//*[local-name()='th'][@colspan] or current()//*[local-name()='td'][@colspan] ">
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current()"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template><xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template><xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/><xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="td">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@colspan" mode="simple-table-colspan"/><xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template><xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>
		
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template><xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]"/>
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template><xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>
	
		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//td">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1"/>
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]"/>
												<xsl:copy-of select="node()"/>
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/td[1 + count(current()/preceding-sibling::td[not(@rowspan) or (@rowspan = 1)])]"/>
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*"/>
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)"/>
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow"/>

		<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
				<xsl:with-param name="previousRow" select="$newRow"/>
		</xsl:apply-templates>
	</xsl:template><xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//*[local-name()='bibdata']//*[local-name()='language']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<!-- <xsl:value-of select="translate(substring($substr, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($substr, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="translate(substring($str2, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($str2, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>		
	</xsl:template><xsl:template match="mathml:math">
		<fo:inline font-family="STIX Two Math"> <!--  -->
			
			<xsl:variable name="mathml">
				<xsl:apply-templates select="." mode="mathml"/>
			</xsl:variable>
			<fo:instream-foreign-object fox:alt-text="Math">
				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy-of select="xalan:nodeset($mathml)"/>
			</fo:instream-foreign-object>			
		</fo:inline>
	</xsl:template><xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = ' '])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<mathml:mspace width="0.5ex"/>
	</xsl:template><xsl:template match="*[local-name()='localityStack']"/><xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">
			
			<xsl:choose>
				<xsl:when test="$target = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<fo:basic-link external-destination="{@target}" fox:alt-text="{@target}">
						<xsl:choose>
							<xsl:when test="normalize-space(.) = ''">
								<!-- <xsl:value-of select="$target"/> -->
								<xsl:call-template name="add-zero-spaces-link-java">
									<xsl:with-param name="text" select="$target"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:basic-link>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']" mode="process"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='appendix']/*[local-name()='title']"/><xsl:template match="*[local-name()='appendix']/*[local-name()='title']" mode="process">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'callout']">		
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'annotation']">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>		
		<fo:block id="{$annotation-id}" white-space="nowrap">			
			<fo:inline>				
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>		
	</xsl:template><xsl:template match="*[local-name() = 'annotation']/*[local-name() = 'p']">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>		
	</xsl:template><xsl:template match="*[local-name() = 'modification']">
		<xsl:variable name="title-modified">
			
			
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-modified'"/>
				</xsl:call-template>
			
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:text>—</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:text> — </xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'xref']">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
			
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'formula']" name="formula">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">	
				<fo:block id="{@id}" xsl:use-attribute-sets="formula-style">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'note']" name="note">
	
		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style">
			
			
			
				<xsl:if test="ancestor::rsd:ul or ancestor::rsd:ol and not(ancestor::rsd:note[1]/following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			
			
			<fo:block-container margin-left="0mm">
				
				
				
				
				
				

				
					<fo:block>
						
						
						
						
						
						
						<fo:inline xsl:use-attribute-sets="note-name-style">
							<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						</fo:inline>
						<xsl:apply-templates/>
					</fo:block>
				
				
			</fo:block-container>
		</fo:block-container>
		
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1">
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style">						
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">			
			<fo:inline xsl:use-attribute-sets="termnote-name-style">
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			</fo:inline>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name'] |               *[local-name() = 'termnote']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
						<xsl:text>:</xsl:text>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
						<xsl:text>:</xsl:text>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'terms']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">
			
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline>
				<xsl:apply-templates/>
				<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'ogc'">
					<xsl:text>.</xsl:text>
				</xsl:if> -->
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']" name="figure">
		<fo:block-container id="{@id}">			
			
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="*[local-name() = 'note']">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
		<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'image']">
		<fo:block xsl:use-attribute-sets="image-style">
			
			
			<xsl:variable name="src">
				<xsl:choose>
					<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
						<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" xsl:use-attribute-sets="image-graphic-style"/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="contents">		
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template><xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template match="*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'references'][@hidden='true']" mode="contents" priority="3"/><xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($contents)/doc">
						<xsl:choose>
							<xsl:when test="count(xalan:nodeset($contents)/doc) &gt; 1">
								<xsl:for-each select="xalan:nodeset($contents)/doc">
									<fo:bookmark internal-destination="{contents/item[1]/@id}" starting-state="hide">
										<fo:bookmark-title>
											<xsl:variable name="bookmark-title_">
												<xsl:call-template name="getLangVersion">
													<xsl:with-param name="lang" select="@lang"/>
													<xsl:with-param name="doctype" select="@doctype"/>
													<xsl:with-param name="title" select="@title-part"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="normalize-space($bookmark-title_) != ''">
													<xsl:value-of select="normalize-space($bookmark-title_)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="@lang = 'en'">English</xsl:when>
														<xsl:when test="@lang = 'fr'">Français</xsl:when>
														<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
														<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>
										<xsl:apply-templates select="contents/item" mode="bookmark"/>
										
										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="contents"/>
										</xsl:call-template>
										
										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>
										
									</fo:bookmark>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="xalan:nodeset($contents)/doc">
								
									<xsl:apply-templates select="contents/item" mode="bookmark"/>
									
									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="contents"/>
									</xsl:call-template>
										
									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>
									
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="xalan:nodeset($contents)/contents/item" mode="bookmark"/>				
					</xsl:otherwise>
				</xsl:choose>
				
				
				
				
				
				
				
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template><xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)/figure">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template><xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:if test="xalan:nodeset($contents)/table">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template><xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				
				
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
				
				
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="item" mode="bookmark">
		<fo:bookmark internal-destination="{@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:if test="@section != ''">
						<xsl:value-of select="@section"/> 
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:value-of select="normalize-space(title)"/>
				</fo:bookmark-title>
				<xsl:apply-templates mode="bookmark"/>				
		</fo:bookmark>
	</xsl:template><xsl:template match="title" mode="bookmark"/><xsl:template match="text()" mode="bookmark"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |         *[local-name() = 'image']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">			
			<fo:block xsl:use-attribute-sets="figure-name-style">
				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/><xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template><xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
		<!-- 
		<xsl:for-each select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()">
			<xsl:value-of select="."/>
		</xsl:for-each>
		-->
		
	</xsl:template><xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'title']/*[local-name() = 'tab']">
				<xsl:copy-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="*[local-name() = 'title']/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertTitleAsListItem">
		<xsl:param name="provisional-distance-between-starts" select="'9.5mm'"/>
		<xsl:variable name="section">						
			<xsl:for-each select="..">
				<xsl:call-template name="getSection"/>
			</xsl:for-each>
		</xsl:variable>							
		<fo:list-block provisional-distance-between-starts="{$provisional-distance-between-starts}">						
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<xsl:value-of select="$section"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>						
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template><xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="*[local-name() = 'tab']">
					<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'fn']" mode="contents"/><xsl:template match="*[local-name() = 'fn']" mode="bookmarks"/><xsl:template match="*[local-name() = 'fn']" mode="contents_item"/><xsl:template match="*[local-name() = 'tab']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'strong']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'em']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'stem']" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'br']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']" name="sourcecode">
	
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">
	
				<fo:block xsl:use-attribute-sets="sourcecode-style">
					<xsl:variable name="_font-size">
						
												
						
						
						
						
						
						
								
						
						
						
												
						10
								
				</xsl:variable>
				<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
				<xsl:if test="$font-size != ''">
					<xsl:attribute name="font-size">
						<xsl:choose>
							<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
							<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
					<xsl:apply-templates/>			
				</fo:block>
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']/text()" priority="2">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces-java">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">		
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']">
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='label']" mode="presentation"/>
			<xsl:apply-templates select="@obligation" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='subject']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="requirement-name-style">
				
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/@obligation" mode="presentation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'inherit']">
		<fo:block xsl:use-attribute-sets="requirement-inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt">
			<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">	
						<xsl:call-template name="getSimpleTable"/>			
					</xsl:variable>					
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<!-- <fo:table-column column-width="35mm"/>
						<fo:table-column column-width="115mm"/> -->
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="requirement">		
		<fo:table-header>			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template><xsl:template match="*[local-name()='tbody']" mode="requirement">		
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">			
			<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']) -->
				<!-- <xsl:attribute name="border">1pt solid black</xsl:attribute> -->
				<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
				<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
				<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(165, 165, 165)</xsl:attribute>				
			</xsl:if>
			<xsl:if test="ancestor::*[local-name()='table']/@type = 'recommendtest'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>				
			</xsl:if> -->
			
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>				 
				<xsl:if test="parent::*[local-name()='tr']/preceding-sibling::*[local-name()='tr'] and not(*[local-name()='table'])">
					<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>					
				</xsl:if>
			</xsl:if> -->
			<!-- 2nd line and below -->
			
			<fo:block>			
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt" color="rgb(237, 193, 35)"> <!-- font-weight="bold" margin-bottom="4pt" text-align="center"  -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block> <!-- margin-bottom="10pt" -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates/>
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'example']">
		<fo:block id="{@id}" xsl:use-attribute-sets="example-style">
			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
			<xsl:variable name="element">
				block				
				
				<xsl:if test=".//*[local-name() = 'table']">block</xsl:if> 
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="contains(normalize-space($element), 'block')">
					<fo:block xsl:use-attribute-sets="example-body-style">
						<xsl:apply-templates/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:inline>
						<xsl:apply-templates/>
					</fo:inline>
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']" mode="presentation">

		<xsl:variable name="element">
			block
			
		</xsl:variable>		
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="normalize-space($element) = 'block'">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			block
			
			
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="normalize-space($element) = 'block'">
				<fo:block xsl:use-attribute-sets="example-p-style">
					
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>					
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template><xsl:template match="*[local-name() = 'termsource']">
		<fo:block xsl:use-attribute-sets="termsource-style">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->			
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>					
					
						<xsl:text>[</xsl:text>
					
					<xsl:apply-templates/>					
					
						<xsl:text>]</xsl:text>
					
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'origin']">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			
				<fo:inline>
					
					
					
					
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-source'"/>
						</xsl:call-template>
					
					
					<xsl:text>: </xsl:text>
				</fo:inline>
			
			<fo:inline xsl:use-attribute-sets="origin-style">
				<xsl:apply-templates/>
			</fo:inline>
			</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'quote']">		
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:if test="not(ancestor::*[local-name() = 'table'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			
			<fo:block-container margin-left="0mm">
		
				<fo:block xsl:use-attribute-sets="quote-style">
					<!-- <xsl:apply-templates select=".//*[local-name() = 'p']"/> -->
					
					<xsl:apply-templates select="./node()[not(local-name() = 'author') and not(local-name() = 'source')]"/> <!-- process all nested nodes, except author and source -->
				</fo:block>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>				
					</fo:block>
				</xsl:if>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'eref']">
	
		<xsl:variable name="bibitemid">
			<xsl:choose>
				<xsl:when test="//*[local-name() = 'bibitem'][@hidden='true' and @id = current()/@bibitemid]"/>
				<xsl:when test="//*[local-name() = 'references'][@hidden='true']/*[local-name() = 'bibitem'][@id = current()/@bibitemid]"/>
				<xsl:otherwise><xsl:value-of select="@bibitemid"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:choose>
			<xsl:when test="normalize-space($bibitemid) != ''">
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						
							<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
							<xsl:attribute name="font-size">80%</xsl:attribute>
							<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
							<xsl:attribute name="vertical-align">super</xsl:attribute>
											
						
					</xsl:if>	
											
					<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
						<xsl:if test="normalize-space(@citeas) = ''">
							<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
						</xsl:if>
						<xsl:if test="@type = 'inline'">
							
							
							
						</xsl:if>

						<xsl:apply-templates/>
					</fo:basic-link>
							
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'tab']">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="padding">
			
			
			
			
			
			
			
			
			
			
			
			
			
			3.5
			
			
			
			
		</xsl:variable>
		
		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		
		<xsl:choose>
			<xsl:when test="$language = 'zh'">
				<fo:inline><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline padding-right="{$padding-right}mm">​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'domain']">
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'deprecates']">
		<xsl:variable name="title-deprecated">
			
			
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-deprecated'"/>
				</xsl:call-template>
			
		</xsl:variable>
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:value-of select="$title-deprecated"/>: <xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p']">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block> </fo:block>
	</xsl:template><xsl:template match="/*/*[local-name() = 'sections']/*" priority="2">
		
		<fo:block>
			<xsl:call-template name="setId"/>
			
			
			
			
			
						
			
				<xsl:variable name="pos"><xsl:number count="rsd:sections/rsd:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | rsd:sections/rsd:terms -->
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			
						
			
			
			
			<xsl:apply-templates/>
		</fo:block>
		
		
		
	</xsl:template><xsl:template match="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'clause']">
		<fo:block>
			<xsl:call-template name="setId"/>
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'references'][@hidden='true']" priority="3"/><xsl:template match="*[local-name() = 'bibitem'][@hidden='true']" priority="3"/><xsl:template match="/*/*[local-name() = 'bibliography']/*[local-name() = 'references'][@normative='true']">
		
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'annex']">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'review']">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template><xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'note']">
				<fo:block-container>
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					
					<fo:block-container margin-left="0mm">
						<fo:block>
							<xsl:apply-templates select="." mode="ul_ol"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:apply-templates select="." mode="ul_ol"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="index" select="document($external_index)"/><xsl:variable name="dash" select="'–'"/><xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//*[local-name() = 'bookmark'][ancestor::*[local-name() = 'fn']]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable><xsl:template match="@*|node()" mode="index_add_id">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_add_id"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'xref']" mode="index_add_id">
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId"/>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id"/>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/node()" mode="process_li_element" priority="2">
		<xsl:param name="element"/>
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'xref'">
				<xsl:variable name="id" select="@id"/>
				<xsl:variable name="page" select="$index//item[@id = $id]"/>
				<xsl:variable name="id_next" select="following-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_next" select="$index//item[@id = $id_next]"/>
				
				<xsl:variable name="id_prev" select="preceding-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_prev" select="$index//item[@id = $id_prev]"/>
				
				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->
						
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					
					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template><xsl:template name="generateIndexXrefId">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		
		<xsl:variable name="docid">
			<xsl:call-template name="getDocumentId"/>
		</xsl:variable>
		<xsl:variable name="item_number">
			<xsl:number count="*[local-name() = 'li'][ancestor::*[local-name() = 'indexsect']]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="*[local-name() = 'xref']"/></xsl:variable>
		<xsl:value-of select="concat($docid, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']" priority="4">
		<xsl:apply-templates/>
		<fo:block>
		<xsl:if test="following-sibling::*[local-name() = 'clause']">
			<fo:block> </fo:block>
		</xsl:if>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'ul']" priority="4">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" priority="4">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'bookmark']">
		<fo:inline id="{@id}"/>
	</xsl:template><xsl:template match="*[local-name() = 'errata']">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row text-align="center" font-weight="bold" background-color="black" color="white">
					
					<fo:table-cell border="1pt solid black"><fo:block>Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="processBibitem">
		
		
		<!-- end BIPM bibitem processing-->
		
		 
		
		
		 
	</xsl:template><xsl:template name="processBibitemDocId">
		<xsl:variable name="_doc_ident" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($_doc_ident) != ''">
				<xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]/@type"/>
				<xsl:if test="$type != '' and not(contains($_doc_ident, $type))">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="$_doc_ident"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]/@type"/>
				<xsl:if test="$type != ''">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="processPersonalAuthor">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'completename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'completename']"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'initial']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'initial']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'forename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'forename']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="renderDate">		
			<xsl:if test="normalize-space(*[local-name() = 'on']) != ''">
				<xsl:value-of select="*[local-name() = 'on']"/>
			</xsl:if>
			<xsl:if test="normalize-space(*[local-name() = 'from']) != ''">
				<xsl:value-of select="concat(*[local-name() = 'from'], '–', *[local-name() = 'to'])"/>
			</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'initial']/text()" mode="strip">
		<xsl:value-of select="translate(.,'. ','')"/>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'forename']/text()" mode="strip">
		<xsl:value-of select="substring(.,1,1)"/>
	</xsl:template><xsl:template match="*[local-name() = 'title']" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'">January</xsl:when>
				<xsl:when test="$month = '02'">February</xsl:when>
				<xsl:when test="$month = '03'">March</xsl:when>
				<xsl:when test="$month = '04'">April</xsl:when>
				<xsl:when test="$month = '05'">May</xsl:when>
				<xsl:when test="$month = '06'">June</xsl:when>
				<xsl:when test="$month = '07'">July</xsl:when>
				<xsl:when test="$month = '08'">August</xsl:when>
				<xsl:when test="$month = '09'">September</xsl:when>
				<xsl:when test="$month = '10'">October</xsl:when>
				<xsl:when test="$month = '11'">November</xsl:when>
				<xsl:when test="$month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="convertDateLocalized">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_january</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '02'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_february</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '03'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_march</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '04'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_april</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '05'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_may</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '06'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_june</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '07'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_july</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '08'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_august</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '09'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_september</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '10'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_october</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '11'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_november</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '12'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_december</xsl:with-param></xsl:call-template></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="addPDFUAmeta">
		<xsl:variable name="lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
				<pdf:dictionary type="normal" key="ViewerPreferences">
					<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
				</pdf:dictionary>
			</pdf:catalog>
		<x:xmpmeta xmlns:x="adobe:ns:meta/">
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">
								
								
								
																
									<xsl:value-of select="*[local-name() = 'title'][@language = $lang]"/>
								
								
																
							</xsl:for-each>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="normalize-space($title) != ''">
								<xsl:value-of select="$title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>							
					</dc:title>
					<dc:creator>
						<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">
							
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
									<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
									<xsl:if test="position() != last()">; </xsl:if>
								</xsl:for-each>
							
							
							
						</xsl:for-each>
					</dc:creator>
					<dc:description>
						<xsl:variable name="abstract">
							
								<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()"/>									
							
							
						</xsl:variable>
						<xsl:value-of select="normalize-space($abstract)"/>
					</dc:description>
					<pdf:Keywords>
						<xsl:call-template name="insertKeywords"/>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
					<!-- XMP properties go here -->
					<xmp:CreatorTool/>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
	</xsl:template><xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="concat(local-name(..), '_', text())"/> -->
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*)"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<!-- <xsl:when test="parent::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when> -->
						<xsl:when test="ancestor::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'bibliography']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="local-name() = 'annex'">1</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:if test="string-length($pText) &gt;0">
		<item>
			<xsl:choose>
				<xsl:when test="$normalize-space = 'true'">
					<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
				</xsl:otherwise>
			</xsl:choose>
		</item>
		<xsl:call-template name="split">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
			<xsl:with-param name="normalize-space" select="$normalize-space"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template><xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">			
			
			
			
			
			
			
			
				<xsl:value-of select="document('')//*/namespace::rsd"/>
			
			
			
			
						
			
			
			
			
		</xsl:variable>
		<xsl:if test="$documentNS != $XSLNS">
			<xsl:message>[WARNING]: Document namespace: '<xsl:value-of select="$documentNS"/>' doesn't equal to xslt namespace '<xsl:value-of select="$XSLNS"/>'</xsl:message>
		</xsl:if>
	</xsl:template><xsl:template name="getLanguage">
		<xsl:param name="lang"/>		
		<xsl:variable name="language" select="java:toLowerCase(java:java.lang.String.new($lang))"/>
		<xsl:choose>
			<xsl:when test="$language = 'en'">English</xsl:when>
			<xsl:when test="$language = 'fr'">French</xsl:when>
			<xsl:when test="$language = 'de'">Deutsch</xsl:when>
			<xsl:when test="$language = 'cn'">Chinese</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="setId">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
			</xsl:choose>					
		</xsl:attribute>
	</xsl:template><xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>				
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char"/>
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getLocalizedString">
		<xsl:param name="key"/>		
		
		<xsl:variable name="curr_lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]">
				<xsl:value-of select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$key"/></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template></xsl:stylesheet>