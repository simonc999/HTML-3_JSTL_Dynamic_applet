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
<%------------------------------       TOP             ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="top.jspf"%>
<form method="post" action="visualizza_test.jsp">
<td align="right" width="60" >
        <!-- COMANDO INDIETRO -->
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="hidden" name="presc" value="${param.test}"/>
       <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
            <input type="image" name="submit" style="width:60px;height:60px" 
             src="indietro.png"/>
</td>
</form>



<%--------------------------------------------------------------------------------------%>
<%-- QUERY CHE FA L'UPDATE: QUANDO UN NUOVO MESSAGGIO RICEVUTO  VIENE VISUALIZZATO 
     PER LA PRIMA VOLTA, VIENE MODIFICATO L'ATTRIBUTO 'NUOVO' DELLA TABELLA MESSAGGI
     CHE DIVENTA DA TRUE A FALSE.
     METTO IL C:IF PERCHE' L'UPDATE LO DEVO FARE SOLO PER I MESSAGGI RICEVUTI E NUOVI --%>
<%--------------------------------------------------------------------------------------%>
<c:if test="${not empty param.tasto && param.inviato == 'true'}">
<sql:update>
     UPDATE MESSAGGI set nuovo = false
     where id_messaggio = ?
     <sql:param value="${param.mess}"/>
</sql:update>
</c:if>

<%--------------------------------------------------------------------------------%>
<%--QUERY CHE ESTRARE TUTTI I MESSAGGI SCAMBIATI, PER IL RELATIVO TEST PRESCRITTO,
    CON IL LAB---%>
<%--------------------------------------------------------------------------------%>
<sql:query var="mess">
     SELECT m.user_lab, m.oggetto, m.data_ora, m.testo, m.inviato, m.nuovo, m.id_messaggio
     FROM MESSAGGI m, TEST t
     WHERE t.id_test=m.id_test 
     and t.id_prescrizione = ?
<sql:param value="${param.test}"/>
     ORDER BY m.data_ora desc
</sql:query>

<c:set var="n_mess" value="${mess.rowCount}"/>

<%--------------------------------------------------------------------------------%>
<%--QUERY CHE ESTRAE SOLO LA DATA DI FINE PRATICA DI CERTIFICAZIONE,
    QUESTA QUERY SERVE PER NON PERMETTERE DI INVIARE MESSAGGI AL LAB SE E' 
    PRESENTE LA DATA DI FINE--%>
<%--------------------------------------------------------------------------------%>
<sql:query var="fine">
     SELECT t.data_ora_esito
     FROM SCHEDA_PROD s, TEST t
     WHERE s.id_scheda=t.id_scheda and
           t.id_prescrizione = ?
     <sql:param value="${param.test}"/>
</sql:query>


<%--------------------------------------------------------------------------------%>
<%--QUERY CHE ESTRAE SOLO IL PAGAMENTO DEL TEST E LA MAIL DEL LAB SCELTO        --%>
<%--------------------------------------------------------------------------------%>
<sql:query var="pagato">
     SELECT c.pagamento, u.mail, l.nome, l.user_lab
     FROM CANDIDATURA c, TEST t, AVERE_LISTINO a, UTENTE_RUOLO u, LAB l
     WHERE  c.id_test=t.id_test 
      and   a.id_tipo=t.id_tipo 
      and   l.user_lab=u.username
      and   u.username=c.user_lab
      and   c.pagamento is not null 
      and   t.id_prescrizione  LIKE ?
      <sql:param value="${param.test}"/>
</sql:query>



<%--------------------------------------------------------------------------------------%>
<%------------------------------    INIZIO HTML        ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="middle.jspf"%>

<TABLE border="0" align="center" width="100%" height="100%">

<tr> <td><h2 align="center"><font color="#008080">        </br>
         CANDIDATURE PER IL TEST : ${param.descrizione}   <br/> 
         EFFETTUATO SUL PRODOTTO : ${param.nome_prodotto} </font></h2>
     </td>
</tr>  


<tr height="25%"> <td align="center">
                  <h3> Area di messaggistica: scambia messaggi con il LAB ${pagato.rows[0].nome} </h3> 
                  </td>
</tr>
 

<%--------------------------------------------------------------------------------%>
<%--MESSAGGIO CHE APPARE SE L'INVIO DEL MESSAGGIO AL LAB E' AVVENUTO CON SUCCESSO --%>
<%--------------------------------------------------------------------------------%>
<c:if test="${not empty mess_inviato}">
<tr><td align="center"> 
    <font color="green">${mess_inviato}</font>
</td></tr>
</c:if>


<c:choose>
<%-------------------------------------------------------------%>
<%--  SE IL LAB E' STATO SCELTO E IL TEST E' STATO PAGATO,
      PUOI VEDERE E SCAMBIARE I MESSAGGI CON IL LAB SCELTO   --%>
<%-------------------------------------------------------------%>
<c:when test="${not empty pagato.rows[0].pagamento}"> 

  
      
<%-------------------------------------------------------------%>
<%-- SOLO FIN QUANDO LA PRATICA DELLA SCHEDA NON E' CONCLUSA,
                E' POSSIBILE INVIARE NUOVI MESSAGGI          --%>
<%-------------------------------------------------------------%>
 <form method="post" action="chat.jsp">
 <input type="hidden" name="id_scheda"     value="${param.id_scheda}"/>
 <input type="hidden" name="test"          value="${param.test}"/>
 <input type="hidden" name="mail_lab"      value="${pagato.rows[0].mail}"/>
 <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
 <input type="hidden" name="descrizione"   value="${param.descrizione}"/>
 <input type="hidden" name="id_lab"        value="${pagato.rows[0].user_lab}"/>

<c:if test="${empty fine.rows[0].data_ora_esito}">
 <tr><td  align="center">  
     <font color="008080"><u> + NUOVO MESSAGGIO &nbsp &nbsp </u>
     <input type="image" name="submit" src="invia.png" style="width:30px;height:30px"/>    
     
     </font>
     </td>
 </tr>

</c:if>
</form>

<%--------------------------------------------------------------------------------------%>
<%---   MESSAGGIO CHE APPARE QUANDO NON SONO ANCORA STATI SCAMBIATI MESSAGGI       -----%>
<%--------------------------------------------------------------------------------------%>
<c:if test="${n_mess == 0}"> 
 <tr><td align="center"> <font color="green" size="5"> 
  Non sono ancora stati scambiati messaggi con il laboratorio scelto per questo test.
 </font></td></tr>
</c:if>

<%--------------------------------------------------------------------------------------%>
<%---    TABELLA CHE APPARE QUANDO CI SONO MESSAGGI SCAMBIATI CON IL LAB           -----%>
<%--------------------------------------------------------------------------------------%>
 <c:if test="${n_mess > 0}"> 
 <%--- <br/> ---%>
 <tr><td valign="top">

     <table cellspacing="0" cellpadding="0" border="1" bordercolor="bbccdc"
      bgcolor="007171" width="800">
      <tr bgcolor="#008080">
          <th WIDTH="35%"><font color="9ad6d6"  align="center"> OGGETTO</font></th>
          <th WIDTH="15%"><font color="9ad6d6"   align="center">DATA</font></th>
          <th WIDTH="10%"><font color="9ad6d6"   align="center">TIPO</font></th>
          <th WIDTH="20%"><font color="9ad6d6"  align="center" >VISUALIZZA</font></th>
      </tr>
    </table>

       <div style="width:850px; overflow:hidden">
       <div style="width:875px; height:250px; overflow:auto;">
        <table cellspacing="0" cellpadding="0" border="1" width="800px"
         bordercolor="bbccdc"  bgcolor="white" >

<%--------------------------------------------------------------------------------%>
<%--C:FOREACH PER TUTTI I MESSAGGI ESTRATTI DALLA QUERY, IN MODO
    CHE VENGANO VISUALIZZATI IN ORDINE CRONOLOGICO (DAL PIU RECENTE)            --%>
<%--------------------------------------------------------------------------------%>
<c:forEach items="${mess.rows}" var="lista">
<form method="post" action="posta_lab.jsp" >
        <tr

<%--------------------------------------------------------------------------------%>
<%--C:IF CHE PERMETTE DI VEDERE LA RIGA EVIDENZIATA DI AZZURO PER I MESSAGGI NUOVI
    RICEVUTI E QUINDI ANCORA NON LETTI--%>
<%--------------------------------------------------------------------------------%>
        <c:if test="${lista.nuovo == 'true' && lista.inviato == 'true'}"> 
         bgcolor="#ADD8E6" </c:if> >
         <td WIDTH="35%" align="center"> ${lista.oggetto}  </td>
         <td WIDTH="15%"> ${lista.data_ora} </td>
         <td WIDTH="10%" align="center">

<%--------------------------------------------------------------------------------%>
<%--C:CHOOSE PER SCEGLIERE L'ICONA DEL TIPO MESSAGGIO, OVVERO SE E' DI TIPO INVIATO
    OPPURE RICEVUTO --%>
<%--------------------------------------------------------------------------------%> 
<c:choose>
<c:when test="${lista.inviato == 'false'}"><IMG SRC="posta_invia.png" width="25"   
 title="messaggio inviato"/> 
</c:when>
    
<c:otherwise> 
<IMG SRC="posta_ricevi.png" width="25" title="messaggio ricevuto"/>
           </c:otherwise>
</c:choose>
       </td>
       <td align="center" WIDTH="20%" valign="middle" >
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="hidden" name="presc" value="${param.presc}"/>
       <input type="hidden" name="test" value="${param.test}"/>
       <input type="hidden" name="descrizione" value="${param.descrizione}"/>
       <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
       <input type="hidden" name="data" value="${lista.data_ora}"/>
       <input type="hidden" name="oggetto" value="${lista.oggetto}"/>
       <input type="hidden" name="messaggio" value="${lista.testo}"/>
       <input type="hidden" name="mess" value="${lista.id_messaggio}"/>
       <input type="hidden" name="inviato" value="${lista.inviato}"/>

         <input type="submit" name="tasto" value="visualizza messaggio"/></td>
        </tr>
      </form>  
    </c:forEach>
  </table>
</div>
</div>
</td>


<%--------------------------------------------------------------------------------%>
<%--C.IF CHE SERVE PER VEDERE IL MESSAGGIO CHE VIENE SELEZIONATO DAL SUBMIT
    VISUALIZZA MESSAGGIO--%>
<%--------------------------------------------------------------------------------%>
<c:if test="${not empty param.tasto}">
<td>
<table width="80%" height="70%" border="1" cellpadding="0" bordercolor="black" 
 bgcolor="bbccdc">
   <tr>
     <td align="right" bgcolor="#ADD8E6" height="10%">
     <font size="2"> ${param.data}</font>
     </td>
  </tr>
  <tr>
     <td align="left" bgcolor="#ADD8E6" height="20%" > 
      Oggetto:  ${param.oggetto} 
     </td> 
  </tr>
  <tr>
     <td align="center" >
      ${param.messaggio}
     </td>
   </tr>

</table>
</td>
</c:if>


</tr>  

</c:if> 


 </form>
</c:when>

<%-------------------------------------------------------------%>
<%--       SE IL LAB NON E' STATO SCELTO , NON 
         PUOI NE VEDERE NE SCAMBIARE I MESSAGGI              --%>
<%-------------------------------------------------------------%>
<c:otherwise>
<form method="post" action="candidature.jsp">
 <input type="hidden" name="test" value="${param.test}"/>
 <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
 <input type="hidden" name="presc" value="${param.presc}"/>
 <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
<tr><td align="center"><font color="green" size="4"> Non avendo ancora affidato il test ad un laboratorio, non e' possibile scambiare alcun messaggio. <br/> Per scegliere la candidatura piu' affine al tuo test </font>
<input type="submit" value="clicca qui" style="color:white; border-color:#007171;background-color:#009c9c;width:100px;height:20px;"/>

</td>
</tr>
</form>
</c:otherwise>
</c:choose>
</TABLE>

<br/><br/>

<%--------------------------------------------------------------------------------------%>
<%------------------------------         BOTTOM        ---------------------------------%>
<%--------------------------------------------------------------------------------------%>

<%@ include file="bottom.jspf"%>


