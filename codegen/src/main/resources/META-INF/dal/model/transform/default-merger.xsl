<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="../../common.xsl"/>
<xsl:output method="html" indent="no" media-type="text/plain" encoding="utf-8"/>
<xsl:param name="package"/>
<xsl:variable name="space" select="' '"/>
<xsl:variable name="empty" select="''"/>
<xsl:variable name="empty-line" select="'&#x0A;'"/>

<xsl:template match="/">
   <xsl:apply-templates select="/model"/>
</xsl:template>

<xsl:template match="model">
   <xsl:value-of select="$empty"/>package <xsl:value-of select="$package"/>;<xsl:value-of select="$empty-line"/>
   <xsl:value-of select="$empty-line"/>
   <xsl:call-template name='import-list'/>
   <xsl:value-of select="$empty"/>public class DefaultMerger implements IVisitor {<xsl:value-of select="$empty-line"/>
   <xsl:call-template name='method-commons'/>
   <xsl:call-template name='method-merge'/>
   <xsl:call-template name='method-visit'/>
   <xsl:value-of select="$empty"/>}<xsl:value-of select="$empty-line"/>
</xsl:template>

<xsl:template name="import-list">
   <xsl:value-of select="$empty"/>import java.util.Stack;<xsl:value-of select="$empty-line"/>
   <xsl:value-of select="$empty-line"/>
   <xsl:value-of select="$empty"/>import <xsl:value-of select="/model/@model-package"/>.IEntity;<xsl:value-of select="$empty-line"/>
   <xsl:value-of select="$empty"/>import <xsl:value-of select="/model/@model-package"/>.IVisitor;<xsl:value-of select="$empty-line"/>
   <xsl:if test="entity/any">
      <xsl:value-of select="$empty"/>import <xsl:value-of select="entity/any/@entity-package"/>.<xsl:value-of select='entity/any/@entity-class'/>;<xsl:value-of select="$empty-line"/>
   </xsl:if>
   <xsl:for-each select="entity">
      <xsl:sort select="@name"/>

      <xsl:value-of select="$empty"/>import <xsl:value-of select="@entity-package"/>.<xsl:value-of select='@entity-class'/>;<xsl:value-of select="$empty-line"/>
   </xsl:for-each>
   <xsl:value-of select="$empty-line"/>
</xsl:template>

<xsl:template name="method-commons">
<xsl:variable name="model" select="//entity[@root='true']"/>
   private Stack<xsl:call-template name="lt"/>Object<xsl:call-template name="gt"/> m_objs = new Stack<xsl:call-template name="lt"/>Object<xsl:call-template name="gt"/>();

   private <xsl:value-of select="$model/@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="$model/@field-name"/>;

   public DefaultMerger() {
   }

   public DefaultMerger(<xsl:value-of select="$model/@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="$model/@param-name"/>) {
      <xsl:value-of select="$model/@field-name"/> = <xsl:value-of select="$model/@param-name"/>;
      m_objs.push(<xsl:value-of select="$model/@param-name"/>);
   }

   public <xsl:value-of select="$model/@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="$model/@get-method"/>() {
      return <xsl:value-of select="$model/@field-name"/>;
   }

   protected Stack<xsl:call-template name="generic-type"><xsl:with-param name="type" select="'Object'"/></xsl:call-template> getObjects() {
      return m_objs;
   }

   public <xsl:call-template name="lt"/>T<xsl:call-template name="gt"/> void merge(IEntity<xsl:call-template name="lt"/>T<xsl:call-template name="gt"/> to, IEntity<xsl:call-template name="lt"/>T<xsl:call-template name="gt"/> from) {
      m_objs.push(to);
      from.accept(this);
      m_objs.pop();
   }
</xsl:template>

<xsl:template name="method-merge">
   <xsl:for-each select="entity">
      <xsl:sort select="@visit-method"/>

      <xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   protected void <xsl:value-of select="@merge-method"/>(<xsl:value-of select="@entity-class"/> to, <xsl:value-of select="@entity-class"/> from) {<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>      to.mergeAttributes(from);<xsl:value-of select="$empty-line"/>
      <xsl:if test="any">
         <xsl:value-of select="$empty"/>      to.<xsl:value-of select="any/@get-method"/>().addAll(from.<xsl:value-of select="any/@get-method"/>());<xsl:value-of select="$empty-line"/>
      </xsl:if>
      <xsl:for-each select="element">
         <xsl:choose>
            <xsl:when test="@list='true' or @set='true'">
               <xsl:value-of select="$empty"/>      to.<xsl:value-of select="@get-method"/>().addAll(from.<xsl:value-of select="@get-method"/>());<xsl:value-of select="$empty-line"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$empty"/>      to.<xsl:value-of select="@set-method"/>(from.<xsl:value-of select="@get-method"/>());<xsl:value-of select="$empty-line"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      <xsl:value-of select="$empty"/>   }<xsl:value-of select="$empty-line"/>
   </xsl:for-each>
</xsl:template>

<xsl:template name="method-visit">
   <xsl:if test="entity/any">
      <xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   @Override<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   public void <xsl:value-of select="entity/any/@visit-method"/>(Any any) {<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>      // do nothing here<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   }<xsl:value-of select="$empty-line"/>
   </xsl:if>
   <xsl:for-each select="entity">
      <xsl:sort select="@visit-method"/>

      <xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   @Override<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   public void <xsl:value-of select="@visit-method"/>(<xsl:value-of select="@entity-class"/> from) {<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="'      '"/><xsl:value-of select="@entity-class"/> to = (<xsl:value-of select="@entity-class"/>) m_objs.peek();<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="'      '"/><xsl:value-of select="@merge-method"/>(to, from);<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="'      '"/><xsl:value-of select="@visit-children-method"/>(to, from);<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   }<xsl:value-of select="$empty-line"/>
      <xsl:call-template name="method-visit-children"/>
   </xsl:for-each>
</xsl:template>

<xsl:template name="method-visit-children">
   <xsl:value-of select="$empty-line"/>
   <xsl:value-of select="$empty"/>   protected void <xsl:value-of select="@visit-children-method"/>(<xsl:value-of select="@entity-class"/> to, <xsl:value-of select="@entity-class"/> from) {<xsl:value-of select="$empty-line"/>
   <xsl:variable name="current" select="."/>

   <xsl:if test="entity-ref[not(@render='false')]">
      <xsl:for-each select="entity-ref[not(@render='false')]">
         <xsl:variable name="name" select="@name"/>
         <xsl:variable name="entity" select="//entity[@name=$name]"/>
         <xsl:choose>
            <xsl:when test="@list='true' or @map='true'">
               <xsl:value-of select="$empty"/>      for (<xsl:value-of select="$entity/@entity-class"/> source : from.<xsl:value-of select="@get-method"/>()<xsl:if test="@map='true'">.values()</xsl:if>) {<xsl:value-of select="$empty-line"/>
               <xsl:choose>
                  <xsl:when test="($entity/attribute|$entity/element)[@key='true']">
                     <xsl:value-of select="'         '"/><xsl:value-of select="$entity/@entity-class"/> target = to.<xsl:value-of select="@find-method"/>(<xsl:call-template name="get-key"/>);<xsl:value-of select="$empty-line"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="'         '"/><xsl:value-of select="$entity/@entity-class"/> target = null;<xsl:value-of select="$empty-line"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         if (target == null) {<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>            target = new <xsl:value-of select="$entity/@entity-class"/>(<xsl:call-template name="get-key"/>);<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>            to.<xsl:value-of select="@add-method"/>(target);<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         }<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         m_objs.push(target);<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         source.accept(this);<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         m_objs.pop();<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$empty"/>      if (from.<xsl:value-of select="@get-method"/>() != null) {<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         m_objs.push(to);<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         from.<xsl:value-of select="@get-method"/>().accept(this);<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         m_objs.pop();<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:if test="position()!=last()">
            <xsl:value-of select="$empty-line"/>
         </xsl:if>
      </xsl:for-each>
   </xsl:if>
   <xsl:if test="any">
      <xsl:value-of select="$empty"/>      to.<xsl:value-of select="any/@get-method"/>().addAll(from.<xsl:value-of select="any/@get-method"/>());<xsl:value-of select="$empty-line"/>
   </xsl:if>
   <xsl:value-of select="$empty"/>   }<xsl:value-of select="$empty-line"/>
</xsl:template>

<xsl:template name="merge-children">
   <xsl:param name="current" select="."/>

   <xsl:variable name="name" select="@name"/>
   <xsl:for-each select="//entity[entity-ref[@name=$name and not(@render='false')]]">
      <xsl:variable name="entity" select="."/>
      <xsl:variable name="variable">
         <xsl:choose>
            <xsl:when test="@param-name=$current/@param-name">
               <xsl:value-of select="'_'"/>
               <xsl:value-of select="@param-name"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="@param-name"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="position()=1"><xsl:value-of select="'      '"/></xsl:if>
      <xsl:value-of select="$empty"/>if (parent instanceof <xsl:value-of select="@entity-class"/>) {<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>         <xsl:value-of select="'         '"/><xsl:value-of select="@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="$variable"/> = (<xsl:value-of select="@entity-class"/>) parent;<xsl:value-of select="$empty-line"/>
      <xsl:variable name="many" select="count(entity-ref[@name=$name and not(@render='false')])!=1"></xsl:variable>
      <xsl:if test="$many">
         <xsl:value-of select="$empty"/>         String tag = m_tags.peek();<xsl:value-of select="$empty-line"/>
      </xsl:if>
      <xsl:variable name="indent">
         <xsl:choose>
            <xsl:when test="$many"><xsl:value-of select="'            '"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="'         '"/></xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$empty-line"/>
      <xsl:for-each select="entity-ref[@name=$name and not(@render='false')]">
         <xsl:if test="$many">
            <xsl:if test="position()=1"><xsl:value-of select="'         '"/></xsl:if>
            <xsl:value-of select="$empty"/>if (<xsl:value-of select="@upper-name"/>.equals(tag)) {<xsl:value-of select="$empty-line"/>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="@list='true' and not(($current/attribute | $current/element)[@key='true'])">
               <xsl:value-of select="$indent"/><xsl:value-of select="$variable"/>.<xsl:value-of select="@add-method"/>(<xsl:value-of select="$current/@param-name"/>);<xsl:value-of select="$empty"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="@list='true' or @map='true'">
                     <xsl:value-of select="$indent"/>old = <xsl:value-of select="$entity/@param-name"/>.<xsl:value-of select="@find-method"/>(<xsl:value-of select="$empty"/>
                     <xsl:for-each select="($current/attribute | $current/element)[@key='true']">
                        <xsl:value-of select="$current/@param-name"/>.<xsl:value-of select="@get-method"/>()<xsl:value-of select="$empty"/>
                        <xsl:if test="position()!=last()">, </xsl:if>
                     </xsl:for-each>
                     <xsl:value-of select="$empty"/>);<xsl:value-of select="$empty-line"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$indent"/>old = <xsl:value-of select="$variable"/>.<xsl:value-of select="@get-method"/>();<xsl:value-of select="$empty-line"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$indent"/>if (old == null) {<xsl:value-of select="$empty-line"/>
                 <xsl:value-of select="$indent"/>   old = <xsl:value-of select="$empty"/>
                 <xsl:call-template name="new-instance">
                    <xsl:with-param name="entity" select="$current"/>
                    <xsl:with-param name="variable" select="$current/@param-name"/>
                 </xsl:call-template>
                 <xsl:value-of select="$empty"/>;<xsl:value-of select="$empty-line"/>
               <xsl:choose>
                  <xsl:when test="@list='true' or @map='true'">
                     <xsl:value-of select="$indent"/><xsl:value-of select="'   '"/><xsl:value-of select="$variable"/>.<xsl:value-of select="@add-method"/>(old);<xsl:value-of select="$empty-line"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$indent"/><xsl:value-of select="'   '"/><xsl:value-of select="$variable"/>.<xsl:value-of select="@set-method"/>(old);<xsl:value-of select="$empty-line"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:value-of select="$indent"/>}<xsl:value-of select="$empty-line"/>
                 <xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$indent"/><xsl:value-of select="$current/@merge-method"/>(old, <xsl:value-of select="$current/@param-name"/>);<xsl:value-of select="$empty"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:if test="$many">
            <xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>         }<xsl:value-of select="$empty"/>
            <xsl:if test="position()!=last()"> else </xsl:if>
         </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty"/>
      <xsl:if test="position()!=last()"> else </xsl:if>
   </xsl:for-each>
   <xsl:value-of select="$empty-line"/>
</xsl:template>

<xsl:template name="visit-entity-refs">
   <xsl:param name="current" select="."/>

   <xsl:for-each select="entity-ref">
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="entity" select="//entity[@name=$name]"/>
      <xsl:choose>
         <xsl:when test="@list='true'">
            <xsl:value-of select="$empty"/>      for (<xsl:value-of select="$entity/@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="$entity/@param-name"/> : <xsl:value-of select="$current/@param-name"/>.<xsl:value-of select="@get-method"/>()) {<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>         <xsl:value-of select="'   '"/><xsl:value-of select="$entity/@visit-method"/>(<xsl:value-of select="$entity/@param-name"/>);<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
         </xsl:when>
         <xsl:when test="@map='true'">
            <xsl:value-of select="$empty"/>      for (<xsl:value-of select="$entity/@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="$entity/@param-name"/> : <xsl:value-of select="$current/@param-name"/>.<xsl:value-of select="@get-method"/>().values()) {<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>         <xsl:value-of select="'   '"/><xsl:value-of select="$entity/@visit-method"/>(<xsl:value-of select="$entity/@param-name"/>);<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
         </xsl:when>
      </xsl:choose>
      <xsl:if test="position()!=last()">
         <xsl:value-of select="$empty-line"/>
      </xsl:if>
   </xsl:for-each>
</xsl:template>

<xsl:template name="new-instance">
   <xsl:param name="entity"/>
   <xsl:param name="variable"/>
   
   <xsl:value-of select="$empty"/>new <xsl:value-of select="$entity/@entity-class"/>(<xsl:value-of select="$empty"/>
   <xsl:for-each select="($entity/attribute | $entity/element)[@key='true']">
      <xsl:value-of select="$variable"/>.<xsl:value-of select="@get-method"/>()<xsl:value-of select="$empty"/>
      <xsl:if test="position()!=last()">, </xsl:if>
   </xsl:for-each>
   <xsl:value-of select="$empty"/>)<xsl:value-of select="$empty"/>
</xsl:template>

<xsl:template name="get-key">
   <xsl:variable name="name" select="@name"/>
   <xsl:variable name="entity" select="//entity[@name=$name]"/>
   <xsl:for-each select="($entity/attribute|$entity/element)[@key='true']">
      <xsl:value-of select="$empty"/>source.<xsl:value-of select="@get-method"/>()<xsl:value-of select="$empty"/>
      <xsl:if test="position()!=last()">, </xsl:if>
   </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
