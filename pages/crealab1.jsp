<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>



<%------------------------------------------------------------%>
<%-----------------AUTORIZZAZIONE AREA ALA--------------------%>
<%------------------------------------------------------------%>


<c:set var="auth_cod_ruolo" value="1"/>
<c:set var="auth_page" value="home_ala.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Alambiccus S.R.L."/>

<%@ include file="auth.jspf"%>

<%------------------------------------------------------------%>
<%-------------------------CONTROLLO CAMPI--------------------%>
<%------------------------------------------------------------%>


<c:if test="${(empty username )  or
              (empty param.password)   or
              (empty param.password1)  or
              (empty param.nome)       or
              (empty param.sede)       or
              (empty param.iva)        or
              (empty param.link)       or
              (empty param.dirigente)  or
              (empty param.recapito)   or
              (empty param.mail)             }">
   <c:set var="msg" scope="request">
    ${msg}
    <font color="red" >
    Si sono omessi alcuni campi.<br/> </font>
   </c:set>
</c:if>


<%------------------------------------------------------------%>
<%---------------------CONTROLLO PASSWORD---------------------%>
<%------------------------------------------------------------%>

<c:if test="${not empty param.password &&
              not empty param.password1 &&
              param.password != param.password1}">
  <c:set var="msg" scope="request"> 
   ${msg}
   <font color="red"> 
   La password di verifica e' differente.
    </font>
  </c:set>
</c:if>

<c:if test="${fn:length(param.password)<8}">
  <c:set var="msg" scope="request"> 
   ${msg}
   <font color="red"> 
   La password e' inferiore di 8 caratteri.<br/>
    </font>
  </c:set>
</c:if>

<%------------------------------------------------------------%>
<%-------------------CONTROLLO PARTITA IVA--------------------%>
<%------------------------------------------------------------%>

<c:if test="${not empty param.iva && (fn:length(param.iva) != 11)}">
<c:set var="msg" scope="request">
 ${msg}
 <font color="red">
  Inserire 11 caratteri per Partita  Iva
 </font>
</c:set>
</c:if>
<%------------------------------------------------------------%>
<%---------------------CAMPI EVIDENZIATI----------------------%>
<%------------------------------------------------------------%>

<c:if test="${empty param.nome}">
 <c:set var="flagNome" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${empty param.password}">
 <c:set var="flagPassword" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${empty param.password1}">
 <c:set var="flagPassword1" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${empty param.sede}">
 <c:set var="flagSede" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${empty param.iva}">
 <c:set var="flagIva" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${empty param.dirigente}">
 <c:set var="flagDirigente" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${empty param.link}">
 <c:set var="flagLink" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${empty param.recapito}">
 <c:set var="flagRecapito" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${empty param.mail}">
 <c:set var="flagMail" scope="request" value="errore">
 </c:set>
</c:if>
<c:if test="${not empty param.password &&
              not empty param.password1 &&  
              param.password != param.password1}">
<c:set var="flagPass" scope="request" value="errore"/>
</c:if>

<c:if test="${not empty msg}">
 <jsp:forward page="crealab.jsp"/>
</c:if>
 

<%------------------------------------------------------------%>
<%--------------------------QUERY-----------------------------%>
<%------------------------------------------------------------%>
<sql:query var="presc_disp">
   select t.id_prescrizione
   from TEST t
   where t.id_test not in(select id_test from CANDIDATURA where data_pagamento is not null or 
   scelto = '1')
</sql:query>

<sql:update>
 INSERT into LAB( user_lab, nome, dirigente, link_sito, p_iva, sede_legale)
   VALUES(?,?,?,?,?,?)
 <sql:param value="USER${username}"/>
 <sql:param value="${param.nome}"/>
 <sql:param value="${param.dirigente}"/>
 <sql:param value="${param.link}"/>
 <sql:param value="${param.iva}"/>
 <sql:param value="${param.sede}"/>
</sql:update>

<sql:update>
 INSERT into UTENTE_RUOLO( username, password, telefono, mail, attivo, cod_ruolo)
   VALUES(?,?,?,?,?,?)
 <sql:param value="USER${username}"/>
 <sql:param value="${param.password}"/>
 <sql:param value="${param.recapito}"/>
 <sql:param value="${param.mail}"/>
 <sql:param value="1"/>
 <sql:param value="4"/>
</sql:update>

<c:forEach items="${presc_disp.rows}" var="row">
<sql:update>
 INSERT into VISUALIZZARE_PRESC ( id_presc, user_lab, nuova)
   VALUES(?,?,?)
 <sql:param value="${row.id_prescrizione}"/>
 <sql:param value="USER${username}"/>
 <sql:param value="1"/>
</sql:update>
</c:forEach>

<%------------------------------------------------------------%>
<%----------------MESSAGGIO DI AVVEBUTA REGISTRAZIONE---------%>
<%------------------------------------------------------------%>

<c:set var="messaggi" scope="request">
  <font color="green">Il nuovo account per ${param.nome} e' stato creato correttamente!</font>
</c:set>
<jsp:forward page="account_lab.jsp"/>
