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
<%------------------------------    FRAMMENTO TOP      ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="top.jspf" %>



<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<td align="right"width="60" >
       <a href="index.htm"> 
         <img style="width:60px;height:60px" src="indietro.png"/>
       </a>
     </td>


<%--------------------------------------------------------------------------------------%>
<%------------------------------    FRAMMENTO MIDDLE   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="middle.jspf" %>


<%-------------------------------------%>
<%---- TOTALE DEI TEST PRESCRITTI -----%>
<%-------------------------------------%>
<sql:query var="test_presc">
SELECT count(id_prescrizione) as totale_test_presc
      from TEST
</sql:query>


<%------------------------------------%>
<%---- TOTALE DEI TEST EFFETTUATI ----%>
<%------------------------------------%>
<sql:query var="test_effettuati">
SELECT count(id_test) as totale_test_effettuati
      from TEST
      where data_ora_esito is not null
</sql:query>


<%---------------------------------------------%>
<%--- MOVIMENTAZIONE AFFARI:SOMMA PAGAMENTI ---%>
<%---------------------------------------------%>
<sql:query var="movimentazione">
SELECT sum(pagamento) as somma_pagamenti
       from CANDIDATURA
</sql:query>


<%----------------%>
<%-- RICAVI LAB --%>
<%----------------%>
<sql:query var="ricavi_lab">
SELECT l.nome,sum(c.pagamento) as somma
      from CANDIDATURA c,LAB l
      where l.user_lab=c.user_lab
group by l.nome
</sql:query>


<%------------------------------------------------%>
<%--- COSTO MEDIO CERTIFICAZIONE PER PRODOTTO ----%>
<%------------------------------------------------%>
<sql:query var="costo">
SELECT s.nome_prod,avg(c.pagamento) as costo_medio
       from TEST t,CANDIDATURA c,SCHEDA_PROD s
       where c.id_test=t.id_test and 
       t.id_scheda=s.id_scheda and s.fine_prat is not null
group by s.nome_prod
</sql:query>
    
     

<html>
<body bgcolor="bbccdc">

<table align="center" border="0" cellspacing="0" cellpadding="3" align="center" width="100%" height="100%">


<tr><td colspan="2"> &nbsp
<img src="statistiche1.jpg" valign="top" width="50%" height="250"/>&nbsp <img src="statistiche2.jpg" valign="top" width="45%" height="250"/> 
</td>
</tr>

<tr>
<td width="50%"> <div valign="top" align="center"><p><font color="black" face="Arial" size="4"><b> In questa sezione potrai, in qualsiasi momento, <br/> consultare la nostra produzione e la nostra efficienza. <br/> Ci piace poter mostrare la nostra <br/> trasparenza attraverso le statistiche su ALA, che vengono <br/> costantemente aggiornate.</b></font> </p></div>
</td>

<td><table width="70%" height="100%" align="center" bgcolor="#a5bacd">

<tr>
<td width="50%">
    <p><font color="#007171" face="Arial" size="4"><b>Numero complessivo test prescritti: </b></font></p></td>
<td width="30%">
    <p><font size="3" face="Arial">${test_presc.rows[0].totale_test_presc} </font></p></td>
</tr>

<tr>
<td width="50%" height="50%">
    <p><font color="#007171" face="Arial" size="4"><b>Numero complessivo test effettuati: </b></font></p></td>
<td width="30%">
    <p><font size="3" face="Arial">

<c:choose>
<c:when test="${not empty test_effettuati.rows[0].totale_test_effettuati}">
 ${test_effettuati.rows[0].totale_test_effettuati}
</c:when>
<c:otherwise>
0
</c:otherwise>
</c:choose>
</font></p></td>
</tr>


<tr>
<td width="50%">
    <p><font color="#007171" face="Arial" size="4"><b>Movimentazione affari</b></font></p></td>
<td width="30%">
    <p><font size="3" face="Arial">

<c:choose>
<c:when test="${not empty movimentazione.rows[0].somma_pagamenti}">
 ${movimentazione.rows[0].somma_pagamenti}&euro;
</c:when>
<c:otherwise>
0&euro;
</c:otherwise>
</c:choose>
</font></p></td>
</tr>


<tr>
<td colspan="2" width="70%"> </br>
   <p><font color="#007171" face="Arial" size="4"><b> Seleziona il laboratorio per il quale vuoi visualizzarne i ricavi  </b></font></p></td>
</tr>

<tr>

<td width="50%"> 
 
   <form method="post" action="statistiche.jsp">
   <input type="hidden" name="prod" value="${param.prod}"/>
   <select name="lab">
         <option value="" checked> --Seleziona Lab-- </option>
            <c:forEach var="nome_lab" items="${ricavi_lab.rows}">
                <option value="${nome_lab.nome}"
                    <c:if test="${nome_lab.nome==param.lab}">
                     selected="selected"
                    </c:if>
                >${nome_lab.nome}</option>
            </c:forEach>  
        </select>
&nbsp&nbsp
       <button type="submit" style="border-color:#007171;background-color:#009c9c;width:120px;height:18px;">
         <b  style="font-size:8px;color:#eaf0f0;font-family:Arial;" >
         VISUALIZZA
         </b>
       </button>
    </form>
</td>
<td width="30%"><p><font size="3" face="Arial">

<c:forEach var="ricavo" items="${ricavi_lab.rows}">
<c:if test="${ricavo.nome==param.lab}">
   <c:choose>
     <c:when test="${not empty ricavo.somma}">
        ${ricavo.somma}&euro;
     </c:when>
  <c:otherwise>
        0&euro;
  </c:otherwise>
</c:choose>
</c:if>
</c:forEach>
</font></p>
</td>
</tr>
<tr>
<td colspan="2" width="70%"> <p><font color="#007171" face="Arial" size="4"><b> Costo medio per la certificazione</b></font></p></td></tr>

<tr><td width="50%">  
    <form method="post" action="statistiche.jsp">
    <input type="hidden" name="lab" value="${param.lab}"/>
       <select name="prod">
         <option value="" checked> --Seleziona Prod-- </option>
            <c:forEach var="nome_prod" items="${costo.rows}">
                <option value="${nome_prod.nome_prod}" 
                    <c:if test="${nome_prod.nome_prod==param.prod}">selected="selected"</c:if> 
                 >${nome_prod.nome_prod}</option>
            </c:forEach>  
        </select>
&nbsp&nbsp
       <button type="submit" style="border-color:#007171;background-color:#009c9c;width:120px;height:18px;">
         <b  style="font-size:8px;color:#eaf0f0;font-family:Arial;" >
         VISUALIZZA
         </b>
       </button>
    </form>
</td>

    <td align="left" width="30%"><p><font size="3" face="Arial">
<c:forEach var="costo_prod" items="${costo.rows}">
<c:if test="${costo_prod.nome_prod==param.prod}">
 <c:choose>
     <c:when test="${not empty costo_prod.costo_medio}">
        ${costo_prod.costo_medio}&euro;
     </c:when>
  <c:otherwise>
        0&euro;
  </c:otherwise>
</c:choose>

</c:if>
</c:forEach></font></p>
     </td>
</tr>


</table></td>
</tr>


</table>
<br/><br/>

</body>
</html>


