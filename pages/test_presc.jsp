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

<%------------------------------------------------------------------------%>
<%------       QUERY CHE ESTRAE TUTTI I TEST PRESCRITTI             ------%> 
<%------------------------------------------------------------------------%>
<sql:query var="test_presc">
   select t.id_test, tt.tipo, t.data_ora_presc, p.Id_scheda, p.Nome_prod,   
          t.data_ora_esito, t.motivi, c.nome, c.cognome
   from TIPO_TEST tt, TEST t, SCHEDA_PROD p, CERT c
   where p.id_scheda = t.id_scheda 
     and tt.id_tipo = t.id_tipo 
     and t.user_cert = c.user_cert
     and p.id_scheda ="${param.id_scheda}"
   order by t.data_ora_presc desc
</sql:query>



<table align="center" border="0" width="80%">
	  <tr>
	  <td> 
		 <table border="0">
		 <tr height="25%">
		 <td align="center" valign="middle"><h1 ><font color="#008080">TEST PRESCRITTI</font></h1>
		 <p valign="middle" align="center"> <font color="black" size="5px" style="italic" ><b>    
		 Prodotto di riferimento: ${test_presc.rows[0].Nome_prod}</b> </font> </p> </td> 
		 </tr>
		 <tr height="5%"><td><c:if test="${not empty messaggio1}">
	<font color="green">${messaggio1}</font>
	</c:if></td></tr>
		 <tr height="55%">
			<td>
				<table cellspacing="0" cellpadding="1" border="1" width="1050" >
					<tr bgcolor="#008080">
						<th width="13.5%"><font color="#bfebfc">  Info test               </font></th>
						<th width="13.5%"><font color="#bfebfc">  Tipo                    </font></th>
						<th width="13.5%"><font color="#bfebfc">  Data Prescrizione       </font></th>
						<th width="13.5%"><font color="#bfebfc">  Motivo Prescrizione     </font></th>
						<th width="13.5%"><font color="#bfebfc">  Certificatore           </font></th>
						<th width="13.5%"><font color="#bfebfc">  Stato                   </font></th>
					</tr>
				</table>
				<br>
			</td>
		</tr>
		<tr>
			<td>
				<div style="width:1100px; height:250px; overflow:auto;">
				<table cellspacing="0" cellpadding="1" border="1" width="1050" >
					<c:forEach items="${test_presc.rows}" var="row">
						<form method="post" action="info_test.jsp">
							<input type="hidden" name="scheda_prod" value="123"/>
							<tr bgcolor="#eeeeee" height="20">
								<td align="center" width="13.5%">
									<input type="submit" value="${row.id_test}" style="width:100px;background:#a5bacd"/>
									<input type="hidden"  name="id_scheda" value="${row.Id_Scheda}">
									<input type="hidden"  name="id_test" value="${row.id_test}">
								</td>
								<td width="13.5%"><c:out value="${row.tipo}"/></td>
								<td width="13.5%"><c:out value="${row.data_ora_presc}"/></td>
								<td width="13.5%"><c:out value="${row.motivi}"/></td>
								<td width="13.5%"><c:out value="${row.nome}"/> <c:out value="${row.cognome}"/></td>
								<c:choose>
									<c:when test="${not empty row.data_ora_esito}" >
										<td align="center" width="13.5%"><img src="spunta.png" align="center" width="25"/></td>
									</c:when>
									<c:otherwise>
										<td align="center" width="13.5%">
										<img src="clessidra1.png" align="center" width="25"/></td>
									</c:otherwise>
								</c:choose>
							</tr>
						</form>
					</c:forEach>
				</table>  
				</div>
			</td>
		</tr>
	<%-----------------%>
	<%---LEGENDA-------%>
	<%-----------------%>
		<tr height="15%">
			<td align="center">
				<table align="center" border="2"bordercolor="" bgcolor="white" cellspacing="0" cellpadding="1">
					<h3><font color="green">LEGENDA</font></h3>
					<tr>
						<td><font color="black">Test effettuato </font> </td>
						<td><img src="spunta.png" width="25"/></td>
					</tr>
					<tr>
						<td><font color="black">Test in svolgimento</font></td>
						<td><img src="clessidra1.png" width="25"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</td>
	
</table>

<%--------------------------------%>
<%---- FRAMMENTO BOTTOM--------------%>
<%--------------------------------%>
<%@ include file="bottom.jspf"%>

 