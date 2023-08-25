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
   <form method="post" action="test_presc.jsp"> 
		<td align="right" width="60" >
			<input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
			<input type="hidden" name="presc" value="${param.test}"/>
			<input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
		 </td> 
    </form>

<%--------------------------------%>
<%---- FRAMMENTO MIDDLE  ---------%>
<%--------------------------------%>
<%@ include file="middle.jspf"%>



<%----------------------------------------------------------------------------------%>
<%--------   QUERY PER ESTRARRE I DETTAGLI DEL TEST SCELTO     ---------------------%>
<%----------------------------------------------------------------------------------%>
<sql:query var="info_test">
    select t.id_test, tt.tipo, p.Nome_prod, t.data_ora_esito, t.scopo, t.risultati_attesi, t.superato, t.rapporto, p.Id_scheda
    from TEST t, SCHEDA_PROD p, TIPO_TEST tt
    where p.id_scheda = t.id_scheda and tt.id_tipo = t.id_tipo  and id_test  LIKE ? 
    <sql:param value="${param.id_test}"/>
</sql:query>


<TABLE  cellspacing="0" cellspacing="5" border="0" bgcolor="#bbccdc" width="100%" height="100%" bordercolor="#41140E"  >

     <%-- SEZIONE PRINCIPALE SX --%>
    <tr>
        <td align="center" width="65%" style="padding: 0px;border-left-width: 3px ">
			<table width="100%" height="100%" border="0">
				<tr width="100%" height="10%">
					<td colspan="3" > &nbsp; </td>
				</tr> 
				<tr width="100%" height="20%">
					<td width="68%"><table width="100%"><tr><td width="40%"></td>
					<td width="60%"><p align="left"  style="font-size:35px;color: #007171;font-weight:bold;font-family:arial" >&nbsp INFORMAZIONI SUL TEST</p></td></tr></table> 
					</td>
				</tr>
				<tr width="100%">
					<td  width="100%" align="center" style="font-size:18px; font-family:arial">
   
   <%-----------------------------------------------------------------------------------%>
   <%--------  TABELLA CHE CONTIENE I DETTAGLI DEL TEST SCELTO     ---------------------%>
   <%-----------------------------------------------------------------------------------%>
   
						<table width="70%" border="1" cellspacing="0" cellpadding="3" bordercolor="bbccdc" align="right"> 
							<tr>
								<td align="left" width="20%" height="22%" bgcolor="#007171">
									<font color="#9ad6d6" face="Arial" size="3">CODICE: </font>
								</td>
								<td align="center" bgcolor="white"> ${info_test.rows[0].id_test}</td>
							</tr>
							<tr>
								<td align="left" width="20%" height="35%" bgcolor="#007171">
									<font color="#9ad6d6" face="Arial" size="3">TEST: </font>
								</td>
								<td align="center" height="35%" bgcolor="white"> ${info_test.rows[0].tipo} </td>
							</tr>
							<tr>
								<td align="left" width="20%" height="22%" bgcolor="#007171">
									<font color="#9ad6d6" face="Arial" size="3">PRODOTTO: </font>
								</td>
								<td align="center"bgcolor="white"> ${info_test.rows[0].Nome_prod} </td>
							</tr>
							<tr>
								<td align="left" width="20%" height="35%" bgcolor="#007171">
									<font color="#9ad6d6" face="Arial" size="3">RISULTATI ATTESI: </font>
								</td>
								<td align="center" height="35%" bgcolor="white"> ${info_test.rows[0].risultati_attesi} </td>
							</tr>
							<tr>
								<td align="left" width="20%" height="22%" bgcolor="#007171">
									<font color="#9ad6d6" face="Arial" size="3">SCOPO</font></td>
								<td align="center" bgcolor="white"> ${info_test.rows[0].scopo} </td>
							</tr>
		  
							<c:if test="${not empty info_test.rows[0].data_ora_esito}">
								<tr>
									<td align="left" width="20%" height="22%" bgcolor="#007171">
										<font color="#9ad6d6" face="Arial" size="3">DATA E ORA ESITO: </font>
									</td>
									<td align="center" bgcolor="white"> ${info_test.rows[0].data_ora_esito} </td>
								</tr>
								<tr>
									<td align="left" width="20%" height="22%" bgcolor="#007171">
										<font color="#9ad6d6" face="Arial" size="3">ESITO: </font>
									</td>
									<c:choose>
										<c:when test="${info_test.rows[0].superato == 'true'}" >
											<td align="center" bgcolor="white"> Positivo </td>
										</c:when>
										<c:otherwise>
											<td align="center" bgcolor="white"> Negativo </td>
										</c:otherwise>
									</c:choose>
								</tr>
							</c:if>
						</table>
					</td>
				</tr> 
				<tr width="100%">
					
<%-------------------------------------------------------------------------------------------%>
<%-------------  CICLO CHE CONTROLLA CHE IL TEST ABBIA GIA' DATO ESITO    -------------------%>
<%-------------------------------------------------------------------------------------------%>

					<c:if test="${not empty info_test.rows[0].data_ora_esito}">
						<td valign="top">
											<table width="40%" border="0" align="center">
												<tr>
<%-----------------------------------------------------------------------------------%>
<%-------------  FORM CHE PERMETTE DI VISUALIZZARE IL RAPPORTO    -------------------%>
<%-----------------------------------------------------------------------------------%>	
													<form method="post" action="info_test.jsp" >
														<td  width="100%" align="left" valign="top" style="font-size:18px; font-family:arial">
															<input type="hidden" name="rapporto" value="${info_test.rows[0].rapporto}"/>
															<input type="hidden" name="id_test" value="${param.id_test}"/>
															<input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
															<input type="submit" name="visualizza" value="Visualizza rapporto" style="background:#ADD8E6;"/>
														</td>
													</form>
												</tr>
											</table>
									</c:if>
								</tr>
								<tr>
									<td height="20%" valign="bottom">
										<table width="80%" height="55%" border="0" align="right">
											<tr>
												<td width="100%" align="right"><font color="green" style="font-size:20px;"> Per visualizzare i messaggi scambiati tra LAB e CPR cliccare icona &nbsp&nbsp</font></td>
											</tr>
										</table>
									</td>
								</tr>
									 
							</table>
   
   
						</td>  
						<td width="10%" height="100%" valign="bottom">
							<table width="100%" height="10%"  border="0" align="left">
								<tr>
									
<%--------------------------------------------------------------------------------------------%>
<%-------------  FORM CHE PERMETTE DI VISUALIZZARE I MESSAGGI SCAMBIATI    -------------------%>
<%--------------------------------------------------------------------------------------------%>

									<form method="post" action="messaggi1.jsp">
										<td  width="100%" align="left" valing="top" style="font-size:18px; font-family:arial">
											<input type="hidden" name="id_test" value="${info_test.rows[0].id_test}"/>
											<input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
											<input type="image" src="posta.png" name="Submit" width="55px"/>
										</td>
									</form>
								</tr>
							</table>
						</td>                           

<%-- SEZIONE PRINCIPALE DX  --%>

						<td width="25%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px" bgcolor="#a5bacd">
							<table cellspacing="0" width="100%" height="70%">
								<tr>
									<td>
<%--CICLO CHE CONTROLLA CHE SI SIA CLICCATO IL BOTTONE PER VISUALIZZARE IL RAPPORTO  --%>										
										<c:if test="${not empty param.visualizza}">    
											<table  cellspacing="0" width="100%" height="100%" border="0" cellpadding="10">
												<tr height="10%">
													<td valign="bottom" align="center"><font color="#008080" style="font-size:20;">DESCRIZIONE ESITO DEL TEST</font></td>
												</tr>
												<tr width="100%" height="10%">
													
<%-------------  FORM PER CHIUDERE IL RAPPORTO  -------------------%>

													<form method="post" action"#">
														<td valign="bottom" align="right">
														  <br>
														  <input type="image" name="submit" style="width:20px;height:20px" src="rosso1.png"/>&nbsp&nbsp&nbsp&nbsp
														  <input type="hidden" name="id_test" value="${info_test.rows[0].id_test}"/>
														  <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
														</td>
													</form>
												</tr>
												<tr align="right" height="80%">
													<td width="100%" height="100%" align="center" valign="top">
														<table width="80%" height="70%" bgcolor="white" bordercolor="#008080" cellspacing="5">
															<tr>
																<td valign="top">${param.rapporto}</td>
															</tr>
														</table>
													</td>
												</tr>
                          
											</table>
										</c:if>
									</td>
								</tr>
							</table>
						</td>
	</tr>
              
</TABLE>

<%--------------------------------%>
<%---- FRAMMENTO TOP--------------%>
<%--------------------------------%>
<%@ include file="bottom.jspf"%>
