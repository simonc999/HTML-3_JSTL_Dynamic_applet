<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------ CONTROLLO DEI PERMESSI DI GOV ------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------------- LAYOUT TOP --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<%@ include file="top.jspf"%>
<form method="post" action="cert_dettagli.jsp">
<td align="right" width="60" >

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- COMANDO INDIETRO ----------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

    
            <input type="hidden" name="user" value="${param.username}"/>
       <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
       
     </td>
     </form>
     
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------------- ESTRAZIONE DELLA QUERY --------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
    
<sql:query var="riab">
  select  c.cf, c.nome, c.cognome, c.n_albo, c.ubicazione, c.user_cert
    from CERT c
    where  c.user_cert LIKE ?
<sql:param value="${param.username}"/>
</sql:query>
 
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------------- LAYOUT MID --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
 
<%@ include file="middle.jspf"%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------- stampa del messaggio con i parametri indicanti il cert in questione -----------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<table width="70%">
    <tr align="center">
        <td valign="top"  style="font-size:18px; font-family:arial"> 
            <p style="font-size:25px">Confermi la riabilitazione dell'utenza del Cert <span style="font-size:23px;color:red;font-family:arial;font- 
            style:italic;font-weight:bolder">${param.username}
            </span>, di numero albo 
            <span style="font-size:23px;color:black;font-family:arial;font-style:italic;font-weight:bolder">${riab.rows[0].n_albo}
            </span>, nome 
            <span style="font-size:23px;color:black;font-family:arial;font-style:italic;font-weight:bolder">${riab.rows[0].nome}
            </span>, cognome 
            <span style="font-size:23px;color:black;font-family:arial;font-style:italic;font-weight:bolder">${riab.rows[0].cognome}
            </span>
            </span>, codice fiscale 
            <span style="font-size:23px;color:black;font-family:arial;font-style:italic;font-weight:bolder">${riab.rows[0].cf}
            </span> e indirizzo 
            <span style="font-size:23px;color:black;fontfamily:arial;font-style:italic;font-weight:bolder">${riab.rows[0].ubicazione}
            </span>?</p>
        </td>
    </tr>
    <tr align="center">   
        <table>
            <tr>
                <td style="font-size:14px;color:black;font-family:arial;">
                    <br>
                    <br>
                    <br>
                    <br>
                    <br>
                    <form method="post" action="riabilitazione1.jsp"> 
                        <input type="hidden" name="nome" value="${riab.rows[0].nome}"/>
                        <input type="hidden" name="cognome" value="${riab.rows[0].cognome}"/>
                        <input type="hidden" name="username" value="${riab.rows[0].user_cert}"/>
                        <button style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;"><b  style="font-size:17px;color:#eaf0f0;font-family:Arial;" >CONFERMA</b>
                        </button>
                    </form>
                </td>
                <td style="font-size:14px;color:black;font-family:arial;">
                    <br>
                    <br>
                    <br>
                    <br>
                    <br>
                    <form method="post" action="cert_dettagli.jsp">
            <input type="hidden" name="user" value="${param.username}"/>
                        <button style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;"><b  style="font-size:17px;color:#eaf0f0;font-family:Arial;" >ANNULLA</b>
                        </button>
                    </form>
                </td>
            </tr>
        </table>
    </tr>
</table>
</td>
</tr>
</table>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------- LAYOUT BOT ------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<%@ include file="bottom.jspf"%>