<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%--------------------------------------------------------------------------------------%>
<%------------------------------AUTORIZZAZIONE AREA CPR---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<c:set var="auth_cod_ruolo" value="5"/>
<c:set var="auth_page" value="home_cpr.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Casa Produttrice"/>

<%@ include file="auth.jspf"%>

<DIV align="CENTER">
<TR><TH><font color="#007171"><b>SELEZIONA LA FOTO CHE VUOI VISUALIZZARE</b></font></TH></TR>
<form method="post" action="prod_foto.jsp">
<HR width="50%">
<c:if test="${not empty param.uno}">
<IMG SRC="${param.foto1}" WIDTH="300">
</c:if>
<c:if test="${not empty param.due}">
<IMG SRC="${param.foto2}" WIDTH="300">
</c:if>
<c:if test="${not empty param.tre}">
<IMG SRC="${param.foto3}" WIDTH="300">
</c:if>
<BR>

<input type="hidden"  name="foto1" value="${param.foto1}"/>
<input type="hidden"  name="foto2" value="${param.foto2}"/>
<input type="hidden"  name="foto3" value="${param.foto3}"/>

<input type="submit" style="border-color:#007171;background-color:#009c9c;width:100px;height:35px;" name="uno" value="1"/> &nbsp
<input type="submit" name="due" style="border-color:#007171;background-color:#009c9c;width:100px;height:35px;" value="2"/>&nbsp
<input type="submit" style="border-color:#007171;background-color:#009c9c;width:100px;height:35px;" name="tre" value="3"/>&nbsp

 
</form>
<br/>
<A HREF="#" onClick="window.close()">Chiudi</A>
</DIV>

