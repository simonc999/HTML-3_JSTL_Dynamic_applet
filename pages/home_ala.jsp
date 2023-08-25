<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>



<%---------------------------------------------------------------------------------%>
<%------------------------------AUTORIZZAZIONE AREA ALA----------------------------%>
<%---------------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="1"/>
<c:set var="auth_page" value="home_ala.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Alambiccus S.R.L."/>

<%@ include file="auth.jspf"%>



<%---------------------------------------------------------------------------------%>
<%----------------------------------QUERY NOTIFICA---------------------------------%>
<%---------------------------------------------------------------------------------%>


<sql:query var="cpr">
select nuovo
from CPR
where nuovo = 1
</sql:query>
<c:set var="n_cpr" value="${cpr.rowCount}"/>



<%---------------------------------------------------------------------------------%>
<%----------------------------------FRAMMENTO TOP----------------------------------%>
<%---------------------------------------------------------------------------------%>

<%@ include file="top.jspf"%>

<%---------------------------------------------------------------------------------%>
<%----------------------------------FRAMMENTO MIDDLE-------------------------------%>
<%---------------------------------------------------------------------------------%>

<%@ include file="middle.jspf"%>

<table width="100%" height="100%">
 <tr  height="10%">
  <td colspan="3">&nbsp;</td>
 </tr>
 <tr>
  <td width="10%"></td>
  <td style="font-size:35px; font-family:arial">
    <p style="font-weight: bold;color:#526579;">ALA</p>


<%-------------------------------------------------------------------------------------%>
<%---- AVVISO DI NOTIFICA NEL CASO IN CUI CI FOSSERO NUOVI ACCOUNT CPR DA CONVALIDARE--%>
<%-------------------------------------------------------------------------------------%>
 

<c:if test="${n_cpr > 0}"> 
<table border="1" bordercolor="green">
 <tr><td align="center">
      <table border="0">
       <tr><td align="center"><img style="width:45px;height:45px;" src="alarm.jpg"></td>
           <td align="left"><font size="3" color="green"> ${n_cpr} NUOVE CPR DA CONVALIDARE!</br></font></td>
       </tr>
      </table>
     </td>
 </tr>
</table>
</c:if>
<hr align="top" color="#526579" size="5px"> 

<%---------------------------------------------------------------------------------%>
<%----------------------------- SEZIONE LATERALE SX -------------------------------%>
<%---------------------------------------------------------------------------------%>

 
<p style="font-weight: bold;color:#526579;font-size:20px">
 Alambiccus SRL e' una societa' nata dalla necessita' di creare un contatto diretto e ottimale tra vari enti specializzati nell'indagine e nella certificazione di prodotti alimentari e cosmetici.</p>
<p style="font-style: italic;font-size:16px">
Oggi ALA puo' vantare di un'esperienza ventennale che l'ha reso leader nazionale nella intermediazione e gestione dei rapporti tra enti importanti. Sede a Pavia (Italy) ALA si occupa di instaurare un collegamento fra i vari utenti che collaborano alla certificazione di un dato prodotto garantendo la tracciabilita' del processo di certificazione.</p>

 <p style="font-style: italic;font-size:15px">-visualizza gli account LAB esistenti</p>
 <p style="font-style: italic;font-size:15px">-crea nuovi account LAB</p>
 <p style="font-style: italic;font-size:15px">-visualizza gli account CPR convalidati</p>
 <p style="font-style: italic;font-size:15px">-convalida i nuovi account CPR </p>
</td>
<td width="10%"></td>
 </tr>
 <tr height="20%">
  <td >&nbsp;</td>
 </tr>
</table>
</td>  

<%---------------------------------------------------------------------------------%>
<%-------------------------- SEZIONE LATERALE DX ---------------------------------%>
<%---------------------------------------------------------------------------------%>

<td width="40%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px" >
 <table  cellspacing="0" width="100%" height="100%"  rules="none" bgcolor="#a5bacd">
  <tr><td width="60%" align="right">
     <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" > AREA LAB</p>
      <hr color="#526579" size="9px">
     <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >gestione di account LAB</p></td>
       <form method="post" action="account_lab.jsp">   <%------PASSAGGIO A SEZIONE LAB-----%>
         <td width="40%"  align="center"><button  style="border-color:   #8aa3b9;background-color:  #8aa3b9;"><img style="width:90px;height:90px;"src="arrowbutton.jpeg"></button></form></td>
    </tr>
  <tr><td width="60%" align="right">
      <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">
           <%---------------------------------------------------------------------------------%>
           <%-----------------------------NOTIFICA CPR DA CONVALIDARE-------------------------%>
           <%---------------------------------------------------------------------------------%>
         <c:if test="${n_cpr > 0}">
          <font size="2" color="green">${n_cpr}</font>&nbsp<img style="width:30px;height:30px;"src="0.png"/>
         </c:if> 
 AREA CPR</p>
       <hr color="#526579" size="9px">
      <p style="font-size:15px;color:  #e3f1fe;font-weight: bold; font-family:arial;margin-top:14px" >gestione di account CPR</p></td>
       <form method="post" action="account_cpr.jsp">     <%----PASSAGGIO A SEZIONE CPR----%>
        <td width="40%"  align="center"><button  style="border-color: #8aa3b9;background-color:   #8aa3b9;"><img style="width:90px;height:90px;"src="arrowbutton.jpeg"></button></td>
       </form> 
  </tr>
 </table>

<%---------------------------------------------------------------------------------%>
<%----------------------------------FRAMMENTO BOTTOM-------------------------------%>
<%---------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf"%>

