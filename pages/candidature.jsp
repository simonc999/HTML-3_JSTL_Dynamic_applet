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

<%--FRAMMENTO TOP--%>
<%@ include file="top.jspf" %>


        <!-- COMANDO INDIETRO -->
       <form method="post" action="visualizza_test.jsp"> 
       <td align="right" width="60" >

       <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
       <input type="hidden" name="descrizione" value="${param.descrizione}"/>
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="hidden" name="presc" value="${param.test}"/>
       <input type="image" name="submit" style="width:60px;height:60px" 
        src="indietro.png"/>
        </td>
       </form>


<%-------------------------------------------------------------%>
<%--          UPDATE DELLA CANDIDATURA VISUALIZZATA          --%>
<%-------------------------------------------------------------%>
<c:if test="${not empty param.tasto}">
<sql:update>
     update CANDIDATURA set nuova = false
     where id_candidatura = ?
     <sql:param value="${param.candidatura}"/>
</sql:update>
</c:if>

<%------------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE I DATI DAL DB RELATIVI ALLA CANDIDATURA DI UN LAB 
     PER UN DETERMINATO TEST ----%>
<%------------------------------------------------------------------------%>
<sql:query var="lista">
     select c.id_candidatura, c.user_lab, c.data_cand, c.campioni, c.tempi, l.nome,  
            a.prezzo,t.data_ora_presc, c.nuova
     from CANDIDATURA c, LAB l, TEST t, AVERE_LISTINO a
     where l.user_lab=c.user_lab 
      and  c.id_test=t.id_test 
      and  a.id_tipo=t.id_tipo 
      and  c.user_lab=a.user_lab 
      and  t.id_prescrizione  LIKE ?
           <sql:param value="${param.test}"/>
      order by c.data_cand desc
</sql:query>


<%---------------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE I DATI DAL DB RELATIVI AL PAGAMENTO DEL LAB SCELTO ----%>
<%---------------------------------------------------------------------------%>
<sql:query var="pagamento">
  select c.pagamento,l.nome
       from CANDIDATURA c, TEST t, LAB l
       where t.id_test=c.id_test 
         and l.user_lab=c.user_lab 
         and c.pagamento is not null 
         and t.id_prescrizione LIKE ?
         <sql:param value="${param.test}"/>
</sql:query>

<%--FRAMMENTO MIDDLE--%>
<%@ include file="middle.jspf" %>

<%------------------------------------------------------------------------%>
<%--INIZIO HTML ----%>
<%------------------------------------------------------------------------%>
<html>
<body>
<%--------------------------------------------------------------------------------------%>
<%--------------------        CONVERSIONE DELLE DATE   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<fmt:formatDate var="var_data" 
                value="${lista.rows[0].data_ora_presc}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora"
                value="${lista.rows[0].data_ora_presc}"
                type="time"
                pattern="HH:mm"/>    



<TABLE width="80%" align="left" cellspacing="0" cellpadding="0">
<tr>
    <td><h2 align="center"><font color="#008080"></br>
        CANDIDATURE PER IL TEST: ${param.descrizione} <br/> 
        EFFETTUATO SUL PRODOTTO: ${param.nome_prodotto}</font></h2>
    </td>
</tr>

<%---------------------------------------------------------------------------%>
<%-- SE CI SONO CANDIDATURE, LE VISUALIZZO CON LA POSSIBILITA' DI 
     ANNULLARE IL TEST, MA SOLO SE NON NE HO ANCORA PAGATA NESSUNA         --%>
<%---------------------------------------------------------------------------%>
<c:choose>
<c:when test="${lista.rowCount > 0}">

<tr><td>
    <div style="width:850px; overflow:hidden">
    <div style="width:870px; height:300px; overflow:auto;">
    <table align="center" width="50%" height="100%" cellspacing="0" cellpadding="0" 
    bgcolor="bbccdc">

 <c:forEach items="${lista.rows}" var="cand">
 <form method="post" action="paga_test.jsp">

 <input type="hidden" name="candidatura" value="${cand.id_candidatura}"/>
 <input type="hidden" name="costo" value="${cand.prezzo}"/>
 <input type="hidden" name="lab" value="${cand.user_lab}"/>
 <input type="hidden" name="test" value="${param.test}"/>
 <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
 <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
 <input type="hidden" name="descrizione" value="${param.descrizione}"/>

 <tr><td>

<%------------------------------------------------%>
<%-- TABELLA A SINISTRA ----%>
<%------------------------------------------------%>

 <table align="center" width="100%" height="100%" cellspacing="0" cellpadding="3" 
 <c:if test="${cand.nuova == 'true'}"> bgcolor="#ADD8E6" </c:if>
 border="1" bordercolor="#007171">

  <tr> 
  <td align="left" style="font-family:arial" width="30%">
      <font color="#007171"><b> LAB CANDIDATO: </b></font>     </td>
  <td bgcolor="white" width="20%"> ${cand.nome}                </td>
  </tr>

  <tr> 
  <td width="30%" align="left" style="font-family:arial">
      <font color="#007171"><b> DATA CANDIDATURA: </b></font>  </td>
  <td width="30%" bgcolor="white"> ${cand.data_cand}           </td>
  </tr>

   <tr> 
   <td width="30%" align="left" style="font-family:arial">
        <font color="#007171"><b> NUMERO CAMPIONI: </b></font> </td>
   <td width="30%" bgcolor="white"> ${cand.campioni}           </td>
   </tr>

   <tr> 
   <td width="30%" align="left" style="font-family:arial">
       <font color="#007171"><b> TEMPI: </b></font>            </td>
   <td width="30%" bgcolor="white"> ${cand.tempi}              </td>
   </tr>

   <tr> 
   <td width="30%" align="left" style="font-family:arial">
       <font color="#007171"><b> COSTI: </b></font>            </td>
   <td width="30%" bgcolor="white"> ${cand.prezzo} &euro;      </td>
   </tr>

<%------------------------------------------------------------------------%>
<%--METTO UN IF, PERCHE' SE NESSUN LAB E' STATO PAGATO LA VARIABILE PAGAMENTO 
    ESTRATTA DALLA QUERY E' VUOTA E QUINDI E' ANCORA POSSIBILE SCEGLIERE UNA 
    DELLE CANDIDATURE PER QUEL TEST E IL CORRISPONDENTE LAB DA PAGARE ----%>
<%------------------------------------------------------------------------%>
   <tr>
      <c:if test="${empty pagamento.rows[0].pagamento}">
      <TD ALIGN="CENTER" colspan="2">
      <INPUT TYPE="SUBMIT" VALUE="Paga test"/>
      </TD>
      </c:if>
  </tr>
</table>
</td>
</tr>
 </form>


<%--------------------------------------------------------------------------------------%>
<%-- FORM CHE RIMANDA ALLA PAGINA PER  SEGNARE LA NOTIFICA COME VISUALIZZATA   ---------%>
<%--------------------------------------------------------------------------------------%>
<form action="candidature.jsp" method="post">

 <input type="hidden" name="candidatura" value="${cand.id_candidatura}"/> 
 <input type="hidden" name="costo" value="${cand.prezzo}"/>
 <input type="hidden" name="lab" value="${cand.username}"/>
 <input type="hidden" name="test" value="${param.test}"/>
 <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
 <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
 <input type="hidden" name="descrizione" value="${param.descrizione}"/>


  
      <c:if test="${cand.nuova == 'true'}"> 
      <tr bgcolor="#ADD8E6" bordercolor="#007171">
      <TD ALIGN="CENTER" >
      <INPUT TYPE="SUBMIT" name="tasto" VALUE="Contrassegna come visualizzata"/>
      </TD>
      </tr>
      </c:if>
 
</form>
 </c:forEach>

</table>

</div>
</div>
</td>

<%------------------------------------------------------------------------%>
<%-- PARTE DESTRA DELLA PAGINA, IN QUESTA PARTE SI POSSONO AVERE 
     DUE SITUAZIONI DIVERSE  (se e' stato gia effettuato un pagamento o meno)
 ----%>
<%------------------------------------------------------------------------%>



<%------------------------------------------------------------------------%>
<%--SE PAGAMENTO E' STATO GIA' EFFETTUATO---%>
<%------------------------------------------------------------------------%>
<c:if test="${not empty pagamento.rows[0].pagamento}">
  <font color="green" size="4"> Avendo gia' pagato il test al lab ${pagamento.rows[0].nome}, 
   non puoi affidare il test ad un altro laboratorio. </font>
</c:if>

<%------------------------------------------------------------------------%>
<%--SE PAGAMENTO NON E' STATO GIA' EFFETTUATO---%>
<%------------------------------------------------------------------------%>
<c:if test="${empty pagamento.rows[0].pagamento}">
<td align="center">
<font color="red" size="3">
  Ricorda che, una volta annullato il test, la pratica di certificazione di questo prodotto verra'   
  immediatamente terminata con esito 'non certificato'  </font>
  <img src="rosso.png" width="15" height="15"/>.<br/>
  Specifica la data e i motivi per il quale vuoi annullare questo test: 
</br>

<form method="post" action="annulla_test.jsp">
<input type="hidden" name="descrizione" value="${param.descrizione}"/>
<input type="hidden" name="test" value="${param.test}"/> 
<input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
<input type="date" min="${var_data}" name="data_annullo" value="${param.data_annullo}"/>
<input type="time" name="ora_annullo" value="${param.ora_annullo}"/>

</br></br>

<textarea name="motivo" cols="30" rows="6" style="width:400;height:150"> ${param.motivo} </textarea>
 
<br/><br/>
  <input type="hidden" name="motivo" value="${param.motivo}"/>
  <input type="hidden" name="nome_prodotto" value="${param.nome_prodotto}"/>
  <input type="hidden"  name="data_annullo" value="${param.data_annullo}"/>
  <input type="hidden"  name="ora_annullo" value="${param.ora_annullo}"/>
  <input type="hidden"  name="var_data" value="${var_data}"/>
  <input type="hidden"  name="var_ora" value="${var_ora}"/>

<input type="submit" name="annullo" align="center" 
  style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;"   value="Annulla test"/>
      
</form>
</td>
</c:if>
</tr>


<%------------------------------------------------------%>
<%--  MESSAGGI ERRORI COMPILAZIONE DELL' ANNULLA_TEST --%>
<%------------------------------------------------------%> 

<font color="red" size="4">${errmsg}</font>
<font color="red" size="4">${msg}</font>

<%-----------------------------------------------%>
<%-- MESSAGGIO PAGAMENTO AVVENUTO CON SUCCESSO --%>
<%-----------------------------------------------%> 

<font color="green" size="4">${pagamento_effettuato}</font>

</c:when>

<%------------------------------------------------------------------------%>
<%-- SE NON CI SONO CANDIDATURE, VISUALIZZO 
     IL MESSAGGIO DI AVVISO SENZA LE CANDIDATURE, SITUAZIONE OPPOSTA AL CASO 
     IN CUI ESTRAGGO CANDIDATURE DALLA QUERY                            --%>
<%------------------------------------------------------------------------%>

<c:otherwise>
<tr><td align="center">
    <font color="green" size="4">Per questo test non sono presenti candidature.</font>
</td></tr>



</c:otherwise>
</c:choose>

</table>




</body>
</html>


<%@ include file="bottom.jspf" %>
