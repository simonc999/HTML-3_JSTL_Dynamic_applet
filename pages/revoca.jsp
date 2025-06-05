<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%---------------------------------------------------------------------%>
<%------------------- AUTORIZZAZIONE AREA GOV -------------------------%>
<%---------------------------------------------------------------------%>
<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>

<%---------------------------------%>
<%--------- FRAMMENTO TOP ---------%>
<%---------------------------------%>

<%@ include file="top.jspf"%>

<%---------------------------------%>
<%-------- COMANDO INDIETRO -------%>
<%---------------------------------%>

<form method="post" action="scheda_prod_gov.jsp"> 
  <td align="right" width="60">
    <input type="hidden" name="id_scheda" value="${param.id_scheda}"/> 
    <input type="image" name="submit"  src="indietro.png" style="width:60px;height:60px">
  </td>
</form>

<%---------------------------------%>
<%-------- FRAMMENTO MIDDLE -------%>
<%---------------------------------%>

<%@ include file="middle.jspf"%>

<table width="70%">
  <tr align="center">
    <td valign="top"  style="font-size:18px; font-family:arial"> 
      <p style="font-size:25px">Confermi la revoca dell'utenza del Cert?</p>
    </td>
  </tr>


                       <%---------------------------------%>
                       <%--------- TASTO CONFERMA --------%>
                       <%---------------------------------%>

  <tr align="center">   
    <table>
      <tr>
        <td style="font-size:14px;color:black;font-family:arial;">
        <br/><br/><br/><br/><br/>
          <form method="post" action="revoca1.jsp">   <%-----VAI ALL'ACTION REVOCA1----%>
            <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
            <input type="hidden" name="username" value="${param.username}"/>
            <button  style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;">
              <b  style="font-size:17px;color:#eaf0f0;font-family:Arial;" >CONFERMA</b>
            </button> 
          </form>
        </td>

                       <%---------------------------------%>
                       <%--------- TASTO ANNULLA ---------%>
                       <%---------------------------------%>

        <td style="font-size:14px;color:black;font-family:arial;" >
        <br/><br/><br/><br/><br/>
          <form method="post" action="scheda_prod_gov.jsp">     <%----TORNA ALLA SCHEDA_PROD_GOV-----%>
            <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
            <button  style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;">
              <b  style="font-size:17px;color:#eaf0f0;font-family:Arial;" >ANNULLA</b>
            </button> 
          </form>
        </td>
      </tr>
    </table>
  </tr>
</table>

<%---------------------------------%>
<%-------- FRAMMENTO BOTTOM -------%>
<%---------------------------------%>

<%@ include file="bottom.jspf"%>

