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
       <form method="post" action="test_prescritti.jsp"> 
        <td align="right" width="60" >
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
       <input type="image" name="submit" style="width:62px" src="indietro.png"/>
          </td> 
       </form>
  

<%------------------------------------------------------------------------%>
<%-------- QUERY CHE ESTRAE I DATI DAL DB RELATIVI ALLA 
             CANDIDATURA DI UN LAB PER UN DETERMINATO TEST (NOTIFICA) ----%>
<%------------------------------------------------------------------------%>
<sql:query var="cand">
  select c.id_candidatura
           from CANDIDATURA c, LAB l, TEST t, AVERE_LISTINO a
           where l.user_lab=c.user_lab and
                 c.id_test=t.id_test and
                 a.id_tipo=t.id_tipo and
                 c.user_lab=a.user_lab and 
                 c.nuova = true and
                 t.id_prescrizione  LIKE ?
                <sql:param value="${param.presc}"/>
</sql:query>

  
<%-------------  CALCOLO IL NUMERO DI CANDIDATURE   ---------------------%>
<c:set var="n_cand" value="${cand.rowCount}"/>


<%------------------------------------------------------------------------%>
<%------------ QUERY CHE ESTRAE I DATI DAL DB RELATIVI AI 
               MESSAGGI CON UN LAB PER UN DETERMINATO TEST(NOTIFICA) -----%>
<%------------------------------------------------------------------------%>
<sql:query var="mess">
SELECT m.id_messaggio
FROM MESSAGGI m, TEST t, LAB l
WHERE t.id_test=m.id_test and 
      l.user_lab=m.user_lab and 
      m.nuovo = 1 and 
      m.inviato = 1 and
      t.id_prescrizione = ?
      <sql:param value="${param.presc}"/>

</sql:query>


<%-------------    CALCOLO IL NUMERO DI MESSAGGI     ---------------------%>
<c:set var="n_mess" value="${mess.rowCount}"/>


<%------------------------------------------------------------------------%>
<%------------ QUERY CHE ESTRAE I DATI DAL DB RELATIVI AI 
               DETTAGLI DEL TEST SELEZIONATO DALLA PAGINA PRECEDENTE -----%>
<%------------------------------------------------------------------------%>
<sql:query var="dettagli">
SELECT te.id_prescrizione, te.data_ora_presc, t.descrizione, te.scopo, t.descrizione, t.tipo, te.annullo_motivo, te.nuova
FROM TEST te, TIPO_TEST t
WHERE t.id_tipo = te.id_tipo and 
      te.id_prescrizione = ?
      <sql:param value="${param.presc}"/>
</sql:query>


<%-------------------------------------------------------------------------------------------%>
<%--- SE IL TEST E' NUOVO, QUANDO LO SELEZIONO FACCIO L' UPDATE PER RENDERLO VISUALIZZATO ---%>
<%-------------------------------------------------------------------------------------------%>
<c:if test="${dettagli.rows[0].nuova == 'true'}">
<sql:update>
update TEST set nuova = false
 where id_prescrizione LIKE ?
<sql:param value="${param.presc}"/>
</sql:update>
</c:if>


<%--------------------------------------------------------------------------------------%>
<%----------------------------    FRAMMENTO MIDDLE      --------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="middle.jspf"%>



<%--------------------------------------------------------------------------------------%>
<%--------------------------    SEZIONE PRINCIPALE SX      -----------------------------%>
<%--------------------------------------------------------------------------------------%>
<TABLE  cellspacing="0" border="0" bgcolor="#bbccdc" width="100%" height="77%" bordercolor="#41140E"  >
<tr>
  <td align="center" width="60%" style="padding: 0px;border-left-width: 3px ">

     <table width="100%" height="100%"  >
            <tr height="10%" >
               <td colspan="3" > &nbsp; </td>
            </tr>
            <tr >
               <td width="10%"></td>
               <td style="font-size:23px; font-family:arial">
                  <p style="font-weight: bold;color:#526579;">TEST PRESCRITTO PER: ${param.nome_prodotto} </br> </p>
                    
      <table border="1" cellspacing="0" cellpadding="3"> </td> </tr>
        <tr>
         <td align="left" width="20%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial" size="4"><b>CODICE PRESCRIZIONE: </b></font></td>
         <td bgcolor="white" align="left"><font face="Arial" size="4">${dettagli.rows[0].id_prescrizione}</font> </td>
        </tr>

        <tr>
         <td align="left" width="20%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial" size="4"><b>NOME TEST PRESCRITTO: </b></font></td>
         <td bgcolor="white" align="left"> <font face="Arial" size="4">${dettagli.rows[0].descrizione}</font></td>
        </tr>

        <tr>
         <td align="left" width="20%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial" size="4"><b>DATA PRESCRIZIONE:                   </b></font></td>
         <td bgcolor="white" align="left"> <font face="Arial" size="4">${dettagli.rows[0].data_ora_presc}</font></td>
         </tr>

        <tr>
         <td align="left" width="20%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial" size="4"><b>SCOPO: </b></font></td>
         <td bgcolor="white" align="left"> <font face="Arial" size="4">${dettagli.rows[0].scopo}</font></td>
        </tr>

        <tr>
         <td align="left" width="20%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial" size="4"><b>TIPO TEST: </b></font></td>
         <td bgcolor="white" align="left"><font face="Arial" size="4">${dettagli.rows[0].tipo}</font></td>
        </tr>

<%--------------------------------------------------------------------------------------%>
<%------------ SE IL TEST VIENE ANNULLATO, STAMPO IL MOTIVO DELL' ANNULLO --------------%>
<%--------------------------------------------------------------------------------------%>
       <c:if test="${not empty dettagli.rows[0].annullo_motivo}">
        <tr>
         <td align="left" width="20%" height="22%" bgcolor="#007171"><font color="#9ad6d6" face="Arial" size="4"><b>MOTIVAZIONE DELL' ANNULLO: </b></font></td>
         <td bgcolor="white" align="left"><font face="Arial" size="4">${dettagli.rows[0].annullo_motivo}</font></td>
        </tr>
       </c:if>

        </table>
           </td>
            </tr>
            <tr height="20%">
               <td >&nbsp;</td>
            </tr>
      </table>
  </td>   
  <td width="40%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px" >
   <br/>

<%--------------------------------------------------------------------------------------%>
<%--------------------------    SEZIONE PRINCIPALE DX      -----------------------------%>
<%--------------------------------------------------------------------------------------%>


<%--------------------------------------------------------------------------------------%>
<%------------ SE IL TEST VIENE ANNULLATO, STAMPO MESSAGGIO DELL' ANNULLO --------------%>
<%--------------------------------------------------------------------------------------%>

    <c:if test="${not empty dettagli.rows[0].annullo_motivo}">
         <font color="green" size="4"> &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Essendo il test annullato, non e' possibile <br/> &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp visualizzare le candidature e i messaggi </font>
    </c:if>

<%------------------------------------------------------------------------------------------%>
<%------------ SE IL TEST NON VIENE ANNULLATO, STAMPO MESSAGGIO DELL' ANNULLO --------------%>
<%------------------------------------------------------------------------------------------%>
    <c:if test="${empty dettagli.rows[0].annullo_motivo}"> 
      <table  cellspacing="0" width="100%" height="100%"  rules="none" bgcolor="#a5bacd" >
       <tr > 
         <td width="70%" align="right" ><p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" > 


<%--------------------------------------------------------------------------------------%>
<%------------------   SE CI SONO CANDIDATURE NUOVE, STAMPO L' ALAMBICCO 
                          E IL NUMERO DELLE NUOVE CANDIDATURE               ------------%>
<%--------------------------------------------------------------------------------------%>
    <c:if test="${n_cand > 0}">
     <font color="green" size="2"><b>${n_cand}</b></font><img style="width:30px;height:30px;"src="0.png"/>
    </c:if>

     CANDIDATURE</p>
     <hr  color=" #526579" size="9px"> <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >vai  alle candidature o prosegui per annullare il test</p></td>
         <td width="40%"  align="center">
           <form method="post" action="candidature.jsp">
            <input type="hidden" name="descrizione" value="${dettagli.rows[0].descrizione}"/>
            <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
            <input type="hidden" name="test" value="${dettagli.rows[0].id_prescrizione}"/>
            <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
            <input type="image" name="submit"  src="arrowbutton.jpeg" style="width:90px;height:90px"/>
           </form>
          </td>

      </tr>
      <tr>
        <td width="70%" align="right"><p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px" > 


<%--------------------------------------------------------------------------------------%>
<%------------------   SE CI SONO MESSAGGI NUOVI, STAMPO L' ALAMBICCO 
                          E IL NUMERO DEI NUOVI MESSAGGI                    ------------%>
<%--------------------------------------------------------------------------------------%>
<c:if test="${n_mess > 0}">
    <font color="green" size="2"><b>${n_mess}</b></font><img style="width:30px;height:30px;"src="0.png">
</c:if>

      MESSAGGI </p>
      <hr color="#526579" size="9px"> <p style="font-size:15px;color: #e3f1fe;font-weight: bold; font-family:arial;margin-top:14px" >vai qui per conrollare la tua posta </p></td>

        <td width="40%"  align="center">
            <form method="post" action="posta_lab.jsp">
             <input type="hidden" name="descrizione" value="${dettagli.rows[0].descrizione}"/>
             <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
             <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
             <input type="hidden" name="test" value="${dettagli.rows[0].id_prescrizione}"/>
             <input type="image" name="submit"  src="arrowbutton.jpeg" style="width:90px;height:90px"/>
            </form>
        </td>
      </tr>
        

     </table>
   </c:if>
  </td>
</tr>
</TABLE>


<%--------------------------------------------------------------------------------------%>
<%--------------------------        FRAMMENTO BOTTOM       -----------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf"%>



