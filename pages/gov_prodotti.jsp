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


<%-------------------------------------------- COMANDO INDIETRO -----------------------------------------------%>
<%@ include file="top.jspf"%>

<td align="right" width="60" >
  <a href="home_gov.jsp"> 
    <img style="width:60px;height:60px" src="indietro.png">
  </a>
</td>




<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%----------------------------------------- QUERY PER TABELLA E PER FILTRO ------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<sql:query var="scheda_prod">
  SELECT DISTINCT C.nome, P.id_scheda, P.nome_prod,  P.stato, P.inizio_prat, P.fine_prat, P.nuovo
  FROM SCHEDA_PROD P, CPR C
                                                                                <%-- USARE DEGLI IF PER --%>
    <c:if test="${param.filtro==2}">, TEST T, TIPO_TEST TP</c:if>              <%-- AGGIUGERE LE TABELLE --%> 
  WHERE  P.stato > 0 and C.user_cpr=P.user_cpr                                  <%-- SOLO SE NECESSARIO --%>

    <c:if test="${not empty param.filtro}">    <%-- VERIFICO SE ALMENO UN RADIO E' ATTIVATO --%>
      and

                       <%-- FILTRO NUMERO 1 NOME PROD O AZIENDA --%>
      <c:if test="${param.filtro==1}">
        <c:if test="${param.nome=='prod'}"> lower(P.nome_prod) like lower(?)
        <sql:param value="${param.search}%"/>
        </c:if>
        <c:if test="${param.nome=='azienda'}"> lower(C.nome) like lower(?)
        <sql:param value="${param.search}%"/>
        </c:if>
      </c:if>

                           <%-- FILTRO NUMERO 2 ID TIPO --%>

      <c:if test="${param.filtro==2}"> T.id_scheda=P.id_scheda and TP.id_tipo=T.id_tipo 
        and  (lower(TP.id_tipo) like lower(?) or lower(TP.tipo) like lower(?)
              or lower(TP.descrizione) like lower(?) )
              <sql:param value="${param.search}%"/>
              <sql:param value="${param.search}%"/>
              <sql:param value="${param.search}%"/>
      </c:if>

                          <%-- FILTRO NUMERO 3 STATO DEL PROD --%>

      <c:if test="${param.filtro==3}">
        <c:if test="${param.iter=='certificato'}"> P.stato=1</c:if>
        <c:if test="${param.iter=='in corso di certificazione'}"> P.stato=2</c:if>
        <c:if test="${param.iter=='non certificato'}"> P.stato=3</c:if>
      </c:if>

                       <%-- FILTRO NUMERO 4 PROD ASSEGNATO E NON --%>

      <c:if test="${param.filtro==4}"> 
        <c:if test="${param.cert=='assegnato'}">P.user_cert is not null</c:if>
        <c:if test="${param.cert=='non assegnato'}">P.user_cert is null</c:if>
      </c:if>

    </c:if>
</sql:query>
 
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------- SEZIONE MID ----------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

<%@ include file="middle.jspf"%>
<table height="85%">
  <tr height="30%">
    <td  width="3%"></td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------- DESCRIZIONE ----------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

    <td width="45%">
        <br/>
        <b style="color:#007171;font-size:24px;">AREA PROD</b>
        <p style="font-size:16px">In questa sezione potrai:
          <ol style="font-size:16px">
            <li>visualizzare le schede dei prodotti e assegnarne i certificatori </li>
            <li>filtrare i  prodotti secondo determinati parametri</li>
            <li>inoltre puoi revocare o sostituire i certificatori gia' assegnati alle schede. </li>
          </ol>
        </p>
    </td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------ LEGENDA STATI ----------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

    <td width="10%" rowspan="2">
      <table border="1" cellpadding="1" align=" center" width="20%" height="20%" bgcolor="a5bacd">
        <caption><font color="008080">LEGENDA </font> </caption>
        <tr>
          <td>certificato</td>
          <td><img src="verde.png" width="20" height="20"></td>
        </tr>
        <tr>
          <td> non certificato</td>
          <td><img src="rosso.png" width="20" height="20"></td>
        </tr>
        <tr>
          <td>in fase di certificazione</td>
          <td><img src="giallo.png" width="20" height="20" </td>
        </tr>
      </table>
    </td>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%---------------------------------------------------- FILTRO -------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

    <td width="20%" rowspan="2">
      <TABLE width="20%" height="90%" align="center" cellspacing="0" cellpadding="5">
        <form name="searchForm" action="gov_prodotti.jsp" method="post">

          

          <tr height="25%">     
             <td ><p style="font-size:15px;font-weight:bold;color: #007171;">Filtra la tua ricerca secondo queste opzioni:</p></td>
          </tr> 

          <tr style="font-family:arial;background-color:#a5bacd">
            <td align="center">
              <label for="search" >Inserisci</label>
              <input type="text" id="search" name="search" placeholder="Cosa cerchi?"/>
            </td>
          </tr>

          <tr style="font-family:arial; background-color:#a5bacd">   
            <td align="left">
              <input type="radio" id="nome" name="filtro" value="1" style="cursor:pointer" <c:if test="${param.filtro==1}">checked</c:if> >
               <label for="nome" style="cursor:pointer">in base al :</label>
              <select name="nome" id="nome">
                <option value="prod" <c:if test="${param.nome=='prod'}">selected</c:if>>nome prodotto</option>
                <option value="azienda" <c:if test="${param.nome=='azienda'}">selected</c:if>>nome azienda</option>
              </select>
              <br/>
            </td>
          </tr>

          <tr style="font-family:arial; background-color:#a5bacd">
            <td align="left">
              <input type="radio" id="test" name="filtro" value="2" style="cursor:pointer" <c:if test="${param.filtro==2}">checked</c:if>>
              <label for="test" style="cursor:pointer"> PROD per cui e' stato prescritto un tipo di test/analisi</label>
            </td>
          </tr>

          <tr style="font-family:arial; background-color:#a5bacd">
            <td align="left">
              <input type="radio" id="iter" name="filtro" value="3" style="cursor:pointer" <c:if test="${param.filtro==3}">checked</c:if>> 
               <label for="iter" style="cursor:pointer">PROD con iter :</label> 
              <select name="iter" id="it">
                <option value="certificato" <c:if test="${param.iter=='certificato'}">selected</c:if>>certificato</option>
                <option value="non certificato" <c:if test="${param.iter=='non certificato'}">selected</c:if>>non certificato</option>
                <option value="in corso di certificazione" <c:if test="${param.iter=='in corso di certificazione'}">selected</c:if>>in corso di certificazione</option>
              </select> 
              <br/>
            </td>
          </tr>

          <tr  style="font-family:arial; background-color:#a5bacd">
            <td align="left">
              <input type="radio" id="c" name="filtro" value="4" style="cursor:pointer" <c:if test="${param.filtro==4}">checked</c:if>>
              <label for="c" style="cursor:pointer"> PROD con CERT: </label>
              <select name="cert" id="cert">
                <option value="assegnato" <c:if test="${param.cert=='assegnato'}">selected</c:if>>assegnato</option>
                <option value="non assegnato" <c:if test="${param.cert=='non assegnato'}">selected</c:if>>non assegnato</option>
              </select> 
              <br/>
            </td> 
          </tr>
        

          <tr style="font-family:arial; background-color:#a5bacd">     
            <td align="center">
              <button style="border-color:#007171;background-color:#009c9c;width:178px;height:40px;">
                <b  style="font-size:13px;color:#eaf0f0;font-family:Arial;" >CERCA</b>
              </button> 
            </td> 
          </tr>
        </form>
        
        <tr style="font-family:arial; background-color:#a5bacd">
          <td align="center">
            <form method="post" action="#">  <%---RITORNA ALLA STESSA PAGINA------%>
              <input type="submit" value="torna alla lista prodotti" style="color:white; border-color:#007171;background-color:#009c9c;width:145px;height:30px;"/>  
            </form>
          </td>
        </tr>

      </table>
    </td>
    <td width="1%"></td>
  </tr>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------- TABELLA --------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

   <tr>
    <td></td>
    <td valign="top" >
      <table cellpadding="0" cellspacing="0" width="90%">
      <tr bgcolor="007171">
        <td align="center" width="22%"><font color="9ad6d6">AZIENDA</font>                   </td>
        <td align="center" width="20%"><font color="9ad6d6">CODICE</font>                    </td>
        <td align="center" width="22%"><font color="9ad6d6">NOME </font>                     </td>
        <td align="center" width="13%"><font color="9ad6d6">STATO</font>                     </td>
        <td align="center" colspan="2"><font color="9ad6d6">VISUALIZZA</font>    </td>
      </tr>
      </table>
      <div style=" height:190px; overflow:auto;">
        <table border="1" width="90%"  cellspacing="0" cellpadding="1" bgcolor="white" bordercolor="bbccdc" >
          <c:forEach items="${scheda_prod.rows}" var="dettagli">
            <form method="post" action="scheda_prod_gov.jsp">            <%----VAI A SCHEDA GOV PROD PER DETTAGLIO SCHEDA------%>
              <input type="hidden" name="id_scheda" value="${dettagli.Id_scheda}"/>
              <input type="hidden" name="stato" value="${dettagli.stato}"/> 
              <tr    <c:if test="${dettagli.nuovo == 'true'}"> bgcolor="#add8e6" </c:if> >
                <td> ${dettagli.nome} </td>
                <td> ${dettagli.Id_scheda} </td>
                <td> ${dettagli.Nome_prod} </td> 
         
                <c:if test="${dettagli.stato == 1}"><td align="center"><img src="verde.png" width="20" height="20"></td></c:if>
                <c:if test="${dettagli.stato == 2}"><td align="center"><img src="giallo.png" width="20" height="20"></td></c:if>
                <c:if test="${dettagli.stato == 3}"><td align="center"><img src="rosso.png" width="20" height="20"></td></c:if>
         
                <td align="center">
                <input type="submit" value="Dettagli" > 
                </td>
              </tr>
            </form>
          </c:forEach>
        </table>
      </div>
    </td>
  </tr>
</table>

<%@ include file="bottom.jspf"%>