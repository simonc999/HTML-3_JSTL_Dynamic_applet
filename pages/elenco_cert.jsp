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
         
    <td align="right" width="60">
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------- COMANDO INDIETRO ----------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
        <a href="home_gov.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
    </td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%> 
<%-------------------------------- ESTRAZIONE DALLA QUERY DEI CERT ATTIVI -------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

    <sql:query var="rset_elencocert">
        select C.user_cert, C.n_albo, C.nome, C.cognome, C.cf, C.data_nascita, C.ubicazione, U.attivo, U.username
        from CERT C, UTENTE_RUOLO U
        where C.user_cert=U.username and U.attivo=1 

    </sql:query>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------------- LAYOUT MID --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
    

<%@ include file="middle.jspf"%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%---  di seguito vengono riportati i messaggi di aggiunta ricevuti dalla action gov_cert_registrazione1.jsp ---%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:if test="${not empty messaggiososp}">
    ${messaggiososp}
</c:if>


<c:if test="${not empty param.messaggio1}">
    ${param.messaggio1}
</c:if>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------- nella tabella di seguito vengono riportate le descrizioni e la lista dei cert -----------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<TABLE align="center">
    <br>
    <tr align="left" height="100%">
        <td  style="font-size:18px; font-family:arial">
            <p style="font-size:23px;font-weight:bold;color: #007171;">AREA CERT
            </p>
            <p style="font-size:15px">In questa sezione sara' possibile :
            </p>
            <p style="font-size:13px;font-style: italic;">-visualizzare l'id dell'utente del corrispettivo CERT, l'albo di provenienza, il codice fiscale e le pratiche avviate e terminate con o senza successo a lui inerenti
            </p>
            <p style="font-size:13px;font-style: italic;">-effettuare la gestione (registrazione / sospensione) delle utenze relative ai CERT iscritti agli albi
            </p>
<p style="font-size:13px;font-style: italic;">-cliccando sul pulsante in fondo alla pagina sara' possibile visualizzare un elenco simile inerente ai cert sospesi
            </p>
<p style="font-size:13px;font-style: italic;">-cliccando sull'id del CERT sara' inoltre possibile visualizzarne i dettagli 
            </p>
        </td>
        <td align="center" style="font-size:18px; font-family:arial">
            
            <br> 
            
            <br> &nbsp Clicca per registrare una nuova utenza
        </td>
    </tr>




<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------- RIGA DENOMINAZIONE COLONNE ----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


    <tr>
        <td>
            <br>
            <table  cellspacing="0" cellpadding="1" border="0" width="100%" align="center">
                <tr style="font-family: arial;font-size:13px;" bgcolor="#008080">
                    <th width="14%">
                        <font color="#bfebfc">USERNAME</font>
                    </th>
                    <th width="12.5%">
                        <font color="#bfebfc">ALBO</font>
                    </th>
                    <th width="12.5%">
                        <font color="#bfebfc">CF</font>
                    </th>
                   
                    <th width="12.5%">
                        <font color="#bfebfc"> PRATICHE <img title="Numero pratiche con stato del prodotto in corso" src="giallo.png" width="15" height="15"/></font>
                    </th>
                    <th width="12.5%">
                        <font color="#bfebfc"> PRATICHE <img title="Numero pratiche con stato del prodotto certificato" src="verde.png" width="15" height="15"/></font>
                    </th>
                    
                    <th width="12.5%">
                        <font color="#bfebfc"> PRATICHE <img title="Numero pratiche con stato del prodotto non certificato" src="rosso.png" width="15" height="15"/></font>
                    </th>
                    <th width="14%">
                        <font  color="#bfebfc">SOSPENSIONE</font>
                    </th>
                </tr>
            </table>
            <br>
        </td>
    </tr>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------------------------------- TABELLA -------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

    <tr>
        <td>
            <div style=" height:70%; overflow:auto;">
                <table width="100%" color="#a5bacd" cellspacing="0" cellpadding="1" border="1" bordercolor="#bbccdc">
                    
                    <c:forEach items="${rset_elencocert.rows}" var="row">
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------- ESTRAZIONE PRATICHE IN CORSO DI OGNI CERT DAL DB --------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="rset_elencocert_praticheavv">
        select S.id_scheda
        from SCHEDA_PROD S 
        where S.user_cert="${row.user_cert}" and 
              S.inizio_prat IS NOT NULL and
              S.stato = 2 and
              S.user_cert LIKE ?
   <sql:param value="${row.username}"/>
    </sql:query>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------- ESTRAZIONE PRATICHE CONCLUSE CON SUCCESSO DI OGNI CERT DAL DB ---------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="rset_elencocert_praticheterm_succ">
        select S.id_scheda
        from SCHEDA_PROD S 
        where S.user_cert="${row.user_cert}" and 
              S.fine_prat IS NOT NULL and
              S.stato=1 and
              S.user_cert LIKE ?
   <sql:param value="${row.username}"/>
    </sql:query>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------- ESTRAZIONE PRATICHE CONCLUSE NONCON SUCCESSO DI OGNI CERT DAL DB ------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="rset_elencocert_praticheterm_nosucc">
        select S.id_scheda
        from SCHEDA_PROD S 
        where S.user_cert="${row.user_cert}" and 
              S.fine_prat IS NOT NULL and
              S.stato=3 and
              S.user_cert LIKE ?
   <sql:param value="${row.username}"/>
    </sql:query>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------- ESTRAZIONE DI TUTTE LE PRATICHE COCNLUSE DI OGNI CERT DAL DB ----------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="rset_elencocert_praticheterm">
        select S.id_scheda
        from SCHEDA_PROD S 
        where S.user_cert="${row.user_cert}" and 
              S.fine_prat IS NOT NULL and
              S.user_cert LIKE ?
   <sql:param value="${row.username}"/>
    </sql:query>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------- PASSAGGIO PARAMETRI PER DETTAGLI -------------------------------------------%>
<%--------------------------------- COLONNA RELATIVA AGLI ID --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>



         <tr style="font-family: arial;font-size:12px;" bgcolor="#eeeeee" height="18">
            <form method="post" action="cert_dettagli.jsp">
                <input type="hidden" name="user" value="${row.user_cert}"/>                            
                <td width="14%" align="center">
                    <input type="submit" value="${row.user_cert}" name="dettagli_username"/>
               </td>
            </form>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------- COLONNA ALBO, CODICE FISCALE E PRATICHE ------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

            <td width="12.5%"><c:out value="${row.n_albo}"/></td>
            <td width="12.5%"><c:out value="${row.cf}"/></td>
            <td width="12.5%"><c:out value="${rset_elencocert_praticheavv.rowCount}"/></td>
            <td width="12.5%"><c:out value="${rset_elencocert_praticheterm_succ.rowCount}"/></td>
            <td width="12.5%"><c:out value="${rset_elencocert_praticheterm_nosucc.rowCount}"/></td>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------- PASSAGGIO PARAMETRI PER SOSPENSIONE ----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

                            <form method="post" action="sospensione.jsp" >
                               <input type="hidden" name="sosp_username" value="${row.user_cert}"/>
                               <%-- <input type="hidden" name="nome" value="${dett_cert.rows[0].nome}"/>
                                <input type="hidden" name="cognome" value="${dett_cert.rows[0].cognome}"/> --%>

                                <td width="12.5%" align="center" style="font-size:14px;color:black;font-family:arial;" >
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------- TASTO SOSPENDI --------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
                                    <button  style="border-color:#007171;background-color:#009c9c;width:100px;height:30px;">
                                        <b style="font-size:12px;color:#eaf0f0;font-family:Arial;margin-bottom: 79px ;" >SOSPENDI</b>
                                    </button>
                                </td>
                            </form>
                            
                        </tr>
                    </c:forEach>
                </table>
            </div>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------ COMANDO DI REGISTRAZIONE -----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

            <form method="post" action="gov_cert_registrazione.jsp">
                <td valign="top" align="center" style="font-size:14px;color:black;font-family:arial;">
                    <button style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;">
                        <b style="font-size:17px;color:#eaf0f0;font-family:Arial;">REGISTRAZIONE</b>
                    </button>
                </td>
            </form>
        </td>
    </tr>
</TABLE>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------ VISUALIZZA I CERT SOSPESI -----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<table>
    <tr>
        <form method="post" action="elenco_cert_sospesi.jsp">
            <td valign="top" align="center" style="font-size:14px;color:black;font-family:arial;">
                <button style="border-color:#007171;background-color:#009c9c;width:230px;height:40px;">
                    <b style="font-size:17px;color:#eaf0f0;font-family:Arial;">VISUALIZZA CERT SOSPESI</b>
                </button>
            </td>
        </form>
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