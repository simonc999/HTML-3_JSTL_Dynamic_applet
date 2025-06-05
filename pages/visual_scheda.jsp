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

<%--------------------------------------------------------------------------------------%>
<%------------------------------    FRAMMENTO TOP      ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="top.jspf"%>


<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
   <form method="POST" action="gestione_prod.jsp"> 
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/> 
      <td align="right" width="60">
        <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
      </td>
   </form>
      


<%------------------------------------------------------------------------%>
<%------------ QUERY CHE ESTRAE I DATI DAL DB RELATIVI AI 
               MESSAGGI CON UN LAB PER UN DETERMINATO TEST(NOTIFICA) -----%>
<%------------------------------------------------------------------------%>
<sql:query var="nuovo_mess">
select m.id_messaggio
from MESSAGGI m, CANDIDATURA c, SCHEDA_PROD s, TEST t
where m.id_test=c.id_test 
      and c.scelto=1 and c.user_lab=m.user_lab and m.nuovo=1 and m.inviato=1 and t.id_test=c.id_test and t.id_scheda=s.id_scheda and s.user_cpr LIKE ? and s.id_scheda LIKE ? 
<sql:param value="${user_userid}"/>
<sql:param value="${param.id_scheda}"/>
</sql:query>


<%-------------    CALCOLO IL NUMERO DI MESSAGGI NUOVI   -----------------%>
<c:set var="n_nuovi_mess" value="${nuovo_mess.rowCount}"/> 


 

<%------------------------------------------------------------------------%>
<%------------     QUERY CHE ESTRAE I DATI DAL DB RELATIVI AI 
                TEST PRESCRITTI PER LA SCHEDA SELEZIONATA(NOTIFICA)  -----%>
<%------------------------------------------------------------------------%>
<sql:query var="nuova">
 select t.id_prescrizione
 from TEST t, SCHEDA_PROD p, TIPO_TEST ti
 where t.id_scheda = p.id_scheda and
       ti.id_tipo=t.id_tipo and 
       t.nuova=true and   
       p.id_scheda LIKE ?
 <sql:param value="${param.id_scheda}"/>
</sql:query>


<%-------------  CALCOLO IL NUMERO DI TEST PRESCRITTI NUOVI  -------------%>
<c:set var="n_test" value="${nuova.rowCount}"/>


<%------------------------------------------------------------------------%>
<%------------     QUERY CHE ESTRAE I DATI DAL DB RELATIVI ALLE 
                 CANDIDATURE PER UN DETERMINATO TEST(NOTIFICA)       -----%>
<%------------------------------------------------------------------------%>
<sql:query var="nuove_candidature">
select c.id_candidatura
from CANDIDATURA c, TEST t, SCHEDA_PROD s
where c.nuova=1 and c.id_test=t.id_test and t.id_scheda=s.id_scheda and 
       s.user_cpr LIKE ? and s.id_scheda LIKE ?
<sql:param value="${user_userid}"/>
<sql:param value="${param.id_scheda}"/>
</sql:query>

<%-------------  CALCOLO IL NUMERO DI NUOVE CANDIDATURE   ----------------%>
<c:set var="n_nuove_candidature" value="${nuove_candidature.rowCount}"/> 

<%-------------  CALCOLO IL NUMERO TOTALE DELLE NOTIFICHE   --------------%>
<c:set var="n_notifiche" value="${n_nuove_candidature + n_test + n_nuovi_mess}"/>


<%----------------------------------------------------------------------------------%>
<%--- QUERY PER VISUALIZZARE I DETTAGLI DEL PRODOTTO SELEZIONATO NELLA 
      PAGINA PRIMA e ACCEDERE AI TEST PRESCRITTI SU QUEL PRODOTTO (gestione_prod) --%>
<%----------------------------------------------------------------------------------%>
<sql:query var="dettagli">
  select p.id_scheda, p.nome_prod, p.tipo, p.uso, p.materiali, p.beneficio, p.inizio_prat, p.stato, p.verbale, p.foto1, p.foto2, p.foto3, p.concluso
    from SCHEDA_PROD p
    where p.id_scheda LIKE ?
  <sql:param value="${param.id_scheda}"/>
</sql:query>

<%----------------------------------------------------------------------------------%>
<%--- QUERY PER VISUALIZZARE IL CERTIFICATORE DEL PRODOTTO SELEZIONATO NELLA 
      PAGINA PRIMA e ACCEDERE AI TEST PRESCRITTI SU QUEL PRODOTTO (gestione_prod) --%>
<%----------------------------------------------------------------------------------%>
<sql:query var="cert">
  select c.nome, c.cognome
    from SCHEDA_PROD p, CERT c
    where c.user_cert=p.user_cert and
          p.id_scheda LIKE ?
  <sql:param value="${param.id_scheda}"/>
</sql:query>

<%--------------------------------------------------------------------------------------%>
<%----------------------------    FRAMMENTO MIDDLE      --------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="middle.jspf"%>






<%--------------------------------------------------------------------------------------%>
<%--------------------------    SEZIONE PRINCIPALE SX      -----------------------------%>
<%--------------------------------------------------------------------------------------%>
<TABLE  cellspacing="0" border="0" bgcolor="#bbccdc" width="100%" height="85%" bordercolor="#41140E"  >
<tr>
  <td align="center" width="60%" style="padding: 0px;border-left-width: 3px ">
    
  <table width="100%" height="100%" bordercolor="bbccdc" >
      <tbody>
        <tr height="10%" >
          <td colspan="3" > &nbsp; </td>
        </tr>
        <tr >
         <td width="10%"></td>
         <td style="font-size:23px; font-family:arial">
         <p style="font-weight: bold;color:#526579;"> 


<%--------------------------------------------------------------------------------------%>
<%----------------- IN BASE ALLO STATO DELLA SCHEDA, STAMPO IL BOLLLINO ----------------%>
<%--------------------------------------------------------------------------------------%>
       <c:if test="${dettagli.rows[0].stato == 0}">
         <img src="bianco.png" width="20" height="20"> 
     </c:if>
     <c:if test="${dettagli.rows[0].stato == 1}">
        <img src="verde.png" width="20" height="20"> 
     </c:if>
     <c:if test="${dettagli.rows[0].stato == 2}">
       <img src="giallo.png" width="20" height="20">  
     </c:if>
     <c:if test="${dettagli.rows[0].stato == 3}">
      <img src="rosso.png" width="20" height="20">
     </c:if>  &nbsp SCHEDA PRODOTTO  &nbsp 
                 
<%--------------------------------------------------------------------------------------%>
<%--------------------  STAMPO LE FOTO DELLA SCHEDA SE CI SONO  ------------------------%>
<%--------------------------------------------------------------------------------------%>
                 <c:if test="${not empty dettagli.rows[0].foto1}">
                <IMG border="0"  src="${dettagli.rows[0].foto1}" width="50" height="50"/>
                 </c:if>
                 <c:if test="${not empty dettagli.rows[0].foto2}">
                <IMG border="0"  src="${dettagli.rows[0].foto2}" width="50" height="50"/>
                </c:if>
                  <c:if test="${not empty dettagli.rows[0].foto3}">
                <IMG border="0"  src="${dettagli.rows[0].foto3}" width="50" height="50"/>
                 </c:if>
        </p>
        
    <table border="1" cellspacing="0" cellpadding="3" bordercolor="bbccdc" bgcolor="white"> </td> </tr>
    <tr>
     <td align="left" width="15%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial">NOME: </font></td>
     <td align="center" bgcolor="white"> ${dettagli.rows[0].nome_prod} </td>
    </tr>

    <tr>
     <td align="left" width="15%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial">CODICE: </font></td>
     <td align="center" bgcolor="white"> ${dettagli.rows[0].id_scheda} </td>
    </tr>

    <tr>
     <td align="left" width="15%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial">TIPO: </font></td>
     <td align="center"bgcolor="white"> ${dettagli.rows[0].tipo} </td>
    </tr>

   <tr>
    <td align="left" width="15%" height="35%" bgcolor="#007171"><font color="#9ad6d6" face="Arial">USO: </font></td>
    <td align="center" height="35%" bgcolor="white"> ${dettagli.rows[0].uso} </td>
   </tr>

   <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial">MATERIALI </font></td>
    <td align="center" bgcolor="white"> ${dettagli.rows[0].materiali} </td>
   </tr>

   <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial">BENEFICIO: </font></td>
    <td align="center" bgcolor="white"> ${dettagli.rows[0].beneficio} </td>
   </tr>

<%--------------------------------------------------------------------------------------%>
<%-----------------      SE LA SCHEDA E' STATA ASSEGNATA AL CERT, 
                                  AGGIUNGO LARIGA E LO STAMPO        -------------------%>
<%--------------------------------------------------------------------------------------%>
 <c:if test="${not empty cert.rows[0].nome &&
              not empty cert.rows[0].cognome}">
   <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial">CERTIFICATORE: </font></td>
    <td align="center" bgcolor="white"> ${fn:trim(cert.rows[0].nome)} &nbsp ${fn:trim(cert.rows[0].cognome)} </td>
   </tr>
 </c:if>

<%--------------------------------------------------------------------------------------%>
<%----------------- SE C'E' IL VERBALE, AGGIUNGO LA RIGA E LO STAMPO    ----------------%>
<%--------------------------------------------------------------------------------------%>
 <c:if test="${not empty dettagli.rows[0].verbale}">
   <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial">VERBALE CONCLUSIVO: </font></td>
    <td align="center" <c:if test="${dettagli.rows[0].concluso == 'true'}"> bgcolor="#add8e6" </c:if>>${dettagli.rows[0].verbale} </td>
   </tr>
 </c:if>



  </table>
<br/><br/>

  <table border="0">
   <tr>
    <td>
     <form method="post" action="elimina_prod.jsp">
      <input type="submit" value="elimina scheda" align="center" style="background-color:#ADD8E6;
       bordercolor:black; width:150px; height:30px;" name="elimina"/ >

      <input type="hidden" name="id_scheda" value="${dettagli.rows[0].id_scheda}"/>
     </form>
    </td>


<%------------------------------------------------------------------------%>
<%----------------- SE LA PRATICA NON E' STATA AVVIATA,
                     STAMPO IL BOTTONE PER MODIFICARE LA SCHEDA   --------%>
<%------------------------------------------------------------------------%>
 <c:if test="${(dettagli.rows[0].stato == 0 && empty dettagli.rows[0].inizio_prat)}">
    <td>
    <form method="post" action="modifica_scheda.jsp">
    <input type="submit" value="modifica scheda" align="center" style="background-color:#ADD8E6;
      bordercolor:black; width:150px; height:30px;" name="modifica"/ >
    <input type="hidden" name="modifica" value="${param.modifica}"/>
    <input type="hidden" name="id_scheda" value="${dettagli.rows[0].id_scheda}"/>
    </form>
    </td>

    <td >
    <form method="post" action="visual_scheda.jsp">
     <input type="submit" value="avvia pratica di certificazione" align="center" style="background-color:#ADD8E6;
      bordercolor:black; width:200px; height:30px;" name="avvia"/ >
     <input type="hidden" name="id_scheda" value="${dettagli.rows[0].id_scheda}"/>
    </form>
   </td>
  </tr>
 </c:if> 

<%------------------------------------------------------------------------%>
<%-----------------   SE LA PRATICA NON E' STATA AVVIATA,
                         STAMPO IL BOTTONE PER AVVIARLA     --------------%>
<%------------------------------------------------------------------------%>
 <c:if test="${not empty param.avvia || not empty errmsg}"> 
   <form method="post" action="avvia_pratica.jsp">
   <input type="hidden" name="id_scheda" value="${dettagli.rows[0].id_scheda}"/>

   <tr>
    <td colspan="3" align="center"><font color="red" size="3">
     Dal momento in cui decidi di avviare la pratica di certificazione, non potrai piu' modificare i dettagli della scheda!</font></td>
   </tr>
   <tr><td colspan="3" align="center">Seleziona la data in cui desideri avviare la pratica di certificazione: </td></tr>
   <tr><td colspan="3" align="center">
                    <input type="date" name="data" value="${param.data}"/>
                    <input type="time" name="ora" value="${param.ora}"/>
                    <input type="submit" value="avvia" name="avvia1" style="color:white; border-color:#007171;background-color:#009c9c;width:145px;height:30px;"/> 
      
      </td>
   </tr>
   </form>
 
</c:if>

</table>


 <font color="red" size="4">${errmsg}</font>

  </tr>
            <tr height="20%">
               <td >&nbsp;</td>
            </tr>
         </tbody>
      </table>
  </td>  

<%------------------------------------------------------------------------%>
<%----------------- SE LA PRATICA E' STATA AVVIATA,
                     VEDO LA SPALLETTA A DX CON I TEST PRESCRITTI   ------%>
<%------------------------------------------------------------------------%>
<c:if test="${not empty dettagli.rows[0].inizio_prat}"> 
  <td width="40%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px" >
     <table  cellspacing="0" width="100%" height="100%"  rules="none" bgcolor="#a5bacd" >
      <tr >
       <td width="60%" align="right" >
    <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" > 

<%------------------------------------------------------------------------%>
<%----------------- SE CI SONO LE NOTIFICHE DEI NUOVI TEST PRESCRITTI,
                     STAMPO L' ALAMBICCO E IL NUMERO DEINUOVI TEST   -----%>
<%------------------------------------------------------------------------%>
           <c:if test="${n_notifiche > 0}"><font color="green" size="2"><b>${n_notifiche}</b></font><img style="width:30px;height:30px;"src="0.png"></c:if>TEST PRESCRITTI</p>
           <hr  color=" #526579" size="9px"> <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >vai ai test prescritti</p></td>
           
    <form method="post" action="test_prescritti.jsp">
         <input type="hidden" name="id_scheda" value="${dettagli.rows[0].id_scheda}"/>
         <input type="hidden" name="nome_prodotto" value="${dettagli.rows[0].nome_prod}"/>
         <td width="40%"  align="center">
       <input type="image" name="submit"  src="arrowbutton.jpeg" style=" width:90px;height:90px"/>

         </td>
    </form>
      </tr>
 


     </table>
  </td>
</c:if>
</tr>
</TABLE>

<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO BOTTOM  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf"%>
