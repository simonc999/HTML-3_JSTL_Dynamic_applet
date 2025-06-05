<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%----------------------------------------------------------------------%>
<%---------------       AUTORIZZAZIONE AREA LAB       ------------------%>
<%----------------------------------------------------------------------%>
<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>

        <c:if test="${empty param.Note || empty param.esito || empty param.date || empty param.time}">
        <c:set var="errmsg" scope="request">Compilare tutti i campi!</c:set>
          <jsp:forward page="rapporto.jsp">
          <jsp:param name="errmsg" value="true"/>
          </jsp:forward>
        </c:if>

<%-------------------------------------------------------------------------------------%>
<%-- SE LA DATA INSERITA E'UGUALE ALLA DATA DELL AVVIO DELLA PRATICA DI----------------- 
 -----------------------------CERTIFICAZIONE-------------------------------------------- 
-------------CONTROLLO CHE L'ORA INSERITA SIA MAGGIORE DI QUELLA DELL'AVVIO
--------------------------- PRATICA CERTIFICAZIONE.---------------------------------- --%>
<%------------------------------------------------------------------------%>


<c:if test="${param.date == param.var_data && param.time <= param.var_ora}">
    <c:set var="errmsg" scope="request" value="Affinche' avvenga la prescrizione del test, l'ora deve essere successiva all' ora della data dell'avvio della pratica di certificazione:${param.var_ora}"/>
<jsp:forward page="rapporto.jsp"/>
</c:if>

<c:if test="${param.date == param.var_data1 && param.time <= param.var_ora1}">
    <c:set var="errmsg" scope="request" value="Affinche' avvenga la prescrizione del test, l'ora deve essere successiva all' ora della data dell'invio dell'ultimo messaggio:${param.var_ora1}"/>
<jsp:forward page="rapporto.jsp"/>
</c:if>

<%------------------------------------------------------------------------------------%>
<%---------------------------------AGGIORNAMENTO TABELLE-----------------------------%>
<%------------------------------------------------------------------------------------%>
<c:set var="mydata" value="${param.date} ${param.time}"/>


<fmt:parseDate value="${mydata}" 
               var="var_mydata"
               pattern="yyyy-MM-dd HH:mm"/>


  <sql:update>
   UPDATE TEST SET 
                superato= ?,
                rapporto= ?,
                data_ora_esito=?
     where id_test = ? 
     <sql:param value="${fn:trim(param.esito)}"/>
     <sql:param value="${fn:trim(param.Note)}"/>
      <sql:dateParam value="${var_mydata}" type="timestamp"/>
     <sql:param value="${param.id_test}"/>
  </sql:update>
  
<c:set var="inoltrato" value="Il rapporto e' stato compilato con successo!" scope="request"/> 
<jsp:forward page="test.jsp"/>
