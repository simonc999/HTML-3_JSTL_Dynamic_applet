<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%----- FRAMMENTO AUTH ------%>
<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/>

<%@ include file="auth.jspf"%>

<%--------------------------------%>
<%---- FRAMMENTO TOP--------------%>
<%--------------------------------%>
<%@ include file="top.jspf"%>

<%-- COMANDO INDIETRO --%>
<form method="post" action="scheda_prod.jsp"> 
	<td align="right" width="60" >
		<input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
		<input type="hidden" name="presc" value="${param.test}"/>
		<input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
	</td> 
</form>

<%--------------------------------%>
<%---- FRAMMENTO CENTRALE---------%>
<%--------------------------------%>
<%@ include file="middle.jspf"%>


<%-------------------------------------------------------------------------------%>
<%----------------QUERY PER CONTROLLO CHE TUTTI I TEST SIANO STATI---------------%>
<%-------------           EFFETTUATI SU QUEL PRODOTTO ---------------------------%>

<sql:query var="controllo">
     select t.id_scheda
     from TEST t
     where t.id_scheda=? 
<sql:param value="${param.id_scheda}"/>
     and t.id_scheda not in
     (select t1.id_scheda from TEST t1 where t1.data_ora_esito is null)
</sql:query>


<%-------------------------------------------------------------------------------%>
<%---- QUERY CHE ESTRAE I DETTAGLI ESSENZIALI DELLA SCHEDA                   ----%>
<%-------------------------------------------------------------------------------%>
<sql:query var="termina">
    select s.nome_prod, s.id_scheda, c.nome
    from SCHEDA_PROD s, CPR c
    where s.user_cpr= c.user_cpr
    and Id_scheda LIKE ?
    <sql:param value="${param.id_scheda}"/>
</sql:query>

<%-------------------------------------------------------------------------------%>
<%---- QUERY CHE ESTRAE LA DATA DELL'ESITO MAGGIORE TRA TUTTE LE DATE ESITO
       DEI TEST EFFETTUATI SUL PRODOTTO DI RIFERIMENTO,PER POTER INSERIRE IL CONTROLLO 
       SULLA DATA DEL VERBALE 
      (che deve essere successiva alla data massima tra tutti gli esiti)     ----%>
<%-------------------------------------------------------------------------------%>
<sql:query var="maxdata_test">
    select max(t.data_ora_esito) as datamax
    from TEST t, SCHEDA_PROD p
    where t.id_scheda=p.id_scheda 
    and t.id_scheda="${param.id_scheda}"
</sql:query>

<%-------------------------------------------------------------------------------%>
<%---- CONVERSIONE DELLE DATE                                                ----%>
<%-------------------------------------------------------------------------------%>
<fmt:formatDate var="var_data" 
                value="${maxdata_test.rows[0].datamax}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora"
                value="${maxdata_test.rows[0].datamax}"
                type="time"
                pattern="HH:mm"/>


<%-------------------------------------------------------------------------------%>
<%-----------PER COMPILARE IL VERBALE TUTTI I TEST DEVONO ESSERE CONCLUSI--------%>
<%---------------------------SU QUEL PRODOTTO------------------------------------%>
<%-------------------------------------------------------------------------------%>

<c:choose>
	<c:when test="${controllo.rowCount==0}">

		<form method="post" action="test_presc.jsp">
			<font size="4" color="green">Non puoi ancora compilare il verbale conclusivo per questa scheda in quanto tutti i test prescritti non sono ancora stati effettuati.</br>
per controllare l'avanzamento dei tuoi test </font>
				<input type="submit" value="Clicca qui"/>
				<input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
		</form>
	</c:when>

	<c:otherwise>
		<TABLE  cellspacing="0" border="0" bgcolor="#bbccdc" width="100%" height="100%" bordercolor="#41140E"  >
			<form method="post" action="termina1.jsp">
				<input type="hidden"  name="var_data" value="${var_data}"/>
				<input type="hidden"  name="var_ora" value="${var_ora}"/>

  <%-- SEZIONE PRINCIPALE SX --%>
  
					<td align="left" width="70%"  style="padding: 0px;border-left-width: 3px ">
						<table border="0" width="100%" height="100%">
							<tr width="100%">
								<td width="100%" height="15%" valign="top"><br>
									<p align="center" style="font-size:35px;font-weight:bold;color: #007171;">VERBALE CONCLUSIVO</p>
								</td>
							</tr>
							<tr height="70%" width="100%">
								<td>
									<table border="0" width="100%" height="100%">
										<tr align="left" valign="top">
											<td align="center" valign="middle" height="30%"> 
												<p style="font-size:17px;font-weight:bold;color:#007171;">Data e ora &nbsp
												<input name="date" type="date" min="${var_data}" value="${param.date}">
												<input name="time" type="time" value="${param.time}"></p>
											</td>
										</tr>
										<tr>
											<td valign="top" align="center">
												<p align="center" style="font-size:20px;font-weight:bold;color: #007171;">Area di compilazione</p>
												<TEXTAREA NAME="Note" ROWS="15" COLS="50" value="${param.Note}">${param.Note}</TEXTAREA>
											</td> 
										</tr>
									</table>
								</td>                                  
							</tr>
							<tr height="15%" width="100%">
								<td >&nbsp;</td>
							</tr>
						</table>
					</td>
<%-- SEZIONE PRINCIPALE DX  --%>
					<td width="30%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px">
						<table  cellspacing="0" border="0" width="100%" height="100%"  rules="none" bgcolor="#a5bacd">
							<tr>
								<td>
									<table border="0" height="100%">
										<tr height="25%">
											<td width="60%" align="left" valign="top">
												<p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px"><br>DATI PRODOTTO</p>
												<hr color="#53667a" size="9px"/>
											</td>
										</tr>
										<tr>                   
											<td>
												<p align="justify">
                                                    <c:if test="${not empty errmsg}">
                                                        <font color="red" >${errmsg}</font>
                                                    </c:if>
											</td>
										</tr>
										<tr valign="top">
											<td  valign="top" width="60%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px;">
												<p style="font-size:15px;font-weight:bold;color: #007171;">Prodotto</p>${termina.rows[0].Nome_prod}
												<p style="font-size:15px;font-weight:bold;color: #007171;">Codice prodotto</p>${termina.rows[0].Id_scheda}
												<p style="font-size:15px;font-weight:bold;color: #007171;">CPR<br></p>${termina.rows[0].nome}
												<p style="font-size:15px;font-weight:bold;color: #007171;">Esito<br> </p>
												<input type="radio" name="certificato" value="1"> Certificato
												<br>
												<input type="radio" name="certificato" value="3"> Non certificato
											</td>
										</tr>
										<tr>
											<td align="center">                                                   
												<input type="submit" name="termina" value="Invia tutto e termina" >
												<input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
												<input type="hidden" name="nome_prod" value="${termina.rows[0].nome_prod}"/>
                         					</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
			</form>
		</TABLE>
	</c:otherwise>
</c:choose>

<%--------------------------------%>
<%------ FRAMMENTO BOTTOM---------%>
<%--------------------------------%>
<%@ include file="bottom.jspf"%>



 