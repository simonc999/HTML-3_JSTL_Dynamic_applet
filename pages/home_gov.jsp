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
<%--------------------- AUTORIZZAZIONE AREA GOV ------------------------%>
<%----------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>

<%----------------------------------------------------------------------%>
<%-------------------------- FRAMMENTO TOP -----------------------------%>
<%----------------------------------------------------------------------%>


<%@ include file="top.jspf"%>

<%----------------------------------------------------------------------%>
<%-------------- QUERY PER CONTARE LE NOTIFICHE ------------------------%>
<%----------------------------------------------------------------------%>

<sql:query var="schede">
  SELECT id_scheda
  FROM SCHEDA_PROD
  WHERE nuovo = 1
</sql:query>

<c:set var="n_schede" value="${schede.rowCount}"/>

<%----------------------------------------------------------------------%>
<%-------------------------- FRAMMENTO MID -----------------------------%>
<%----------------------------------------------------------------------%>


<%@ include file="middle.jspf"%>


<TABLE  cellspacing="0" border="0" bgcolor="#bbccdc" width="100%" height="77%" bordercolor="#41140E">
  <tr>
    <td align="center" width="60%">
      <table width="100%" height="100%"  >
        <tbody>
          <tr  height="10%" >
            <td colspan="3" > &nbsp; </td>
          </tr>
          <tr>
            <td width="10%"></td>
            <td style="font-size:23px; font-family:arial">
              <p style="font-weight: bold;color:#526579;">BENVENUTO GOV</p>
                <c:if test="${n_schede > 0}"> 
                  <table border="1" bordercolor="green">
                   <tr><td><table border="0">
                    <tr>
                      <td align="center"><img style="width:45px;height:45px;" src="alarm.jpg"></td>
                      <td align="left">
                        <font color ="green" size="4"> <br/>${n_schede} NUOVE SCHEDE AVVIATE! </font>
                      </td>
                    </tr>
                  </table>  
                 </td></tr></table>  
                </c:if>
              <hr align="top" color="#526579" size="5px"/> 
              <p style="font-weight: bold;color:#526579;font-size:18px;">GOV e' un'agenzia governativa adibita severamente a supervisionare e 
                  regolamentare l'intero processo di certificazione di prodotti alimentari e cosmetici.</p>
              <p style="font-size:16px">E' un'unica utenza in grado di:</p>
              <p style="font-style: italic;font-size:14px">-gestire le utenze relative ai CERT</p>
              <p style="font-style: italic;font-size:14px">-gestire e aggiornare i tipi di TEST</p>
              <p style="font-style: italic;font-size:14px">-visualizzare le schede PROD e il loro stato di certificazione</p>
              <p style="font-style: italic;font-size:14px">-visualizzare i TEST richiesti per ogni PROD</p>
              <p style="font-style: italic;font-size:14px">-visualizzare il rapporto conclusivo del CERT per ogni PROD</p>
              <p style="font-style: italic;font-size:14px"> -gestire l'assegnazione e l'eventuale revoca di CERT per i PROD in corso di certificazione</p>
            </td>
            <td width="10%"></td>
          </tr>
          <tr height="20%">
            <td >&nbsp;</td>
          </tr>
        </tbody>
      </table>
    </td>   
    <td width="40%"  >
      <table  cellspacing="0" width="100%" height="100%" bgcolor="#a5bacd">
        <tr>
          <td width="60%" align="right" >
            <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" > AREA CERT</p>
            <hr  color=" #526579" size="9px"/> 
            <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px" >gestione di CERT</p>
          </td>

<%----------------------------------------------------------------------%>
<%------------------------ FORM PER ZONA CERT --------------------------%>
<%----------------------------------------------------------------------%>

          <form method="post" action="elenco_cert.jsp" >
            <td width="40%"  align="center">
              <button  style="border-color:   #8aa3b9;background-color:  #8aa3b9;">
                <img style="width:90px;height:90px;"src="arrowbutton.jpeg">
              </button>
            </td>
          </form>
        </tr>
        <tr>
          <td width="60%" align="right">
            <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px"> 
              <c:if test="${n_schede >0}"> 
                <font color="green" size="2"> ${n_schede} </font>
                <img src="0.png" style="width:30px;height:30px;"/>
              </c:if>AREA PROD</p>
            <hr color="#526579" size="9px"/>
            <p style="font-size:15px;color: #e3f1fe;font-weight: bold; font-family:arial;margin-top:14px" >gestione delle schede dei PROD</p>
          </td>

<%----------------------------------------------------------------------%>
<%------------------------ FORM PER ZONA PROD --------------------------%>
<%----------------------------------------------------------------------%>

          <form method="post" action="gov_prodotti.jsp">
            <td width="40%"  align="center">
              <button  style="border-color:   #8aa3b9;background-color:  #8aa3b9;">
                <img style="width:90px;height:90px;"src="arrowbutton.jpeg">
              </button>
            </td>
          </form>
        </tr>
        <tr>
          <td width="60%" align="right">
            <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" > AREA TEST</p>
            <hr  color=" #526579" size="9px">
            <p style="font-size:15px;color: #e3f1fe; font-weight: bold;font-family:arial;margin-top:14px">gestione dei TEST</p>
          </td>

<%----------------------------------------------------------------------%>
<%---------------------- FORM PER ZONA TIPI TEST -----------------------%>
<%----------------------------------------------------------------------%>

          <form method="post" action="elenco_tipitest.jsp">
            <td width="40%"  align="center">
              <button  style="border-color:   #8aa3b9;background-color:  #8aa3b9;">
                <img style="width:90px;height:90px;"src="arrowbutton.jpeg">
              </button>
            </td>
          </form>
        </tr>
      </table>
    </td>
  </tr>
</TABLE>

<%----------------------------------------------------------------------%>
<%------------------------ FRAMMENTO BOTTOM ----------------------------%>
<%----------------------------------------------------------------------%>

<%@ include file="bottom.jspf"%>