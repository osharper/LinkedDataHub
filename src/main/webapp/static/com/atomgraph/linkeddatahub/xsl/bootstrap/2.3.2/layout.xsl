<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY lapp   "https://w3id.org/atomgraph/linkeddatahub/apps/domain#">
    <!ENTITY lacl   "https://w3id.org/atomgraph/linkeddatahub/admin/acl/domain#">
    <!ENTITY lsm    "https://w3id.org/atomgraph/linkeddatahub/admin/sitemap/domain#">
    <!ENTITY apl    "https://w3id.org/atomgraph/linkeddatahub/domain#">
    <!ENTITY aplt   "https://w3id.org/atomgraph/linkeddatahub/templates#">
    <!ENTITY google "https://w3id.org/atomgraph/linkeddatahub/services/google#">
    <!ENTITY ac     "https://w3id.org/atomgraph/client#">
    <!ENTITY a      "https://w3id.org/atomgraph/core#">
    <!ENTITY rdf    "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <!ENTITY xhv    "http://www.w3.org/1999/xhtml/vocab#">
    <!ENTITY rdfs   "http://www.w3.org/2000/01/rdf-schema#">
    <!ENTITY xsd    "http://www.w3.org/2001/XMLSchema#">
    <!ENTITY owl    "http://www.w3.org/2002/07/owl#">
    <!ENTITY geo    "http://www.w3.org/2003/01/geo/wgs84_pos#">
    <!ENTITY http   "http://www.w3.org/2011/http#">
    <!ENTITY sc     "http://www.w3.org/2011/http-statusCodes#">
    <!ENTITY acl    "http://www.w3.org/ns/auth/acl#">
    <!ENTITY cert   "http://www.w3.org/ns/auth/cert#">
    <!ENTITY sd     "http://www.w3.org/ns/sparql-service-description#">
    <!ENTITY ldt    "https://www.w3.org/ns/ldt#">
    <!ENTITY c      "https://www.w3.org/ns/ldt/core/domain#">
    <!ENTITY ct     "https://www.w3.org/ns/ldt/core/templates#">
    <!ENTITY dh     "https://www.w3.org/ns/ldt/document-hierarchy/domain#">
    <!ENTITY dct    "http://purl.org/dc/terms/">
    <!ENTITY foaf   "http://xmlns.com/foaf/0.1/">
    <!ENTITY sioc   "http://rdfs.org/sioc/ns#">
    <!ENTITY sp     "http://spinrdf.org/sp#">
    <!ENTITY spin   "http://spinrdf.org/spin#">
    <!ENTITY spl    "http://spinrdf.org/spl#">
    <!ENTITY void   "http://rdfs.org/ns/void#">
    <!ENTITY nfo    "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#">
]>
<xsl:stylesheet version="3.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xhtml="http://www.w3.org/1999/xhtml"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:map="http://www.w3.org/2005/xpath-functions/map"
xmlns:ac="&ac;"
xmlns:a="&a;"
xmlns:lapp="&lapp;"
xmlns:lacl="&lacl;"
xmlns:apl="&apl;"
xmlns:aplt="&aplt;"
xmlns:rdf="&rdf;"
xmlns:xhv="&xhv;"
xmlns:rdfs="&rdfs;"
xmlns:owl="&owl;"
xmlns:http="&http;"
xmlns:acl="&acl;"
xmlns:cert="&cert;"
xmlns:sd="&sd;"
xmlns:ldt="&ldt;"
xmlns:core="&c;"
xmlns:dh="&dh;"
xmlns:dct="&dct;"
xmlns:foaf="&foaf;"
xmlns:sioc="&sioc;"
xmlns:spin="&spin;"
xmlns:sp="&sp;"
xmlns:spl="&spl;"
xmlns:void="&void;"
xmlns:nfo="&nfo;"
xmlns:geo="&geo;"
xmlns:google="&google;"
xmlns:bs2="http://graphity.org/xsl/bootstrap/2.3.2"
exclude-result-prefixes="#all">

    <xsl:import href="imports/xml-to-string.xsl"/>
    <xsl:import href="../../../../client/xsl/converters/RDFXML2JSON-LD.xsl"/>
    <xsl:import href="../../../../client/xsl/bootstrap/2.3.2/internal-layout.xsl"/>
    <xsl:import href="imports/default.xsl"/>
    <xsl:import href="imports/apl.xsl"/>
    <xsl:import href="imports/dct.xsl"/>
    <xsl:import href="imports/dh.xsl"/>
    <xsl:import href="imports/nfo.xsl"/>
    <xsl:import href="imports/rdf.xsl"/>
    <xsl:import href="imports/sioc.xsl"/>
    <xsl:import href="imports/sp.xsl"/>
    <xsl:import href="imports/void.xsl"/>
    <xsl:import href="resource.xsl"/>
    <xsl:import href="document.xsl"/>
    
    <!--  To use xsl:import-schema, you need the schema-aware version of Saxon -->
    <!-- <xsl:import-schema namespace="http://www.w3.org/1999/xhtml" schema-location="http://www.w3.org/2002/08/xhtml/xhtml1-transitional.xsd"/> -->
  
    <xsl:include href="sparql.xsl"/>
    <xsl:include href="signup.xsl"/>
    <xsl:include href="request-access.xsl"/>

    <xsl:output method="xhtml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" media-type="application/xhtml+xml"/>

    <xsl:param name="apl:baseUri" as="xs:anyURI" static="yes"/>
    <xsl:param name="lapp:Application" as="document-node()?"/>
    <xsl:param name="sd:endpoint" select="if ($ldt:base) then resolve-uri('sparql', $ldt:base) else ()" as="xs:anyURI?"/>
    <xsl:param name="a:graphStore" select="if ($ldt:base) then resolve-uri('service', $ldt:base) else ()" as="xs:anyURI?"/>
    <xsl:param name="acl:Agent" as="document-node()?"/>
    <xsl:param name="force-exclude-all-namespaces" select="true()"/>
    <xsl:param name="ldt:template" as="xs:anyURI?"/>
    <xsl:param name="ac:httpHeaders" as="xs:string"/> 
    <xsl:param name="ac:method" as="xs:string"/>
    <xsl:param name="ac:requestUri" as="xs:anyURI?"/>
    <xsl:param name="ac:uri" as="xs:anyURI"/>
    <xsl:param name="ac:mode" select="xs:anyURI('&ac;ReadMode')" as="xs:anyURI*"/>
    <xsl:param name="ac:googleMapsKey" select="'AIzaSyCQ4rt3EnNCmGTpBN0qoZM1Z_jXhUnrTpQ'" as="xs:string"/>
    <xsl:param name="acl:agent" as="xs:anyURI?"/>
    <xsl:param name="acl:mode" select="$acl:Agent//*[acl:accessToClass/@rdf:resource = (key('resources', $ac:uri, $main-doc)/rdf:type/@rdf:resource, key('resources', $ac:uri, $main-doc)/rdf:type/@rdf:resource/apl:listSuperClasses(.))]/acl:mode/@rdf:resource" as="xs:anyURI*"/>
    <xsl:param name="google:clientID" as="xs:string?"/>

    <xsl:variable name="root-containers" select="($ldt:base, resolve-uri('latest/', $ldt:base), resolve-uri('geo/', $ldt:base), resolve-uri('services/', $ldt:base), resolve-uri('files/', $ldt:base), resolve-uri('imports/', $ldt:base), resolve-uri('queries/', $ldt:base), resolve-uri('charts/', $ldt:base))" as="xs:anyURI*"/>
    
    <xsl:key name="resources-by-primary-topic" match="*[@rdf:about] | *[@rdf:nodeID]" use="foaf:primaryTopic/@rdf:resource"/>
    <xsl:key name="resources-by-primary-topic-of" match="*[@rdf:about] | *[@rdf:nodeID]" use="foaf:isPrimaryTopicOf/@rdf:resource"/>
    <xsl:key name="resources-by-dataset" match="*[@rdf:about]" use="void:inDataset/@rdf:resource"/>
    <xsl:key name="resources-by-defined-by" match="*[@rdf:about]" use="rdfs:isDefinedBy/@rdf:resource"/>
    <xsl:key name="violations-by-path" match="*" use="spin:violationPath/@rdf:resource"/>
    <xsl:key name="violations-by-root" match="*" use="spin:violationRoot/@rdf:resource"/>
    <xsl:key name="violations-by-value" match="*" use="apl:violationValue/text()"/>
    <xsl:key name="resources-by-container" match="*[@rdf:about] | *[@rdf:nodeID]" use="sioc:has_parent/@rdf:resource | sioc:has_container/@rdf:resource"/>
    <xsl:key name="resources-by-expression" match="*[@rdf:nodeID]" use="sp:expression/@rdf:about | sp:expression/@rdf:nodeID"/>
    <xsl:key name="resources-by-varname" match="*[@rdf:nodeID]" use="sp:varName"/>
    <xsl:key name="resources-by-arg1" match="*[@rdf:nodeID]" use="sp:arg1/@rdf:about | sp:arg1/@rdf:nodeID"/>
    <xsl:key name="restrictions-by-container" match="*[rdf:type/@rdf:resource = '&owl;Restriction'][owl:onProperty/@rdf:resource = ('&sioc;has_parent', '&sioc;has_container')]" use="owl:allValuesFrom/@rdf:resource"/>
    
    <rdf:Description rdf:about="">
    </rdf:Description>

    <!-- show only form when ac:ModalMode combined with ac:Edit (used by client.xsl) -->
    <xsl:template match="rdf:RDF[$ac:mode = '&ac;EditMode']" mode="xhtml:Body" priority="1">
        <body>
            <xsl:choose>
                <xsl:when test="$ac:mode = '&ac;ModalMode'">
                    <xsl:apply-templates select="." mode="bs2:ModalForm"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="bs2:Form"/>
                </xsl:otherwise>
            </xsl:choose>
        </body>
    </xsl:template>

    <!-- show only form when ac:ModalMode combined with ac:forClass (used by client.xsl) -->
    <xsl:template match="rdf:RDF[$ac:forClass]" mode="xhtml:Body" priority="1">
        <body>
            <xsl:choose>
                <xsl:when test="$ac:method = 'GET'">
                    <xsl:choose>
                        <xsl:when test="$ac:mode = '&ac;ModalMode'">
                            <xsl:apply-templates select="ac:construct-doc($ldt:ontology, $ac:forClass, $ldt:base)" mode="bs2:ModalForm"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="ac:construct-doc($ldt:ontology, $ac:forClass, $ldt:base)" mode="bs2:Form"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$ac:method = 'POST' and key('resources-by-type', '&spin;ConstraintViolation')">
                    <xsl:choose>
                        <xsl:when test="$ac:mode = '&ac;ModalMode'">
                            <xsl:apply-templates select="." mode="bs2:ModalForm"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="bs2:Form"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:next-match/>
                </xsl:otherwise>
            </xsl:choose>
        </body>
    </xsl:template>
    
    <xsl:template match="rdf:RDF[key('resources', $ac:uri)][$ac:mode = '&aplt;InfoWindowMode']" mode="xhtml:Body" priority="1">
        <body>
            <div> <!-- SPARQLMap renders the first child of <body> as InfoWindow -->
                <xsl:apply-templates select="." mode="bs2:Block">
                    <xsl:with-param name="display" select="true()" tunnel="yes"/>
                </xsl:apply-templates>
            </div>
        </body>
    </xsl:template>

    <xsl:template match="rdf:RDF[key('resources', $ac:uri)][$ac:mode = '&aplt;ObjectMode']" mode="xhtml:Body" priority="2">
        <body class="embed">
            <div>
                <xsl:apply-templates select="." mode="bs2:Object">
                    <xsl:with-param name="show-controls" select="false()" tunnel="yes"/>
                </xsl:apply-templates>
            </div>
        </body>
    </xsl:template>
    
    <!-- TITLE -->

    <xsl:template match="rdf:RDF" mode="xhtml:Title">
        <title>
            <xsl:if test="$lapp:Application">
                <xsl:value-of>
                    <xsl:apply-templates select="$lapp:Application//*[ldt:base/@rdf:resource = $ldt:base]" mode="ac:label"/>
                </xsl:value-of>
                <xsl:text> - </xsl:text>
            </xsl:if>

            <xsl:apply-templates mode="#current"/>
        </title>
    </xsl:template>

    <xsl:template match="*[rdf:type/@rdf:resource = '&http;Response'][not(key('resources', $ac:uri))]" mode="xhtml:Title" priority="1">
        <xsl:value-of>
            <xsl:apply-templates select="." mode="ac:label"/>
        </xsl:value-of>
    </xsl:template>
    
    <xsl:template match="*[@rdf:about = $ac:uri]" mode="xhtml:Title" priority="1">
        <xsl:value-of>
            <xsl:apply-templates select="." mode="ac:label"/>
        </xsl:value-of>
    </xsl:template>

    <xsl:template match="*[*][@rdf:about] | *[*][@rdf:nodeID]" mode="xhtml:Title"/>
    
    <!-- META -->
    
    <xsl:template match="rdf:RDF" mode="xhtml:Meta">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

        <meta name="og:url" content="{$ac:uri}"/>
        <meta name="twitter:url" content="{$ac:uri}"/>

        <xsl:for-each select="key('resources', $ac:uri)">
            <meta name="og:title" content="{ac:label(.)}"/>
            <meta name="twitter:title" content="{ac:label(.)}"/>

            <meta name="twitter:card" content="summary_large_image"/>

            <xsl:if test="ac:description(.)">
                <meta name="description" content="{ac:description(.)}"/>
                <meta property="og:description" content="{ac:description(.)}"/>
                <meta name="twitter:description" content="{ac:description(.)}"/>
            </xsl:if>

            <xsl:if test="ac:image(.)">
                <meta property="og:image" content="{ac:image(.)}"/>
                <meta name="twitter:image" content="{ac:image(.)}"/>
            </xsl:if>

            <xsl:for-each select="foaf:maker/@rdf:resource">
                <xsl:if test="doc-available(ac:document-uri(.))">
                    <xsl:for-each select="key('resources', ., document(ac:document-uri(.)))">
                        <meta name="author" content="{ac:label(.)}"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>

        <xsl:if test="$lapp:Application//*[ldt:base/@rdf:resource = $ldt:base]">
            <meta property="og:site_name" content="{ac:label($lapp:Application//*[ldt:base/@rdf:resource = $ldt:base])}"/>
        </xsl:if>
    </xsl:template>

    <!-- STYLE -->
    
    <xsl:template match="rdf:RDF" mode="xhtml:Style">
        <xsl:param name="load-wymeditor" select="exists($acl:Agent//@rdf:about)" as="xs:boolean"/>
        
        <xsl:apply-imports/>

        <link href="{resolve-uri('static/com/atomgraph/linkeddatahub/css/bootstrap.css', $ac:contextUri)}" rel="stylesheet" type="text/css"/>
        <xsl:if test="$load-wymeditor">
            <link href="{resolve-uri('static/com/atomgraph/linkeddatahub/js/wymeditor/skins/default/skin.css', $ac:contextUri)}" rel="stylesheet" type="text/css"/>
        </xsl:if>
    </xsl:template>

    <!-- SCRIPT -->

    <xsl:template match="rdf:RDF" mode="xhtml:Script">
        <xsl:param name="client-stylesheet" select="resolve-uri('static/com/atomgraph/linkeddatahub/xsl/client.xsl.sef.json', $ac:contextUri)" as="xs:anyURI"/>
        <xsl:param name="saxon-js-log-level" select="10" as="xs:integer"/>
        <xsl:param name="load-wymeditor" select="exists($acl:Agent//@rdf:about)" as="xs:boolean"/>
        <xsl:param name="load-saxon-js" select="$ldt:base and not($ac:mode = ('&ac;ModalMode', '&aplt;InfoWindowMode')) and not($ac:uri = resolve-uri(concat('admin/', encode-for-uri('sign up')), $ldt:base))" as="xs:boolean"/>
        <xsl:param name="load-sparql-builder" select="$ldt:base and not($ac:mode = ('&ac;ModalMode', '&aplt;InfoWindowMode')) and (not(key('resources-by-type', '&http;Response')) or $ac:uri = resolve-uri(concat('admin/', encode-for-uri('sign up')), $ldt:base))" as="xs:boolean"/>
        <xsl:param name="load-sparql-map" select="$ldt:base and not($ac:mode = ('&ac;ModalMode', '&aplt;InfoWindowMode')) and (not(key('resources-by-type', '&http;Response')) or $ac:uri = resolve-uri(concat('admin/', encode-for-uri('sign up')), $ldt:base))" as="xs:boolean"/>
        <xsl:param name="load-google-charts" select="$ldt:base and not($ac:mode = ('&ac;ModalMode', '&aplt;InfoWindowMode')) and not($ac:mode = ('&ac;ModalMode', '&aplt;InfoWindowMode')) and (not(key('resources-by-type', '&http;Response')) or $ac:uri = resolve-uri(concat('admin/', encode-for-uri('sign up')), $ldt:base))" as="xs:boolean"/>
        <xsl:param name="output-json-ld" select="false()" as="xs:boolean"/>

        <!-- Web-Client scripts -->
        <script type="text/javascript" src="{resolve-uri('static/js/jquery.min.js', $ac:contextUri)}" defer="defer"></script>
        <script type="text/javascript" src="{resolve-uri('static/js/bootstrap.js', $ac:contextUri)}" defer="defer"></script>
        <script type="text/javascript" src="{resolve-uri('static/com/atomgraph/client/js/UUID.js', $ac:contextUri)}" defer="defer"></script>
        <!-- LinkedDataHub scripts -->
        <script type="text/javascript" src="{resolve-uri('static/com/atomgraph/linkeddatahub/js/jquery.js', $ac:contextUri)}" defer="defer"></script>
        <script type="text/javascript">
            <![CDATA[
                var baseUri = "]]><xsl:value-of select="$ldt:base"/><![CDATA[";
                var ontologyUri = "]]><xsl:value-of select="$ldt:ontology"/><![CDATA[";
                var contextUri = "]]><xsl:value-of select="$ac:contextUri"/><![CDATA[";
                var agentUri = ]]><xsl:value-of select="if ($acl:agent) then '&quot;' || $acl:agent || '&quot;'  else 'null'"/><![CDATA[;
                var accessModeUri = []]><xsl:value-of select="string-join(for $mode in $acl:mode return '&quot;' || $mode || '&quot;', ', ')"/><![CDATA[];
            ]]>
        </script>
        <xsl:if test="$load-wymeditor">
            <script type="text/javascript" src="{resolve-uri('static/com/atomgraph/linkeddatahub/js/wymeditor/jquery.wymeditor.js', $ac:contextUri)}" defer="defer"></script>
        </xsl:if>
        <xsl:if test="$load-saxon-js">
            <script type="text/javascript" src="{resolve-uri('static/com/atomgraph/linkeddatahub/js/saxon-js/SaxonJS2.rt.js', $ac:contextUri)}" defer="defer"></script>
            <script type="text/javascript">
                <![CDATA[
                    window.onload = function() {
                        const locationMapping = [ 
                            // not using entities as we don't want the # in the end
                            { name: contextUri + "static/com/atomgraph/linkeddatahub/xsl/bootstrap/2.3.2/translations.rdf", altName: contextUri + "static/com/atomgraph/linkeddatahub/xsl/bootstrap/2.3.2/translations.rdf" },
                            { name: "https://w3id.org/atomgraph/client", altName: baseUri + "?uri=" + encodeURIComponent("https://w3id.org/atomgraph/client") + "&accept=" + encodeURIComponent("application/rdf+xml") },
                            { name: "http://www.w3.org/1999/02/22-rdf-syntax-ns", altName: baseUri + "?uri=" + encodeURIComponent("http://www.w3.org/1999/02/22-rdf-syntax-ns") + "&accept=" + encodeURIComponent("application/rdf+xml") }
                            ]]>
                            <!--<xsl:variable name="ontology-imports" select="for $value in distinct-values(apl:ontologyImports($ldt:ontology)) return xs:anyURI($value)" as="xs:anyURI*"/>
                            <xsl:if test="exists($ontology-imports)">
                                <xsl:text>,</xsl:text>
                                <xsl:for-each select="$ontology-imports">
                                    <xsl:text>{ name: "</xsl:text>
                                    <xsl:value-of select="ac:document-uri(.)"/>
                                    <xsl:text>", altName: baseUri + "?uri=" + encodeURIComponent("</xsl:text>
                                    <xsl:value-of select="ac:document-uri(.)"/>
                                    <xsl:text>") + "&amp;accept=" + encodeURIComponent("application/rdf+xml") }</xsl:text>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>,&#xa;</xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if> -->
                            <![CDATA[
                        ];
                        const docPromises = locationMapping.map(mapping => SaxonJS.getResource({location: mapping.altName, type: "xml"}));
    
                        Promise.all(docPromises)
                        .then(resources => {
                            const cache = {};
                            for (var i = 0; i < resources.length; i++) {
                                cache[locationMapping[i].name] = resources[i]
                            };
                            return SaxonJS.transform({
                                documentPool: cache,
                                stylesheetLocation: "]]><xsl:value-of select="$client-stylesheet"/><![CDATA[",
                                initialTemplate: "main",
                                logLevel: ]]><xsl:value-of select="$saxon-js-log-level"/><![CDATA[,
                                stylesheetParams: {
                                    "Q{https://w3id.org/atomgraph/client#}contextUri": contextUri, // servlet context URI
                                    "Q{https://www.w3.org/ns/ldt#}base": baseUri,
                                    "Q{https://www.w3.org/ns/ldt#}ontology": ontologyUri,
                                    "Q{http://www.w3.org/ns/auth/acl#}agent": agentUri,
                                    "Q{http://www.w3.org/ns/auth/acl#}mode": accessModeUri
                                    }
                            }, "async");
                        })
                        .catch(err => console.log("Transformation failed: " + err));
                    }
                ]]>
            </script>
        </xsl:if>
        <xsl:if test="$load-sparql-builder">
            <script type="text/javascript" src="{resolve-uri('static/com/atomgraph/linkeddatahub/js/SPARQLBuilder.js', $ac:contextUri)}" defer="defer"></script>
        </xsl:if>
        <xsl:if test="$load-sparql-map">
            <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key={$ac:googleMapsKey}" defer="defer"></script>
            <script type="text/javascript" src="{resolve-uri('static/com/atomgraph/linkeddatahub/js/SPARQLMap.js', $ac:contextUri)}" defer="defer"></script>
        </xsl:if>
        <xsl:if test="$load-google-charts">
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <script type="text/javascript">
                <![CDATA[
                    google.charts.load('current', {packages: ['corechart', 'table', 'timeline', 'map']});
                ]]>
            </script>
        </xsl:if>
        <xsl:if test="$output-json-ld">
            <!-- output structured data: https://developers.google.com/search/docs/guides/intro-structured-data -->
            <script type="application/ld+json">
                <xsl:apply-templates select="." mode="ac:JSON-LD"/>
            </script>
        </xsl:if>
    </xsl:template>
    
    <!-- NAVBAR -->
    
    <xsl:template match="rdf:RDF" mode="bs2:NavBar">
        <div class="navbar navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container-fluid">
                    <button class="btn btn-navbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>

                    <xsl:if test="$ldt:base">
                        <xsl:if test="not($ldt:base = $ac:contextUri)">
                            <a class="brand context" href="{resolve-uri('..', $ldt:base)}"/>
                        </xsl:if>
                    </xsl:if>
                        
                    <a class="brand" href="{$ldt:base}">
                        <xsl:if test="$lapp:Application//*[ldt:base/@rdf:resource = $ldt:base]/rdf:type/@rdf:resource = '&lapp;AdminApplication'">
                            <xsl:attribute name="class" select="'brand admin'"/>
                        </xsl:if>
                        
                        <xsl:value-of>
                            <xsl:apply-templates select="$lapp:Application//*[ldt:base/@rdf:resource = $ldt:base]" mode="ac:label"/>
                        </xsl:value-of>
                    </a>

                    <div id="collapsing-top-navbar" class="nav-collapse collapse" style="margin-left: 17%;">
                        <xsl:apply-templates select="." mode="bs2:SearchBar"/>

                        <xsl:apply-templates select="." mode="bs2:NavBarNavList"/>
                    </div>
                </div>
            </div>

            <xsl:apply-templates select="." mode="bs2:ActionBar"/>
        </div>
    </xsl:template>

    <xsl:template match="rdf:RDF[$ldt:base][$acl:mode = '&acl;Read']" mode="bs2:SearchBar" priority="1">
        <form action="{$ac:requestUri}" method="get" class="navbar-form pull-left" accept-charset="UTF-8" title="{ac:label(key('resources', 'search-title', document('translations.rdf')))}">
            <div class="input-append">
                <select id="search-service" name="service">
                    <option value="">[SPARQL service]</option>
                </select>
                
                <input type="text" id="uri" name="uri" class="input-xxlarge typeahead">
                    <xsl:if test="not(starts-with($ac:uri, $ldt:base))">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$ac:uri"/>
                        </xsl:attribute>
                    </xsl:if>
                </input>

                <button type="submit">
                    <xsl:apply-templates select="key('resources', 'search', document('translations.rdf'))" mode="apl:logo">
                        <xsl:with-param name="class" select="'btn btn-primary'"/>
                    </xsl:apply-templates>
                </button>
            </div>
        </form>
    </xsl:template>
    
    <xsl:template match="*" mode="bs2:SearchBar"/>

    <xsl:template match="rdf:RDF" mode="bs2:ActionBarLeft">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" select="'span2'" as="xs:string?"/>
        
        <div>
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:sequence select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:sequence select="$class"/></xsl:attribute>
            </xsl:if>
            
            <xsl:apply-templates select="." mode="bs2:Create">
                <xsl:with-param name="class" select="'btn-group pull-left'"/>
            </xsl:apply-templates>
            
            <xsl:apply-templates select="." mode="bs2:AddData"/>
        </div>
    </xsl:template>
    
    <xsl:template match="rdf:RDF" mode="bs2:ActionBarMain">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" select="'span7'" as="xs:string?"/>

        <div>
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            </xsl:if>
            
            <xsl:apply-templates select="." mode="bs2:ContentToggle"/>

            <div id="result-counts">
                <!-- placeholder for client.xsl callbacks -->
            </div>

            <div id="breadcrumb-nav">
                <!-- placeholder for client.xsl callbacks -->
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="rdf:RDF" mode="bs2:ActionBarRight">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" select="'span3'" as="xs:string?"/>

        <div>
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            </xsl:if>
            
            <xsl:apply-templates select="." mode="bs2:Settings"/>

            <xsl:apply-templates select="." mode="bs2:MediaTypeList"/>

            <xsl:apply-templates select="." mode="bs2:NavBarActions"/>
        </div>
    </xsl:template>
    
    <xsl:template match="rdf:RDF" mode="bs2:NavBarNavList">
        <xsl:if test="$acl:Agent//@rdf:about">
            <ul class="nav pull-right">
                <li>
                    <xsl:if test="$ac:mode = '&ac;QueryEditorMode'">
                        <xsl:attribute name="class" select="'active'"/>
                    </xsl:if>

                    <a href="{ac:build-uri((), map{ 'mode': '&ac;QueryEditorMode' })}">SPARQL editor</a>
                </li>
                <li>
                    <div class="btn-group">
                        <button type="button" title="{ac:label($acl:Agent//*[@rdf:about][1])}">
                            <xsl:apply-templates select="key('resources', '&acl;Agent', document(ac:document-uri('&acl;')))" mode="apl:logo">
                                <xsl:with-param name="class" select="'btn dropdown-toggle'"/>
                            </xsl:apply-templates>
                        </button>
                        <ul class="dropdown-menu pull-right">
                            <li>
                                <xsl:for-each select="key('resources-by-type', '&acl;Agent', $acl:Agent)">
                                    <xsl:apply-templates select="." mode="xhtml:Anchor"/>
                                </xsl:for-each>
                            </li>
                        </ul>
                    </div>
                </li>
            </ul>
        </xsl:if>

        <xsl:apply-templates select="." mode="bs2:SignUp"/>
    </xsl:template>

    <xsl:template match="rdf:RDF[not($acl:Agent//@rdf:about)][$lapp:Application//*[ldt:base/@rdf:resource = $ldt:base]/rdf:type/@rdf:resource = '&lapp;EndUserApplication']" mode="bs2:SignUp" priority="1">
        <xsl:param name="uri" select="ac:build-uri(resolve-uri(concat('admin/', encode-for-uri('sign up')), $ldt:base), map{ 'forClass': string(resolve-uri('admin/ns#Person', $ldt:base)) })" as="xs:anyURI"/>
        <xsl:param name="google-signup" select="exists($google:clientID)" as="xs:boolean"/>
        <xsl:param name="webid-signup" select="true()" as="xs:boolean"/>
        
        <xsl:if test="$google-signup or $webid-signup">
            <p class="pull-right">
                <xsl:if test="$google-signup">
                    <a class="btn btn-primary" href="{ac:build-uri(resolve-uri('admin/oauth2/authorize/google', $apl:baseUri), map{ 'referer': string($ac:uri) })}">
                        <xsl:value-of>
                            <xsl:apply-templates select="key('resources', 'login-google', document('translations.rdf'))" mode="ac:label"/>
                        </xsl:value-of>
                    </a>
                </xsl:if>
                <xsl:if test="$webid-signup">
                    <a class="btn btn-primary" href="{if (not(starts-with($ldt:base, $apl:baseUri))) then ac:build-uri((), map{ 'uri': string($uri) }) else $uri}">
                        <xsl:value-of>
                            <xsl:apply-templates select="key('resources', 'sign-up', document('translations.rdf'))" mode="ac:label"/>
                        </xsl:value-of>
                    </a>
                </xsl:if>
            </p>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="rdf:RDF" mode="bs2:SignUp"/>
    
    <xsl:template match="*[ldt:base/@rdf:resource]" mode="bs2:AppListItem">
        <xsl:param name="active" as="xs:boolean?"/>
        
        <li>
            <xsl:if test="$active">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>

            <a href="{ldt:base/@rdf:resource[starts-with(., $ac:contextUri)]}" title="{ldt:base/@rdf:resource[starts-with(., $ac:contextUri)]}">
                <xsl:value-of>
                    <xsl:apply-templates select="." mode="ac:label"/>
                </xsl:value-of>
            </a>
        </li>
    </xsl:template>

    <xsl:template match="rdf:RDF" mode="xhtml:Body">
        <body>
            <xsl:apply-templates select="." mode="bs2:NavBar"/>

            <div id="content-body" class="container-fluid">
                <xsl:apply-templates mode="#current">
                    <xsl:sort select="ac:label(.)"/>
                </xsl:apply-templates>
            </div>

            <xsl:apply-templates select="." mode="bs2:Footer"/>
        </body>
    </xsl:template>
    
    <!-- ADD DATA -->
    
    <xsl:template match="rdf:RDF[$acl:mode = '&acl;Append'][$ldt:ontology]" mode="bs2:AddData" priority="1">
        <div class="btn-group pull-left">
            <button type="button" title="{ac:label(key('resources', 'add-data-title', document('translations.rdf')))}" class="btn btn-primary btn-add-data">
<!--                <xsl:apply-templates select="key('resources', '&ac;ConstructMode', document(ac:document-uri('&ac;')))" mode="apl:logo">
                    <xsl:with-param name="class" select="'btn btn-primary dropdown-toggle'"/>
                </xsl:apply-templates>-->
<!--                <xsl:value-of>
                    <xsl:apply-templates select="key('resources', '&ac;ConstructMode', document(ac:document-uri('&ac;')))" mode="ac:label"/>
                </xsl:value-of>-->
                <xsl:text>Add data</xsl:text>
            </button>
        </div>
    </xsl:template>
    
    <xsl:template match="*" mode="bs2:AddData"/>
    
    <!-- MODE LIST -->
        
    <xsl:template match="rdf:RDF[key('resources-by-type', '&http;Response')][not(key('resources-by-type', '&spin;ConstraintViolation'))]" mode="bs2:ModeList" priority="1"/>

    <xsl:template match="rdf:RDF[key('resources', key('resources', $ac:uri)/foaf:primaryTopic/@rdf:resource)/rdf:type/@rdf:resource = '&apl;Dataset']" mode="bs2:ModeList"/>

    <xsl:template match="rdf:RDF[$ac:uri]" mode="bs2:ModeList">
        <div class="btn-group pull-right">
            <button type="button" title="{ac:label(key('resources', 'mode-list-title', document('translations.rdf')))}">
                <xsl:apply-templates select="key('resources', $ac:mode, document(ac:document-uri('&ac;'))) | key('resources', $ac:mode, document(ac:document-uri('&apl;')))" mode="apl:logo">
                    <xsl:with-param name="class" select="'btn dropdown-toggle'"/>
                </xsl:apply-templates>
                <xsl:text> </xsl:text>
                <span class="caret"></span>
            </button>

            <ul class="dropdown-menu">
                <xsl:for-each select="key('resources-by-type', '&ac;Mode', document(ac:document-uri('&ac;'))) | key('resources', ('&ac;QueryEditorMode'), document(ac:document-uri('&ac;')))">
                    <xsl:sort select="ac:label(.)"/>
                    <xsl:apply-templates select="." mode="bs2:ModeListItem">
                        <xsl:with-param name="active" select="$ac:mode"/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>

    <!-- hide ac:EditMode if the current resource belongs is edited via its named graph (and has a separate Edit button) -->
    <xsl:template match="*[@rdf:about = '&ac;EditMode'][key('resources', $ac:uri, $main-doc)/void:inDataset/@rdf:resource]" mode="bs2:ModeListItem" priority="3"/>
    
    <!-- always show ac:DocumentModes and ac:QueryEditorMode; only show ac:ContainerModes for dh:Container (subclass) instances -->
    <xsl:template match="*[@rdf:about][$ac:uri][(rdf:type/@rdf:resource = '&ac;ContainerMode' and (key('resources', key('resources', $ac:uri, $main-doc)/core:stateOf/@rdf:resource, $main-doc)/sioc:has_parent/@rdf:resource) or key('resources', $ac:uri, $main-doc)/core:stateOf/@rdf:resource = $ldt:base) or rdf:type/@rdf:resource = '&ac;DocumentMode' or @rdf:about = '&ac;QueryEditorMode']" mode="bs2:ModeListItem" priority="1">
        <xsl:param name="active" as="xs:anyURI*"/>
        <xsl:variable name="href" select="$ac:uri" as="xs:anyURI"/>

        <li>
            <xsl:if test="@rdf:about = $active">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>

            <a href="{if (not(starts-with($href, $ac:contextUri))) then ac:build-uri((), map{ 'uri': string($href), 'mode': string(@rdf:about) }) else if (contains($ac:uri, '?')) then concat($ac:uri, '&amp;mode=', encode-for-uri(@rdf:about)) else ac:build-uri($ac:uri, map{ 'mode': string(@rdf:about) })}" title="{@rdf:about}">
                <xsl:apply-templates select="." mode="apl:logo"/>
            </a>
        </li>
    </xsl:template>
       
    <xsl:template match="*" mode="bs2:ModeListItem"/>

    <!-- CONTENT TOGGLE  -->
    
    <xsl:template match="rdf:RDF[key('resources', $ac:uri)/sioc:content]" mode="bs2:ContentToggle" priority="1">
        <div class="pull-right">
            <button class="btn" title="Collapse/expand document content">
                <xsl:apply-templates select="key('resources', 'toggle-content', document('translations.rdf'))" mode="apl:logo">
                    <xsl:with-param name="class" select="'btn'"/>
                </xsl:apply-templates>
            </button>
        </div>
    </xsl:template>

    <xsl:template match="rdf:RDF" mode="bs2:ContentToggle"/>

    <!-- HEADER  -->
        
    <xsl:template match="rdf:RDF" mode="bs2:MediaTypeList" priority="1">
        <div class="btn-group pull-right">
            <button type="button" title="{ac:label(key('resources', 'nav-bar-action-export-rdf-title', document('translations.rdf')))}">
                <xsl:apply-templates select="key('resources', '&ac;Export', document(ac:document-uri('&ac;')))" mode="apl:logo">
                    <xsl:with-param name="class" select="'btn dropdown-toggle'"/>
                </xsl:apply-templates>
                
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li>
                    <xsl:variable name="href" as="xs:anyURI">
                        <xsl:variable name="accept-href" select="ac:build-uri($ac:uri, map{ 'accept': 'application/rdf+xml' })" as="xs:anyURI"/>
                        <xsl:choose>
                            <xsl:when test="starts-with($ac:uri, $ldt:base)">
                                <xsl:sequence select="$accept-href"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="ac:build-uri($ac:uri, map{ 'uri': encode-for-uri($accept-href) })"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <a href="{$href}" title="application/rdf+xml">RDF/XML</a>
                </li>
                <li>
                    <xsl:variable name="href" as="xs:anyURI">
                        <xsl:variable name="accept-href" select="ac:build-uri($ac:uri, map{ 'accept': 'text/turtle' })" as="xs:anyURI"/>
                        <xsl:choose>
                            <xsl:when test="starts-with($ac:uri, $ldt:base)">
                                <xsl:sequence select="$accept-href"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="ac:build-uri($ac:uri, map{ 'uri': encode-for-uri($accept-href) })"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <a href="{$href}" title="text/turtle">Turtle</a>
                </li>
                <xsl:if test="key('resources', $ac:uri)">
                    <li class="divider"></li>
                    
                    <xsl:variable name="href" select="ac:build-uri($ac:uri, map{ 'debug': 'http://www.w3.org/ns/sparql-service-description#SPARQL11Query' })" as="xs:anyURI"/>
                    <li>
                        <a href="{$href}" title="application/sparql-query">SPARQL query</a>
                    </li>
                </xsl:if>
            </ul>
        </div>
    </xsl:template>
    
    <!-- HEADER  -->

    <!-- TO-DO: move http:Response templates to error.xsl -->
    <xsl:template match="*[rdf:type/@rdf:resource = '&http;Response'][lacl:requestAccess/@rdf:resource][$acl:Agent]" mode="bs2:Header" priority="2">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" select="'alert alert-info well'" as="xs:string?"/>

        <div>
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            </xsl:if>

            <h2>
                <xsl:apply-templates select="." mode="apl:logo"/>
                
                <a href="{if (not(starts-with(lacl:requestAccess/@rdf:resource, $ldt:base))) then ac:build-uri($ldt:base, map{ 'uri': string(lacl:requestAccess/@rdf:resource), 'access-to': string($ac:uri) }) else concat(lacl:requestAccess/@rdf:resource, '&amp;access-to=', encode-for-uri($ac:uri))}" class="btn btn-primary pull-right">Request access</a>
            </h2>
        </div>
    </xsl:template>
    
    <xsl:template match="*[rdf:type/@rdf:resource = '&http;Response']" mode="bs2:Header" priority="1">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" select="'alert alert-error well'" as="xs:string?"/>

        <div>
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            </xsl:if>

            <h2>
                <xsl:value-of>
                    <xsl:apply-templates select="." mode="ac:label"/>
                </xsl:value-of>
            </h2>
        </div>
    </xsl:template>

    <!-- FORM -->

    <xsl:template match="rdf:RDF[$ac:forClass = resolve-uri('ns/domain/system#File', $ldt:base)]" mode="bs2:Form" priority="3">
        <xsl:param name="modal" select="false()" as="xs:boolean" tunnel="yes"/>
        <xsl:param name="action" select="ac:build-uri(resolve-uri('uploads', $ldt:base), let $params := map{ 'forClass': string($ac:forClass) } return if ($modal) then map:merge(($params, map{ 'mode': '&ac;ModalMode' })) else $params)" as="xs:anyURI"/>
        <xsl:param name="enctype" select="'multipart/form-data'" as="xs:string?"/>

        <xsl:next-match> <!-- TO-DO: account for external $ac:uri -->
            <xsl:with-param name="action" select="$action"/>
            <xsl:with-param name="enctype" select="$enctype"/>
        </xsl:next-match>
    </xsl:template>

    <xsl:template match="rdf:RDF[$ac:forClass]" mode="bs2:Form" priority="2">
        <xsl:param name="modal" select="false()" as="xs:boolean" tunnel="yes"/>
        <xsl:param name="action" select="ac:build-uri($a:graphStore, let $params := map{ 'forClass': string($ac:forClass) } return if ($modal) then map:merge(($params, map{ 'mode': '&ac;ModalMode' })) else $params)" as="xs:anyURI"/>
        <xsl:param name="enctype" as="xs:string?"/>
        <xsl:param name="create-resource" select="true()" as="xs:boolean"/>

        <xsl:next-match> <!-- TO-DO: account for external $ac:uri -->
            <xsl:with-param name="action" select="$action"/>
            <xsl:with-param name="enctype" select="$enctype"/>
            <xsl:with-param name="create-resource" select="$create-resource"/>
        </xsl:next-match>
    </xsl:template>
    
    <!-- override form action in Client template -->
    <xsl:template match="rdf:RDF[$ac:mode = '&ac;EditMode']" mode="bs2:Form" priority="2">
        <xsl:param name="modal" select="false()" as="xs:boolean" tunnel="yes"/>
        <xsl:param name="action" select="if (empty($ldt:base)) then ac:build-uri($ac:contextUri, map{ 'uri': string($ac:uri), '_method': 'PUT', 'mode': for $mode in $ac:mode return string($mode) }) else ac:build-uri($ac:uri, map{ '_method': 'PUT', 'mode': for $mode in $ac:mode return string($mode) })" as="xs:anyURI"/>

        <xsl:next-match>
            <xsl:with-param name="action" select="$action" as="xs:anyURI"/>
        </xsl:next-match>
    </xsl:template>
    
    <!-- hide object blank nodes (that only have a single rdf:type property) from constructed models -->
    <xsl:template match="*[@rdf:nodeID][$ac:forClass][not(* except rdf:type)]" mode="bs2:Form" priority="2"/>

    <!-- TARGET CONTAINER -->
    
    <xsl:template match="rdf:RDF" mode="bs2:TargetContainer">
        <fieldset class="action-container">
            <div class="control-group">
                <label class="control-label" for="input-container">
                    <xsl:value-of>
                        <xsl:apply-templates select="key('resources', '&dh;Container', document(ac:document-uri('&dh;')))" mode="ac:label"/>
                    </xsl:value-of>
                </label>
                <div class="controls">
                    <span>
                        <xsl:apply-templates select="key('resources', $ac:uri, $main-doc)" mode="apl:Typeahead">
                            <xsl:with-param name="disabled" select="true()"/>
                        </xsl:apply-templates>
                    </span>
                    <span class="help-inline">Resource</span>
                </div>
            </div>
        </fieldset>
    </xsl:template>
    
    <!-- NAVBAR ACTIONS -->

    <xsl:template match="rdf:RDF" mode="bs2:NavBarActions" priority="1">
        <xsl:if test="$acl:Agent//@rdf:about">
                <div class="pull-right">
                    <form action="{ac:build-uri($ac:uri, map{ '_method': 'DELETE' })}" method="post">
                        <button type="submit" title="{ac:label(key('resources', 'nav-bar-action-delete-title', document('translations.rdf')))}">
                            <xsl:apply-templates select="key('resources', '&ac;Delete', document(ac:document-uri('&ac;')))" mode="apl:logo">
                                <xsl:with-param name="class" select="'btn'"/>
                            </xsl:apply-templates>
                        </button>
                    </form>
                </div>

            <xsl:if test="not($ac:mode = '&ac;EditMode')">
                <div class="pull-right">
                    <xsl:variable name="graph-uri" select="ac:build-uri($ac:uri, map{ 'mode': '&ac;EditMode' })" as="xs:anyURI"/>
                    <button title="{ac:label(key('resources', 'nav-bar-action-edit-graph-title', document('translations.rdf')))}">
                        <xsl:apply-templates select="key('resources', '&ac;EditMode', document(ac:document-uri('&ac;')))" mode="apl:logo">
                            <xsl:with-param name="class" select="'btn'"/>
                        </xsl:apply-templates>

                        <input type="hidden" value="{$graph-uri}"/>
                    </button>
                </div>
            </xsl:if>
            
            <div class="pull-right">
                <form action="{$ac:uri}?ban=true" method="post">
                    <!--<input type="hidden" name="ban" value="true"/>-->
                    <button type="submit" title="{ac:label(key('resources', 'nav-bar-action-refresh-title', document('translations.rdf')))}">
                        <xsl:apply-templates select="key('resources', '&aplt;Ban', document(ac:document-uri('&aplt;')))" mode="apl:logo">
                            <xsl:with-param name="class" select="'btn'"/>
                        </xsl:apply-templates>
                    </button>
                </form>
            </div>
            
            <div class="btn-group pull-right">
                <button type="button" title="{ac:label(key('resources', 'acl-list-title', document('translations.rdf')))}">
                    <xsl:apply-templates select="key('resources', '&acl;Access', document(ac:document-uri('&acl;')))" mode="apl:logo">
                        <xsl:with-param name="class" select="'btn dropdown-toggle'"/>
                    </xsl:apply-templates>
                    <xsl:text> </xsl:text>
                    <span class="caret"></span>
                </button>

                <ul class="dropdown-menu">
                    <xsl:for-each select="key('resources-by-subclass', '&acl;Access', document(ac:document-uri('&acl;')))">
                        <xsl:sort select="ac:label(.)"/>
                        <xsl:apply-templates select="." mode="bs2:AccessListItem">
                            <xsl:with-param name="enabled" select="$acl:mode"/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*[@rdf:about]" mode="bs2:AccessListItem" priority="1">
        <xsl:param name="enabled" as="xs:anyURI*"/>
        <xsl:variable name="href" select="$ac:uri" as="xs:anyURI"/>

        <li>
            <a title="{@rdf:about}">
                <xsl:choose>
                    <xsl:when test="@rdf:about = $enabled">
                        <xsl:text>&#x2714;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#x2718;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <xsl:value-of>
                    <xsl:apply-templates select="." mode="ac:label"/>
                </xsl:value-of>
            </a>
        </li>
    </xsl:template>
        
    <!-- SETTINGS -->
    
    <xsl:template match="rdf:RDF" mode="bs2:Settings" priority="1">
        <xsl:if test="$acl:Agent//@rdf:about and $lapp:Application//*[ldt:base/@rdf:resource = $ldt:base]/rdf:type/@rdf:resource = '&lapp;EndUserApplication'">
            <div class="btn-group pull-right">
                <button type="button" title="{ac:label(key('resources', 'nav-bar-action-settings-title', document('translations.rdf')))}">
                    <xsl:apply-templates select="key('resources', 'settings', document('translations.rdf'))" mode="apl:logo">
                        <xsl:with-param name="class" select="'btn dropdown-toggle'"/>
                    </xsl:apply-templates>
                    <xsl:text> </xsl:text>
                    <span class="caret"></span>
                </button>

                <ul class="dropdown-menu">
                    <li>
                        <xsl:for-each select="$lapp:Application">
                            <a href="{key('resources', //*[ldt:base/@rdf:resource = $ldt:base]/lapp:adminApplication/(@rdf:resource, @rdf:nodeID))/ldt:base/@rdf:resource[starts-with(., $ac:contextUri)]}" target="_blank">
                                Administration
                            </a>
                        </xsl:for-each>
                    </li>
                    <li>
                        <a href="{resolve-uri('ns', $ldt:base)}" target="_blank">Namespace</a>
                    </li>
                    <li>
                        <a href="https://linkeddatahub.com/linkeddatahub/docs/" target="_blank">Documentation</a>
                    </li>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- BLOCK -->
    
    <!-- embed file content -->
    <xsl:template match="*[*][dct:format]" mode="bs2:Block" priority="2">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" as="xs:string?"/>

        <div>
            <xsl:if test="$id">
                <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$class">
                <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
            </xsl:if>

            <xsl:apply-templates select="." mode="bs2:Header"/>

            <xsl:apply-templates select="." mode="bs2:PropertyList"/>
            
            <xsl:variable name="media-type" select="substring-after(dct:format[1]/@rdf:resource, 'http://www.sparontologies.net/mediatype/')" as="xs:string"/>
            <object data="{@rdf:about}" type="{$media-type}"></object>
        </div>
    </xsl:template>

    <!-- suppress types in property list - we show them in the bs2:Header instead -->
    <xsl:template match="rdf:type[@rdf:resource]" mode="bs2:PropertyList"/>
    
    <!-- SPARQL QUERY -->
    
    <!-- Query over POST does not work -->
    <xsl:template match="*[sp:text]" mode="bs2:Actions" priority="2">
        <xsl:param name="method" select="'get'" as="xs:string"/>
        <xsl:param name="action" select="xs:anyURI('')" as="xs:anyURI"/>
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="class" as="xs:string?"/>
        <xsl:param name="accept-charset" select="'UTF-8'" as="xs:string?"/>
        <xsl:param name="enctype" as="xs:string?"/>
        
        <div class="pull-right">
            <form method="{$method}" action="{$action}">
                <xsl:if test="$id">
                    <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="$class">
                    <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="$accept-charset">
                    <xsl:attribute name="accept-charset"><xsl:value-of select="$accept-charset"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="$enctype">
                    <xsl:attribute name="enctype"><xsl:value-of select="$enctype"/></xsl:attribute>
                </xsl:if>

                <xsl:for-each select="apl:service/@rdf:resource">
                    <input type="hidden" name="service" value="{.}"/>
                </xsl:for-each>
                <input type="hidden" name="mode" value="&ac;QueryEditorMode"/>
                <input type="hidden" name="query" value="{sp:text}"/>

                <button type="submit" class="btn btn-primary">Open</button>
            </form>
        </div>
        
        <xsl:next-match/>
    </xsl:template>

    <!-- FOOTER -->
    
    <xsl:template match="rdf:RDF" mode="bs2:Footer">
        <div class="footer container-fluid">
            <div class="row-fluid">
                <div class="offset2 span8">
                    <div class="span3">
                        <h2 class="nav-header">About</h2>
                        <ul class="nav nav-list">
                            <li>
                                <a href="https://linkeddatahub.com/linkeddatahub/docs/about/" target="_blank">LinkedDataHub</a>
                            </li>
                            <li>
                                <a href="https://atomgraph.com" target="_blank">AtomGraph</a>
                            </li>
                        </ul>
                    </div>
                    <div class="span3">
                        <h2 class="nav-header">Resources</h2>
                        <ul class="nav nav-list">
                            <li>
                                <a href="https://linkeddatahub.com/linkeddatahub/docs/" target="_blank">Documentation</a>
                            </li>
                            <li>
                                <a href="https://www.youtube.com/channel/UCtrdvnVjM99u9hrjESwfCeg" target="_blank">Screencasts</a>
                            </li>
                            <li>
                                <a href="https://linkeddatahub.com/demo/" target="_blank">Demo apps</a> <!-- built-in Context -->
                            </li>
                        </ul>
                    </div>
                    <div class="span3">
                        <h2 class="nav-header">Support</h2>
                        <ul class="nav nav-list">
                            <li>
                                <a href="https://groups.io/g/linkeddatahub" target="_blank">Mailing list</a>
                            </li>
                            <li>
                                <a href="https://github.com/AtomGraph/LinkedDataHub/issues" target="_blank">Report issues</a>
                            </li>
                            <li>
                                <a href="mailto:support@linkeddatahub.com">Contact support</a>
                            </li>
                        </ul>
                    </div>
                    <div class="span3">
                        <h2 class="nav-header">Follow us</h2>
                        <ul class="nav nav-list">
                            <li>
                                <a href="https://twitter.com/atomgraphhq" target="_blank">@atomgraphhq</a>
                            </li>
                            <li>
                                <a href="https://github.com/AtomGraph" target="_blank">github.com/AtomGraph</a>
                            </li>
                            <li>
                                <a href="https://www.facebook.com/AtomGraph" target="_blank">facebook.com/AtomGraph</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
</xsl:stylesheet>