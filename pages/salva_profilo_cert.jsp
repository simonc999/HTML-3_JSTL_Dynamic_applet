<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%----- FRAMMENTO AUTH ------%>
<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/>

<%@ include file="auth.jspf"%>


<%---AGGIORNO QUERY CON CAMPI MODIFICATI---%>

 <sql:update>
UPDATE CERT SET ubicazione = ?
                where user_cert = ? 
     <sql:param value="${param.ubicazione}"/>
     <sql:param value="${user_userid}"/>
</sql:update>

<sql:update>

UPDATE UTENTE_RUOLO SET  telefono = ?,
                         mail = ? 
     where username = ? 
     <sql:param value="${param.telefono}"/>
     <sql:param value="${param.mail}"/>
     <sql:param value="${user_userid}"/>


</sql:update>


<c:set var="profilo_salvato" scope="request" value="Il salvataggio e' avvenuto con successo!"/>
<jsp:forward page="visual_profilo_cert.jsp"/>





