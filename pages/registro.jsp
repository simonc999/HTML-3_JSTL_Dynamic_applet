<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<%----------------------------------------------------------------------%>
<%--------------- AUTORIZZAZIONE AREA LAB   ----------------------------%>
<%----------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>

<%@ include file="top.jspf"%>

<form method="post" action="home_lab.jsp">
 <td width="8%" align="center" width="60">
          <!-- COMANDO BACK -->
       <a href="home_lab.jsp"><img style="width:60px;height:60px" src="indietro.png"></a>          
 </td>

<%@ include file="middle.jspf"%>

<%---------------------------------------------------------------------------------%>
<%----- QUERY CHE ESTRAE TUTTE LE CANDIDATURE DEL LAB LOGGATO -----%>
<%---------------------------------------------------------------------------------%>
<sql:query var="registro">
     select t.id_test, p.nome_prod, t.id_prescrizione, c.data_cand, c.scelto, c.nuova
     from TEST t, SCHEDA_PROD p, CANDIDATURA c
     where t.Id_scheda=p.id_scheda 
     and c.id_test=t.id_test 
     and c.user_lab = "${user_userid}" 
</sql:query>

<%---------------------------------------------------------------------------------%>
<%----- TABELLA CHE CONTIENE ALTRE DUE TABELLE    -----%>
<%---------------------------------------------------------------------------------%>

<TABLE align="center" border="0" width="80%" height="85%">
 <tr>
 <td><h1 align="center" valign="middle">
     <font color="#008080">REGISTRO DI TUTTE LE CANDIDATURE</font>
     </h1><br/>
     <font color="black" style="font-size:20px;">In questa pagina si trovano tutti i test per cui il laboratorio si e' candidato.</font>
 </td>
 </tr>
<%---------------------------------------------------------------------------------%>
<%----- MESSAGGIO -----%>
<%---------------------------------------------------------------------------------%>
 <tr>
 <td align="center">
     <c:if test="${not empty messaggio1}">
     <font color="green">${messaggio1}</font>
     </c:if>
 </td>
 </tr>
 <tr>
 <td>
<%---------------------------------------------------------------------------------%>
<%----- INTESTAZIONE -----%>
<%---------------------------------------------------------------------------------%>
     <table cellspacing="0" cellpadding="1" border="1" width="1100" >
     <tr bgcolor="#008080">
     <th width="20%"><font color="#bfebfc"> Codice Prescrizione </font></th>    
     <th width="20%"><font color="#bfebfc"> Codice Test         </font></th> 
     <th width="20%"><font color="#bfebfc"> Codice Prodotto     </font></th>
     <th width="10%"><font color="#bfebfc"> Stato               </font></th>
     <th width="20%"><font color="#bfebfc"> Data/ora Candidatura</font></th>
     </tr>
     </table>
 <br>
 </td>
 </tr>
 <tr>
 <td>
<%---------------------------------------------------------------------------------%>
<%-----    TABELLA CHE CONTIENE TUTTE LE CANDIDATURE ESTRATTE DALLA QUERY     -----%>
<%---------------------------------------------------------------------------------%>
      <div style="width:1150px; height:250px; overflow:auto;">
      <table cellspacing="0" cellpadding="1" border="1" width="1100" >

      <c:forEach items="${registro.rows}" var="row"> 
      <form method="post" action="Scheda_prod.jsp" bgcolor="#008080">
      <input type="hidden" name="scheda_prod" value="123"/>

        <tr bgcolor="#eeeeee" >
        <td width="20%"><c:out value="${row.id_prescrizione}"/> </td>
        <td width="20%"><c:out value="${row.id_test}"/>         </td>
        <td width="20%"><c:out value="${row.nome_prod}"/>       </td>
        <td align="center" width="10%">

          <c:if test="${row.scelto == 0}">
          <img src="bianco.png" width="20" height="20">
          </c:if>
          <c:if test="${row.scelto == 1}">
          <img src="verde.png" width="20" height="20">
          </c:if>
          <c:if test="${row.scelto == 2}">
          <img src="rosso.png" width="20" height="20">
          </c:if>

       </td>
       <td align="center" width="20%"><c:out value="${row.data_cand}"/></td>
       </tr>
                         
       </form>
       </c:forEach>

       </table>  
       </div>

 </td>
 </tr>
 <tr>
 <td width="60%" align="left">

<%---------------------------------------------------------------------------------%>
<%----- TABELLA CHE CONTIENE LA LEGENDA CHE SPIEGA IL TIPO DI CANDIDATURE 
        0 sospesa/ancora in attesa  1 scelta   2 non scelta                   -----%>
<%---------------------------------------------------------------------------------%>
       <table border="1" cellpadding="0" align=" center" 
        width="1100" height="100%" bgcolor="a5bacd">

           <tr>
           <td width="30%" valign="middle">
           <font size="4">candidatura da processare</font> &nbsp 
           <img src="bianco.png" width="20" height="20" valign="middle"> 
           </td>
                      
           <td width="30%" valign="middle">
           <font size="4">candidatura accettata</font> &nbsp 
           <img src="verde.png" width="20" height="20" valign="middle">
           </td>
                      
           <td width="30%" valign="middle">
           <font size="4">candidatura rifiutata</font> &nbsp 
           <img src="rosso.png" width="20" height="20" valign="middle"></td>
           </tr>

        </table>
 </td>
 </tr>
</TABLE>
<%@ include file="bottom.jspf"%>

 