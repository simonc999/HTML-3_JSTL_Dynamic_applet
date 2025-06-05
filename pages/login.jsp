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
<%------------------------------     FRAMMENTO TOP  ------------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@include file="top.jspf"%>



<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
     <td align="right" width="60">
        <a href="index.htm">
         <img style="width:60px;height:60px" src="indietro.png"/>
        </a>
     </td>


<%--------------------------------------------------------------------------------%>
<%------ESTRAZIONE DALLA QUERY DI USERNAME E PASSWORD DI UN RUOLO(DESCRIZIONE)----%>  
<%--------------------------------------------------------------------------------%>
<sql:query var="r">
select u.username, u.password
from UTENTE_RUOLO u, RUOLO r 
where u.cod_ruolo = r.cod_ruolo
and r.descrizione_ruolo LIKE ? 
<sql:param value="${param.ruolo}"/>
</sql:query>


<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO MIDDLE  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@include file="middle.jspf"%>             
            
 <table width="100%" cellpadding="7" cellspacing="0" align="center" border="0" >
   <tr><td align="center" width="30%" style="font-family:arial"> 
       <p style="font-size:23px;font-weight:bold;color: #007171;">AREA LOGIN</p>
       <p style="font-size:18px;font-style: italic;">Se non hai un account e sei una casa produttrice 
       <a href="registrazione.jsp"><font color="#007171">registrati!</font></a></p>

</br> 
</br>
<%---------------------------------------------------------------------%>
<%--MESSAGGIO GENERATO DALLA PAGINA CHE HA RIFIUTATO L'AUTORIZZAZIONE--%>
<%---------------------------------------------------------------------%>

<FONT color="LIMEGREEN">${param.auth_messaggio}</FONT></B>
</br>

<%-----------------------------------------------------------%>
<%--STAMPO MESSAGGIO DI ERRORE SE NON COMPILO TUTTI I CAMPI--%>
<%-----------------------------------------------------------%>

<c:if test="${not empty errmsg}">
    <font color="red"><i><b>${errmsg}</b></i></font></br>
   </c:if>   
</br>

<%---------------------------------------------------------------------------------------%>
<%---MESSAGGIO CHE PROVIENE DALLA REGISTRAZIONE DI UNA CPR CHE E' AVVENUTA CON SUCCESSO--%>
<%--------------------------------------------------------------------------------------%>
<c:if test="${not empty msg1}">
${msg1}
</c:if>
<%--------------------------------------------%>
<%--MESSAGGIO IN CASO DI PASSWORD RECUPERATA--%>
<%--------------------------------------------%>
</br>
<font color="green">${pas_rec}</font>

<%---------------------------------------------------------------------------------%>
<%--MESSAGGIO DI ERRORE SE I VALORI CHE HO INTRODOTTO NELLA LOGIN NON SONO VALIDI--%>
<%---------------------------------------------------------------------------------%>
<B><FONT color="RED">${param.login_errMsg}</FONT></B>
</br>
      
<br/>
<%--------------------------------------------------------------------------------%>
<%-----------------------FORM PER AIUTO NELLA CORREZIONE DEL PROF-----------------%>
<%--------------------------------------------------------------------------------%>
<form action="login.jsp" method="post">

<select name="ruolo" onchange="this.form.submit()">
<option value="" checked>  </option>
<c:forTokens delims="," items="casa produttrice,laboratorio,certificatore,ALA,agenzia governativa" var="scelta">     
             <option value="${scelta}"
                  <c:forEach var="myruolo" items="${paramValues.ruolo}">
                         <c:if test="${scelta == myruolo}"> selected="selected" </c:if>
                  </c:forEach>
             > ${scelta} </option>
</c:forTokens>
</select> 

<br/>
</form>
<%------------------------------------------------------------------------------------%>
<%-------------STAMPO PER OGNI RUOLO TABELLA CON USERNAME E PASSWORD------------------%>
<%------------------------------------------------------------------------------------%>

<c:if test="${not empty param.ruolo}">
<table width="70%" height="50%" cellspacing="0" cellpadding="0">
<tr><td>Username:</td>
    <td>Password:</td>
</tr>
<c:forEach var="profilo" items="${r.rows}">
<tr><td> ${profilo.username} </td>
    <td> ${profilo.password} </td>
</tr>
</c:forEach>
</table>

</c:if>

       </td>
<%-------------------------------------------------------------------------------------%>
<%----------------------------FORM DI LOGIN--------------------------------------------%>   
<%-------------------------------------------------------------------------------------%>
     
     <form action="effettua_login.jsp" method="post">

  <INPUT type="HIDDEN" name="auth_page" 
                       value="${param.auth_page}"/>
  <INPUT type="HIDDEN" name="auth_messaggio"
            value="${param.auth_messaggio}"/>    
   
      <td width="15%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px;background-color:#a5bacd" >
     
        <p style="font-size:15px;font-weight:bold;color: #007171;">USERNAME</p>
        <input type="text" name="form_username" value="${param.form_username}" placeholder="username"/>

        <p style="font-size:15px;font-weight:bold;color: #007171;">PASSWORD</p>
        <input type="password" name="form_password" value="${param.form_password}"  placeholder="password"  minlength="8" >&ensp;&ensp;&ensp;

  </br></br> 

        <a href="recup_psw.jsp"><font color="#007171">Password dimenticata?</font></a>

     </td>
     <td  align="center" width="15%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px;background-color:#a5bacd" >

       
  <input type="submit" align="center" style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;" value="COMPLETA LOGIN">
       
    
     
      </td>      
    </tr>
   </form>
<%------------------------------------------------------------------------------%>
<%--------------------------------------FINE FORM LOGIN-------------------------%>
<%------------------------------------------------------------------------------%>



   </table>

<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO BOTTOM  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@include file="bottom.jspf"%>
     