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

<%---------------------------------%>
<%---------- FRAMMENTO TOP --------%>
<%---------------------------------%>

<%@ include file="top.jspf"%>

<%---------------------------------%>
<%--------- COMANDO INDIETRO ------%>
<%---------------------------------%>

<form method="post" action="scheda_prod_gov.jsp"> 
  <td align="right"  width="60">
    <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
    <input type="image" name="submit"  src="indietro.png" style="width:60px;height:60px">
  </td>    
</form>
 
<%---------------------------------%>
<%-------- FRAMMENTO MIDDLE -------%>
<%---------------------------------%>

<%@ include file="middle.jspf"%>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------ QUERY  -----------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<%----------------------------------------------------------------------------%>
<%-------------- ESTRAGGO I TEST PRESCRITTI PER LA SCHEDA SELEZIONATA --------%>
<%----------------------------------------------------------------------------%>

<sql:query var="test_presc">
    SELECT t.id_test, ti.descrizione, t.motivi, p.Id_scheda, p.Nome_prod, t.motivi
    FROM TEST t, SCHEDA_PROD p, TIPO_TEST ti
    WHERE t.id_scheda = p.id_scheda and ti.id_tipo=t.id_tipo and p.id_scheda LIKE ?
    <sql:param value="${param.id_scheda}"/>
</sql:query>


<%----------------------------------------------------------------------------%>
<%------------- ESTRAGGO L' ESITO DEL TEST SELEZIONATO -----------------------%>
<%----------------------------------------------------------------------------%>

<sql:query var="esito">
    SELECT t.data_ora_esito, t.superato, t.rapporto
    FROM TEST t
    WHERE t.id_test LIKE ?
    <sql:param value="${param.test}"/>
</sql:query>



<table align="center" width="100%" cellspacing="0" cellpadding="0" bgcolor="bbccdc">
  <caption align="top">
    <font size="5" face="Arial" color="#007171">
      <b> TEST EFFETTUATI PER : ${param.nome_prod} </b>
    </font>
    <br/>
    <br/>
  </caption>


  <c:set var="n_test" value="${test_presc.rowCount}"/>

<%-------------------------------------------------------------------------%>
<%---------- SE IL NUMERO DI TEST E' = 0, VEDO MESSAGGIO DI AVVISO --------%>
<%-------------------------------------------------------------------------%>

  <c:if test="${n_test == 0}">
    <tr>
      <td align="center">
        <font color="green" size="5"> Non e' stato effettuato alcun test per questa scheda. </font>
      </td>
    </tr>
  </c:if>

<%-------------------------------------------------------------------------%>
<%---------- SE IL NUMERO DI TEST E' > 0, LI MOSTRO IN UNA TABELLA --------%>
<%-------------------------------------------------------------------------%>

  <c:if test="${n_test > 0}">
    <tr>
      <td>

        <table align="center" width="60%" cellspacing="0" cellpadding="3" bgcolor="bbccdc" border="1" bordercolor="bbccdc">

          <tr width="10% height="20%">
            <th align="center" width="25%" height="10%" bgcolor="#007171">
              <font color="#9ad6d6" size="4" face="Arial"> CODICE TEST: </font>
            </th>
            <th align="center" width="25%" height="10%" bgcolor="#007171">
              <font color="#9ad6d6" size="4" face="Arial"> NOME TEST: </font>
            </th>
            <th align="center" width="25%" height="10%" bgcolor="#007171">
              <font color="#9ad6d6" size="4" face="Arial"> MOTIVO: </font>
            </th>
            <th align="center" width="25%" height="10%" bgcolor="#007171">
              <font color="#9ad6d6" size="4" face="Arial"></font>
            </th>
          </tr>


            <c:forEach items="${test_presc.rows}" var="lista">
             <form method="post" action="#">    <%-----RICARICA SU SE STESSA-----%>
              <tr bgcolor="white ">
                <td width="25%" align="center"><font face="Arial" size="3"> ${lista.id_test} </font></td>
                <td width="25%"><font face="Arial" size="3"> ${lista.descrizione} </font></td>
                <td width="25%"><font face="Arial" size="3"> ${lista.motivi} </font></td>
                <td width="25%" align="center" valign="middle">
                  <font size="3" face="Arial">
                  <br/>
                  <br/>
                  <input type="hidden" name="nome_prod" value="${param.nome_prod}"/>
                  <input type="hidden" name="test" value="${lista.id_test}"/>
                  <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
                  <input type="submit" name="tasto" value="Visualizza esito"/>
                  </font>
                </td>
              </tr>
              </form>
            </c:forEach>

        </table>
      </td>

<%---------------------------------------%>
<%---------- SE CLICCO SUL TASTO --------%>
<%---------------------------------------%>

      <td>
        <c:if test="${not empty param.tasto}">
          <c:choose>

<%-------------------------------------------------------------------%>
<%---------- SE C'E' L'ESITO DEL TEST SELEZIONATO, LO MOSTRO --------%>
<%-------------------------------------------------------------------%>

            <c:when test="${not empty esito.rows[0].rapporto}">
              <table align="center" width="80%" cellspacing="0" cellpadding="3" bgcolor="white" bordercolor="bbccdc" border="1">
                <tr>
                  <th align="left" width="20%"><font color="#007171" face="Arial" size="4"><b>DATA ESITO: </b></font></th>
                  <td align="center"> <font face="Arial" size="4" > ${esito.rows[0].data_ora_esito} </font></td>
                </tr>
                <tr>
                  <th align="left" width="20%"><font color="#007171" face="Arial" size="4"><b>SUPERATO: </b></font></th>
                  <td align="center"> 
                    <c:if test="${esito.rows[0].superato == 'true'}"> <font face="Arial" size="4"> Certificato </font> </c:if>
                    <c:if test="${esito.rows[0].superato == 'false'}"> <font face="Arial" size="4"> Non certificato </font> </c:if>
                  </td>
                </tr>
                <tr>
                  <th align="left" width="20%"><font color="#007171" face="Arial" size="4"><b>RAPPORTO: </b></font></th>
                  <td align="center"> <font face="Arial" size="4">${esito.rows[0].rapporto}</font></td>
                </tr>
              </table>
            </c:when>


<%-------------------------------------------------------------------%>
<%---------- SE NON C'E' L'ESITO, MOSTRO MESSAGGIO DI AVVISO --------%>
<%-------------------------------------------------------------------%>

            <c:otherwise>
              <tr>
                <td align="center">
                  <font color="green" size="4">Esito non ancora disponibile. <br/> Sara' visibile in questa sezione una volta redatto dal certificatore. </font>
                </td>
              </tr>
            </c:otherwise>
          </c:choose>
        </c:if>
      </td>
    </tr>
  </c:if>
</table>

<%---------------------------------%>
<%-------- FRAMMENTO BOTTOM -------%>
<%---------------------------------%>

<%@ include file="bottom.jspf"%>
