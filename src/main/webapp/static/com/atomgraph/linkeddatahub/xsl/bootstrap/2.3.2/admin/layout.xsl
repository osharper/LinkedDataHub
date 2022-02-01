<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY lacl   "https://w3id.org/atomgraph/linkeddatahub/admin/acl#">
    <!ENTITY lapp   "https://w3id.org/atomgraph/linkeddatahub/apps#">
    <!ENTITY adm    "https://w3id.org/atomgraph/linkeddatahub/admin#">
    <!ENTITY ldh    "https://w3id.org/atomgraph/linkeddatahub#">
    <!ENTITY ac     "https://w3id.org/atomgraph/client#">
    <!ENTITY rdf    "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <!ENTITY rdfs   "http://www.w3.org/2000/01/rdf-schema#">
    <!ENTITY owl    "http://www.w3.org/2002/07/owl#">
    <!ENTITY acl    "http://www.w3.org/ns/auth/acl#">
    <!ENTITY cert   "http://www.w3.org/ns/auth/cert#">
    <!ENTITY ldt    "https://www.w3.org/ns/ldt#">
    <!ENTITY dh     "https://www.w3.org/ns/ldt/document-hierarchy#">
    <!ENTITY sp     "http://spinrdf.org/sp#">
    <!ENTITY sioc   "http://rdfs.org/sioc/ns#">
    <!ENTITY foaf   "http://xmlns.com/foaf/0.1/">
    <!ENTITY spin   "http://spinrdf.org/spin#">
]>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xhtml="http://www.w3.org/1999/xhtml"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:map="http://www.w3.org/2005/xpath-functions/map"
xmlns:lapp="&lapp;"
xmlns:ldh="&ldh;"
xmlns:ac="&ac;"
xmlns:rdf="&rdf;"
xmlns:rdfs="&rdfs;"
xmlns:acl="&acl;"
xmlns:ldt="&ldt;"
xmlns:sioc="&sioc;"
xmlns:foaf="&foaf;"
xmlns:spin="&spin;"
xmlns:bs2="http://graphity.org/xsl/bootstrap/2.3.2"
exclude-result-prefixes="#all">

    <xsl:import href="../layout.xsl"/>
    <xsl:include href="acl/layout.xsl"/>
    <xsl:include href="sitemap/layout.xsl"/>

    <xsl:param name="default-classes" as="map(xs:string, xs:anyURI)">
        <xsl:map>
            <xsl:map-entry key="'&owl;Ontology'" select="resolve-uri('model/ontologies/', $ldt:base)"/>
            <xsl:map-entry key="'&acl;Authorization'" select="resolve-uri('acl/authorizations/', $ldt:base)"/>
            <xsl:map-entry key="'&foaf;Person'" select="resolve-uri('acl/agents/', $ldt:base)"/>
            <xsl:map-entry key="'&cert;PublicKey'" select="resolve-uri('acl/public-keys/', $ldt:base)"/>
            <xsl:map-entry key="'&sioc;UserAccount'" select="resolve-uri('acl/users/', $ldt:base)"/>
            <xsl:map-entry key="'&foaf;Group'" select="resolve-uri('acl/groups/', $ldt:base)"/>
        </xsl:map>
    </xsl:param>
        
    <xsl:template match="rdf:RDF" mode="bs2:ActionBarLeft">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" select="'span2'" as="xs:string?"/>
        <xsl:param name="classes" select="for $class-uri in map:keys($default-classes) return key('resources', $class-uri, document(ac:document-uri($class-uri)))" as="element()*"/>

        <div>
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:sequence select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:sequence select="$class"/></xsl:attribute>
            </xsl:if>
            
            <xsl:apply-templates select="." mode="bs2:Create">
                <xsl:with-param name="class" select="'btn-group pull-left'"/>
                <xsl:with-param name="classes" select="$classes"/>
                <xsl:with-param name="create-graph" select="true()"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    
    <xsl:template match="rdf:RDF[$foaf:Agent]" mode="bs2:Create" priority="1">
        <xsl:param name="classes" as="element()*"/>
        <xsl:param name="create-graph" select="false()" as="xs:boolean"/>

        <div class="btn-group pull-left">
            <button type="button" title="{ac:label(key('resources', 'create-instance-title', document('../translations.rdf')))}">
                <xsl:apply-templates select="key('resources', '&ac;ConstructMode', document(ac:document-uri('&ac;')))" mode="ldh:logo">
                    <xsl:with-param name="class" select="'btn btn-primary dropdown-toggle'"/>
                </xsl:apply-templates>
                <xsl:value-of>
                    <xsl:apply-templates select="key('resources', '&ac;ConstructMode', document(ac:document-uri('&ac;')))" mode="ac:label"/>
                </xsl:value-of>
                <xsl:text> </xsl:text>
                <span class="caret"></span>
            </button>

            <xsl:call-template name="bs2:ConstructorList">
                <xsl:with-param name="ontology" select="key('resources', $ldt:ontology, document(ac:document-uri($ldt:ontology)))"/>
                <xsl:with-param name="classes" select="$classes"/>
                <xsl:with-param name="visited-classes" select="()"/>
                <xsl:with-param name="create-graph" select="$create-graph"/>
            </xsl:call-template>
        </div>
    </xsl:template>
    
    <!-- unlike in the end-user app, only show classes from top-level ontology - don't recurse into imports -->
    <xsl:template name="bs2:ConstructorList">
        <xsl:param name="ontology" as="element()"/>
        <xsl:param name="classes" as="element()*"/>
        <xsl:param name="visited-classes" as="element()*"/>
        <xsl:param name="create-graph" select="false()" as="xs:boolean"/>

        <ul class="dropdown-menu">
            <xsl:apply-templates select="$classes" mode="bs2:ConstructorListItem">
                <xsl:with-param name="create-graph" select="$create-graph"/>
                <xsl:sort select="ac:label(.)"/>
            </xsl:apply-templates>
        </ul>
    </xsl:template>

    <xsl:template match="rdf:RDF" mode="ldh:Constructor" as="document-node()">
        <xsl:param name="forClass" as="xs:anyURI"/>
        <xsl:param name="createGraph" as="xs:boolean"/>

        <xsl:choose>
            <!-- if $forClass is not a document class, then pair the instance with a document instance -->
            <xsl:when test="$createGraph and not($forClass = ('&dh;Container', '&dh;Item'))">
                <xsl:document>
                    <xsl:for-each select="ac:construct($ldt:ontology, ($forClass, xs:anyURI('&dh;Item')), $ldt:base)">
                        <xsl:apply-templates select="." mode="ldh:SetPrimaryTopic">
                            <xsl:with-param name="topic-id" select="key('resources-by-type', $forClass)[* except rdf:type]/@rdf:nodeID" tunnel="yes"/>
                            <xsl:with-param name="doc-id" select="key('resources-by-type', '&dh;Item')/@rdf:nodeID" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </xsl:document>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="ac:construct($ldt:ontology, $forClass, $ldt:base)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
<!--    <xsl:template match="rdf:RDF[$ac:forClass or $ac:mode = '&ac;EditMode']" mode="bs2:RowForm" priority="1">
        <xsl:param name="classes" as="element()*"/>
        
        <xsl:next-match>
            <xsl:with-param name="classes" select="$classes"/>
        </xsl:next-match>
    </xsl:template>-->
    
    <!-- allow subject editing in admin EditMode -->
    <xsl:template match="*[*][@rdf:about or @rdf:nodeID]" mode="bs2:FormControl">
        <xsl:apply-imports>
            <xsl:with-param name="show-subject" select="not(rdf:type/@rdf:resource = ('&dh;Item', '&dh;Container'))" tunnel="yes"/>
        </xsl:apply-imports>
    </xsl:template>
        
    <!-- FORM CONTROL -->
    
<!--    <xsl:template match="*[@rdf:about or @rdf:nodeID][$ac:forClass]/sioc:has_parent/@rdf:nodeID | *[@rdf:about or @rdf:nodeID][$ac:forClass]/sioc:has_container/@rdf:nodeID" mode="bs2:FormControl">
        <xsl:next-match>
            <xsl:with-param name="default-classes" select="$default-classes"/>
        </xsl:next-match>
    </xsl:template>-->
    
</xsl:stylesheet>
