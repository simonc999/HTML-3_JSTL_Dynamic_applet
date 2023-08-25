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

<%----------------------------------------------------------------------------------%>
<%--- TOP --%>
<%----------------------------------------------------------------------------------%>
<%@ include file="top.jspf"%><td align="right" width="60">
        <!-- COMANDO INDIETRO -->
       <a href="home_cpr.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
<%----------------------------------------------------------------------------------%>
<%----QUERY PER CAMBIARE LE NUOVE PRATICHE CONCLUSE IN NON PIU NUOVE----------------%>
<%----------------------------------------------------------------------------------%>
<c:if test="${not empty param.id_scheda}">
      <sql:update>
       UPDATE SCHEDA_PROD 
       SET concluso = false
       WHERE id_scheda LIKE ?
       <sql:param value="${param.id_scheda}"/>
       </sql:update>
</c:if>
     </td>


<%----------------------------------------------------------------------------------%>
<%--- MIDDLE --%>
<%----------------------------------------------------------------------------------%>
<%@ include file="middle.jspf"%>

<%----------------------------------------------------------------------------------%>
<%--QUERY CONVALIDATO--%>
<%----------------------------------------------------------------------------------%>
<sql:query var="mes">
SELECT messaggio 
FROM CPR
WHERE user_cpr LIKE ?
      <sql:param value="${user_userid}"/>
</sql:query>


<c:if test="${mes.rows[0].messaggio == 'true'}">
  <sql:update>
   UPDATE CPR
   SET messaggio = false
   WHERE user_cpr LIKE ?
   <sql:param value="${user_userid}"/>
   </sql:update>
</c:if>



<%----------------------------------------------------------------------------------%>
<%-- QUERY PER ESTRARRE TUTTI I PRODOTTI e LE RELATIVE INFORMAZIONI SULLA  PRATICA DI 
     CERTIFICAZIONE--%>
<%----------------------------------------------------------------------------------%>
<sql:query var="scheda_prod">
  SELECT id_scheda, nome_prod,  stato, inizio_prat, fine_prat,concluso,foto1, foto2, foto3
  FROM  SCHEDA_PROD
  WHERE user_cpr = "${user_userid}"
<c:if test="${not empty param.prod_cercato}">
   AND lower(nome_prod) LIKE lower(?)
       <sql:param value="${param.prod_cercato}%"/>
</c:if> 
<c:if test="${not empty param.stato_scelto}">
   AND stato  = ?
       <sql:param value="${param.stato_scelto}"/> 
</c:if>
  order by nome_prod
</sql:query>

<%----------------------------------------------------------------------------------%> 
<!-- HTML: DUE TABELLE DENTRO UNA PIU GRANDE -->
<%----------------------------------------------------------------------------------%>
<html>
<body>
<TABLE>
</br> 
<TR> 
<TD ALIGN="CENTER"><h1><font color="007171">GESTIONE PRODOTTI</font></h1></TD> 
</TR>

<TR>
<TD> 
<%---------------------------------------------------------------------------------%>
<%----FORM CERCA, PER FILTRARE I PRODOTTI INSERENDO IL NOME------%>
<%---------------------------------------------------------------------------------%>
<form method="post" action="gestione_prod.jsp">

<font color="green" size="3"><b> CERCA: </b> </font>
<input type="text" name="prod_cercato" value="${param.prod_cercato}" 
  placeholder="Quale prodotto cerchi?"/>
<input type="image" name="submit" title="CERCA" src="filtra_cerca.png" style="width:15px;height:15px"/>

<br/><br/><br/>

<font color="green" size="3"><b> FILTRA SCEGLIENDO LO STATO DEL PRODOTTO:</b> </font>
<br/>
Da certificare:  <input type="radio" name="stato_scelto" value="0"   
                  onChange="this.form.submit()"
                 <c:if test="${param.stato_scelto == '0'}"> checked </c:if> />
&nbsp&nbsp&nbsp
In corso:        <input type="radio" name="stato_scelto" value="2"
                  onChange="this.form.submit()"
                  <c:if test="${param.stato_scelto == '2'}"> checked </c:if> />
&nbsp&nbsp&nbsp
Certificato:     <input type="radio" name="stato_scelto" value="1"
                  onChange="this.form.submit()"
                  <c:if test="${param.stato_scelto == '1'}"> checked </c:if> />
&nbsp&nbsp&nbsp
Non certificato: <input type="radio" name="stato_scelto" value="3"
                  onChange="this.form.submit()"
                  <c:if test="${param.stato_scelto == '3'}"> checked </c:if> />
</form>

<form method="post" action="#">
<input type="submit" value="Ripristina la tua ricerca"/>
</form>

<%---------------------------------------------------------------------------------%>
<%-- MESSAGGIO CHE APPARE QUANDO NON CI SONO PRODOTTI CHE VENGONO TROVATI DAL CERCA
     --%>
<%---------------------------------------------------------------------------------%>
<c:if test="${scheda_prod.rowCount == 0}">
<font color="green"> Non hai ottenuto nessun risultato dalla tua ricerca. Riprova! </font>
<br/> 
</c:if>
 
<%---------------------------------------------------------------------------------%>
<%--PRIMA TABELLA: CONTIENE LE INFORMAZIONI DEI VARI PRODOTTI, COSTRUITA CON I DATI 
    ESTRATTI DALLA QUERY PRECEDENTE--%>
<%----------------------------------------------------------------------------------%>
 
  <table border="1"  cellspacing="0" cellpadding="1" bgcolor="white" bordercolor="bbccdc" 
   width="950">
     <tr bgcolor="007171">
       <td align="center" width="100"><font color="9ad6d6">CODICE   </font></td>
       <td align="center" width="100"><font color="9ad6d6">NOME     </font></td>
       <td align="center" width="150"><font color="9ad6d6">STATO   
                                       CERTIFICAZIONE               </font></td>
       <td align="center" width="150"><font color="9ad6d6">DATA INIZIO 
                                       CERTIFICAZIONE               </font></td>
       <td align="center" width="150"><font color="9ad6d6">DATA FINE 
                                       CERTIFICAZIONE               </font></td>    
       <td align="center" width="200"><font color="9ad6d6">FOTO     </font></td>  
       <td align="center" width="100"><font color="9ad6d6">SELEZIONA</font></td>
    </tr>
   </table>

    <div style="width:975px; overflow:hidden">
    <div style="width:1000px; height:200px; overflow-y:scroll; padding-right:0px">
   
    <table border="1"  cellspacing="0" cellpadding="1" bgcolor="white" 
     bordercolor="bbccdc" width="950">
         <c:forEach items="${scheda_prod.rows}" var="dettagli">

<%----------------------------------------------------------------------------------%>
<%---- DIVERSE QUERY PER ESTRARRE IL NUMERO DI NOTIFICHE PER OGNI PRODOTTO ---------%>
<%----------------------------------------------------------------------------------%>

<%----       QUERY PER ESTRARRE LE NOTIFICHE      ---------%>
<%----------------------------------------------------------------------------------%>
<%---- QUERY PER ESTRARRE IL NUMERO DI NUOVI MESSAGGI---------%>
<%----------------------------------------------------------------------------------%>
<sql:query var="nuovo_mess">
select m.id_messaggio
from MESSAGGI m, CANDIDATURA c, SCHEDA_PROD s, TEST t
where m.id_test=c.id_test 
      and c.scelto=1 
      and c.user_lab=m.user_lab 
      and m.nuovo=1 and m.inviato=1 
      and t.id_test=c.id_test and t.id_scheda=s.id_scheda 
      and s.user_cpr LIKE ? and s.id_scheda LIKE ? 
      <sql:param value="${user_userid}"/>
      <sql:param value="${dettagli.id_scheda}"/>
</sql:query>
<c:set var="n_nuovi_mess" value="${nuovo_mess.rowCount}"/> 


<%----       QUERY PER ESTRARRE LE NOTIFICHE      ---------%>
<%----------------------------------------------------------------------------------%>
<%---- QUERY PER ESTRARRE IL NUMERO DI NUOVI TEST PRESCRITTI DAI CERT---------------%>
<%----------------------------------------------------------------------------------%>
<sql:query var="nuove_presc">
select t.id_prescrizione
       from TEST t, SCHEDA_PROD s
       where t.nuova=1 and s.id_scheda=t.id_scheda 
       and s.user_cpr LIKE ? and s.id_scheda LIKE ?
       <sql:param value="${user_userid}"/>
       <sql:param value="${dettagli.id_scheda}"/>
</sql:query>
<c:set var="n_nuove_presc" value="${nuove_presc.rowCount}"/> 



<%----       QUERY PER ESTRARRE LE NOTIFICHE      ---------%>
<%----------------------------------------------------------------------------------%>
<%---- QUERY PER ESTRARRE IL NUMERO DI NUOVE CANDIDATURE DA PARTE DEI LAB-----------%>
<%----------------------------------------------------------------------------------%>
<sql:query var="nuove_candidature">
select c.id_candidatura
      from CANDIDATURA c, TEST t, SCHEDA_PROD s
      where c.nuova=1 
        and c.id_test=t.id_test 
        and t.id_scheda=s.id_scheda 
        and s.user_cpr LIKE ? 
        and s.id_scheda LIKE ?
        <sql:param value="${user_userid}"/>
        <sql:param value="${dettagli.id_scheda}"/>
</sql:query>
<c:set var="n_nuove_candidature" value="${nuove_candidature.rowCount}"/> 

<%----       QUERY PER ESTRARRE LE NOTIFICHE      ---------%>
<%----------------------------------------------------------------------------------%>
<%---- QUERY PER ESTRARRE IL NUMERO DI NUOVE PRATICHE CONCLUSE DAI CERT-------------%>
<%----------------------------------------------------------------------------------%>
<sql:query var="nuove_prat_concluse">
select s.id_scheda
       from SCHEDA_PROD s
       where s.concluso=1 and
       s.user_cpr LIKE ?  and 
       s.id_scheda LIKE ?
       <sql:param value="${user_userid}"/>
       <sql:param value="${dettagli.id_scheda}"/>
</sql:query>
<c:set var="n_nuove_prat_concluse" value="${nuove_prat_concluse.rowCount}"/>

<%----- VARIABILE CHE CONTA IL NUMERO DI NOTIFICHE  TOTALE  --------%>

<c:set var="n_notifiche" value="${n_nuove_prat_concluse + n_nuove_candidature + n_nuove_presc + nuovo_mess.rowCount}"/>



<%----------------------------------------------------------------------------------%>
<%---- RIGHE CON I VARI PRODOTTI E LE RELATIVE INFORMAZIONI            -------------%>
<%----------------------------------------------------------------------------------%>
   <form method="post" action="visual_scheda.jsp">
   <input type="hidden" name="id_scheda" value="${dettagli.id_scheda}"/>
   <tr <c:if test="${dettagli.concluso == 'true'}"> bgcolor="#ADD8E6" </c:if> > 
        <td width="100"> ${dettagli.id_scheda}

<%----------------------------------------------------------------------------------%>
<%---- SE CI SONO DELLE NOTIFICHE OVVERO SE LA VAR E' MAGGIORE DI ZERO
       VISUALIZZO L'IMMAGINE CHE RAPPRESENTA LA NOTIFICHE VICINO AL NOME DEL PRODOTTO
        ---%>
<%----------------------------------------------------------------------------------%>  
            <c:if test="${n_notifiche > 0}">
            <font color="green" size="1"><b>${n_notifiche}</b></font>
            <img style="width:20px;height:20px;"src="0.png"> 
            </c:if>  
           </td>
           <td width="100">   ${dettagli.nome_prod}  </td>


<%---- STATO PRODOTTO ----%>                
    <c:if test="${dettagli.stato == 0}">
       <td align="center" width="150"> <img src="bianco.png" width="20" height="20"> </td>
    </c:if>
    <c:if test="${dettagli.stato == 1}">
        <td align="center" width="150"> <img src="verde.png" width="20" height="20"> </td>
    </c:if>
    <c:if test="${dettagli.stato == 2}">
       <td align="center" width="150"> <img src="giallo.png" width="20" height="20"> </td>
     </c:if>
     <c:if test="${dettagli.stato == 3}">
        <td align="center" width="150"><img src="rosso.png" width="20" height="20">  </td>
     </c:if>

<%--- DATE INIZIO E FINE PRATICA DI CERTIFICAZIONE ---%>     
        <td width="150">    ${dettagli.inizio_prat}    </td>
        <td width="150">    ${dettagli.fine_prat}      </td>


<%----------------------------------------------------------------------------------%>
<%---- FOTO DEL PRDOTTO --------%>
<%----------------------------------------------------------------------------------%>        
          <c:choose>
          <c:when test="${not empty dettagli.foto1 || not empty dettagli.foto2 || 
                          not empty dettagli.foto3}">

         <td align="center" width="200" >
          

<A onClick='window.open("prod_foto.jsp?foto1=${dettagli.foto1}&foto2=${dettagli.foto2}&foto3=${dettagli.foto3}", "foto1", "foto2", "foto3", "HEIGHT=400,WIDTH=400")'>
        <c:if test="${not empty dettagli.foto1}">
        <IMG border="0" title="clicca per visualizzare le immagini" 
         src="${dettagli.foto1}" width="50" height="50"/>
        </c:if>

        <c:if test="${not empty dettagli.foto2}">
        <IMG border="0" title="clicca per visualizzare le immagini" 
         src="${dettagli.foto2}" width="50" height="50"/>
        </c:if>

        <c:if test="${not empty dettagli.foto3}">
        <IMG border="0" title="clicca per visualizzare le immagini" 
         src="${dettagli.foto3}" width="50" height="50"/>
        </c:if>

        </A>
        </TD>
        </c:when>
        <c:otherwise>
                <td align="center" width="150">Nessuna foto</TD>
        </c:otherwise>
        </c:choose>                          
       

<%----------------------------------------------------------------------------------%>
<%--- FORM PER COLLEGARSI ALLA PAGINA PER POTER VISUALIZZARE/MODIFICARE I DETTAGLI DI
      UNA SCHEDA PRODOTTO --%>
<%----------------------------------------------------------------------------------%>
          <td align="center" width="100">
             <input type="submit" value="dettagli" > 
             <input type="hidden" name="id_scheda" value="${dettagli.id_scheda}"/>
           </td>
         </tr>
        </form>
     </c:forEach>
    </table>
    </div>
    </div>

</br>
<%----------------------------------------------------------------------------------%>
<%--FORM PER COLLEGARSI AD UNA PAGINA PER POTER CREARE UNA NUOVA SCHEDA PRODOTTI  --%>
<%----------------------------------------------------------------------------------%>
     <form action="modifica_scheda.jsp" method="post" > 
     <input type="hidden" name="crea" value="${param.crea}"/> 
     <input type="submit" value="crea nuova scheda" align="center" 
      style="background-color:#ADD8E6;
      bordercolor:black; width:150px; height:30px;" name="crea"/ >
     
     </form>

</td>

<TD> &nbsp &nbsp  &nbsp &nbsp  &nbsp &nbsp</TD>
<TD align="center">

<%----------------------------------------------------------------------------------%>
<%-- SECONDA TABELLA: CONTIENE LA LEGENDA DELLA STATO IN CUI SI TROVA LA PRATICA DI 
     CERTIFICAZIONE --%>
<%----------------------------------------------------------------------------------%>
<font color="black"><b>LEGENDA</b></font>

<table border="1" bordercolor="black" bgcolor="#ADD8E6" cellpadding="1" align=" center" width="20%" height="20%" 
  bgcolor="a5bacd">
    <tr><td> da certificare </td>
        <td><img src="bianco.png" width="20" height="20"></td>
    </tr>

    <tr>
        <td>in fase di certificazione</td>
        <td><img src="giallo.png" width="20" height="20" </td>
    </tr>
    <tr>
        <td>certificato</td>
        <td><img src="verde.png" width="20" height="20"></td>
    </tr>
    <tr>
        <td>non certificato</td>
        <td><img src="rosso.png" width="20" height="20"></td>
   </tr>
</table>
</TD>
</TR>
<tr><td align="center">

<%----------------------------------------------------------------------------------%>
<%-- MESSAGGI PROVENIENTI DALLE ACTION --%>
<%----------------------------------------------------------------------------------%>
<font color="green" size="4">
 <br/>
    ${pratica_aggiunta}
    ${scheda_eliminata}
    ${scheda_salvata} 
</font>
</td></tr>
</TABLE>


</body>
</html>


<%----------------------------------------------------------------------------------%>
<%--- BOTTOM --%>
<%----------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf"%>