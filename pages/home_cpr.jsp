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


<%--------------------------------%>
<%---- FRAMMENTO TOP--------------%>
<%--------------------------------%>
<%@ include file="top.jspf"%>

<%--------------------------------%>
<%---- FRAMMENTO MIDDLE  ---------%>
<%--------------------------------%>
<%@ include file="middle.jspf"%>



<%---------------------------------------------%>
<%---- SEZIONE DI NOTIFICHE NELLA HOME --------%>
<%---------------------------------------------%>

<%-----------------------------------------------------------%>
<%---- QUERY PER ESTRARRE IL NUMERO DI NUOVI MESSAGGI -------%>
<%-----------------------------------------------------------%>
<sql:query var="nuovo_mess">
select m.id_messaggio
from MESSAGGI m, CANDIDATURA c, SCHEDA_PROD s, TEST t
where m.id_test=c.id_test 
      and c.scelto=1 and c.user_lab=m.user_lab and m.nuovo=1 and m.inviato=1 and t.id_test=c.id_test and t.id_scheda=s.id_scheda and s.user_cpr LIKE ?
<sql:param value="${user_userid}"/>
</sql:query>

<%-------------  CALCOLO IL NUMERO DI MESSAGGI NUOVI  --------------%>
<c:set var="n_nuovi_mess" value="${nuovo_mess.rowCount}"/> 


<%-----------------------------------------------------------%>
<%------- QUERY PER ESTRARRE IL NUMERO DI NUOVI TEST 
                     PRESCRITTI DAI CERT            ---------%>
<%-----------------------------------------------------------%>
<sql:query var="nuove_presc">
select t.id_prescrizione
from TEST t, SCHEDA_PROD s
where t.nuova=1 and s.id_scheda=t.id_scheda and
       s.user_cpr LIKE ?
<sql:param value="${user_userid}"/>
</sql:query>

<%-------------  CALCOLO IL NUMERO DI PRESCRIZIONI NUOVE  ------------%>
<c:set var="n_nuove_presc" value="${nuove_presc.rowCount}"/> 


<%-----------------------------------------------------------%>
<%----     QUERY PER ESTRARRE IL NUMERO DI NUOVE 
              CANDIDATURE DA PARTE DEI LAB          ---------%>
<%-----------------------------------------------------------%>
<sql:query var="nuove_candidature">
select c.id_candidatura
from CANDIDATURA c, TEST t, SCHEDA_PROD s
where c.nuova=true and c.id_test=t.id_test and t.id_scheda=s.id_scheda and
       s.user_cpr LIKE ?
<sql:param value="${user_userid}"/>
</sql:query>

<%-------------  CALCOLO IL NUMERO DI CANDIDATURE NUOVE  ------------%>
<c:set var="n_nuove_candidature" value="${nuove_candidature.rowCount}"/> 


<%-----------------------------------------------------------%>
<%-------   QUERY PER ESTRARRE IL NUMERO DI NUOVE 
                PRATICHE CONCLUSE DAI CERT          ---------%>
<%-----------------------------------------------------------%>
<sql:query var="nuove_prat_concluse">
select s.id_scheda
from SCHEDA_PROD s
where s.concluso=1 and
       s.user_cpr LIKE ?
<sql:param value="${user_userid}"/>
</sql:query>

<%-------------  CALCOLO IL NUMERO DI PRATICHE CONCLUSE NUOVE  ------------%>
<c:set var="n_nuove_prat_concluse" value="${nuove_prat_concluse.rowCount}"/>


<%--------------------------------------------------------------------------------%>
<%-------------          CALCOLO IL NUMERO TOTALE DELLE NOTIFICHE
                  (PRATICHE + CANDIDATURE + MESSAGGI + PRESCRIZIONI)  ------------%>
<%--------------------------------------------------------------------------------%>
<c:set var="n_notifiche" value="${n_nuove_prat_concluse + n_nuove_candidature + n_nuove_presc + n_nuovi_mess}"/>



<%-----------------------------------------------------------%>
<%------- QUERY PER ESTRARRE I DATI DEL PROFILO LOGGATO -----%>
<%-----------------------------------------------------------%>
<sql:query var="profilo">
select c.nome, u.attivo, c.messaggio
from CPR c, UTENTE_RUOLO u
where u.username=c.user_cpr 
      and c.user_cpr = ?
<sql:param value="${user_userid}"/>
</sql:query>



<%--------------------------------------------------------------------------------------%>
<%--------------------------    SEZIONE PRINCIPALE SX      -----------------------------%>
<%--------------------------------------------------------------------------------------%>
<TABLE  cellspacing="0" border="0" bgcolor="#bbccdc" width="100%" height="77%" bordercolor="#41140E"  >
<tr>
  <td align="center" width="60%" style="padding: 0px;border-left-width: 3px ">


     <table width="100%" height="100%"  >
         <tbody>
            <tr  height="10%" >
               <td colspan="3" > &nbsp; </td>
            </tr>
            <tr >
               <td width="10%"></td>
               <td style="font-size:23px; font-family:arial">
                  <p style="font-weight: bold;color:#526579;">BENVENUTO ${profilo.rows[0].nome} </br> </p>
                  <p style="font-size:15px; font-family:arial;color:#526579;"> visualizza profilo &nbsp <a href="visual_profilo.jsp"><img src="profilo2.png" width="35" align="center"></a></p>

<%-----------------------------------------------------------%>
<%---- SEZIONE DEDICATA ALLE NOTIFICHE (SE CI SONO) ---------%>
<%-----------------------------------------------------------%>
<c:if test="${n_notifiche > 0}">

<table border="1" bordercolor="green">
<tr> 
  <td align="center">
    <table border="0">
     <tr>
       <td align="center"><img style="width:45px;height:45px;" src="alarm.jpg"></td>
        <td align="left">

<%-----------------------------------------------------------------------------------%>
<%---- AVVISO DI NOTIFICA NEL CASO IN CUI CI FOSSERO NUOVI MESSAGGI DAI LAB ---------%>
<%-----------------------------------------------------------------------------------%>
<c:if test="${n_nuovi_mess > 0}"> 
<font size="3" color="green"> ${n_nuovi_mess} NUOVI MESSAGGI! </br>
</font></c:if>

<%-----------------------------------------------------------------------------------%>
<%---- AVVISO DI NOTIFICA NEL CASO IN CUI CI FOSSERO NUOVE PRESCRIZIONI DA CERT -----%>
<%-----------------------------------------------------------------------------------%>
<c:if test="${n_nuove_presc > 0}"> 
<font size="3" color="green"> ${n_nuove_presc} NUOVE PRESCRIZIONI! </br>
</font></c:if>
<%-----------------------------------------------------------------------------------%>
<%------ AVVISO DI NOTIFICA NEL CASO IN CUI CI FOSSERO NUOVE CANDIDATURE
                       PER UN DETERMINATO TEST DA PARTE DEI LAB               -------%>
<%-----------------------------------------------------------------------------------%>
<c:if test="${n_nuove_candidature > 0}"> 
<font size="3" color="green"> ${n_nuove_candidature} NUOVE CANDIDATURE! </br>
</font></c:if>

<%-----------------------------------------------------------------------------------%>
<%----- AVVISO DI NOTIFICA NEL CASO IN CUI CERT SCELGA DI CONCLUDERE UNA PRATICA ----%>
<%-----------------------------------------------------------------------------------%>
<c:if test="${n_nuove_prat_concluse > 0}"> 
<font size="3" color="green"> ${n_nuove_prat_concluse} NUOVE PRATICHE CONCLUSE! </br></font>
</c:if>
</td></tr></table>
</td></tr>
</table>
</c:if>
                  
      <hr align="top" color="#526579" size="5px">

<%------------------------------------------------------%>
<%---- MESSAGGIO CHE APPARE QUANDO IL PROFILO DELLA CPR
     LOGGATA NON E' ANCORA STATO CONVALIDATO DA ALA  ---%>
<%------------------------------------------------------%>
                 <c:if test="${profilo.rows[0].attivo == 'false'}">
          <p style="font-weight: bold;color:#526579;font-size:18px;">
Attraverso questa sezione potrai visualizzare l'iter di certificazione dei tuoi prodotti,ma ancora il tuo account non e' stato convalidato da ALA. A presto!
                 </p>
 </c:if>


<%------------------------------------------------------%>
<%---- MESSAGGIO CHE APPARE QUANDO IL PROFILO 
      DELLA CPR LOGGATA E' STATO CONVALIDATO DA ALA  ---%>
<%------------------------------------------------------%>
               <c:if test="${profilo.rows[0].attivo == 'true'}">  
               <c:if test="${profilo.rows[0].messaggio == 'true'}">
                 <font size="3" color="limegreen"> Il tuo account e' stato convalidato da Ala.<br/> Da questo momento puoi procedere con le operazioni sul tuo profilo. </font> 
               </c:if>

              <p style="font-weight: bold;color:#526579;font-size:18px;">
Attraverso questa sezione potrai visualizzare l'iter di certificazione dei tuoi prodotti.
                 </p>
            <p style="font-size:16px">
               In gestione prodotti potrai:
                <ol style="font-size:16px">
                   <li>visualizzare,modificare e creare le schede dei prodotti </li>
                   <li>avviare la pratica di certificazione per ogni prodotto,</br>visualizzandone lo stato
                  </li>
                   <li>una volta avviata la pratica, potrai visionare per ogni <br/> 
 prodotto i testi prescritti e quelli effettuati  </li>
                   <li>per ogni test prescritto e' possibile vedere <br/> le candidature e i messaggi scambiati con i laboratori candidati.</li>
                </ol>
             </p>
            
            <p style="font-size:16px">
               In pagamenti e' possibile tener traccia di tutti i movimenti bancari.
            </p>
            <p style="font-size:16px">
               In elenco certificatori potrai vedere tutti i CERT che fanno parte della nostra community e le relative case produttrici con cui collaborano. Avrai inoltre la possibilita' di "bannare" i certificatori, cosi da impedire loro la possibilita' di lavorare con i tuoi prodotti.
            </p>
            </c:if>

              </td>
               <td width="10%"></td>
            </tr>
            <tr height="20%">
               <td >&nbsp;</td>
            </tr>
         </tbody>
      </table>
  </td>  



<%--------------------------------------------------------------------------------------%>
<%-----------------        SEZIONE PRINCIPALE DX 
                    (SI VEDE SE LA CPR LOGGATA E' CONVALIDATA)     ---------------------%>
<%--------------------------------------------------------------------------------------%>
<c:if test="${profilo.rows[0].attivo == 'true'}" >
  <td width="40%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px" >
     <table  cellspacing="0" 
     width="100%" height="100%"  rules="none" bgcolor="#a5bacd" >
       <tr >
           <td width="60%" align="right" ><p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" > 

<%--------------------------------------------------------------------------------------%>
<%-- SE CI SONO LE NOTIFICHE, STAMPO ILNUMERO DI QUEST'ULTIME CON L' ALAMBICCO ---------%>
<%--------------------------------------------------------------------------------------%>
<c:if test="${n_notifiche > 0}"><font color="green" size="2"><b>${n_notifiche}</b></font><img style="width:30px;height:30px;" src="0.png"></c:if> GESTIONE PRODOTTI</p>
           <hr  color=" #526579" size="9px"> <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >vai alle schede</p></td>
           <td width="40%"  align="center">
        <a href="gestione_prod.jsp">
          <img style="width:90px;height:90px;"src="arrowbutton.jpeg"></a>
           </td>
      </tr>
        <tr >
           <td width="60%" align="right" ><p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" >PAGAMENTI</p>
           <hr  color=" #526579" size="9px"> <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >visualizza il tuo conto o prosegui per ricaricare il tuo conto </p></td>
           <td width="40%"  align="center"><a href="pagamenti.jsp">
              <img style="width:90px;height:90px;" src="arrowbutton.jpeg"></a>
           </td>
        </tr>
        <tr >
           <td width="60%" align="right" ><p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" >ELENCO CERTIFICATORI</p>
           <hr  color=" #526579" size="9px"> <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >visualizza tutti i certificatori ai quali potranno essere affidate le certificazioni dei tuoi prodotti</p></td>
           <td width="40%"  align="center"><a href="elenco_cert_cpr.jsp">
              <img style="width:90px;height:90px;" src="arrowbutton.jpeg"></a>
           </td>
        </tr>

     </table>
  </td>
</c:if>
</tr>
</TABLE>


<%--------------------------------%>
<%---- FRAMMENTO BOTTOM  ---------%>
<%--------------------------------%>
<%@ include file="bottom.jspf"%>