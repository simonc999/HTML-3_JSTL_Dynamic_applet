<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%---------------------------------------------------------------------%>
<%---------------------- AUTENTICAZIONE AREA GOV ----------------------%>
<%---------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>


<%---------------------------------%>
<%---------- REVOCA CERT ----------%>
<%---------------------------------%>

<sql:update>
  UPDATE TEST 
  SET user_cert= NULL
  WHERE id_scheda LIKE ? 
  <sql:param value="${param.id_scheda}"/>
</sql:update>

<sql:update>
  UPDATE SCHEDA_PROD 
  SET user_cert=NULL
  WHERE id_scheda LIKE ? 
  <sql:param value="${param.id_scheda}"/>
</sql:update>

<%---------------------------------%>
<%----------- MESSAGGIO -----------%>
<%---------------------------------%>

<sql:query var="cert">
  SELECT nome, cognome
  FROM CERT 
  WHERE user_cert LIKE ?
  <sql:param value="${param.username}"/>
</sql:query>

<c:set var="msgerror" scope="request">
  <font color="green" size="4">Il certificatore ${cert.rows[0].nome} ${cert.rows[0].cognome} e' stato revocato con successo!</font>
</c:set>

<jsp:forward page="scheda_prod_gov.jsp">
<jsp:param name="id_scheda" value="${param.id_scheda}"/>
</jsp:forward>




