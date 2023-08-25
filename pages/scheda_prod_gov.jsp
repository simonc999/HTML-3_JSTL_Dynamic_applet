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
<%------------------------------------- CONTROLLO DEI PERMESSI DI GOV  ----------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="2"/>
<c:set var="auth_page" value="home_gov.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Agenzia Governativa"/>

<%@ include file="auth.jspf"%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%---------------------------------------------- LAYOUT TOP  --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<%@ include file="top.jspf"%>

<%------------ COMANDO INDIETRO -----------%>

<td align="right" width="60" >
  <a href="gov_prodotti.jsp"> 
    <img style="width:60px;height:60px" src="indietro.png">
  </a>
</td>       

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%---------------------------------------------- LAYOUT MID  --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>


<%@ include file="middle.jspf"%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------- QUERY  ---------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

      <%---------------------------------------------%>
      <%---------------- QUERY TABELLA --------------%>
      <%---------------------------------------------%>

<sql:query var="dettagli">
  SELECT P.id_scheda, P.Nome_prod, P.tipo, P.uso, P.materiali, P.beneficio,P.nuovo, P.inizio_prat, P.stato, P.user_cpr, P.verbale
  FROM SCHEDA_PROD P
  WHERE  P.id_scheda LIKE ?
  <sql:param value="${param.id_scheda}"/>
</sql:query>

      <%------------------------------------------------%>
      <%---------- QUERY CERT PER TABELLA  -------------%>
      <%------------------------------------------------%>

<sql:query var="cert">
  SELECT c.nome,c.cognome, u.telefono, u.mail, c.user_cert, u.attivo
  FROM SCHEDA_PROD p, CERT c, UTENTE_RUOLO u
  WHERE p.user_cert=c.user_cert and u.username=c.user_cert and
  p.id_scheda LIKE ?
  <sql:param value="${param.id_scheda}"/>
</sql:query>

      <%----------------------------------------------------%>
      <%---------------- QUERY VALORE ANNULLO --------------%>
      <%----------------------------------------------------%>

<sql:query var="annullo">
  SELECT annullo_motivo
  FROM TEST
  WHERE  id_scheda LIKE ?
  and  annullo_motivo is not null
  <sql:param value="${param.id_scheda}"/>
</sql:query>


     <%----------------------------------------------%>
     <%-----------NOTIFICA DI NUOVO PROD-------------%>
     <%----------------------------------------------%>

<c:if test="${dettagli.rows[0].nuovo == 'true'}">
  <sql:update>
    UPDATE SCHEDA_PROD
    SET nuovo = false
    WHERE id_scheda LIKE ?
    <sql:param value="${param.id_scheda}"/>
  </sql:update>
</c:if>



     <%-------------------------------------------%>
     <%------------STAVO DI AVANZAMENTO-----------%>
     <%-------------------------------------------%>

<sql:query var="test_eff">
  SELECT t.id_prescrizione
  FROM SCHEDA_PROD p, TEST t
  WHERE p.id_scheda=t.id_scheda and t.data_ora_esito is not null and
  p.id_scheda LIKE ?
  <sql:param value="${param.id_scheda}"/>
</sql:query>

<sql:query var="test_presc">
  SELECT t.id_prescrizione
  FROM SCHEDA_PROD p, TEST t
  WHERE p.id_scheda=t.id_scheda and 
  p.id_scheda LIKE ?
  <sql:param value="${param.id_scheda}"/>
</sql:query>

     <%-------------------------------------------%>
     <%----------------- CONTEGGI ----------------%>
     <%-------------------------------------------%>

 <c:set var="n_test_eff" value="${test_eff.rowCount}"/>                       <%----------------- TEST EFFETTUATI ----------------%>
 <c:set var="n_test_presc" value="${test_presc.rowCount}"/>                   <%----------------- TEST PRESCRITTI ----------------%>
 <c:set var="percentuale" value="${(n_test_eff/n_test_presc)*100}"/>  <%----------------- PERCENTUALE EFFETTUATI PRESCRITTI ----------------%>


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------- TABELLA  --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

      <%---------------------------------------------%>
      <%---------------- TABELLA PROD ---------------%>
      <%---------------------------------------------%>


<table>
  <tr>
    <h2 style="font-weight: bold;color:#526579;">INFORMAZIONI SUL PRODOTTO </h2>
  </tr>

  
  <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171">
      <font color="#9ad6d6" face="Arial">STATO DI AVANZAMENTO: </font>
    </td>

    <td align="center" bgcolor="white">
      <c:if test="${n_test_presc>0}">
        <progress style="border:3;width:70%;height:40%" title="${percentuale}%" value="${n_test_eff}" max="${n_test_presc}"></progress>
        <br/>
        <font size="2">Rapporto in % tra test effettuati e test prescritti per questo prodotto </font>
      </c:if>
    
      <c:if test="${n_test_presc==0}">
        <font size="3"> Non sono ancora stati prescritti test per questo prodotto</font>
      </c:if>
    </td>
  </tr>



  <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171">
      <font color="#9ad6d6" face="Arial">NOME: </font>
    </td>
    <td align="center" bgcolor="white"> ${dettagli.rows[0].Nome_prod} </td>
  </tr>

  <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171">
      <font color="#9ad6d6" face="Arial">CODICE: </font>
    </td>
    <td align="center" bgcolor="white"> ${dettagli.rows[0].Id_scheda} </td>
  </tr>

  <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171">
      <font color="#9ad6d6" face="Arial">TIPO: </font>
    </td>
    <td align="center"bgcolor="white"> ${dettagli.rows[0].tipo} </td>
  </tr>

  <tr>
    <td align="left" width="15%" height="35%" bgcolor="#007171">
      <font color="#9ad6d6" face="Arial">USO: </font>
    </td>
    <td align="center" height="35%" bgcolor="white"> ${dettagli.rows[0].uso} </td>
  </tr>

  <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171">
      <font color="#9ad6d6" face="Arial">MATERIALI: </font>
    </td>
    <td align="center" bgcolor="white"> ${dettagli.rows[0].materiali} </td>
  </tr>

  <tr>
    <td align="left" width="15%" height="22%" bgcolor="#007171">
      <font color="#9ad6d6" face="Arial">BENEFICIO: </font>
    </td>
    <td align="center" bgcolor="white"> ${dettagli.rows[0].beneficio} </td>
  </tr>



      <%---------------------------------------------%>
      <%---------------- TABELLA CERT ---------------%>
      <%---------------------------------------------%>



  <c:if test="${not empty cert.rows[0].nome}">

    <tr>
      <td align="left" height="22%" bgcolor="#007171">
        <font color="#9ad6d6" face="Arial">ID CERT: </font>
      </td>
      <td align="center"bgcolor="white"> ${cert.rows[0].user_cert} </td>
    </tr>

    <tr>
      <td align="left"  height="22%" bgcolor="#007171">
        <font color="#9ad6d6" face="Arial">NOME E COGNOME: </font>
      </td>
      <td align="center" bgcolor="white"> ${cert.rows[0].nome} ${cert.rows[0].cognome} </td>
    </tr> 

    <tr>
      <td align="left" height="22%" bgcolor="#007171">
        <font color="#9ad6d6" face="Arial">RECAPITO: </font>
      </td>
      <td align="center" height="35%" bgcolor="white">${cert.rows[0].telefono} </td>
    </tr>

    <tr>
      <td align="left"  height="22%" bgcolor="#007171">
        <font color="#9ad6d6" face="Arial">EMAIL: </font>
      </td>
      <td align="center" bgcolor="white">${cert.rows[0].mail} </td>
    </tr>

    <tr>
      <td align="left"  height="22%" bgcolor="#007171">
        <font color="#9ad6d6" face="Arial">DATA INIZIO: </font>
      </td>
      <td align="center" bgcolor="white"> ${dettagli.rows[0].inizio_prat} </td>
    </tr> 
    <br/>
    <br/>

      <%---------------------------------------------%>
      <%-------------- TASTI PER ACTION -------------%>
      <%---------------------------------------------%>


    <c:if test="${dettagli.rows[0].stato==2}">

      <tr>
        <td align="center" colspan="2">
          <table>
            <tr>
              <td align="center">
                <form method="post" action="assegnazione.jsp">    <%----VAI ALLA PAGINA ASSEGNAZIONE-----%>
                  <input type="hidden" name="ban_cpr" value="${dettagli.rows[0].user_cpr}"/> 
                  <input type="hidden" name="username" value="${cert.rows[0].user_cert}"/> 
                  <input type="hidden" name="id_scheda" value="${dettagli.rows[0].id_scheda}"/>
                  <button  style="border-color:#007171;background-color:#009c9c;width:100px;height:40px;">
                    <b align="center" style="font-size:12px;color:white;font-family:arial;">SOSTITUISCI</b>
                  </button> 
                </form>
              </td>

              <td align="center">
                <form method="post" action="revoca.jsp">  <%--------VAI ALLA PAGINA REVOCA-----%>
                  <input type="hidden" name="username" value="${cert.rows[0].user_cert}"/> 
                  <input type="hidden" name="id_scheda" value="${dettagli.rows[0].id_scheda}"/>
                  <button  style="border-color:#007171;background-color:#009c9c;width:100px;height:40px;">
                    <b align="center" style="font-size:12px;color:white;font-family:arial;">REVOCA</b>
                  </button>
                </form>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </c:if>
  </c:if>

  <c:if test="${empty cert.rows[0].nome and dettagli.rows[0].stato==2}">
    <form method="post" action="assegnazione.jsp">           <%----VAI ALLA PAGINA ASSEGNAZIONE-----%>
      <input type="hidden" name="id_scheda" value="${dettagli.rows[0].id_scheda}"/>
      <input type="hidden" name="ban_cpr" value="${dettagli.rows[0].user_cpr}"/> 

      <tr>
        <td align="center" colspan="2">
          <button  style="border-color:#007171;background-color:#009c9c;width:100px;height:40px;">
            <b align="center" style="font-size:12px;color:white;font-family:arial;">ASSEGNA CERT</b>
          </button> 
        </td>
      </tr>
    </form>
  </c:if>

  <c:if test="${not empty dettagli.rows[0].verbale}">
    <tr>
      <td align="left"  height="22%" bgcolor="#007171">
        <font color="#9ad6d6" face="Arial">VERBALE: </font>
      </td>
      <td align="center" bgcolor="white">${dettagli.rows[0].verbale} </td>
    </tr>
  </c:if>

  <c:if test="${not empty annullo.rows[0].annullo_motivo}">
    <tr>
      <td align="left"  height="22%" bgcolor="#007171">
        <font color="#9ad6d6" face="Arial"> CERTIFICAZIONE ANNULLATA: </font>
      </td>
      <td align="center" bgcolor="white">${annullo.rows[0].annullo_motivo} </td>
    </tr>
  </c:if>

<c:if test="${cert.rows[0].attivo == 'false'}">
<tr><td colspan="2" align="center">
 <font color="red" size="3"> Il certificatore assegnato a questa scheda e' stato sospeso. <br/>
                             Se vuoi che il processo di certificazione proceda, sostituisci il certificatore.
</font>
</td></tr>
</c:if>

      <%---------------------------------------------%>
      <%--------------- MESSAGGI ERRORE -------------%>
      <%---------------------------------------------%>


  ${msgerror}
  ${msgerror1}
</table>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------ SPALLETTA --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<td width="40%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px">
  <table  cellspacing="0"width="100%" height="100%"  rules="none" bgcolor="#a5bacd">
    <tr>
      <td width="60%" align="right" >
        <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" >TEST PRESCRITTI</p>
        <hr  color="#53667a" size="9px">
        <p style="font-size:15px;color: white; font-weight: bold;font-family:arial;margin-top:14px" >Visualizza test prescritti</p>
      </td>
      <form method="post" action="test_gov.jsp">       <%-----VAI ALLA PAGINA TEST_GOV-------%>
        <input type="hidden" name="id_scheda" value="${dettagli.rows[0].Id_scheda}"/>
        <input type="hidden" name="nome_prod" value="${dettagli.rows[0].Nome_prod}"/>

        <td width="40%"  align="center">
          <button  style="border-color:   #a5bacd;background-color:  #a5bacd;">
            <img style="width:90px;height:90px;"src="testeff.jpg">
          </button>
        </td>
      </form>
    </tr>
  </table>
</td>
</tr>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------- BOTTOM ---------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<%@ include file="bottom.jspf"%>