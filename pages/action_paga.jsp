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

<%--------------------------------------------------------------%>
<%-- VALIDATORE CHE CONTROLLA CHE I CAMPI NON SIANO COMPILATI
SE SELEZIONO LE CARTE ------------------------------------------%>
<%--------------------------------------------------------------%>

<c:choose>
<c:when test="${param.parte=='Paypal' ||
                param.parte=='Carta di credito'}">
<c:if test="${empty fn:trim(param.intestatario)       ||  
              empty fn:trim(param.numero)             ||
              empty fn:trim(param.data_pagamento)          ||
              empty fn:trim(param.ora_pagamento)           || 
              empty fn:trim(param.costo)  }">

<c:set var="msg" scope="request"> Per procedere con il pagamento devi compilare tutti i campi </c:set>
<jsp:forward page="paga_test.jsp">
<jsp:param name="test" value="${param.test}"/>
</jsp:forward>
</c:if>
</c:when>
<%--------------------------------------------------------------%>
<%-- VALIDATORE CHE CONTROLLA CHE I CAMPI NON SIANO COMPILATI
SE SELEZIONO IL BONIFICO ---------------------------------------%>
<%--------------------------------------------------------------%>

<c:otherwise>
<c:if test="${empty fn:trim(param.intestatario)       ||  
              empty fn:trim(param.iban)               ||
              empty fn:trim(param.data_pagamento)          ||
              empty fn:trim(param.ora_pagamento)           || 
              empty fn:trim(param.costo)}">

<c:set var="msg1" scope="request"> Per procedere con il pagamento devi compilare tutti i campi </c:set>
<jsp:forward page="paga_test.jsp">
<jsp:param name="test" value="${param.test}"/>
</jsp:forward>
</c:if>
</c:otherwise>
</c:choose>






<%------------------------------------------------------------------------%>
<%-- SE LA DATA INSERITA E'UGUALE ALLA DATA DELLA CANDIDATURA DEL TEST, 
CONTROLLO CHE L'ORA INSERITA SIA MAGGIORE DI QUELLA DELLA CANDIDATURA. ---%>
<%------------------------------------------------------------------------%>

<c:if test="${param.data_pagamento == param.data}">
  <c:if test="${param.ora_pagamento <= param.ora}">
    <c:set var="errmsg" scope="request" value="Affinche' il pagamento avvenga con successo, </br> l'ora del pagamento deve essere successiva all' ora della data</br> della candidatura che hai scelto per questo test."/>
<jsp:forward page="paga_test.jsp"/>
    </c:if>
</c:if>




<%------------------------------------------------------%>
<%--- SE TUTTO CORRETTO SETTO LA VARIABILE   ---%>
<%------------------------------------------------------%>

<c:set var="mydata" value="${param.data_pagamento} ${param.ora_pagamento}"/>


<fmt:parseDate value="${mydata}" 
               var="var_mydata"
               pattern="yyyy-MM-dd HH:mm"/>

<%--------------------------------------------------------------------------%>
<%-- QUERY CHE AUTOMATICAMENTE AGGIORNA LE CANDIDATURE CHE AUTOMATICAMENTE
     NON SONO STATE SCELTE, CAMBIO LO STATO DI QUESTE CANDIDATURE CHE DA 
     in sospeso (0) passa a non scelto (2)                                --%>
<%--------------------------------------------------------------------------%>

<sql:query var="id_test">
    select id_test
    from TEST
    where id_prescrizione LIKE ?
    <sql:param value="${param.test}"/>
</sql:query>

<sql:update>
update CANDIDATURA set    scelto = 2
                          where id_test = ?
                         
<sql:param value="${id_test.rows[0].id_test}"/>
</sql:update>


<%--------------------------------------------------------------------------%>
<%-- QUERY CHE AGGIORNA LA CANDIDATURA SCELTA CON IL PAGAMENTO EFFETTUATO --%>
<%--------------------------------------------------------------------------%>
<sql:update>
update CANDIDATURA set    scelto = 1,
                          pagamento = ?,
                          data_pagamento = ?
                          where id_candidatura = ?
                         
<sql:param value="${param.costo}"/>
<sql:dateParam value="${var_mydata}" type="timestamp"/>  
<sql:param value="${param.candidatura}"/>
</sql:update>


<%--------------------------------------------------------------------------%>
<%-- QUERY CHE AGGIORNA LE CANDIDATURA NON ANCORA VISUALIZZATE            --%>
<%--------------------------------------------------------------------------%>
<sql:update>
update CANDIDATURA set    nuova = ?
                          where id_test = ?

<sql:param value="0"/>
<sql:param value="${param.id_test}"/>

</sql:update>


<%-----------------------------------------------------------%>
<%--- QUERY CHE ESTRAE IL SALDO ATTUALE DELLA CPR LOGGATA ---%>
<%-----------------------------------------------------------%>
<sql:query var="s">
 select saldo
 from CPR
 where user_cpr = ?
 <sql:param value="${user_userid}"/>
</sql:query> 

<fmt:parseNumber var="saldo" value="${s.rows[0].saldo}"/>

<%------------------------------------------------------------------------------%>
<%---CREO UNA NUOVA VARIABILE CON IL SALDO AGGIORNATO SOTTRAENDO DAL SALDO
     PRECEDENTEMENTE ESTRATTO IL COSTO DEL TEST PROPOSTO DAL LAB SCELTO      ---%>
<%------------------------------------------------------------------------------%>
<c:set var="saldo" value="${saldo - param.costo}"/>
<sql:update>
     update CPR set saldo = ?
                where user_cpr = ?
                <sql:param value="${saldo}"/>
                <sql:param value="${user_userid}"/>
</sql:update>



<sql:query var="lab">
select nome
from LAB
where user_lab = ?
<sql:param value="${param.lab}"/>
</sql:query> 
 
<%---------------------------------------------------------------------------------%>
<%--- MESSAGGIO CHE APPARE IN PAGAMENTI  QUANDO TUTTO E' ANDATO A BUON FINE     ---%>
<%---------------------------------------------------------------------------------%>             
<c:set var="pagamento_effettuato" scope="request">
   Il pagamento effettuato per ${lab.rows[0].nome} e' andato a buon fine! 
</c:set>
<jsp:forward page="pagamenti.jsp"/>


