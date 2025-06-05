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
<%------------------------------     FRAMMENTO TOP     ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@include file="top.jspf"%>


<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
     <td align="right" width="60" >
        <a href="login.jsp">
            <img style="width:60px;height:60px" src="indietro.png"/>
        </a>
     </td>


<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO MIDDLE  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@include file="middle.jspf"%>


<%------------------------------------------------------------------------------------------------------%>
<%-- CONTROLLO CHE L'UTENTE SIA UNA CPR, PERCHE SE NON E UNA CPR NON SI PUO FARE IL RECUPERA PASSWORD --%>
<%----ESTRAZIONE DELLA DESCRIZIONE DEL RUOLO PER L'USERNAME CHE INSERISCO NEL FORM----------------------%>
<%------------------------------------------------------------------------------------------------------%>

<sql:query var="ruolo">
SELECT r.descrizione_ruolo  
FROM RUOLO r, UTENTE_RUOLO u
WHERE u.cod_ruolo = r.cod_ruolo and 
      u.username LIKE ?
      <sql:param value="${param.username}"/>  
</sql:query>

   <table width="100%" cellpadding="7" cellspacing="0" align="center" border="0" >
      <td align="center" width="30%" style="font-family:arial"> <p style="font-size:23px;font-weight:bold;color: #007171;">AREA RECUPERO PASSWORD</p>



<p style="font-size:16px;font-style: italic;">Se hai dimenticato la tua password inserisci il tuo username e rispondi alla domanda di sicurezza </p>
<p style="font-size:16px;font-style: italic;"><font color="green">Solo sei sei una casa produttrice puoi recuperare la tua password, in caso non lo fossi contatta chi ha creato la tua utenza!</font></p>


<%-------------------------------------------------------------------------------------%>
<%------------------ESTRAZIONE USERNAME,DOMANDA,RISPOSTA per CPR-------------------------%>
<%---------------------------------------------------------------------------------------%>
<sql:query var="recupero">
select u.username,c.d_sicurezza,c.risposta
       from UTENTE_RUOLO u,CPR c
       where u.username=c.user_cpr
</sql:query>

<%-------------------------------------------------------------------------------------%>
<%------------------ESTRAZIONE USERNAME per gli ALTRI RUOLI----------------------------%>
<%--------------------------------------------------------------------------------------%>
<sql:query var="ruolo_cert">
select user_cert 
       from CERT 
</sql:query>

<sql:query var="ruolo_lab">
select user_lab 
       from LAB 
</sql:query>

<sql:query var="ruolo_ala">
select username 
       from UTENTE_RUOLO
       where cod_ruolo="1"
</sql:query>

<sql:query var="ruolo_gov">
select username 
       from UTENTE_RUOLO
       where cod_ruolo="2"
</sql:query>



</br>
<%--------------------------------------------------------------------------------%>
<%-----------------------FORM PER AIUTO NELLA CORREZIONE DEL PROF-----------------%>
<%--------------------------------------------------------------------------------%>
<form action="recup_psw.jsp" method="post">

<select name="recupero" onchange="this.form.submit()">
<option value="" checked>  </option>
<c:forTokens delims="," items="casa produttrice,laboratorio,certificatore,ALA,agenzia governativa" var="scelta">     
             <option value="${scelta}"
                  <c:forEach var="myrecupero" items="${paramValues.recupero}">
                         <c:if test="${scelta == myrecupero}"> selected="selected" </c:if>
                  </c:forEach>
             > ${scelta} </option>
</c:forTokens>
</select> 
</br></br>

<%-------------------------------------------------------------------------------------------------%>
<%-------------STAMPO PER OGNI RUOLO TABELLA CON DOMANDA E RISPOSTA SOLO PER CPR-------------------
--------------------------------per gli altri utenti stampo solo username ------------------%>
<%-------------------------------------------------------------------------------------------------%>
<c:choose>
<c:when test="${not empty param.recupero && param.recupero=='casa produttrice'}">
<table width="70%" height="50%" cellspacing="0" cellpadding="0">
<tr><td>Username:</td>
    <td>Domanda_sicurezza:</td>
    <td>Risposta:</td>
</tr>
<c:forEach var="recupero1" items="${recupero.rows}">
<tr><td> ${recupero1.username} </td>
    <td> ${recupero1.d_sicurezza} </td>
    <td> ${recupero1.risposta} </td>
</tr>
</c:forEach>
</table>
</c:when>
<c:otherwise>


<c:if test="${not empty param.recupero && param.recupero=='certificatore'}">
<table width="70%" height="50%" cellspacing="0" cellpadding="0">
<tr><td>Username:</td>
</tr>
<c:forEach var="recupero2" items="${ruolo_cert.rows}">
<tr><td> ${recupero2.user_cert} </td>
</tr>
</c:forEach>
</table>
</c:if>

<c:if test="${not empty param.recupero && param.recupero=='ALA'}">
<table width="70%" height="50%" cellspacing="0" cellpadding="0">
<tr><td>Username:</td>
</tr>
<c:forEach var="recupero3" items="${ruolo_ala.rows}">
<tr><td> ${recupero3.username} </td>
</tr>
</c:forEach>
</table>
</c:if>

<c:if test="${not empty param.recupero && param.recupero=='laboratorio'}">
<table width="70%" height="50%" cellspacing="0" cellpadding="0">
<tr><td>Username:</td>
</tr>
<c:forEach var="recupero4" items="${ruolo_lab.rows}">
<tr><td> ${recupero4.user_lab} </td>
</tr>
</c:forEach>
</table>
</c:if>

<c:if test="${not empty param.recupero && param.recupero=='agenzia governativa'}">
<table width="70%" height="50%" cellspacing="0" cellpadding="0">
<tr><td>Username:</td>
</tr>
<c:forEach var="recupero5" items="${ruolo_gov.rows}">
<tr><td> ${recupero5.username} </td>
</tr>
</c:forEach>
</table>
</c:if>

</c:otherwise>
</c:choose>


<c:if test="${not empty param.username}">

<%---------------------------------------------------------------------------------%>
<%--------SE INSERISCO USERNAME IL CUI RUOLO NON E' CPR STAMPO ERRORE--------------%>
<%---------------------------------------------------------------------------------%>
<c:if test="${ruolo.rows[0].descrizione_ruolo != 'casa produttrice'}">
<font color="red">Non e' possibile effettuare il recupero password perche' non sei una casa produttrice. Il tuo account e' stato creato da altre utenze quindi non hai una domanda di sicurezza.</font>
</c:if>
</c:if>


</br></br>

 <%----------------------------------------------------%>
 <%---------------------INIZIO FORM--------------------%>
 <%----------------------------------------------------%>
       
  <form action="recup_psw.jsp" method="post">

<td  align="center" width="35%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px;background-color:#a5bacd" >

<%----------------------------------------%>
<%---STAMPO ERRORE SE USERNAME E' VUOTO---%>
<%----------------------------------------%>
<c:if test="${ruolo.rows[0].descrizione_ruolo != 'casa produttrice'}">
<c:if test="${empty param.username && not empty param.bottone1}">
<font color="red">inserisci il tuo username!</font>
</c:if>

<p style="font-size:15px;font-weight:bold;color: #007171;">Inserisci il tuo username per recuperare la password:</p>
<input type="text" name="username" value="${param.username}" /><br/>
<br/>

<input type="submit" align="center" name="bottone1" style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;" value="COMPLETA RECUPERO PASSWORD"/>

</c:if>


</FORM>
<%------------------------------------------------FINE PRIMO FORM-------------------------------------------------%>

<c:if test="${ruolo.rows[0].descrizione_ruolo == 'casa produttrice'}">
  <%-------------------------------------------------------------------------------%>
 <%-----STAMPO UN ERRORE SE LA DOMANDA SCELTA NON COINCIDE CON QUELLA PERSONALE---%> 
 <%------------------------------------------------------------------------------%>
   <c:if test="${not empty errmsg}">
     <br/>
     <font color="red">${errmsg}</font>
   </c:if>
  
  <%---------------------------------------------------%>
  <%------------STAMPO ERRORE SE RISPOSTA ERRATA-------%>
  <%---------------------------------------------------%>
   <font color="red">${msgerr}</font></br>

  <%----------------------------------------------------------%>
  <%------------STAMPO ERRORE SE RISPOSTA O DOMANDA VUOTA-------%>
  <%------------------------------------------------------------%>
  <c:if test="${not empty errmsg2}">
  <font color="red">${errmsg2}</font></br> 
  </c:if>
<form action="effettua_recup_psw.jsp" method="post">

  

<p style="font-size:15px;font-weight:bold;color: #007171;">Inserisci il tuo username per recuperare la password:</p>
<input type="text" name="username" value="${param.username}" /><br/>
</br> 
 <%-----------------------------------------------------------------------------%>
 <%-------QUERY che recupera domande di sicurezza che sono nella tabella CPR----%>
 <%-----------------------------------------------------------------------------%>

 <sql:query var="rset_dom">
    select d_sicurezza
    from CPR
    group by d_sicurezza 
  </sql:query>

 <%------------------------------------------------------------------------------%>
 <%-------------MENU A TENDINA DOVE SI SCEGLIE LA DOMANDA DI SICUREZZA-----------%>
 <%------------------------------------------------------------------------------%>
  
   <p style="font-size:15px;font-weight:bold;color: #007171;">Scegli la tua domanda: </p>
   <select name="form_domanda">
     <option value="" checked>--Seleziona la tua domanda di sicurezza--</option>
     <c:forEach items="${rset_dom.rows}" var="domanda">
       <option value="${domanda.d_sicurezza}"
       <c:if test="${domanda.d_sicurezza == param.form_domanda}">selected="selected"</c:if>
       >${domanda.d_sicurezza}</option>
     </c:forEach>
   </select>

<%------RISPOSTA----------%>
     <p style="font-size:15px;font-weight:bold;color: #007171;">Inserisci la risposta:</p> 
     <input type="text" name="form_risposta"  value="${param.form_risposta}"/> </br></br>
  


</BR>

<input type="submit" name="bottone2" align="center" style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;" value="COMPLETA RECUPERO PASSWORD"/>

</form>
</c:if>

         </td>
                     
      </tr> 

        

  
</table>

<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO BOTTOM  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@include file="bottom.jspf"%>

