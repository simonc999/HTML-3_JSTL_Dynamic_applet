<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------ CONTROLLO DEI PERMESSI DI GOV ------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- RIPASSO IL PARAMETRO DEL CHECKBOX -----------------------------%>
<%--------------------------------------------- E STAMPO IL MESSAGGIO DI ERRORE INERENTE (msg3) ---------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<c:if test="${param.cond!='on'}">
  <c:set var="msg3" scope="request"> 
   ${msg3}
   <font style="font-size:12px" color="red"> 
   Non hai accettato i termini di licenza
    </font>
  </c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- CONTROLLO LA PRESENZA DI TUTTI I CAMPI ------------------------%>
<%--------------------------------------------- E STAMPO IL MESSAGGIO DI ERRORE INERENTE (msg) ----------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<c:if test="${empty param.gender}">
<c:set var="flagsesso" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Sesso.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.name}">
<c:set var="flagnome" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Nome.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.surname}">
<c:set var="flagcognome" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Cognome.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.codicefiscale}">
<c:set var="flagcf" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Codice Fiscale.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${empty param.data}">
<c:set var="flagdata" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Data di nascita.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.indirizzo}">
<c:set var="flagubicazione" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Ubicazione.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.albo}">
<c:set var="flagalbo" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Numero albo.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${empty param.telefono}">
<c:set var="flagtelefono" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Numero di telefono.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${empty param.email}">
<c:set var="flagemail" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Email.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.password}">
<c:set var="flagpassword" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Password.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>



<c:if test="${empty param.confirm_password}">
<c:set var="flagconfpassword" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:12px" color="red" > Conferma password.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- CONFRONTO LA PASSWORD E LA CONFERMA ---------------------------%>
<%--------------------------------------------- E STAMPO IL MESSAGGIO DI ERRORE INERENTE (msg4) ---------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>



<c:if test="${not empty param.password && not empty param.confirm_password && param.password != param.confirm_password}">
<c:set var="flagpasswordCC" value="true" scope="request"/>
<c:set var="msg4" scope="request">
${msg4}

    <font style="font-size:12px" color="orange" > &nbsp&nbsp Le password non corrispondono</font>
  </c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- CONTROLLO LA LUNGHEZZA CODICE FISCALE -------------------------%>
<%--------------------------------------------- E STAMPO IL MESSAGGIO DI ERRORE INERENTE ----------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>



<c:if test="${(fn:length(param.codicefiscale) != 16)}">
<c:set var="flagcf1" scope="request" value="true"/>
<c:set var="flagcf1_msg" scope="request">
Il codice fiscale deve avere 16 cifre!
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- CONTROLLO LA LUNGHEZZA ALBO -----------------------------------%>
<%--------------------------------------------- E STAMPO IL MESSAGGIO DI ERRORE INERENTE ----------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>



<c:if test="${(fn:length(param.albo) != 11 )}">
<c:set var="flagalbo1" scope="request" value="true"/>
<c:set var="flagalbo1_msg" scope="request">
Il n albo deve avere 11 cifre!
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- CONTROLLO LA LUNGHEZZA PASSWORD -------------------------------%>
<%--------------------------------------------- E STAMPO IL MESSAGGIO DI ERRORE INERENTE ----------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<c:if test="${fn:length(param.password)<8}">
  <c:set var="flagpassword1" scope="request" value="true"/> 
  <c:set var="flagpassword1_msg" scope="request">
   La password deve avere 8 caratteri!
  </c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------ RIPASSO IL PARAMETRO DEL CHECKBOX --------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------ RIPASSO L'INTERO MESSAGGIO DI ERRORE -----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:if test="${ERRORE}">
<jsp:forward page="gov_cert_registrazione.jsp">
<jsp:param name="condd" value="${param.cond}"/>
<jsp:param name="gendermf" value="${param.gender}"/>
</jsp:forward>

</c:if>



<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------ AGGIUNGO UNA RIGA NELLA TABELLA CERT -----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>




<sql:update>
INSERT into CERT( user_cert, cf, sesso, nome, cognome, data_nascita, n_albo, ubicazione)
   VALUES(?,?,?,?,?,?,?,?)
<sql:param value="USER${id_numerocert}"/>
<sql:param value="${param.codicefiscale}"/>
 <sql:param value="${param.gender}"/>
 <sql:param value="${param.name}"/>
 <sql:param value="${param.surname}"/>
<sql:param value="${param.data}"/>
<sql:param value="${param.albo}"/>
<sql:param value="${param.indirizzo}"/>
 
</sql:update>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------- AGGIUNGO UNA RIGA NELLA TABELLA UTENTE_RUOLO -------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<sql:update>
INSERT into UTENTE_RUOLO( username, password, telefono, mail, attivo, cod_ruolo)
   VALUES(?,?,?,?,?,?)
<sql:param value="USER${id_numerocert}"/>
 <sql:param value="${param.password}"/>
 <sql:param value="${param.telefono}"/>
 <sql:param value="${param.email}"/>
 <sql:param value="1"/>
<sql:param value="${param.codice}"/>
 
</sql:update>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-- ------------------------------ IMPOSTO UN MESSAGGIO DI AGGIUNTA RIGA -------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:set var="msg1" scope="request">
  <font size="4" color="green"> Il nuovo account di ${param.name} ${param.surname} e' stato creato con successo!</font>
</c:set>

<%--
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------- INVIO IL MESSAGGIO IL MESSAGGIO NELLA PAGINA DI ELENCO ---------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:if test="${not empty msg1}">
<jsp:forward page="elenco_cert.jsp">
<jsp:param name="messaggio1" value="${msg1}"/>
</jsp:forward>
</c:if>
 --%>

