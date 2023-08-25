<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%--------------------------------------%>
<%-------------TOP----------------------%>
<%--------------------------------------%>
   
<%@include file="top.jspf"%>

     <td align="right" width="60">
        <!-- COMANDO INDIETRO -->
       <a href="index.htm"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
     </td>

     
<%@include file="middle.jspf"%>

   <table width="100%" cellpadding="7" cellspacing="0" align="center" border="0" >
</br></br>

<c:if test="${not empty msg}"> 
     <font style="font-size:14px" color="red" >L'utente ha dimenticato i seguenti campi, separati da punto (.) :
     </font>
${msg}
</c:if>

  <tr align="left" >
      <td></td>
      <td width="30%" style="font-family:arial"> <p style="font-size:23px;font-weight:bold;color: #007171;">AREA REGISTRAZIONE CPR</p>
        <p style="font-size:15px;font-style: italic;">-inserire P.IVA (massimo 11 cifre)</p>
        <p style="font-size:15px;font-style: italic;">-inserire una password( minimo 8 caratteri)</p>
        
<form action="effettua_registrazione.jsp" method="post">


 <input type="hidden" name="attivo" value="0">
 <input type="hidden" name="codice" value="5">
 <input type="hidden" name="nuovo" value="1">  
 <input type="hidden" name="convalida" value="0">
    
   <td width="15%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px;background-color:#a5bacd" >


    <p style="font-size:15px;font-weight:bold;color: #007171;">Nome Azienda</p>

    <input type="text" name="Nome_azienda" value="${param.Nome_azienda}" placeholder="Nome" >

    <p style="font-size:15px;font-weight:bold;color: #007171;">P.IVA</p>
    <input type="num" name="PartitaIva" value="${param.PartitaIva}" placeholder="P.IVA" >
     <br/> <font color="red" size="1"> ${controllo_piva} </font>   

    <p style="font-size:15px;font-weight:bold;color: #007171;">Link sito azienda</p>
    <p>http:// &nbsp <input type="text" name="url" value="${param.url}" placeholder="cpr.it"></p>
        
          
    <p style="font-size:15px;font-weight:bold;color: #007171;">Mercato </p>
      <select name="mercato">
           <option value="" checked>--Seleziona il mercato dei tuoi prodotti--</option>
              <c:forTokens var="mercato" items="Italiano,Europeo,Internazionale" delims=",">
                 <option value="${mercato}"  
                    <c:forEach var="mymercato" items="${paramValues.mercato}">
                       <c:if test="${mymercato == mercato}">
                             selected="selected"
                       </c:if>
                    </c:forEach>
                 >${mercato}</option>
              </c:forTokens>
   </select>
  <p style="font-size:15px;font-weight:bold;color: #007171;">Saldo disponibile</p>
  <input type="text" name="saldo" value="${param.saldo}" placeholder="es:1200.00"/>
   
   </td>
          
          
          
   <td width="15%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px;background-color:#a5bacd" >

         <p style="font-size:15px;font-weight:bold;color: #007171;">Recapito telefonico</p><input type="tel" name="tel" value="${param.tel}" placeholder="aggiungere prefisso(es +39)" maxlenght="14">


          <p style="font-size:15px;font-weight:bold;color: #007171;">Sede Legale</p><input type="text" name="indirizzo" value="${param.indirizzo}" placeholder="Indirizzo" >    


          <p style="font-size:15px;font-weight:bold;color: #007171;">Dirigente</p>
<input type="text" name="dirigente"  value="${param.dirigente}" placeholder="Nome Cognome" >

          <p style="font-size:15px;font-weight:bold;color: #007171;">E-mail</p>
   <input type="email" name="email" value="${param.email}" placeholder="esempio@esempio.it" >

</td>          
            
                       
<td width="40%" style="font-family:arial;background-color:#a5bacd">        
         <p style="font-size:15px;font-weight:bold;color: #007171;">USERNAME</p>
         <input type="text" name="username" value="${param.username}" placeholder="username"  >
        
         <p style="font-size:15px;font-weight:bold;color: #007171;">PASSWORD</p>
       <input type="password" placeholder="password" name="password" value="${param.password}"minlength="8" >

       <p style="font-size:15px;font-weight:bold;color: #007171;">CONFERMA PASSWORD</p>           <input type="password" placeholder="verifica" name="confirm_password" value="${param.confirm_password}" minlength="8" >

<p style="font-size:15px;font-weight:bold;color: #007171;">Scegli la tua domanda di sicurezza:</p>
      <select name="domanda_sicurezza">
           <option value="" checked>--Seleziona la tua domanda di sicurezza--</option>
              <c:forTokens var="domanda" items="Qual e il nome di tua mamma?,Qual e il tuo colore preferito?" delims=",">
                 <option value="${domanda}"  
                    <c:forEach var="mydomanda" items="${paramValues.domanda_sicurezza}">
                       <c:if test="${mydomanda == domanda}">
                             selected="selected"
                       </c:if>
                    </c:forEach>
                 >${domanda}</option>
              </c:forTokens>
   </select>

    <input type="text" name="risposta" value="${param.risposta}" placeholder="risposta">
       </br></br>
    <input type="checkbox" name="privacy" checked="checked">
        Dichiaro di aver preso visione dell'<a href="info_privacy.jsp"><b><font color="#007171">Informativa sulla privacy</font></b></a>
        
       </br></br>
 
       <button type="submit" style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;">
         <b  style="font-size:13px;color:#eaf0f0;font-family:Arial;" >
         COMPLETA REGISTRAZIONE
         </b>
       </button>
      
      </form>
</td>  
</tr>
</table>
<%--------------------------------------%>
<%---ERRORE IN CASO DI USERNAME UGUALE---%>
<c:if test="${not empty errmsg}">
<font color="red">${errmsg}</font>
</c:if>
<%@include file="bottom.jspf"%>