<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%--------------------------------------------------------------------------------------%>
<%------------------------------AUTORIZZAZIONE AREA CPR---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/>

<%@ include file="auth.jspf"%>

<%--------------------------------%>
<%---- FRAMMENTO TOP--------------%>
<%--------------------------------%>
<%@ include file="top.jspf"%> 

<td width="60" align="center">
          <!-- COMANDO BACK -->

       <a href="schede_cert.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
        
       </td>
 
<%--------------------------------%>
<%---- FRAMMENTO MIDDLE  ---------%>
<%--------------------------------%>
<%@ include file="middle.jspf"%>

<%----------------------------------------------------------------------%>
<%--- QUERY CHE ELIMINA LA NOTIFICA (nuovo_assegnato non e' piu true) --%>

<sql:update>
     UPDATE SCHEDA_PROD set nuovo_assegnato = false
     where id_scheda = ?
     <sql:param value="${param.id_scheda}"/>
</sql:update>

<%-----------------------------------------------------------%>
<%---- QUERY PER ESTRARRE I DETTAGLI DEL PRODOTTO -------%>
<%-----------------------------------------------------------%>

<sql:query var="dettagli">
  select Id_scheda, Nome_prod, tipo, uso, materiali, beneficio, foto1, foto2, foto3
    from SCHEDA_PROD
    where Id_scheda LIKE ?
  <sql:param value="${param.id_scheda}"/>
</sql:query>

    <TABLE  cellspacing="0" border="0" bgcolor="#bbccdc" width="100%" height="100%" bordercolor="#41140E">

<%--------------------------------------------------------------------------------------%>
<%--------------------------    SEZIONE PRINCIPALE SX      -----------------------------%>
<%--------------------------------------------------------------------------------------%>
                     
                <tr width="100%">
                        <td   align="center" width="60%" height="100%" style="padding: 0px;border-left-width: 3px ">

<%------------------------------------------------------------------%>
<%------TABELLA CHE RIPORTA I DETTAGLI ESTRATTI CON LA QUERY -------%>
<%------------------------------------------------------------------%>
                            <table width="100%" height="100%"  border="0" >
                                    <tr width="20%">
										<td width="68%">
											<p align="center" style="font-size:35px;color: #007171;font-weight:bold;font-family:arial" >SCHEDA PRODOTTO <br/> <br/>                  

											<c:if test="${not empty dettagli.rows[0].foto1}">
												<IMG border="0" src="${dettagli.rows[0].foto1}" width="70" height="70"/>
											</c:if>
											<c:if test="${not empty dettagli.rows[0].foto2}">
												<IMG border="0" src="${dettagli.rows[0].foto2}" width="70" height="70"/>
										    </c:if>
											<c:if test="${not empty dettagli.rows[0].foto3}">
												<IMG border="0" src="${dettagli.rows[0].foto3}" width="70" height="70"/>
											</c:if>
											</p>
										</td>
                                    </tr>
                                    <tr width="50%">
                                      <td  width="100%" align="center" style="font-size:18px; font-family:arial">
                                            <table width="90%" border="1" cellspacing="0" cellpadding="3" bordercolor="bbccdc"> 
                                            <tr>
                                                <td align="left" width="15%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">NOME: </font></td>
                                                <td align="center" bgcolor="white"> ${dettagli.rows[0].Nome_prod} </td>
                                            </tr>
                                            <tr>
                                                <td align="left" width="15%" height="35%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">CODICE: </font></td>
                                                <td align="center" height="35%" bgcolor="white"> ${dettagli.rows[0].Id_scheda} </td>
                                            </tr>
                                            <tr>
                                                <td align="left" width="15%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">TIPO: </font></td>
                                                <td align="center"bgcolor="white"> ${dettagli.rows[0].tipo} </td>
                                            </tr>
                                            <tr>
                                                <td align="left" width="15%" height="35%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">USO: </font></td>
                                                <td align="center" height="35%" bgcolor="white"> ${dettagli.rows[0].uso} </td>
                                            </tr>
                                            <tr>
                                                <td align="left" width="15%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">MATERIALI </font></td>
                                                <td align="center" bgcolor="white"> ${dettagli.rows[0].materiali} </td>
                                            </tr>
                                            <tr>
                                                <td align="left" width="15%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">BENEFICIO: </font></td>
                                                <td align="center" bgcolor="white"> ${dettagli.rows[0].beneficio} </td>
                                            </tr>
                                            </table>
                                       </td>
                                    </tr>
                                    <tr heigth="30%">
                                        <td>&nbsp</td>
                                    </tr>
                            </table>
                        </td>
                        
<%--------------------------------------------------------------------------------------%>
<%--------------------------    SEZIONE PRINCIPALE SX      -----------------------------%>
<%--------------------------------------------------------------------------------------%>
                                             
                        <td width="40%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px">

<%----------------------------------------------------------------------------%>
<%------TABELLA CHE CONTIENE I BOTTONI PER ACCEDERE ALLE ALTRE SEZIONI -------%>
<%----------------------------------------------------------------------------%>

							<table  cellspacing="0"width="100%" height="100%"  rules="none" bgcolor="#a5bacd">
                                <tr >
									<td width="60%" align="right" >
										<p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" >TEST</p>
										<hr  color="#53667a" size="9px">
										<p style="font-size:15px;color: white; font-weight: bold;font-family:arial;margin-top:14px" >Visualizza test eseguiti</p>
									</td>
	
<%------FORM PER ACCEDERE ALLA PAGINA CONTENENTE I TEST PRESCRITTI-------%>
	
									<form method="post" action="test_presc.jsp"> 
										<td width="40%"  align="center">
										  <button  style="border-color:   #a5bacd;background-color:  #a5bacd;"><img style="width:90px;height:90px;"src="testeff.jpg"></button>
										  <input type="hidden" name="id_scheda" value="${dettagli.rows[0].Id_scheda}"/>
										</td>
									</form>
                                </tr>
                                <tr>
									<td width="60%" align="right">
										<p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">NUOVO TEST</p>
										<hr color="#53667a" size="9px"> 
										<p style="font-size:15px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Prescrivi nuovo test</p></td>
									
   <%------FORM PER ACCEDERE ALLA PAGINA PER CREARE UNA NUOVA PRESCRIZIONE-------%>
   
									<form method="post" action="presc_test.jsp">
										<td width="40%"  align="center"><button  style="border-color: #a5bacd;background-color:   #a5bacd;"><img style="width:90px;height:90px;"src="add.jpg"></button>
											<input type="hidden" name="id_scheda" value="${dettagli.rows[0].Id_scheda}"/>
											<input type="hidden"  name="Nome_prod" value="${user.userid}">
										</td>    
									</form>
								</tr>
								<tr>
									<td width="60%" align="right">
										<p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">VERBALE</p>
										<hr color="#53667a" size="9px"> 
										<p style="font-size:15px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Redigi verbale conclusivo</p>
									 </td>
									<form method="post" action="termina.jsp">
										<td width="40%"  align="center"><button  style="border-color: #a5bacd;background-color:   #a5bacd;"><img style="width:90px;height:90px;"src="rapporto.jpg"></button>
											<input type="hidden" name="id_scheda" value="${dettagli.rows[0].Id_scheda}"/>
										</td>
									 </form>
                               </tr>
                            </table>
                        </td>
                </tr>
    </TABLE>

<%--------------------------------%>
<%------- FRAMMENTO BOTTOM -------%>
<%--------------------------------%>
<%@ include file="bottom.jspf"%>
