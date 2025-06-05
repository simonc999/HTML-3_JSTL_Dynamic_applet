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
<%@include file="top.jspf"%>
   
<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
  <form method="post" action="visual_scheda.jsp"> 
    <td align="right"  width="60">
        <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
        <input type="image" name="submit"  src="indietro.png" style="width:60px;height:60px">
    </td>  
  </form>


<%-------------------------------------------------------------%>
<%--- QUERY CHE ESTRAE DAL DB L'ESITO DEL TEST SELEZIONATO  ---%>
<%-------------------------------------------------------------%>
<sql:query var="esito">
 select data_ora_esito, superato, rapporto
 from TEST 
 where id_prescrizione LIKE ?
<sql:param value="${param.presc}"/>
</sql:query>


<%--------------------------------------------------------------------------------------%>
<%--- QUERY CHE PERMETTE DI FAR DIVENTARE UN VERB CONCLUSIVO DA NUOVO NON PIU NUOVO  ---%>
<%--------------------------------------------------------------------------------------%>
<sql:update>
UPDATE SCHEDA_PROD 
   SET concluso = false
 WHERE id_scheda LIKE ?
<sql:param value="${param.id_scheda}"/>
</sql:update>



<%--------------------------------------------------------------------%>
<%--- QUERY CHE ESTRAE I TEST PRESCRITTI PER LA SCHEDA SELEZIONATA ---%>
<%--------------------------------------------------------------------%>

<sql:query var="dettagli">
 select t.id_prescrizione, t.data_ora_presc, t.motivi, ti.descrizione, t.nuova, t.data_ora_esito, t.id_test
 from TEST t, SCHEDA_PROD p, TIPO_TEST ti
 where t.id_scheda = p.id_scheda and
       ti.id_tipo=t.id_tipo and
       p.id_scheda LIKE ?
 <sql:param value="${param.id_scheda}"/>
      order by t.data_ora_presc desc
</sql:query>


<%-------------  CALCOLO IL NUMERO DI TEST PRESCRITTI NUOVI  --------------%>
<c:set var="n_presc" value="${dettagli.rowCount}"/>


<%--------------------------------------------------------------------------------------%>
<%------------------------------    FRAMMENTO MIDDLE   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@include file="middle.jspf"%>





<TABLE height="100%" width="80%" border="0">

<%--------------------------------------------------------------------%>
<%--- SE NON CI SONO TEST PRESCRITTI, VEDO IL MESSAGGIO DI AVVISO  ---%>
<%--------------------------------------------------------------------%>

    <c:if test="${n_presc == 0}"> 
     <tr>
      <td align="center">
       <font color="green" size="5"> Il certificatore assegnato a questa scheda non ha ancora prescritto nessun test. </font>
      </td>
     </tr>
    </c:if>

<%--------------------------------------------------------------------------%>
<%--- SE CI SONO TEST PRESCRITTI, VEDO LA TABELLA CON L' ELENCO DEI TEST ---%>
<%--------------------------------------------------------------------------%>

    <c:if test="${n_presc > 0}">
   
    <td>
       
      <table width="700" border="0" bordercolor="bbccdc">
         <caption align="top"><h1><font color="007171">TEST PRESCRITTI PER : ${param.nome_prodotto}</font></h1></caption>
          <tr  bgcolor="#007171" >
           <th align="center" width="140" height="10%"><font color="#9ad6d6" face="Arial"><b> CODICE PRESCRIZIONE: </b></font></th>
           <th align="center" width="140" height="10%"><font color="#9ad6d6" face="Arial"><b> NOME TEST: </b></font>          </th>
           <th align="center" width="140" height="10%"><font color="#9ad6d6" face="Arial"><b> DATA PRESCRIZIONE: </b></font>  </th>
           <th align="center" width="140" height="10%"><font color="#9ad6d6" face="Arial"><b>MOTIVO: </b></font>              </th>
           <th align="center" width="140" height="10%"><font color="#9ad6d6" face="Arial"><b>OPZIONI:</b></font>                      </th>
          </tr>
        </table>
            
       
            <div style="width:850px; overflow:hidden">
            <div style="width:875px; height:300px; overflow-y:scroll; padding-right:0px">
            <table width="700" border="0" bordercolor="bbccdc"> 
            <c:forEach items="${dettagli.rows}" var="prescrizione">


<%---- QUERY PER ESTRARRE IL NUMERO DI NUOVI MESSAGGI PER OGNI TEST---------%>
<sql:query var="nuovo_mess">
select m.id_messaggio
from MESSAGGI m, CANDIDATURA c, SCHEDA_PROD s, TEST t
where m.id_test=c.id_test 
      and c.scelto=1 and c.user_lab=m.user_lab and m.nuovo=1 and m.inviato=1 and t.id_test=c.id_test and t.id_scheda=s.id_scheda and s.user_cpr LIKE ? and s.id_scheda LIKE ? and t.id_prescrizione LIKE ?
<sql:param value="${user_userid}"/>
<sql:param value="${param.id_scheda}"/>
<sql:param value="${prescrizione.id_prescrizione}"/>
</sql:query>

  
<%-------------  CALCOLO IL NUMERO DI NUOVI MESSAGGI PER IL TEST SELEZIONATO   ---------%>
<c:set var="n_nuovi_mess" value="${nuovo_mess.rowCount}"/> 



<%---- QUERY PER ESTRARRE IL NUMERO DI NUOVE CANDIDATURE DA PARTE DEI LAB PER OGNI TEST---------%>
<sql:query var="nuove_candidature">
select c.id_candidatura
from CANDIDATURA c, TEST t, SCHEDA_PROD s
where c.nuova=1 and c.id_test=t.id_test and t.id_scheda=s.id_scheda and
       s.user_cpr LIKE ? and s.id_scheda LIKE ? and t.id_prescrizione LIKE ?
<sql:param value="${user_userid}"/>
<sql:param value="${param.id_scheda}"/>
<sql:param value="${prescrizione.id_prescrizione}"/>
</sql:query>

  
<%-------------  CALCOLO IL NUMERO DI NUOVE CANDIDATURE PER IL TEST SELEZIONATO   ---------%>
<c:set var="n_nuove_cand" value="${nuove_candidature.rowCount}"/> 

  
<%-------------  CALCOLO IL NUMERO DELLE NUOVENOTIFICHE (CANDIDATURE E 
                          MESSAGGI) PER IL TEST SELEZIONATO           -------------%>
<c:set var="nuove" value="${n_nuove_cand + n_nuovi_mess}"/>   
       
  
<%-------------  SE LA PRESCRIZIONE E' NUOVA, COLORA LA RIGHA DI AZZURRO   ---------%>
             <tr <c:if test="${prescrizione.nuova == 'true'}"> bgcolor="#ADD8E6" </c:if> bgcolor="white" >
                <td width="140" valign="middle"><font face="Arial">
            

                 <c:choose>
                   <c:when test="${not empty prescrizione.data_ora_esito }">
                      <img src="spunta.png" width="25"/>
                   </c:when>
                   <c:otherwise>
                      <img src="clessidra1.png" width="25"/>
                   </c:otherwise>
                  </c:choose>


                     ${prescrizione.id_prescrizione} 

  
<%------------------------------------------------------------------%>
<%-------------  SE E' UNA PRESCRIZIONE NUOVA, STAMPO 
                   L'ALAMBICCO SULLA RIGA DEL TEST          ---------%>
<%-------------------------------------------------------------------%>
<c:if test="${nuove > 0}"> <font color="green" size="1"><b>${nuove}</b></font><img style="width:20px;height:20px;"src="0.png"> 
</c:if>  
</font>   </td>
                <td width="140"><font face="Arial">${prescrizione.descrizione}</font>       </td>
                <td width="140" ><font face="Arial">${prescrizione.data_ora_presc}</font>   </td>
                <td width="140"><font face="Arial">${prescrizione.motivi}</font>            </td>
                <td width="140" align="center">
                 <form method="post" action="visualizza_test.jsp">
                 <input type="submit" value="dettagli" name="Dettagli"/>               </br>

                                <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
                                <input type="hidden" name="presc" value="${prescrizione.id_prescrizione}"/>
                                <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
                                <input type="hidden" name="dettagli" value="${param.dettagli}"/>
              
                 </form>

<%-------------------------------------------------------------------%>
<%-------------  SE C'E' L'ESITO DEL TEST, VISUALIZZO 
                         IL TASTO DELL' ESITO         ---------------%>
<%-------------------------------------------------------------------%>
         <c:if test="${not empty prescrizione.data_ora_esito}">
         <form method="post" action="test_prescritti.jsp"> 
<input type="submit" value="Esito" name="esito"/>              
<input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
<input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
<input type="hidden" name="presc" value="${prescrizione.id_prescrizione}"/>
             
             </form>
             </c:if>
            </td></tr>
            </c:forEach>
                                 
         </table>
         </div>
         </div>
         </td>

<%-------------------------------------------------------------------%>
<%-------------  QUANDO CLICCO SUL TASTO DELL' ESITO,
        VISUALIZZO LA TABELLA CON L'ESITO DEL TEST SELEZIONATO    ---%>
<%-------------------------------------------------------------------%>
         <c:if test="${not empty param.esito}">
         <td width="100%">
         <table align="center" width="300" cellspacing="0" cellpadding="3" bgcolor="white" bordercolor="bbccdc" border="1">

           <tr>
            <th align="left"><font color="#007171" face="Arial"><b>DATA ESITO: </b></font></th>
            <td align="center"> <font face="Arial" > ${esito.rows[0].data_ora_esito} </font></td>
           </tr>
           <tr>
            <th align="left"><font color="#007171" face="Arial"><b>SUPERATO: </b></font></th>
            <td align="center"> <font face="Arial"> 
              <c:if test="${esito.rows[0].superato == 'true'}"> Si </c:if> 
              <c:if test="${esito.rows[0].superato == 'false'}"> No </c:if> 
                  </font></td>
           </tr>
           <tr>
            <th align="left"><font color="#007171" face="Arial" ><b>RAPPORTO: </b></font></th>
            <td align="center"> <font face="Arial">${esito.rows[0].rapporto}</font></td>
           </tr>
        </table>
     </td>
    </c:if>

         </tr>
        <tr height="15%">
    <td align="center">
        <table align="center" border="2" bordercolor="bbccdc" bgcolor="white" cellspacing="0" cellpadding="1">
        <h3><font color="green">LEGENDA</font></h3>
            <tr><td><font color="black">Test effettuato </font> </td>
                <td><img src="spunta.png" width="25"/></td>
            </tr>
            <tr><td><font color="black">Test in svolgimento 
                     (gia' assegnato al lab)</font></td>
                <td><img src="clessidra1.png" width="25"/></td>
            </tr>
                
        </table>
    </td>
  </tr>
    </c:if>

</TABLE>


<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO BOTTOM  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf" %>
