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
<%-------------------AUTORIZZAZIONE AREA ALA------------------%>
<%------------------------------------------------------------%>


<c:set var="auth_cod_ruolo" value="1"/>
<c:set var="auth_page" value="home_ala.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Alambiccus S.R.L."/>

<%@ include file="auth.jspf"%>



<%------------------------------------------------------------%>
<%---------------------------FRAMMENTO TOP--------------------%>
<%------------------------------------------------------------%>

<%@ include file="top.jspf"%>

 <td align="right" width="60">
        <%-- COMANDO INDIETRO --%>
       <a href="account_lab.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
 </td>

<%------------------------------------------------------------%>
<%-----------------------FRAMMENTO MIDDLE---------------------%>
<%------------------------------------------------------------%>

<%@ include file="middle.jspf"%>

<%------------------------------------------------------------%>
<%------------------------QUERY IDMAX-------------------------%>
<%------------------------------------------------------------%>

<sql:query var="usermax">
     select max(convert(substring(username, 5),decimal))  as user_max 
     from UTENTE_RUOLO
</sql:query>

<c:if test="${not empty usermax.rows}">
     <c:set var="username" value="${usermax.rows[0].user_max + 1}" scope="session"/>
</c:if>


<%------------------------------------------------------------%>
<%---------------SEZIONE LATERALE SX--------------------------%>
<%------------------------------------------------------------%>

<table width="100%" cellpadding="1" cellspacing="0" align="left">
   <tr align="left">
     <form method="post" action="crealab1.jsp">
      <td width="5%"></td>
      <td  width="30%" style="font-family:arial">
         <p style="font-size:23px;font-weight:bold;color: #007171;">AREA REGISTRAZIONE LAB</p>
         <p style="font-size:15px;font-style: italic;"> compilare tutti campi</p>
         <p style="font-size:15px;font-style: italic;"> inserire password<br/>da almeno 8 caratteri</p>
         <p style="font-size:15px;font-style: italic;"> assicurarsi che il campo Partita Iva<br/>sia formato da 11 caratteri</p>
         <p style="font-size:15px;font-style: italic;"> per tornare all'elenco lab<br/> cliccare sul back button in alto a destra</p>
      </td>



<%------------------------------------------------------------%>
<%-------------------SEZIONE LATERALE DX----------------------%>
<%-------------CAMPI DA COMPILARE+FLAGDIERRORE----------------%>
<%------------------------------------------------------------%>
   
      <td width="20%" style="font-family:arial;padding:10px;background-color:#a5bacd;color: #007171;font-size:15px;font-weight:bold;">
          <p>Username</p><p style="color:black">USER${username}</p>
          <p <c:if test="${not empty flagPassword}"> style="font-weight:bold;color:red"</c:if><c:if test="${not empty flagPass}">style="font-weight:bold;color:red"</c:if>>Password</p><input type="password" name="password" minlenght="8" placeholder="password"/>
          <p <c:if test="${not empty flagPassword1}"> style="font-weight:bold;color:red"</c:if><c:if test="${not empty flagPass}">style="font-weight:bold;color:red"</c:if>>Conferma Password</p><input type="password" name="password1" minlenght="8" placeholder="conferma password"/>
      </td>

      <td width="20%" style="font-family:arial;background-color:#a5bacd;color: #007171;font-size:15px;font-weight:bold;" >
          <p <c:if test="${not empty flagNome}">style="color:red"</c:if>>Nome</p><input type="text" name="nome" value="${param.nome}" placeholder="nome" />
          <p <c:if test="${not empty flagSede}">style="color:red"</c:if>>Sede Legale</p><input type="text" name="sede" value="${param.sede}" placeholder="sede"/>
          <p <c:if test="${not empty flagIva}">style="color:red"</c:if>>Partita Iva</p><input type="text" name="iva" value="${param.iva}" placeholder="iva" />
      </td>

      <td width="20%" style="font-family:arial;background-color:#a5bacd;color: #007171;font-size:15px;font-weight:bold;">
          <p <c:if test="${not empty flagLink}">style="color:red"</c:if>>Link Sito</p><input type="text" name="link" value="${param.link}" placeholder="link"/>
          <p <c:if test="${not empty flagDirigente}">style="color:red"</c:if>>Dirigente</p><input type="text" name="dirigente" value="${param.dirigente}" placeholder="dirigente"/>
          <p <c:if test="${not empty flagRecapito}">style="color:red"</c:if>>Recapito Telefonico</p><input type="tel" name="recapito" value="${param.recapito}" placeholder="(+39)" /> 
          <br>
      </td>
      <td style="font-family:arial;background-color:#a5bacd;color: #007171;font-size:15px;font-weight:bold;" >
         <br>
         <p <c:if test="${not empty flagMail}">style="color:red"</c:if>>Mail</p><input type="email" name="mail" value="${param.mail}" placeholder="mario.rossi@gmail.com"/>
         <br><br><br><br>
         <input type="checkbox" name="set" value="${param.set}" required/>Accetto i termini d'uso
         <br><br>
      <button type="submit" style="border-color:#007171;background-color:#009c9c;width:160px;height:40px;"><b  style="font-size:13px;color:#eaf0f0;font-family:Arial;" >COMPLETA REGISTRAZIONE</b></button><br><br>
      </td>
      <td width="5%" style="background-color:#a5bacd"></td>
    </form>
  </tr>

  <tr height="60">
      <td></td>
      <td></td>
<%------------------------------------------------------------%>
<%---------------MESSAGGIO DI ERRORE--------------------------%>
<%------------------------------------------------------------%>
      <td> <font color="red"><b>${msg}</b></font></td>
  </tr>
</table>
  
<br/>
<br/>

<%------------------------------------------------------------%>
<%-------------------------FRAMMENTO BOTTOM-------------------%>
<%------------------------------------------------------------%>


<%@ include file="bottom.jspf"%>