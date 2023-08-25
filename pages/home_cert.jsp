<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%----- FRAMMENTO AUTH ------%>
<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/>

<%@ include file="auth.jspf"%>

<%----- FRAMMENTO TOP ------%>
<%@ include file="top.jspf"%>


<%----- FRAMMENTO MIDDLE ------%>
<%@ include file="middle.jspf"%>





<%--------------------------------------------------------------------%>
<%----------QUERY CHE ESTRAE NOME E COGNOME DEL CERT---------%>

<sql:query var="Nome_cert">
    select c.nome, c.cognome, u.attivo
    from CERT c, UTENTE_RUOLO u
    where c.user_cert=u.username and
          c.user_cert="${user_userid}"
</sql:query>


<%--------------------------------------------------------------------%>
<%----------QUERY CHE TROVA I PRODOTTI DEL CERT---------%>

<sql:query var="rset_elencoprod">
    select p.nome_prod, p.id_scheda, p.user_cert, c.nome
    from SCHEDA_PROD p, CPR c
    where  fine_prat is null
           and p.user_cpr = c.user_cpr
           and p.user_cert=? 

<sql:param value="${user_userid}"/>
</sql:query>

<c:set var="n_schede" value="${rset_elencoprod.rowCount}"/>
<%-----------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE LA NOTIFICA SE C'E' UN  NUOVO PRODOTTO ASSEGNATO --%>

<sql:query var="nuovi_prod">
    select nome_prod
    from SCHEDA_PROD 
    where  fine_prat is null
    and    nuovo_assegnato =1
    and    user_cert= ? 
   <sql:param value="${user_userid}"/>
          
</sql:query>

<c:set var="notifica" value="${nuovi_prod.rowCount}"/>


<TABLE  cellspacing="0" border="0" bgcolor="#bbccdc"
          width="100%" height="100%" bordercolor="#41140E"  > 
<tr>
<td align="left" width="65%" style="padding: 0px;border-left-width: 3px ">

<%---------------------------%>
<%-- SEZIONE PRINCIPALE SX --%>
<%---------------------------%>

<table border="0" width="100%" height="100%" cellspacing="0">
<tr height="10%" >
<td colspan="3">&nbsp </td>
</tr>
<tr><td width="10%"></td>

<%---------------------------------------------------------------------------------%>
<%-- PARTE INIZIALE --%>
<%---------------------------------------------------------------------------------%>

  <td style="font-size:23px; font-family:arial">
  <p style="font-weight: bold;color:#526579;">
   BENVENUTO ${Nome_cert.rows[0].nome} ${Nome_cert.rows[0].cognome} </br> </p>

  <p style="font-size:15px; font-family:arial;color:#526579;"> 
   visualizza profilo &nbsp <a href="visual_profilo_cert.jsp"><img src="profilo2.png" 
   width="35" align="center"></a></p>
<c:if test="${notifica > 0 && Nome_cert.rows[0].attivo == 'true'}">
<table border="1" bordercolor="green">
<tr><td align="center">
<table border="0">
<tr>
<td align="center"><img style="width:45px;height:45px;" src="alarm.jpg"></td>
<td align="left">
<font color="green" size="4"> ${notifica} NUOVI PRODOTTI ASSEGNATI! </font>

</td></tr></table>
</td></tr></table>
</c:if>


  

 <hr align="top" color="#526579" size="5px"> 
  
<%----------------------------------------------------------------%>
<%-------------------- AVVISO NOTIFICA ---------------------------%>
  <c:if test="${Nome_cert.rows[0].attivo == 'false'}">
    </td></tr><tr height="40%">
   
    <td width="10%"></td>

    <td align="left" valign="top">
    <p style="font-weight: bold;color:#526579;font-size:20px;">
   Il tuo account e' stato sospeso. Per ritornare ad essere operativo, contatta l' agenzia governativa! </p>
  </td></tr></table></td>
 </c:if>



 <c:if test="${Nome_cert.rows[0].attivo == 'true'}">

    


<%---------------------------------------------------------------------------------%>
<%-- DESCRIZIONE GENERALE DEI CERT --%>
<%---------------------------------------------------------------------------------%>
   
   <p style="font-weight: bold;color:#526579;font-size:18px;">
   Attraverso questa sezione potrai tenere traccia di tutti i prodotti che ti ha assegnato GOV e prescrivere test per ogni prodotto.
   </p>
   <p style="font-size:16px">
   Da qui in poi potrai:
   <ol style="font-size:16px">
      <li>visualizzare i prodotti che ti ha assegnato Gov e per ogni prodotto visualizzare tutti i dettagli del prodotto con il suo stato di avanzamento(GESTIONE PRODOTTI) </li> </br>
      <li>Per ogni prodotto potrai prescrivere nuovi test e visualizzare i test gia'  prescritti nella sezione TEST.</li></br>
      <li> Quando tutti i test prescritti per un prodotto sono stati effettuati potrai compilare il verbale conclusivo che terminera' la pratica di certificazione del prodotto nella sezione VERBALE </li></br>
     <li>Per ogni test prescritto il certificatore puo' visualizzare nella sezione MESSAGGI, i messaggi scambiati tra il laboratorio che ha effettuato il test e la casa produttrice.</li>
  </ol>
  </p>

    </td>
   <td width="10%" ></td>
   </tr>

   <tr height ="20%">
   <td> &nbsp </td>
   </tr>
   </tr>
</table>
</td>


					


<%---------------------------%>
<%-- SEZIONE PRINCIPALE DX --%>
<%---------------------------%>
<td width="35%" style="padding: 0px; border-left-width: 1px; border-right-width: 3px">
 <table  cellspacing="0" width="100%" height="100%"  rules="none" bgcolor="#a5bacd">
 <tr >
 <c:choose>
 <c:when test="${n_schede > 0}" >
           <td width="60%" align="right" ><p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" ><c:if test="${notifica > 0}"><font color="green" size="2"><b>${notifica}</b></font><img style="width:30px;height:30px;" src="0.png"></c:if> GESTIONE PRODOTTI</p>
           <hr  color=" #526579" size="9px"> <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >Visualizza le schede assegnate da GOV</p></td>
           <td width="40%"  align="center"><a href="schede_cert.jsp">
              <img style="width:90px;height:90px;" src="schede_prod.jpeg"></a>
           </td>
 </c:when>
 <c:otherwise>
          <td width="60%" align="right" ><p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" >GESTIONE PRODOTTI</p>
           <hr  color=" #526579" size="9px"> <p style="font-size:15px; color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >Al momento non ha alcun prodotto in gestione.</p></td>
            <td width="40%"  align="center">
              <img style="width:90px;height:90px;" src="schede_prod.jpeg">
           </td>
 </c:otherwise>
 </c:choose>

          
        </tr>
                           
   </table>
  </td>
 
</c:if>





 </tr>
 </TABLE>


<%----- FRAMMENTO BOTTOM ------%>
<%@ include file="bottom.jspf"%>









