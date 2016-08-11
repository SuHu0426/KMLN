<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/2000/svg"
		xmlns:svg="http://www.w3.org/2000/svg"
		xmlns:xlink="http://www.w3.org/1999/xlink">

<xsl:key name="switchnm" match="switch" use="@name"/> 

<xsl:template match="/">
<xsl:text>
</xsl:text>
<svg width="100%" height="100%" version="1.1"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink">
 <!-- <xsl:apply-templates select="host"/>
  <xsl:apply-templates select="switch"/>-->
   <xsl:apply-templates select="/project/*"/> 
  </svg><xsl:text>
</xsl:text> 
</xsl:template>

<xsl:template match="/project/superclass">
  <xsl:variable name="superclss_pos" select="position()"/>
  <xsl:apply-templates select="host"> 
    <xsl:with-param name="superclss_pos" select="$superclss_pos"/>
  </xsl:apply-templates>
  <image x="{150 + 525*($superclss_pos - 2)}" y="300" width="50" height="100" xlink:href="./images/computer.png" />
  <text x="{150 + 525*($superclss_pos - 2)}" y="400"><xsl:value-of select="@physical_host"/></text>
  <line x1="{175 + 525*($superclss_pos - 2)}" y1="210" x2="{175 + 525*($superclss_pos - 2)}" y2="300" style="stroke: #000000; stroke-width: 2;"/>
  <xsl:apply-templates select="switch"> 
    <xsl:with-param name="superclss_pos" select="$superclss_pos"/>
  </xsl:apply-templates>
</xsl:template> 


<!-- Host block -->
<xsl:template match="host">
  <xsl:param name="superclss_pos"/> 
  <xsl:variable name="position" select="position()"/>
  <xsl:variable name="host_x" select="40 + 230 * ($position - 1) + 500 * ($superclss_pos - 2) "/>
  <image x="{$host_x}" y="40" width="50" height="100" xlink:href="./images/vm.png" />
  <text x="{$host_x}" y="120"><xsl:value-of select="@name"/></text>
  <line x1="{$host_x+23}" y1="120" x2="{$host_x+23}" y2="220" style="stroke: #000000; stroke-width: 2;"/>
  <text x="{$host_x+55}" y="40">virTech = <xsl:value-of select="@virTech"/></text>
  <text x="{$host_x+55}" y="55">IP = <xsl:value-of select="network/@address"/></text>
  <xsl:apply-templates select="network">
    <xsl:with-param name="host_x" select="$host_x"/>
  </xsl:apply-templates>
</xsl:template>

<!-- network block -->
<xsl:template match="network">
  <xsl:param name="host_x"/> 
  <xsl:variable name="net_position" select="position()"/>
</xsl:template>

<!-- switch block -->
<xsl:template match="switch">
  <xsl:param name="superclss_pos"/> 
  <xsl:variable name="switch_pos" select="position()"/>
  <image x="{145 + ($switch_pos - 4) * 525}" y="200" width="60" height="50" xlink:href="./images/switch.png" />
  <text x="{180 + ($switch_pos - 4) * 525}" y="250"><xsl:value-of select="@switchType"/></text>
  <text x="{180 + ($switch_pos - 4) * 525}" y="265">tap = <xsl:value-of select="@tap"/></text>
  <text x="{180 + ($switch_pos - 4) * 525}" y="280"><xsl:value-of select="@tun_iface"/>: <xsl:value-of select="@tun_address"/></text>
</xsl:template>

<!-- Get attribute name and value -->
<xsl:template match="@*">
  <xsl:if test="name(.) != 'name'">
    <xsl:text>
      </xsl:text>
    <xsl:value-of select="name(.)"/><xsl:text> </xsl:text><xsl:value-of select="." />
  </xsl:if>
</xsl:template>

<!-- users block -->
<xsl:template match="users">
<xsl:text>users {</xsl:text>
  <xsl:apply-templates select="user"/>
<xsl:text>
    }</xsl:text>
</xsl:template>
<xsl:template match="user">
  <xsl:text>
      </xsl:text><xsl:value-of select="@username"/><xsl:text> </xsl:text><xsl:value-of select="@password" />
</xsl:template>

<!-- groups block -->
<xsl:template match="groups">
<xsl:text>groups {</xsl:text>
  <xsl:apply-templates select="group"/>
  <xsl:apply-templates select="groupuser"/>
<xsl:text>
    }</xsl:text>
</xsl:template>
<xsl:template match="group">
  <xsl:text>
      </xsl:text><xsl:value-of select="@groupname"/><xsl:text> {</xsl:text>
  <xsl:apply-templates select="groupuser"/>
<xsl:text>
      }</xsl:text>
</xsl:template>
<xsl:template match="groupuser">
    <xsl:text>
        </xsl:text><xsl:value-of select="@user"/>
</xsl:template>

<!-- Get superclass attributes. -->
<xsl:template name="get_superclass_att">
  <xsl:if test="not(@term) and ../@term">
    <xsl:text>
      term </xsl:text><xsl:value-of select="../@term" />
  </xsl:if>
  <xsl:if test="not(@template) and ../@template">
    <xsl:text>
      template </xsl:text><xsl:value-of select="../@template" />
  </xsl:if>
  <xsl:if test="not(@swap) and ../@swap">
    <xsl:text>
      swap </xsl:text><xsl:value-of select="../@swap" />
  </xsl:if>
  <xsl:if test="not(@size) and ../@size">
    <xsl:text>
      size </xsl:text><xsl:value-of select="../@size" />
  </xsl:if>
  <xsl:if test="not(@free_space) and ../@free_space">
    <xsl:text>
      free_space </xsl:text><xsl:value-of select="../@free_space" />
  </xsl:if>
  <xsl:if test="not(@qcow) and ../@qcow">
    <xsl:text>
      qcow </xsl:text><xsl:value-of select="../@qcow" />
  </xsl:if>
  <xsl:if test="not(@cow_filesystem) and ../@cow_filesystem">
    <xsl:text>
      cow_filesystem </xsl:text><xsl:value-of select="../@cow_filesystem" />
  </xsl:if>
  <xsl:if test="not(@format) and ../@format">
    <xsl:text>
      format </xsl:text><xsl:value-of select="../@format" />
  </xsl:if>
  <xsl:if test="not(@memory) and ../@memory">
    <xsl:text>
      memory </xsl:text><xsl:value-of select="../@memory" />
  </xsl:if>
  <xsl:if test="not(@service_host) and ../@service_host">
    <xsl:text>
      service_host </xsl:text><xsl:value-of select="../@service_host" />
  </xsl:if>
  <xsl:if test="not(@kernel) and ../@kernel">
    <xsl:text>
      kernel </xsl:text><xsl:value-of select="../@kernel" />
  </xsl:if>
  <xsl:if test="not(@modules) and ../@modules">
    <xsl:text>
      modules </xsl:text><xsl:value-of select="../@modules" />
  </xsl:if>
  <xsl:if test="not(@kvm) and ../@kvm">
    <xsl:text>
      kvm </xsl:text><xsl:value-of select="../@kvm" />
  </xsl:if>
  <xsl:if test="not(@xen) and ../@xen">
    <xsl:text>
      xen </xsl:text><xsl:value-of select="../@xen" />
  </xsl:if>
  <xsl:if test="not(@color) and ../@color">
    <xsl:text>
      color </xsl:text><xsl:value-of select="../@color" />
  </xsl:if>
  <xsl:if test="not(@root_password) and ../@root_password">
    <xsl:text>
      root_password </xsl:text><xsl:value-of select="../@root_password" />
  </xsl:if>
  <xsl:if test="not(@nameserver) and ../@nameserver">
    <xsl:text>
      nameserver </xsl:text><xsl:value-of select="../@nameserver" />
  </xsl:if>
  <xsl:if test="not(@boot_order) and ../@boot_order">
    <xsl:text>
      boot_order </xsl:text><xsl:value-of select="../@boot_order" />
  </xsl:if>
  <xsl:if test="not(@owner) and ../@owner">
    <xsl:text>
      owner </xsl:text><xsl:value-of select="../@owner" />
  </xsl:if>
  <xsl:if test="not(@users) and ../@users">
    <xsl:text>
      users </xsl:text><xsl:value-of select="../@users" />
  </xsl:if>
  <xsl:if test="not(@group) and ../@group">
    <xsl:text>
      group </xsl:text><xsl:value-of select="../@group" />
  </xsl:if>
  <xsl:if test="not(@groups) and ../@groups">
    <xsl:text>
      groups </xsl:text><xsl:value-of select="../@groups" />
  </xsl:if>
  <xsl:if test="not(@sudo) and ../@sudo">
    <xsl:text>
      sudo </xsl:text><xsl:value-of select="../@sudo" />
  </xsl:if>
  <xsl:if test="not(@nice) and ../@nice">
    <xsl:text>
      nice </xsl:text><xsl:value-of select="../@nice" />
  </xsl:if>
  <xsl:if test="not(@family) and ../@family">
    <xsl:text>
      family </xsl:text><xsl:value-of select="../@family" />
  </xsl:if>
  <xsl:if test="not(@shutdown) and ../@shutdown">
    <xsl:text>
      shutdown </xsl:text><xsl:value-of select="../@shutdown" />
  </xsl:if>
  <xsl:if test="not(@files) and ../@files">
    <xsl:text>
      files </xsl:text><xsl:value-of select="../@files" />
  </xsl:if>
  <xsl:if test="not(@startup) and ../@startup">
    <xsl:text>
      startup </xsl:text><xsl:value-of select="../@startup" />
  </xsl:if>
  <xsl:if test="not(@mount) and ../@mount">
    <xsl:text>
      mount </xsl:text><xsl:value-of select="../@mount" />
  </xsl:if>
</xsl:template>

<!-- Get superclass network block attributes. -->
<xsl:template name="get_superclass_network_att">
  <xsl:if test="not(@netmask) and ../../network/@netmask">
    <xsl:text>
      netmask </xsl:text><xsl:value-of select="../../network/@netmask" />
  </xsl:if>
  <xsl:if test="not(@gateway) and ../../network/@gateway">
    <xsl:text>
      gateway </xsl:text><xsl:value-of select="../../network/@gateway" />
  </xsl:if>
  <xsl:if test="not(@address) and ../../network/@address">
    <xsl:text>
      address </xsl:text><xsl:value-of select="../../network/@address" />
  </xsl:if>
  <xsl:if test="not(@broadcast) and ../../network/@broadcast">
    <xsl:text>
      broadcast </xsl:text><xsl:value-of select="../../network/@broadcast" />
  </xsl:if>
  <xsl:if test="not(@mac) and ../../network/@mac">
    <xsl:text>
      mac </xsl:text><xsl:value-of select="../../network/@mac" />
  </xsl:if>
  <xsl:if test="not(@auto) and ../../network/@auto">
    <xsl:text>
      auto </xsl:text><xsl:value-of select="../../network/@auto" />
  </xsl:if>
  <xsl:if test="not(@switch) and ../../network/@switch">
    <xsl:text>
      switch </xsl:text><xsl:value-of select="../../network/@switch" />
  </xsl:if>
</xsl:template>

</xsl:stylesheet>