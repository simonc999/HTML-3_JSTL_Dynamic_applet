<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%-------------------------------------------------------------------%>
<%-------------------- CONTROLLO PERMESSI GOV -----------------------%>
<%-------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>

<%-------------------------------%>
<%---SETTO VARIABILE MESSAGGIO---%>
<%-------------------------------%>

<c:if test="${empty param.sas}">
 <c:set var="msgerror" scope="request">
   <font style="font-size:15px" color="red"> Si prega di scegliere il cert.</font>
 </c:set>
 <jsp:forward page="assegnazione.jsp"/>
</c:if>


<%-------------------------------%>
<%----------- UPDATE ------------%>
<%-------------------------------%>

<c:if test="${not empty param.sas}">
  <sql:update>
    UPDATE TEST
    SET user_cert="${param.sas}"
    WHERE id_scheda LIKE ? 
    <sql:param value="${param.id_scheda}"/>
  </sql:update>

  <sql:update>
    UPDATE SCHEDA_PROD
    SET user_cert="${param.sas}",
        nuovo_assegnato ="1"
    WHERE id_scheda LIKE ?
    <sql:param value="${param.id_scheda}"/>
  </sql:update>
 
<%-------------------------------%>
<%----- MESSAGGIO DI SUCCESSO ------%>
<%-------------------------------%>

  <sql:query var="cert">
    SELECT nome, cognome
    FROM CERT 
    WHERE user_cert LIKE ?
    <sql:param value="${param.sas}"/>
  </sql:query>

  <sql:query var="prod">
    SELECT nome_prod
    FROM SCHEDA_PROD 
    WHERE id_scheda LIKE ?
    <sql:param value="${param.id_scheda}"/>
  </sql:query>

  <c:set var="msgerror1" scope="request">
    <font size="4" color="green" > E' stato assegnato il certificatore ${cert.rows[0].nome} ${cert.rows[0].cognome} al prodotto ${prod.rows[0].nome_prod}.</font>
  </c:set>
  <jsp:forward page="scheda_prod_gov.jsp"/>
</c:if>

