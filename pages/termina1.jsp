Editing File: presc_test1.jsp
<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%----- AUTORIZZAZIONE AREA CERT ----%>
<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/>
<%@ include file="auth.jspf"%>


<%------------------------------------------------------------------------------------------------%>
<%--------------------------CONTROLLO CAMPI VUOTI-------------------------------------------------%>
<%------------------------------------------------------------------------------------------------%>

<c:if test="${empty param.Note || empty param.certificato || empty param.date || empty param.time}">
  <c:set var="errmsg" scope="request">Compilare tutti i campi!</c:set>
     <jsp:forward page="termina.jsp">
     <jsp:param name="errmsg" value="true"/>
     </jsp:forward>
</c:if> 


<%-------------------------------------------------------------------------------------%>
<%-- SE LA DATA INSERITA E'UGUALE ALLA DATA FINALE(ESITO) DELL'ULTIMO TEST----------------- 
 -----------------------------FATTO SUL PRODOTTO-------------------------------------------- 
-------------CONTROLLO CHE L'ORA INSERITA SIA MAGGIORE DI QUELLA DELL'ULTIMO
--------------------------- TEST FATTO SUL PRODOTTO.---------------------------------- --%>
<%------------------------------------------------------------------------%>


<c:if test="${param.date == param.var_data}">
  <c:if test="${param.time <= param.var_ora}">
    <c:set var="errmsg" scope="request" value="Affinche' la pratica sia conclusa con successo, devi inserire un'ora successiva all'ora della data dell'ultimo esito."/>
<jsp:forward page="termina.jsp"/>
    </c:if>
</c:if>


<%------------------------------------------------------------------------------------%>
<%---------------------------------AGGIORNAMENTO TABELLE------------------------------%>
<%------------------------------------------------------------------------------------%>

<c:set var="mydata" value="${param.date} ${param.time}"/>

<%--------------------------------------------------%>
<%------CONVERSIONE DATA PER AGGIORNARE IL DB-------%>
<%--------------------------------------------------%>

<fmt:parseDate value="${mydata}" 
               var="var_mydata"
               pattern="yyyy-MM-dd HH:mm"/>

<%------------------------------------------------------------%>
<%----------------AGGIORNAMENTO QUERY-------------------------%>
<%------------------------------------------------------------%>
<sql:update>

UPDATE SCHEDA_PROD SET verbale=?, 
                       stato=?, 
                       fine_prat=? ,
                       concluso=?
                 where id_scheda=?

<sql:param value="${param.Note}" />
<sql:param value="${param.certificato}"/>
<sql:dateParam value="${var_mydata}" type="timestamp"/>
<sql:param value="1"/>
<sql:param value="${param.id_scheda}"/>
</sql:update>

<c:set var="messaggio" value="Il verbale conclusivo e' avvenuto con successo, per cui la pratica di certificazione del prodotto: ${param.nome_prod} e' terminata </br>" scope="request"/>
<jsp:forward page="schede_cert.jsp"/>

