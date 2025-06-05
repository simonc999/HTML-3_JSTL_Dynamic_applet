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
<%------------------------------AUTORIZZAZIONE AREA LAB---------------------------------%>
<%--------------------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>



<%--------------------------------%>
<%---- FRAMMENTO TOP--------------%>
<%--------------------------------%>

<%@ include file="top.jspf"%>



<%--------------------------------%>
<%---- FRAMMENTO CENTRALE---------%>
<%--------------------------------%>

<%@ include file="middle.jspf"%>



<%---- QUERY PER SELEZIONARE IL NOME DEL LAB---------%>

<sql:query var="Nome_lab">
    select nome
    from LAB
    where user_lab="${user_userid}"
</sql:query>

<%---- QUERY PER SELEZIONARE L'ELENCO DEI TEST SVOLTI DAL LAB---------%>

<sql:query var="elenco_test">
select t.id_test
    from TEST t, CANDIDATURA c
    where t.id_test=c.id_test and c.user_lab = "${user_userid}"
</sql:query>


<%---- SEZIONE DI NOTIFICHE NELLA HOME---------%>

<%---- QUERY PER ESTRARRE LE NUOVE PRESCRIZIONI DISPONIBILI PER LA CANDIDATURA---------%>

  <sql:query var="nuove_presc">
   select t.id_prescrizione
   from TEST t, SCHEDA_PROD p, TIPO_TEST tt, VISUALIZZARE_PRESC vp, AVERE_LISTINO a
   where t.id_scheda= p.id_scheda and tt.id_tipo=t.id_tipo and t.id_test not in(select id_test from CANDIDATURA where 
   user_lab="${user_userid}" and data_cand is not null and
   scelto = '1') and t.id_tipo=a.id_tipo and vp.nuova='1' and a.user_lab="${user_userid}" and
   vp.user_lab="${user_userid}" and vp.id_presc=t.id_prescrizione and t.id_test not in (select id_test from CANDIDATURA)
</sql:query>   

<c:set var="n_presc" value="${nuove_presc.rowCount}"/>


<%---- QUERY PER ESTRARRE I NUOVI MESSAGGI INVIATI DA CERT A LAB---------%>

<sql:query var="nuovo_mess">
select m.id_messaggio
from MESSAGGI m, CANDIDATURA c, TEST t
where m.id_test=c.id_test 
      and c.scelto=1 and c.user_lab=m.user_lab and m.nuovo=1 and m.inviato=0 and t.id_test=c.id_test and m.user_lab LIKE ?
<sql:param value="${user_userid}"/>
</sql:query>
<c:set var="n_nuovi_mess" value="${nuovo_mess.rowCount}"/>
<c:set var="n_notifiche" value="${n_nuovi_mess + n_presc}"/>




<TABLE  cellspacing="0" border="0" bgcolor="#bbccdc"
          width="100%" height="100%" bordercolor="#41140E"  >


<%----------------------------------------------------------------------------------------------------%>
<%----------------------------------------- SEZIONE SX -----------------------------------------------%>
<%----------------------------------------------------------------------------------------------------%>
   
<tr>
<td align="left" width="60%" style="padding: 0px;border-left-width: 3px ">
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
   BENVENUTO ${Nome_lab.rows[0].nome} </br> </p>

  <p style="font-size:15px; font-family:arial;color:#526579;"> 
   visualizza profilo &nbsp <a href="visual_profilo_lab.jsp"><img src="profilo2.png" 
   width="35" align="center"></a></p>

<%--- RIQUADRO DELLE NOTIFICHE ------%>

<c:if test="${n_notifiche > 0}">
<table border="1" bordercolor="green">
<tr><td align="center">
<table border="0">
<tr>
<td align="center">
<img style="width:45px;height:45px;" src="alarm.jpg"></td>
<td align="left">

<%--- AVVISO DI NOTIFICA NEL CASO IN CUI CI FOSSERO NUOVE PRESC DA PARTE DI CERT------%>

<c:if test="${n_presc > 0}"> 
<font size="3" color="green"> ${n_presc} NUOVE PRESCRIZIONI! </br>
</font></c:if>

<%--- AVVISO DI NOTIFICA NEL CASO IN CUI CI FOSSERO NUOVI MESS------%>

<c:if test="${n_nuovi_mess > 0}"> 
<font size="3" color="green"> ${n_nuovi_mess} NUOVI MESSAGGI! </br>
</font></c:if>
</td></tr></table>
</td></tr></table>
</c:if>
   
    <hr align="top" color="#526579" size="5px"> 
<%---------------------------------------------------------------------------------%>
<%-- DESCRIZIONE GENERALE DEI LAB --%>
<%---------------------------------------------------------------------------------%>
   
   <p style="font-weight: bold;color:#526579;font-size:18px;">
   A partire da questa sezione potrai accedere a tutte le tue funzionalita'
   </p>
   <p style="font-size:16px">
   Da qui infatti potrai:
<br>
   <ol style="font-size:16px">
      <li>visualizzare i test per i quali hai effettuato una candidatura nella sezione TEST APPROVATI </li><br>
      <li>visualizzare i test prescritti dai certificatori per i quali puoi candidarti nella sezione TEST PRESCRITTI</li><br>
     <li> visualizzare le tipologie di test che il laboratorio puo' svolgere nella sezione LISTINO, ed eventualmente aggiungerne di nuove </li>
     
  </ol>
  </p>

    </td>
   <td width="10%" ></td>
   </tr>
   <tr height ="10%">
   <td> &nbsp </td>
   </tr>
</table>
</td>

		
</table>
</td>
<%---------------------------------------------------------------------------------%>
<%----------------- SEZIONE DX, CONTIENE I VARI SUBMIT  ---------------------------%>
<%---------------------------------------------------------------------------------%>

        			<td width="35%" style="padding: 0px; border-left-width: 1px; border-right-width: 3px">
           				<table  cellspacing="0" width="100%" height="100%"  rules="none" bgcolor="#a5bacd">
                          <tr>
                            <c:choose>
                                <c:when test="${not empty elenco_test}" >
                                 <td width="55%" align="left">
                                       <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">
                                        <c:if test="${n_nuovi_mess > 0}">
                                            <font color="green" size="2">
                                                <b>${n_nuovi_mess}</b>
                                            </font>
                                            <img style="width:30px;height:30px;" src="0.png">
                                            </c:if>TEST</p>
                                       <hr color="#53667a" size="9px"> 
                                       <p style="font-size:15px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Registro delle candidature e dei test approvati</p>
                                 </td>             
                                 <form method="post" action="test.jsp"> 
                                      <td width="45%"  align="center">
                                          <button  style="border-color: #a5bacd;background-color:   #a5bacd;">
                                            <img style="width:90px;height:90px;"src="testeff.jpg">
                                          </button>
                                          <input type="hidden"  name="Nome_prod" value="${user.userid}">
                                      </td>    
                                 </form>
                                </c:when>
                                <c:otherwise>
                                <td width="55%" align="left">
                                       <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">
                                        <c:if test="${n_nuovi_mess > 0}">
                                            <font color="green" size="2">
                                                <b>${n_nuovi_mess}</b>
                                            </font>
                                            <img style="width:30px;height:30px;" src="0.png">
                                            </c:if>TEST</p>
                                       <hr color="#53667a" size="9px"> 
                                       <p style="font-size:15px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Non hai ancora effettuato test o candidature</p>
                                 </td>             
                                     <td width="45%"  align="center">
                                          <img style="width:90px;height:90px;"src="testeff.jpg">
                                      </td>   
                                </c:otherwise>
                            </c:choose>
                            </tr>
                            <tr>
                               <td width="55%" align="left">
                                   <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">
                                    <c:if test="${n_presc > 0}">
                                        <font color="green" size="2">
                                            <b>${n_presc}</b>
                                        </font>
                                        <img style="width:30px;height:30px;" src="0.png"></c:if>NUOVE PRESCRIZIONI</p>
                                   <hr color="#53667a" size="9px"> 
                                   <p style="font-size:15px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Visualizza le prescrizioni disponibili per la candidatura</p>
                                   </td>
                               <form method="post" action="nuove_presc.jsp"> 
                               		<td width="45%"  align="center">
                                        <button  style="border-color: #a5bacd;background-color:   #a5bacd;">
                                            <img style="width:90px;height:90px;"src="iconapresc.png">
                                        </button>
                                        <input type="hidden"  name="Nome_prod" value="${user.userid}">
                                    </td>
                           		</form> 
                           </tr>
                            <tr>
                                    <td width="55%" align="left">
                                        <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">LISTINO PREZZI</p>
                                        <hr color="#53667a" size="9px"> 
                                        <p style="font-size:15px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Visualizza il tuo listino prezzi</p>
                                     </td>
                                    <form method="post" action="listino.jsp"> 
                                      <td width="45%"  align="center">
                                             <button  style="border-color: #a5bacd;background-color:   #a5bacd;">
                                                <img style="width:90px;height:90px;"src="registro.jpg">
                                             </button>
                                             <input type="hidden"  name="Nome_prod" value="${user.userid}">
                                         </td>
                                  </form> 
                           </tr>
                        </table>
                     </td>
                </tr>
            </table>
        </td>
 </TABLE>


<%@ include file="bottom.jspf"%>

