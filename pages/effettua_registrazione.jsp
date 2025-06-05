<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%-----------------------------------------------------------------%>
<%-- CONTROLLO CHE TUTTI I CAMPI VENGANO COMPILATI CORRETTAMENTE --%>
<%-----------------------------------------------------------------%>
<c:if test="${empty param.Nome_azienda}">
<c:set var="flagazienda" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Nome Azienda.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${not empty param.PartitaIva && (fn:length(param.PartitaIva) != 11)}">
<c:set var="controllo_piva" scope="request" value="La partita IVA deve avere 11 cifre!"/>
<jsp:forward page="registrazione.jsp"/>
</c:if>


<c:if test="${empty param.PartitaIva}">
<c:set var="flagp.iva" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > P.IVA. </font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.url}">
<c:set var="flagurl" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Link Sito Azienda.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.tel}">
<c:set var="flagtelefono" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Telefono.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.indirizzo}">
<c:set var="flagindirizzo" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Sede Legale.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.mercato}">
<c:set var="flagmercato" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Mercato.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${empty param.saldo}">
<c:set var="flagsaldo" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Saldo.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>



<c:if test="${empty param.dirigente}">
<c:set var="flagdirigente" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Dirigente.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${empty param.email}">
<c:set var="flagemail" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > E-mail.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${empty param.username}">
<c:set var="flagusername" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Username.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.password}">
<c:set var="flagpassword" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Password.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>



<c:if test="${empty param.confirm_password}">
<c:set var="flagconfpassword" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Conferma password.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>


<c:if test="${empty param.domanda_sicurezza}">
<c:set var="flagdomanda_sicurezza" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Domanda Sicurezza.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${empty param.risposta}">
<c:set var="flagdomanda_sicurezza" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}
<font style="font-size:14px" color="red" > Risposta.</font>
</c:set>
<c:set var="ERRORE" value="true"/>
</c:if>




<%---------------------------------------------------------------------------------------------------%>
<%-- SE PASSWORD E CONFERMA PASSWORD NON COINCIDONO E I CAMPI NON SONO VUOTI (MESSAGGIO DI ERRORE) --%>
<%---------------------------------------------------------------------------------------------------%>

<c:if test="${not empty param.password && not empty param.confirm_password && param.password != param.confirm_password}">
<c:set var="flagpasswordCC" value="true" scope="request"/>
<c:set var="msg" scope="request">
${msg}

    <font style="font-size:14px" color="orange" > &nbsp&nbsp Le password non corrispondono</font>
  </c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- CONTROLLO LA LUNGHEZZA PASSWORD -------------------------------%>
<%--------------------------------------------- E STAMPO IL MESSAGGIO DI ERRORE INERENTE (msg2) ---------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:if test="${fn:length(param.password)<8}">
  <c:set var="msg2" scope="request"> 
   ${msg2}
   <font style="font-size:12px" color="red" > 
   La password e' inferiore di 8 caratteri.
    </font>
  </c:set>
<c:set var="ERRORE" value="true"/>
</c:if>

<c:if test="${ERRORE}">
<jsp:forward page="registrazione.jsp"/>
</c:if>

<%------------------------------------%>
<%--VERIFICA CHE L'UTENTE SIA UNICO --%>
<%-------------------------------------%>
<sql:query var="utente">
SELECT username
       from UTENTE_RUOLO
</sql:query>

<c:forEach var="utente_db" items="${utente.rows}">
  <c:if test="${utente_db.username == param.username}">
    <c:set var="errmsg" value="L'username e' gia stato utilizzato. Scegli un username diverso!" scope="request"/>
    <jsp:forward page="registrazione.jsp"/>
  </c:if>
</c:forEach>

<%------------------------------------------------------------------------------------%>
<%---------------------AGGIORNAMENTO TABELLE------------------------------------------%>
<%------------------------------------------------------------------------------------%>

<sql:update>

INSERT into CPR( nome,user_cpr,p_iva, dirigente, sede_legale, link_sito,mercato,d_sicurezza,risposta,nuovo,saldo)
   VALUES(?,?,?,?,?,?,?,?,?,?,?)
<sql:param value="${param.Nome_azienda}"/>
 <sql:param value="${param.username}"/>
 <sql:param value="${param.PartitaIva}"/>
 <sql:param value="${param.dirigente}"/>
 <sql:param value="${param.indirizzo}"/>
 <sql:param value="${param.url}"/>
 <sql:param value="${param.mercato}"/>
 <sql:param value="${param.domanda_sicurezza}"/>
 <sql:param value="${param.risposta}"/>
 <sql:param value="${param.nuovo}"/>
 <sql:param value="${param.saldo}"/>

</sql:update>

<sql:update>
INSERT into UTENTE_RUOLO( username, password, telefono, mail, attivo, cod_ruolo)
   VALUES(?,?,?,?,?,?)
<sql:param value="${param.username}"/>
 <sql:param value="${param.password}"/>
 <sql:param value="${param.tel}"/>
 <sql:param value="${param.email}"/>
 <sql:param value="${param.attivo}"/>
<sql:param value="${param.codice}"/>
 
</sql:update>



<%-------------------------------------------------------------%>
<%----- MESSAGGIO DI AVVENUTA REGISTRAZIONE CON SUCCESSO ------%>
<%-------------------------------------------------------------%>

<c:set var="msg1" scope="request">
  <font color="green"> La registrazione e' avvenuta con successo!</br> Se vuoi fare accesso alla tua area riservata, inserisci le tue credenziali. </font>
</c:set>

<c:if test="${not empty msg1}">
<jsp:forward page="login.jsp">
<jsp:param name="messaggio1" value="${msg1}"/>
</jsp:forward>
</c:if>

</body>
</html>