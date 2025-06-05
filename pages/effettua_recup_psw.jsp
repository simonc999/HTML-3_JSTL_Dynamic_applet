%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%------------------------------------------------------------------------------------%>
<%----ESTRAZIONE DELLA DESCRIZIONE DEL RUOLO PER L'USERNAME CHE INSERISCO NEL FORM ---%>
<%------------------------------------------------------------------------------------%>
<sql:query var="ruolo">
SELECT r.descrizione_ruolo  
FROM RUOLO r, UTENTE_RUOLO u
WHERE u.cod_ruolo = r.cod_ruolo and 
      u.username LIKE ?
      <sql:param value="${param.username}"/>  
</sql:query>

<%--------------------------------------------------------%>
<%--- DOMANDA VUOTA O RISPOSTA VUOTA-->MESSAGGIO ERRORE --%>
<%---------------------------------------------------------%>

<c:if test="${empty param.form_domanda || empty param.form_risposta}">
<c:if test="${ruolo.rows[0].descrizione_ruolo == 'casa produttrice'}">
 <c:set var="errmsg2" value="Inserire una risposta per la domanda selezionata prima di premere invio" scope="request"/>
</c:if>
 <jsp:forward page="recup_psw.jsp">
   <jsp:param name="username" value="${param.username}"/>
 </jsp:forward>

</c:if>



<%----------------------------------------%>                              
<%-- QUERY CHE ESTRAE DOMANDA E RISPOSTA--%>
<%----------------------------------------%> 

<sql:query var="rset_dom">
    select d_sicurezza, risposta
    from CPR
    where user_cpr =?
     <sql:param value="${param.username}"/>
</sql:query>

<%---------------------------------------------------%>
<%-- CONFRONTO TRA DOMANDA INSERITA E QUELLA NEL DB--%>
<%---------------------------------------------------%>

<c:forEach items="${rset_dom.rows}" var="domanda">
   <c:choose>
   <c:when test="${domanda.d_sicurezza == param.form_domanda}">
       <c:set var="risposta" value="${domanda.risposta}"/>
   </c:when>
   <c:otherwise>
    <c:set var="errmsg" value="La domanda selezionata e' errata" scope="request"/>
    <jsp:forward page="recup_psw.jsp"/>
   </c:otherwise>
  </c:choose>
</c:forEach>


<%-------------------------------------%>
<%-- QUERY CHE RECUPERA LA PASSWORD ---%>
<%------------------------------------%>
   <sql:query var="rset_passwd">
      select password 
      from UTENTE_RUOLO 
      where username = ?
       <sql:param value="${param.username}"/>
   </sql:query>
<c:set var="pw_recuperata" value="${rset_passwd.rows[0].password}" scope="request"/>


<c:choose>
 <%----------------------------------------------------------%>
 <%---------- RISPOSTA CORRETTA-----------------------------%>
 <%----------------------------------------------------------%>
 <c:when test="${param.form_risposta == risposta}">

<%----Ritorno alla pagina di login con la psw recuperata---%>
<c:set var="pas_rec" value="hai effettuato il recupera password con successo!</br> la  tua password e' : ${pw_recuperata}" scope="request"/>
   <jsp:forward page="login.jsp">
    <jsp:param name="pas_rec" value="${pas_rec}"/>
    <jsp:param name="form_username" value="${param.username}"/>
    <jsp:param name="form_password" value="${pw_recuperata}"/>
 </jsp:forward> 

 </c:when>
 <%--------------------------------------------------------%>
 <%---------- RISPOSTA ERRATA -----------------------------%>
 <%--------------------------------------------------------%>
 <c:otherwise>
   <c:set var="msgerr" value="Risposta errata. Riprova!" scope="request"/>
   <jsp:forward page="recup_psw.jsp">
     <jsp:param name="username" value="${param.username}"/>
     <jsp:param name="form_password" value="${param.form_domanda}"/>
   </jsp:forward>
 </c:otherwise>
</c:choose>



