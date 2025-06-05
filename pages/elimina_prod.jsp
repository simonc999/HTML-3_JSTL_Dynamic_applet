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

<%--------------------------------------------------------------------------------------%>
<%---------------------------------QUERY ELIMINAZIONE SCHEDA----------------------------%>
<%--------------------------------------------------------------------------------------%>

<sql:update>
delete from SCHEDA_PROD 
where id_scheda LIKE ?
<sql:param value="${param.id_scheda}"/>
</sql:update>


<%------------------------------------------------------%>
<%----   MESSAGGIO CHE APPARE QUANDO LA SCHEDA 
             VIENE ELIMINATA CON SUCCESSO            ---%>
<%------------------------------------------------------%>
<c:set var="scheda_eliminata" scope="request"> La scheda e' stata eliminata correttamente! </c:set>
<jsp:forward page="gestione_prod.jsp"/>






