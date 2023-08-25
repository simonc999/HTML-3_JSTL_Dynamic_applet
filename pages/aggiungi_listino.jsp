Editing File: candidatura.jsp

<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>

<%--------------------------------------------------------------------------------------%>
<%------------------------------CONTROLLO SUI VALORI INSERITI---------------------------%>
<%--------------------------------------------------------------------------------------%>

<c:if test="${empty param.costo}">
<c:set var="errmsg" scope="request">Controllare tariffa inserita!${param.costo}</c:set>
     <jsp:forward page="listino.jsp">
         <jsp:param name="errmsg" value="true"/>
     </jsp:forward>
</c:if>


<%--------------------------------------------------------------------------------------%>
<%--------------------------CONVERSIONE STRINGHE IN  NUMERI-----------------------------%>
<%--------------------------------------------------------------------------------------%>

<c:set var = "costo_senzapunto" value = "${fn:split(param.costo, '.')}" />
<c:set var = "costo_convirgola" value = "${fn:join(costo_senzapunto, ',')}" />

<fmt:parseNumber var="costo" value="${costo_convirgola}"/>

<fmt:parseNumber var="costo_min" value="${param.costo_min}"/>

<fmt:parseNumber var="costo_max" value="${param.costo_max}"/>
<c:choose>
<c:when test="${costo >= costo_min && costo <= costo_max}">

<%--------------------------------------------------------------------------------------%>
<%-------------------------INSERIMENTO VALORI NELLA TABELLA-----------------------------%>
<%--------------------------------------------------------------------------------------%>

<sql:update>
 INSERT into AVERE_LISTINO( id_tipo, user_lab, prezzo)
   VALUES(?,?,?)
 <sql:param value="${param.tipotest}"/>
 <sql:param value="${user_userid}"/>
 <sql:param value="${costo_convirgola}"/>
 ON DUPLICATE KEY UPDATE prezzo= "${costo_convirgola}";
</sql:update>

<c:set var="ciao" value="Test aggiunto al listino!" scope="request"/>
<jsp:forward page="listino.jsp"/> 
  
</c:when>
<c:otherwise> 
       <c:set var="errmsg" scope="request">Controllare tariffa inserita!                
       </c:set>
     <jsp:forward page="listino.jsp">
         <jsp:param name="errmsg" value="true"/>
     </jsp:forward>
</c:otherwise>
</c:choose>



 