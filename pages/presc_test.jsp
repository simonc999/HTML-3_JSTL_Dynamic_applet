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

<form method="post" action="scheda_prod.jsp"> 
	<td align="right" width="60" >
        <!-- COMANDO INDIETRO -->
       
       <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
       <input type="hidden" name="presc" value="${param.test}"/>
    <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
	</td> 
</form>

<%--------------------------------%>
<%---- FRAMMENTO MIDDLE  ---------%>
<%--------------------------------%>
<%@ include file="middle.jspf"%>


<%------ QUERY PER ESTRARRE I DATI DELLA PRESCRIZIONE -------%>

<sql:query var="presc_test">
    select p.Nome_prod, p.Id_scheda, p.user_cpr,c.nome, p.inizio_prat
    from SCHEDA_PROD p,CPR c
    where c.user_cpr=p.user_cpr and p.Id_scheda LIKE ?
    <sql:param value="${param.id_scheda}"/>
</sql:query>

<%------ QUERY PER ESTRARRE IL TIPO DEL TEST DA PRESCRIVERE-------%>

<sql:query var="presc_tipo">
    select id_tipo, descrizione
    from TIPO_TEST
</sql:query>

<fmt:formatDate var="var_data" 
                value="${presc_test.rows[0].inizio_prat}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora"
                value="${presc_test.rows[0].inizio_prat}"
                type="time"
                pattern="HH:mm"/>


 <TABLE  cellspacing="0" border="0" bgcolor="#bbccdc" width="100%" height="100%" bordercolor="#41140E"  >
            
            
<%-- SEZIONE PRINCIPALE SX --%>    
            
                    <td align="left" width="75%"  style="padding: 0px;border-left-width: 3px ">
                        <table border="0" width="100%" height="100%">
                            <tr width="30%">
								<td width="100%" height="15%" valign="bottom">
									<p align="center" style="font-size:23px;color: #007171;font-weight:bold;font-family:arial" >AREA COMPILAZIONE NUOVA PRESCRIZIONE</p>
                                </td>
                            </tr>
                            <tr height="70%" width="100%">
								<td>
                                    <table border="0" width="100%">

<%------ FORM CHE PORTA ALLA ACTION DELLA PRESCRIZIONE-------%>	
									
                                        <form method="post" action="presc_test1.jsp">
											<input type="hidden"  name="var_data" value="${var_data}"/>
											<input type="hidden"  name="var_ora" value="${var_ora}"/>

												<tr>	
													<td>
<%------ TABELLA CHE CONTIENE I DATI DELLA PRESCRIZIONE-------%>	
														<table width="70%" align="center" border="0">
															<tr>
																<td  align="left"; width="50%" height="100%" style="font-family:arial;padding: 12px;">
																	<p style="font-size:17px;font-weight:bold;color:#007171;">Prodotto:&nbsp
																		<font style="color:black; font-weight:normal;">&nbsp${presc_test.rows[0].Nome_prod}</font>
																	<br><br><br>
																	 Codice prodotto:&nbsp
																		<font style="color:black; font-weight:normal;">&nbsp${presc_test.rows[0].Id_scheda}</font>
																	<br><br><br>
																	CPR:&nbsp
																		<font style="color:black; font-weight:normal;">&nbsp${presc_test.rows[0].nome}</font>
																	</p>
																</td>
																<td align="left" valign="middle" height="100%" width="50%" style="font-family:arial;padding: 12px;">
																	<p style="font-size:17px;font-weight:bold;color:#007171;">Data e ora</p><input name="date" type="date" min="${var_data}" value="${param.date}"><input name="time" type="time"  value="${param.time}"><br>
																	<p style="font-size:17px;font-weight:bold;color: #007171;">Scegli TEST</p>        
																		<SELECT style="width:220px; height:22px;" NAME="tipotest">
																			<OPTION VALUE="" checked >Nessuno</OPTION>
																				<c:forEach items="${presc_tipo.rows}" var="row">
																					<OPTION VALUE="${row.id_tipo}" 
																						<c:if test="${row.id_tipo==param.tipotest}">selected="selected"</c:if>
																					>${row.descrizione}</OPTION>
																				</c:forEach>
																		</SELECT>
																</td>
															</tr>
														</table>
													</td>
												</tr>
												<tr width="100%">
													<td>
														<table width="100%" border="0">
															<tr>
																<td align="center" valign="middle">
																	<br>
																	<TEXTAREA NAME="Note" ROWS="10" COLS="30" placeholder="Scopi">${param.Note}</TEXTAREA>
																</td> 
																<td align="center" valign="middle">
																	<br>
																	<TEXTAREA NAME="Note1" ROWS="10" COLS="30" placeholder="Motivi">${param.Note1}</TEXTAREA>
																</td> 
																<td align="center" valign="middle">
																	<br>
																	<TEXTAREA NAME="Note2" ROWS="10" COLS="30" placeholder="Risultati attesi">${param.Note2}</TEXTAREA>
																</td>
															</tr>
														</table>
													</td>
												</tr>  
									</table>          
								</td>                                     
                            </tr>
                        </table>
                    </td>
            
<%-- SEZIONE PRINCIPALE DX  --%>
                    <td width="25%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px">
                        <table  cellspacing="1" border="0" width="100%" height="100%"  rules="none" bgcolor="#a5bacd">       
                            <tr height="20%">
                                <td valign="top">
                                    <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px"><br>ATTENZIONE</p>
                                    <hr color="#53667a" size="9px">
								</td>
                            </tr>
                            <tr height="10%" width="100%">
                                <td align ="center">
									<p align="center">
										<c:if test="${not empty errmsg}">
                                            <font color="red" >${errmsg}</font>
                                        </c:if>
                                    </p>
                                                     
                                    </br>
                                </td>
                            </tr>
							<tr>
                                <td align="center" valign="top">
                                    <table border="0" width="80%" height="70%">
                                        <tr height="50%" >
                                            <td>
                                                <p style="text-align:justify;font-size:20,5px;color:#3b4957; font-family:Arial, Helvetica, sans-serif; font-weight: bold;">La prescrizione deve essere processata e visualizzata dai laboratori, che solo a quel punto potranno procedere alla candidatura.<br>Il procedimento potrebbe richiedere qualche giorno.</p>
                                            </td>
                                        </tr>
                                        <tr height="20%">
                                            <td>
                                                <br>
                                                    <input type="checkbox" id="username" name="certification" required><font style="font-size:17px;font-weight:bold;color: #007171;">&nbsp Ho capito </font>
                                                    <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
                                                    <input type="hidden" name="presc" value="${param.test}"/>                                     
                                            </td>
                                        </tr>
                                        <tr height="25%">
                                            <td align="center" valign="bottom">
                                                <input type="submit" name="submission" value="Invia Richiesta" style="width:120px;background:#008080;color:white;" >
                                                <input type="hidden" name="id_scheda" value="${presc_test.rows[0].Id_scheda}"> 
                                                                   <%-- <input type="hidden" name="Note" value="${param.Note}">Comment --%>
                                                                    <%--<input type="hidden" name="Note1" value="${param.Note1}">Comment --%>
                                                                   <%-- <input type="hidden"  name="Nome_prod" value="${user.userid}"> --%>
                                            </td>
										</tr>
                                        </form>
                          
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
            </TABLE>
 
<%--------------------------------%>
<%---- FRAMMENTO TOP--------------%>
<%--------------------------------%>
<%@ include file="bottom.jspf"%>