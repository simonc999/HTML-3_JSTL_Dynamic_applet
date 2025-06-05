<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%------------------------------------------------------------------------%>
<%---------------  AUTORIZZAZIONE AREA LAB -------------------------------%>
<%------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%--VALIDATORE: CONTROLLO CHE SIANO STATI SALVATI TUTTI I CAMPI, ALTRIMENTI RESTITUISCO UN 
    MESSAGGIO DI ERRORE NELLA PAGINA PRECEDENTE --%>

<c:if test="${empty fn:trim(param.telefono)        ||  
              empty fn:trim(param.ubicazione)        ||
              empty fn:trim(param.mail)   }">

<c:set var="errore" scope="request"> 
E' necessario compilare tutti i campi prima di procedere al salvataggio
</c:set>

<jsp:forward page="visual_profilo_lab.jsp">
<jsp:param name="errore" value="true"/>
</jsp:forward>
</c:if>

<%---AGGIORNO QUERY CON CAMPI MODIFICATI---%>

 <sql:update>
UPDATE LAB SET sede_legale= ?
                where user_lab = ? 
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
<jsp:forward page="visual_profilo_lab.jsp"/>





