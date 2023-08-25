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
<%@ include file="top.jspf" %>


<%---------------------%>
<%--COMANDO INDIETRO --%>
<%---------------------%>

<td align="right" width="60" >
       <a href="home_cpr.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png"/>
       </a>

</td>

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


<%--------------------------------------------------------------------------%>
<%-- QUERY PER ESTRARRE TUTTI I TEST CON I DATI RELATIVI AI PAGAMENTI-------%>
<%--------------------------------------------------------------------------%>
<sql:query var="pagamento">
  SELECT ca.pagamento, ca.user_lab, ca.data_pagamento, e.descrizione,l.nome
  FROM  CANDIDATURA ca, TEST t, TIPO_TEST e,LAB l, SCHEDA_PROD p
  WHERE t.id_test=ca.id_test 
    and e.id_tipo=t.id_tipo 
    and l.user_lab=ca.user_lab 
    and ca.pagamento is not null 
    and p.id_scheda=t.id_scheda
    and p.user_cpr LIKE ?
  <sql:param value="${user_userid}"/>
  ORDER BY ca.data_pagamento desc
 </sql:query>

<%--------------------------------------------------------------------------%>
<%-- QUERY PER ESTRARRE IL TOTALE DEI SOLDI VERSATI PER TUTTI I TEST     ---%>
<%--------------------------------------------------------------------------%>
<sql:query var="totale">
  SELECT sum(ca.pagamento) as tot
  FROM  CANDIDATURA ca, TEST t, SCHEDA_PROD p 
  WHERE ca.pagamento is not null 
   and t.id_scheda=p.id_scheda
   and t.id_test=ca.id_test
   and p.user_cpr LIKE ?
  <sql:param value="${user_userid}"/>
   </sql:query>

<%--------------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE IL CONTO DELLA CPR LOGGATA  ---%>
<%--------------------------------------------------------------------------%>
<sql:query var="s">
  SELECT saldo
  FROM  CPR
  WHERE user_cpr = ?
<sql:param value="${user_userid}"/>
 </sql:query>

<%------------------------------%>
<%-------FRAMMENTO CENTRALE-----%>
<%------------------------------%>

<%@ include file="middle.jspf" %>

<%--------------------------------------------------------------%>
<%-------TABELLA CON TUTTI I PAGAMENTI ESTRATTI DALLA QUERY-----%>
<%--------------------------------------------------------------%>
<TABLE align="center" border="0" width="80%" cellspacing="0" cellpadding="1" 
       bgcolor="bbccdc">
    
     <tr><td width="80%"><table  width="1200" cellspacing="0" cellpadding="1" 
          bgcolor="bbccdc" border="1" bordercolor="bbccdc">
         <caption align="top">
         <h1><font color="#007171" face="Arial">PAGAMENTI&nbsp
              <img src="dollar.gif" width="3%"/></font></h1><br/></br>
         </caption>

     <tr bgcolor="#007171"> 
         <td align="center" width="20%" colspan="1"  
          style="font-size:18px;font-family:arial">
         <font color="#9ad6d6"><b> TEST: </b></font></td>

         <td align="center" width="20%" colspan="1"  style="font-size:18px;font-  
          family:arial">
         <font color="#9ad6d6"><b> LABORATORIO: </b></font></td>

         <td align="center" width="20%" colspan="1"  style="font-size:18px;font-
          family:arial">
         <font color="#9ad6d6"><b> DATA PAGAMENTO: </b></font></td>

         <td align="center" width="20%" colspan="1"  style="font-size:18px;font-  
          family:arial">
         <font color="#9ad6d6"><b> COSTO: </b></font></td>
     </tr>
     </table>
</td></tr>
         
<tr>
    <td width="80%">
    <div style="width:1250px; height:200px; overflow:auto;">
    <table width="1200"  cellspacing="0" cellpadding="1" bgcolor="bbccdc" 
     border="2" bordercolor="bbccdc">


     <c:forEach items="${pagamento.rows}" var="lista">
         <form method="get" action="ricarica.jsp">
         <input type="hidden" name="Nome" value="${lista.nome}"/>

             <tr bgcolor="white">
                 <td width="20%">      ${lista.descrizione}      </td>
                 <td width="20%">      ${lista.nome}             </td>   
                 <td width="20%">      ${lista.data_pagamento}   </td>
                 <td width="20%">      ${lista.pagamento} &euro; </td>
             </tr>
             </form>
             </c:forEach>
     </table>
     </div>
</td></tr>
    
<tr>
     <td width="1200">
<%---------------------------------------------------------------------------%>
<%-------TABELLA IN BASSO CON IL TOTALE PAGATO E IL CONTO ATTUALE DELLA CPR 
         ENTRAMBI ESTRATTI DALLA QUERY-----%>
<%---------------------------------------------------------------------------%>
     <table width="1200" cellspacing="0" cellpadding="0" bgcolor="bbccdc" 
      border="2" bordercolor="#007171">

<tr> <td width="50%"  align="center"><h3><font color="#007171"><br/>
      TOTALE PAGATO:</font> &nbsp&nbsp ${totale.rows[0].tot} &euro; </h3></td>
                 
     <td width="50%" align="center"><h3><font color="#007171"><br/>
      SALDO:</font>&nbsp&nbsp ${s.rows[0].saldo} &euro; </h3></td>
</tr>
     </table>
</td>
</tr>

<%----------------------------------------------------%>
<%-------FORM CHE SI COLLEGA ALLA PAGINA RICARICA-----%>
<%----------------------------------------------------%>
 <form action="ricarica.jsp" method="get"> 
     <input type="hidden" name="Nome" value="${lista.nome}"/> 
     <tr>
    <td align="center" valign="middle">
    <i><font color="black" size="5"><br/>
    <img src="saldo.png" width="35"/>Vuoi ricaricare il tuo saldo? 
    <input type="submit" align="center" style="border-color:#007171;background-  
     color:#009c9c;width:90px;height:25px;" value="Clicca qui"/></b></u></font></i></a>
    </td>
    </tr>
 </form>
<%------------------------------------------------------------------------%>
<%-------MESSAGGIO CHE APPARE SE SI VIENE IN QUESTA PAGINA DALLA ACTION    
         (action_paga) MESSAGGIO DI PAGAMENTO AVVENUTO CORRETTAMENTE -----%>
<%------------------------------------------------------------------------%>
<tr>
   <td>
   <font color="green" size="4">${pagamento_effettuato} </font> 
  </td>
</tr>
</TABLE>
</br></br>
<%@ include file="bottom.jspf" %>